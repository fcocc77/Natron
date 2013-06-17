//  Powiter
//
//  Created by Alexandre Gauthier-Foichat on 06/12
//  Copyright (c) 2013 Alexandre Gauthier-Foichat. All rights reserved.
//  contact: immarespond at gmail dot com


#include "Writer/writeExr.h"
#include "Writer/Writer.h"
#include "Core/lookUpTables.h"
#include "Gui/knob.h"
#include "Core/row.h"
#include <QtCore/QMutexLocker>
#include <QtCore/QMutex>
using namespace std;

WriteExr::WriteExr(Writer* writer):Write(writer),outfile(0),_lock(0){
    
}
WriteExr::~WriteExr(){
    
}

std::vector<std::string> WriteExr::fileTypesEncoded(){
    vector<string> out;
    out.push_back("exr");
    return out;
}

void ExrWriteKnobs::initKnobs(Knob_Callback* callback,std::string& fileType){
    std::string separatorDesc(fileType);
    separatorDesc.append(" Options");
    sepKnob = static_cast<Separator_Knob*>(KnobFactory::createKnob("Separator", callback, separatorDesc, Knob::NONE));
    
    std::string compressionCBDesc("Compression");
    compressionCBKnob = static_cast<ComboBox_Knob*>(KnobFactory::createKnob("ComboBox", callback,
                                                                            compressionCBDesc, Knob::NONE));
    vector<string> compressionEntries;
    for (int i =0; i < 6; i++) {
        compressionEntries.push_back(EXR::compressionNames[i]);
    }
    compressionCBKnob->populate(compressionEntries);
    compressionCBKnob->setPointer(&_compression);
    
    std::string depthCBDesc("Data type");
    depthCBKnob = static_cast<ComboBox_Knob*>(KnobFactory::createKnob("ComboBox", callback,
                                                                      depthCBDesc, Knob::NONE));
    vector<string> depthEntries;
    for(int i = 0 ; i < 2 ; i++){
        depthEntries.push_back(EXR::depthNames[i]);
    }
    depthCBKnob->populate(depthEntries);
    depthCBKnob->setPointer(&_dataType);
    
    /*calling base-class version at the end*/
    WriteKnobs::initKnobs(callback,fileType);
}
void ExrWriteKnobs::cleanUpKnobs(){
    sepKnob->enqueueForDeletion();
    compressionCBKnob->enqueueForDeletion();
    depthCBKnob->enqueueForDeletion();
}

bool ExrWriteKnobs::allValid(){
    return _dataType!="/" && _compression!="/";
}

/*Must implement it to initialize the appropriate colorspace  for
 the file type. You can initialize the _lut member by calling the
 function Lut::getLut(datatype) */
void WriteExr::initializeColorSpace(){
    _lut = Lut::getLut(Lut::FLOAT);
}

/*This must be implemented to do the output colorspace conversion*/
void WriteExr::engine(int y,int offset,int range,ChannelMask channels,Row* out){
    InputRow row;
    op->input(0)->get(y, offset, range, channels, row);
    const float* a = row[Channel_alpha];
    if (a) {
        a+=row.offset();
    }
    Row* toRow = new Row(offset,y,range,channels);
    toRow->allocate();
    foreachChannels(z, channels){
        const float* from = row[z] + row.offset();
        float* to = toRow->writable(z)+row.offset();
        to_float(z, to , from, a, row.right()- row.offset());
    }
    QMutexLocker g(_lock);
    _img.insert(make_pair(y,toRow));
}

/*This function initialises the output file/output storage structure and put necessary info in it, like
 meta-data, channels, etc...This is called on the main thread so don't do any extra processing here,
 otherwise it would stall the GUI.*/
