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
INCLUDEPATH += $$PWD/NatronGui
DEPENDPATH += $$PWD/NatronGui



SOURCES += \
    misc/cpp/AboutWindow.cpp \
    misc/cpp/ActionShortcuts.cpp \
    misc/cpp/AddKnobDialog.cpp \
    misc/cpp/AnimatedCheckBox.cpp \
    misc/cpp/AutoHideToolBar.cpp \
    misc/cpp/BackdropGui.cpp \
    components/cpp/Button.cpp \
    components/cpp/ChannelsComboBox.cpp \
    components/cpp/ClickableLabel.cpp \
    misc/cpp/ColoredFrame.cpp \
    components/cpp/ComboBox.cpp \
    misc/cpp/CurveEditor.cpp \
    misc/cpp/CurveEditorUndoRedo.cpp \
    misc/cpp/CurveGui.cpp \
    misc/cpp/CurveWidget.cpp \
    misc/cpp/CurveWidgetDialogs.cpp \
    misc/cpp/CurveWidgetPrivate.cpp \
    misc/cpp/CustomParamInteract.cpp \
    misc/cpp/DialogButtonBox.cpp \
    misc/cpp/DockablePanel.cpp \
    misc/cpp/DockablePanelPrivate.cpp \
    misc/cpp/DockablePanelTabWidget.cpp \
    misc/cpp/DocumentationManager.cpp \
    misc/cpp/DopeSheet.cpp \
    misc/cpp/DopeSheetEditor.cpp \
    misc/cpp/DopeSheetEditorUndoRedo.cpp \
    misc/cpp/DopeSheetHierarchyView.cpp \
    misc/cpp/DopeSheetView.cpp \
    misc/cpp/DotGui.cpp \
    misc/cpp/Edge.cpp \
    misc/cpp/EditExpressionDialog.cpp \
    misc/cpp/EditScriptDialog.cpp \
    misc/cpp/ExportGroupTemplateDialog.cpp \
    misc/cpp/FileTypeMainWindow_win.cpp \
    misc/cpp/FloatingWidget.cpp \
    misc/cpp/GroupBoxLabel.cpp \
    main/cpp/Gui.cpp \
    main/cpp/Gui05.cpp \
    main/cpp/Gui10.cpp \
    main/cpp/Gui15.cpp \
    main/cpp/Gui20.cpp \
    main/cpp/Gui30.cpp \
    main/cpp/Gui40.cpp \
    main/cpp/Gui50.cpp \
    main/cpp/GuiAppInstance.cpp \
    main/cpp/GuiApplicationManager.cpp \
    main/cpp/GuiApplicationManager10.cpp \
    main/cpp/GuiApplicationManagerPrivate.cpp \
    main/cpp/GuiPrivate.cpp \
    misc/cpp/Histogram.cpp \
    misc/cpp/HostOverlay.cpp \
    misc/cpp/InfoViewerWidget.cpp \
    knob/cpp/KnobGui.cpp \
    knob/cpp/KnobGui10.cpp \
    knob/cpp/KnobGui20.cpp \
    knob/cpp/KnobGuiBool.cpp \
    knob/cpp/KnobGuiButton.cpp \
    knob/cpp/KnobGuiChoice.cpp \
    knob/cpp/KnobGuiColor.cpp \
    knob/cpp/KnobGuiContainerHelper.cpp \
    knob/cpp/KnobGuiFactory.cpp \
    knob/cpp/KnobGuiFile.cpp \
    knob/cpp/KnobGuiGroup.cpp \
    knob/cpp/KnobGuiParametric.cpp \
    knob/cpp/KnobGuiPrivate.cpp \
    knob/cpp/KnobGuiSeparator.cpp \
    knob/cpp/KnobGuiString.cpp \
    knob/cpp/KnobGuiTable.cpp \
    knob/cpp/KnobGuiValue.cpp \
    knob/cpp/KnobUndoCommand.cpp \
    knob/cpp/KnobWidgetDnD.cpp \
    components/cpp/Label.cpp \
    components/cpp/LineEdit.cpp \
    misc/cpp/LinkToKnobDialog.cpp \
    misc/cpp/LogWindow.cpp \
    misc/cpp/ManageUserParamsDialog.cpp \
    misc/cpp/Menu.cpp \
    misc/cpp/MessageBox.cpp \
    misc/cpp/MultiInstancePanel.cpp \
    misc/cpp/NewLayerDialog.cpp \
    node_graph/cpp/NodeBackdropSerialization.cpp \
    node_graph/cpp/NodeCreationDialog.cpp \
    node_graph/cpp/NodeGraph.cpp \
    node_graph/cpp/NodeGraph05.cpp \
    node_graph/cpp/NodeGraph10.cpp \
    node_graph/cpp/NodeGraph13.cpp \
    node_graph/cpp/NodeGraph15.cpp \
    node_graph/cpp/NodeGraph20.cpp \
    node_graph/cpp/NodeGraph25.cpp \
    node_graph/cpp/NodeGraph30.cpp \
    node_graph/cpp/NodeGraph35.cpp \
    node_graph/cpp/NodeGraph40.cpp \
    node_graph/cpp/NodeGraph45.cpp \
    node_graph/cpp/NodeGraphPrivate.cpp \
    node_graph/cpp/NodeGraphPrivate10.cpp \
    node_graph/cpp/NodeGraphRectItem.cpp \
    node_graph/cpp/NodeGraphTextItem.cpp \
    node_graph/cpp/NodeGraphUndoRedo.cpp \
    node_graph/cpp/NodeGui.cpp \
    node_graph/cpp/NodeGuiSerialization.cpp \
    node_graph/cpp/NodeSettingsPanel.cpp \
    node_graph/cpp/NodeViewerContext.cpp \
    misc/cpp/PanelWidget.cpp \
    misc/cpp/PickKnobDialog.cpp \
    misc/cpp/PreferencesPanel.cpp \
    misc/cpp/PreviewThread.cpp \
    misc/cpp/ProgressPanel.cpp \
    misc/cpp/ProgressTaskInfo.cpp \
    main/cpp/ProjectGui.cpp \
    main/cpp/ProjectGuiSerialization.cpp \
    misc/cpp/PropertiesBinWrapper.cpp \
    main/cpp/PyGuiApp.cpp \
    misc/cpp/PythonPanels.cpp \
    misc/cpp/QtEnumConvert.cpp \
    misc/cpp/RenderStatsDialog.cpp \
    misc/cpp/ResizableMessageBox.cpp \
    misc/cpp/RightClickableWidget.cpp \
    misc/cpp/RotoPanel.cpp \
    misc/cpp/ScaleSliderQWidget.cpp \
    misc/cpp/ScriptEditor.cpp \
    misc/cpp/ScriptTextEdit.cpp \
    misc/cpp/SequenceFileDialog.cpp \
    misc/cpp/SerializableWindow.cpp \
    misc/cpp/Shaders.cpp \
    components/cpp/SpinBox.cpp \
    components/cpp/SpinBoxValidator.cpp \
    misc/cpp/SplashScreen.cpp \
    misc/cpp/Splitter.cpp \
    misc/cpp/TabGroup.cpp \
    misc/cpp/TabWidget.cpp \
    misc/cpp/TableModelView.cpp \
    misc/cpp/TextRenderer.cpp \
    misc/cpp/TimeLineGui.cpp \
    misc/cpp/ToolButton.cpp \
    misc/cpp/TrackerPanel.cpp \
    misc/cpp/VerticalColorBar.cpp \
    viewer/cpp/ViewerGL.cpp \
    viewer/cpp/ViewerGLPrivate.cpp \
    viewer/cpp/ViewerTab.cpp \
    viewer/cpp/ViewerTab10.cpp \
    viewer/cpp/ViewerTab20.cpp \
    viewer/cpp/ViewerTab30.cpp \
    viewer/cpp/ViewerTab40.cpp \
    viewer/cpp/ViewerTabPrivate.cpp \
    viewer/cpp/ViewerToolButton.cpp \
    misc/cpp/ticks.cpp \
    wrapper/cpp/guiapp_wrapper.cpp \
    wrapper/cpp/pyguiapplication_wrapper.cpp \
    wrapper/cpp/pymodaldialog_wrapper.cpp \
    wrapper/cpp/pypanel_wrapper.cpp \
    wrapper/cpp/pytabwidget_wrapper.cpp \
    wrapper/cpp/pyviewer_wrapper.cpp \
    wrapper/cpp/natrongui_module_wrapper.cpp \
    ../utils/util.cpp 

