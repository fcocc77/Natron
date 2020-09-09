# ***** BEGIN LICENSE BLOCK *****
# This file is part of Natron <https://natrongithub.github.io/>,
# Copyright (C) 2013-2018 INRIA and Alexandre Gauthier-Foichat
# Copyright (C) 2018-2020 The Natron developers
#
# Natron is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Natron is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Natron.  If not, see <http://www.gnu.org/licenses/gpl-2.0.html>
# ***** END LICENSE BLOCK *****

TARGET = Gui
TEMPLATE = lib
CONFIG += staticlib
CONFIG += moc rcc
CONFIG += boost opengl qt cairo python shiboken pyside 
QT += gui core opengl network

CONFIG += glad-flags

include(../global.pri)

precompile_header {
  # Use Precompiled headers (PCH)
  # we specify PRECOMPILED_DIR, or qmake places precompiled headers in Natron/c++.pch, thus blocking the creation of the Unix executable
  PRECOMPILED_DIR = pch
  PRECOMPILED_HEADER = pch.h
}

#OpenFX C api includes and OpenFX c++ layer includes that are located in the submodule under /libs/OpenFX
INCLUDEPATH += $$PWD/../libs/OpenFX/include
DEPENDPATH  += $$PWD/../libs/OpenFX/include
INCLUDEPATH += $$PWD/../libs/OpenFX_extensions
DEPENDPATH  += $$PWD/../libs/OpenFX_extensions
INCLUDEPATH += $$PWD/../libs/OpenFX/HostSupport/include
DEPENDPATH  += $$PWD/../libs/OpenFX/HostSupport/include
INCLUDEPATH += $$PWD/..
INCLUDEPATH += $$PWD/../libs/SequenceParsing

DEPENDPATH += $$PWD/../Engine
DEPENDPATH += $$PWD/../Global

INCLUDEPATH += $$PWD/../Engine
INCLUDEPATH += $$PWD/../Engine/NatronEngine
INCLUDEPATH += $$PWD/../Global

#qhttpserver
INCLUDEPATH += $$PWD/../libs/qhttpserver/src

#To overcome wrongly generated #include <...> by shiboken
INCLUDEPATH += $$PWD
INCLUDEPATH += $$PWD/wrapper/includes
#DEPENDPATH += $$PWD/NatronGui

INCLUDEPATH += components/includes
INCLUDEPATH += knob/includes
INCLUDEPATH += main/includes
INCLUDEPATH += misc/includes
INCLUDEPATH += node_graph/includes
INCLUDEPATH += viewer/includes


SOURCES += \
    misc/src/*.cpp \
    components/src/*.cpp \
    main/src/*.cpp \
    knob/src/*.cpp \
    node_graph/src/*.cpp \
    viewer/src/*.cpp \
    wrapper/src/*.cpp \
    ../utils/util.cpp 

HEADERS += \
    misc/includes/*.h \
    components/includes/*.h \
    main/includes/*.h \
    knob/includes/*.h \
    node_graph/includes/*.h \
    viewer/includes/*.h \
    ../libs/OpenFX/include/ofxCore.h \
    ../libs/OpenFX/include/ofxDialog.h \
    ../libs/OpenFX/include/ofxImageEffect.h \
    ../libs/OpenFX/include/ofxInteract.h \
    ../libs/OpenFX/include/ofxKeySyms.h \
    ../libs/OpenFX/include/ofxMemory.h \
    ../libs/OpenFX/include/ofxMessage.h \
    ../libs/OpenFX/include/ofxMultiThread.h \
    ../libs/OpenFX/include/ofxNatron.h \
    ../libs/OpenFX/include/ofxOpenGLRender.h \
    ../libs/OpenFX/include/ofxParam.h \
    ../libs/OpenFX/include/ofxParametricParam.h \
    ../libs/OpenFX/include/ofxPixels.h \
    ../libs/OpenFX/include/ofxProgress.h \
    ../libs/OpenFX/include/ofxProperty.h \
    ../libs/OpenFX/include/ofxSonyVegas.h \
    ../libs/OpenFX/include/ofxTimeLine.h \
    ../libs/OpenFX/include/nuke/camera.h \
    ../libs/OpenFX/include/nuke/fnOfxExtensions.h \
    ../libs/OpenFX/include/nuke/fnPublicOfxExtensions.h \
    ../libs/OpenFX/include/tuttle/ofxReadWrite.h \
    ../libs/OpenFX_extensions/ofxhParametricParam.h \
    wrapper/includes/*.h \
    ../utils/util.hpp 

RESOURCES += \
    GuiResources.qrc

OTHER_FILES += \
    Resources/Fonts/Apache_License.txt \
    Resources/Images/MotionTypeRTS.png \
    Resources/Images/Other/natron_picto_tools.svg \
    Resources/Images/Other/natron_picto_viewer.svg \
    Resources/Images/motionTypeAffine.png \
    Resources/Images/motionTypeRT.png \
    Resources/Images/motionTypeS.png \
    Resources/Images/motionTypeT.png \
    Resources/Images/natronIcon.icns \
    Resources/Images/natronIcon.svg \
    Resources/Images/natronIcon256_windows.ico \
    Resources/Images/patternSize.png \
    Resources/Images/prevUserKey.png \
    Resources/Images/searchSize.png \
    Resources/Images/splashscreen.svg

