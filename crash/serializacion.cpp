Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7fffd37fe700 (LWP 21047)]
0x00007ffff40199ad in __dynamic_cast () from /opt/Natron2/bin/../lib/libstdc++.so.6

#0  0x00007ffff40199ad in __dynamic_cast () from /opt/Natron2/bin/../lib/libstdc++.so.6
#1  0x00000000007ec692 in Natron::ProjectGuiSerialization::initialize(Natron::ProjectGui const*) () at ProjectGuiSerialization.cpp:151
#2  0x00000000007e0e5c in void Natron::ProjectGui::save<boost::archive::xml_oarchive>(boost::archive::xml_oarchive&) const () at ProjectGui.cpp:272
#3  0x0000000000b87d8a in Natron::Project::saveProjectInternal(QString const&, QString const&, bool, bool) () at ../../natron/Engine/Hash64.h:57
#4  0x0000000000b8839e in Natron::Project::saveProject_imp(QString const&, QString const&, bool, bool, QString*) () at Project.cpp:452
#5  0x0000000000b88632 in Natron::Project::autoSave() () at Project.cpp:645
#6  0x000000000058b66f in non-virtual thunk to QtConcurrent::RunFunctionTask<void>::run() () at moc_ProjectGui.cpp:170
#7  0x00007ffff484a832 in QThreadPoolThread::run() () from /opt/Natron2/bin/../lib/libQtCore.so.4
#8  0x00007ffff48567b3 in ?? () from /opt/Natron2/bin/../lib/libQtCore.so.4
#9  0x00007ffff432be65 in start_thread () from /lib64/libpthread.so.0
#10 0x00007ffff357988d in clone () from /lib64/libc.so.6