void WriteExr::setupFile(std::string filename){
    _lock = new QMutex;
    
    ExrWriteKnobs* knobs = dynamic_cast<ExrWriteKnobs*>(_optionalKnobs);
    compression = EXR::stringToCompression(knobs->_compression);
    depth = EXR::depthNameToInt(knobs->_dataType);
    const Format& dispW = op->getInfo()->getDisplayWindow();
    const Box2D& dataW = op->getInfo()->getDataWindow();
    const ChannelSet& channels = op->getRequestedChannels();
    _dataW = new Box2D;
    if(op->getInfo()->blackOutside()){
        if(dataW.x() +2 < dataW.right()){
            _dataW->x(dataW.x()+1);
            _dataW->right(dataW.right()-1);
        }
        if(dataW.y() +2 < dataW.top()){
            _dataW->y(dataW.y()+1);
            _dataW->top(dataW.top()-1);
        }
    }else{
        _dataW->set(dataW);
    }
    exrDataW = new Imath::Box2i;
    exrDispW = new Imath::Box2i;
    exrDataW->min.x = _dataW->x();
    exrDataW->min.y = dispW.h() - _dataW->top();
    exrDataW->max.x = _dataW->right()-1;
    exrDataW->max.y = dispW.h() -  _dataW->y() -1;
    
    exrDispW->min.x = 0;
    exrDispW->min.y = 0;
    exrDispW->max.x = dispW.w() -1;
    exrDispW->max.y = dispW.h() -1;
    
    Imf::Header exrheader(*exrDispW, *exrDataW,dispW.pixel_aspect(),
                          Imath::V2f(0, 0), 1, Imf::INCREASING_Y, compression);
    
    foreachChannels(z, channels){
        std::string channame = EXR::toExrChannel(z);
        if (depth == 32) {
            exrheader.channels().insert(channame.c_str(), Imf::Channel(Imf::FLOAT));
        }
        else {
            exrheader.channels().insert(channame.c_str(), Imf::Channel(Imf::HALF));
        }
    }
  //  try{
    outfile = new Imf::OutputFile(filename.c_str(), exrheader);
//    }catch (const std::exception& exc) {
//        cout << "OpenEXR error" << exc.what() << endl;
//        return;
//    }
    
    
    
}

/*This function must fill the pre-allocated structure with the data calculated by engine.
 This function must close the file as writeAllData is the LAST function called before the
 destructor of Write.*/
void WriteExr::writeAllData(){
    try{
        const ChannelSet& channels = op->getRequestedChannels();
        for (int y = _dataW->top()-1; y >= _dataW->y(); y--) {
            Imf::FrameBuffer fbuf;
            Row* row = _img[y];
            assert(row);
            if (depth == 32) {
                foreachChannels(z, channels){
                    std::string channame = EXR::toExrChannel(z);
                    fbuf.insert(channame.c_str(),
                                Imf::Slice(Imf::FLOAT, (char*)row->writable(z),
                                           sizeof(float), 0));
            }
            }else{
                Imf::Array2D<half> halfwriterow(channels.size() , _dataW->right() - _dataW->x());
                int cur = 0;
                foreachChannels(z, channels){
                    std::string channame = EXR::toExrChannel(z);
                    fbuf.insert(channame.c_str(),
                                Imf::Slice(Imf::HALF,
                                           (char*)(&halfwriterow[channels.size() + cur][0] - exrDataW->min.x),
                                           sizeof(halfwriterow[ channels.size() * cur][0]), 0));
                    const float* from = (*row)[z];
                    for(int i = exrDataW->min.x ; i < exrDataW->max.x ; i++){
                        halfwriterow[channels.size() + cur][i - exrDataW->min.x] = from[i];
                    }
                    cur++;
                }
            }
            outfile->setFrameBuffer(fbuf);
            outfile->writePixels(1);
        }
        
        delete outfile;
        delete exrDataW;
        delete exrDispW;
        delete _lock;

    }catch (const std::exception& exc) {
        cout << "OpenEXR error" << exc.what() << endl;
        return;
    }
    
}

void WriteExr::debug(){
    int notValidC = 0;
    for (map<int,Row*>::iterator it = _img.begin(); it!=_img.end(); it++) {
        cout << "img[" << it->first << "] = ";
        if(it->second) cout << "valid row" << endl;
        else{
            cout << "NOT VALID" << endl;
            notValidC++;
        }
    }
    cout << "Img size : " << _img.size() << " . Invalid rows = " << notValidC << endl;
}