HEADERS += \
    misc/hpp/AboutWindow.h \
    misc/hpp/ActionShortcuts.h \
    misc/hpp/AddKnobDialog.h \
    misc/hpp/AnimatedCheckBox.h \
    misc/hpp/AutoHideToolBar.h \
    misc/hpp/BackdropGui.h \
    components/hpp/Button.h \
    components/hpp/ChannelsComboBox.h \
    components/hpp/ClickableLabel.h \
    misc/hpp/ColoredFrame.h \
    components/hpp/ComboBox.h \
    misc/hpp/CurveEditor.h \
    misc/hpp/CurveEditorUndoRedo.h \
    misc/hpp/CurveGui.h \
    misc/hpp/CurveSelection.h \
    misc/hpp/CurveWidget.h \
    misc/hpp/CurveWidgetDialogs.h \
    misc/hpp/CurveWidgetPrivate.h \
    misc/hpp/CustomParamInteract.h \
    misc/hpp/DialogButtonBox.h \
    misc/hpp/DockablePanel.h \
    misc/hpp/DockablePanelPrivate.h \
    misc/hpp/DockablePanelTabWidget.h \
    misc/hpp/DocumentationManager.h \
    misc/hpp/DopeSheet.h \
    misc/hpp/DopeSheetEditor.h \
    misc/hpp/DopeSheetEditorUndoRedo.h \
    misc/hpp/DopeSheetHierarchyView.h \
    misc/hpp/DopeSheetView.h \
    misc/hpp/DotGui.h \
    misc/hpp/Edge.h \
    misc/hpp/EditExpressionDialog.h \
    misc/hpp/EditScriptDialog.h \
    misc/hpp/ExportGroupTemplateDialog.h \
    misc/hpp/FileTypeMainWindow_win.h \
    misc/hpp/FloatingWidget.h \
    misc/hpp/GroupBoxLabel.h \
    main/hpp/Gui.h \
    main/hpp/GuiAppInstance.h \
    main/hpp/GuiApplicationManager.h \
    main/hpp/GuiApplicationManagerPrivate.h \
    main/hpp/GuiDefines.h \
    main/hpp/GuiFwd.h \
    main/hpp/GuiMacros.h \
    main/hpp/GuiPrivate.h \
    misc/hpp/Histogram.h \
    misc/hpp/HostOverlay.h \
    misc/hpp/InfoViewerWidget.h \
    knob/hpp/KnobGui.h \
    knob/hpp/KnobGuiBool.h \
    knob/hpp/KnobGuiButton.h \
    knob/hpp/KnobGuiChoice.h \
    knob/hpp/KnobGuiColor.h \
    knob/hpp/KnobGuiContainerHelper.h \
    knob/hpp/KnobGuiContainerI.h \
    knob/hpp/KnobGuiFactory.h \
    knob/hpp/KnobGuiFile.h \
    knob/hpp/KnobGuiGroup.h \
    knob/hpp/KnobGuiParametric.h \
    knob/hpp/KnobGuiSeparator.h \
    knob/hpp/KnobGuiString.h \
    knob/hpp/KnobGuiTable.h \
    knob/hpp/KnobGuiValue.h \
    knob/hpp/KnobUndoCommand.h \
    knob/hpp/KnobWidgetDnD.h \
    components/hpp/Label.h \
    components/hpp/LineEdit.h \
    misc/hpp/LinkToKnobDialog.h \
    misc/hpp/LogWindow.h \
    misc/hpp/ManageUserParamsDialog.h \
    misc/hpp/Menu.h \
    misc/hpp/MessageBox.h \
    misc/hpp/MultiInstancePanel.h \
    misc/hpp/NewLayerDialog.h \
    node_graph/hpp/NodeBackdropSerialization.h \
    node_graph/hpp/NodeClipBoard.h \
    node_graph/hpp/NodeCreationDialog.h \
    node_graph/hpp/NodeGraph.h \
    node_graph/hpp/NodeGraphPrivate.h \
    node_graph/hpp/NodeGraphRectItem.h \
    node_graph/hpp/NodeGraphTextItem.h \
    node_graph/hpp/NodeGraphUndoRedo.h \
    node_graph/hpp/NodeGui.h \
    node_graph/hpp/NodeGuiSerialization.h \
    node_graph/hpp/NodeSettingsPanel.h \
    node_graph/hpp/NodeViewerContext.h \
    misc/hpp/PanelWidget.h \
    misc/hpp/PickKnobDialog.h \
    misc/hpp/PreferencesPanel.h \
    misc/hpp/PreviewThread.h \
    misc/hpp/ProgressPanel.h \
    misc/hpp/ProgressTaskInfo.h \
    main/hpp/ProjectGui.h \
    main/hpp/ProjectGuiSerialization.h \
    misc/hpp/PropertiesBinWrapper.h \
    main/hpp/PyGlobalGui.h \
    main/hpp/PyGuiApp.h \
    main/hpp/Pyside_Gui_Python.h \
    misc/hpp/PythonPanels.h \
    misc/hpp/QtEnumConvert.h \
    misc/hpp/RegisteredTabs.h \
    misc/hpp/RenderStatsDialog.h \
    misc/hpp/ResizableMessageBox.h \
    misc/hpp/RightClickableWidget.h \
    misc/hpp/RotoPanel.h \
    misc/hpp/ScaleSliderQWidget.h \
    misc/hpp/ScriptEditor.h \
    misc/hpp/ScriptTextEdit.h \
    misc/hpp/SequenceFileDialog.h \
    misc/hpp/SerializableWindow.h \
    misc/hpp/Shaders.h \
    components/hpp/SpinBox.h \
    components/hpp/SpinBoxValidator.h \
    misc/hpp/SplashScreen.h \
    misc/hpp/Splitter.h \
    misc/hpp/TabGroup.h \
    misc/hpp/TabWidget.h \
    misc/hpp/TableModelView.h \
    misc/hpp/TextRenderer.h \
    misc/hpp/TimeLineGui.h \
    misc/hpp/ToolButton.h \
    misc/hpp/TrackerPanel.h \
    misc/hpp/VerticalColorBar.h \
    viewer/hpp/ViewerGL.h \
    viewer/hpp/ViewerGLPrivate.h \
    viewer/hpp/ViewerTab.h \
    viewer/hpp/ViewerTabPrivate.h \
    viewer/hpp/ViewerToolButton.h \
    misc/hpp/ZoomContext.h \
    misc/hpp/ticks.h \
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
    wrapper/hpp/guiapp_wrapper.h \
    wrapper/hpp/natrongui_python.h \
    wrapper/hpp/pyguiapplication_wrapper.h \
    wrapper/hpp/pymodaldialog_wrapper.h \
    wrapper/hpp/pypanel_wrapper.h \
    wrapper/hpp/pytabwidget_wrapper.h \
    wrapper/hpp/pyviewer_wrapper.h \
    ../utils/util.hpp 

RESOURCES += \
    GuiResources.qrc

# for i in `find Resources -type f |sort |uniq`; do fgrep -q "$i" GuiResources.qrc || echo "$i"; done |fgrep -v .git |fgrep -v .DS_Store
OTHER_FILES += \
    resources/Fonts/Apache_License.txt \
    resources/Images/MotionTypeRTS.png \
    resources/Images/Other/natron_picto_tools.svg \
    resources/Images/Other/natron_picto_viewer.svg \
    resources/Images/motionTypeAffine.png \
    resources/Images/motionTypeRT.png \
    resources/Images/motionTypeS.png \
    resources/Images/motionTypeT.png \
    resources/Images/natronIcon.icns \
    resources/Images/natronIcon.svg \
    resources/Images/natronIcon256_windows.ico \
    resources/Images/patternSize.png \
    resources/Images/prevUserKey.png \
    resources/Images/searchSize.png \
    resources/Images/splashscreen.svg

