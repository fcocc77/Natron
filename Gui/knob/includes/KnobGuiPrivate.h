/* ***** BEGIN LICENSE BLOCK *****
 * This file is part of Natron <http://www.natron.fr/>,
 * Copyright (C) 2016 INRIA and Alexandre Gauthier-Foichat
 *
 * Natron is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Natron is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Natron.  If not, see <http://www.gnu.org/licenses/gpl-2.0.html>
 * ***** END LICENSE BLOCK ***** */

#ifndef _Gui_KnobGuiPrivate_h_
#define _Gui_KnobGuiPrivate_h_

// ***** BEGIN PYTHON BLOCK *****
// from <https://docs.python.org/3/c-api/intro.html#include-files>:
// "Since Python may define some pre-processor definitions which affect the standard headers on some systems, you must include Python.h before any standard headers are included."
#include <Python.h>
// ***** END PYTHON BLOCK *****

#include <KnobGui.h>

//#include <KnobUndoCommand.h>

#include <cassert>
#include <climits>
#include <cfloat>
#include <stdexcept>
#include <map>
#include <boost/weak_ptr.hpp>


#include <QtCore/QString>
#include <QHBoxLayout>
#include <QPushButton>
#include <QFormLayout>
#include <QFileDialog>
#include <QTextEdit>
#include <QStyle> // in QtGui on Qt4, in QtWidgets on Qt5
#include <QTimer>

GCC_DIAG_UNUSED_PRIVATE_FIELD_OFF
// /opt/local/include/QtGui/qmime.h:119:10: warning: private field 'type' is not used [-Wunused-private-field]
#include <QKeyEvent>
GCC_DIAG_UNUSED_PRIVATE_FIELD_ON
#include <QColorDialog>
#include <QGroupBox>
#include <QtGui/QVector4D>
#include <QStyleFactory>
#include <QComboBox>
#include <QDialogButtonBox>
#include <QCompleter>

#include "Global/GlobalDefines.h"

#include "Engine/Curve.h"
#include "Engine/KnobFile.h"
#include "Engine/KnobSerialization.h"
#include "Engine/KnobTypes.h"
#include "Engine/LibraryBinary.h"
#include "Engine/Node.h"
#include "Engine/NodeGroup.h"
#include "Engine/Project.h"
#include "Engine/Settings.h"
#include "Engine/TimeLine.h"
#include "Engine/Utils.h" // convertFromPlainText
#include "Engine/Variant.h"
#include "Engine/ViewerInstance.h"

#include <ComboBox.h>
#include <ClickableLabel.h>
#include <CurveEditor.h>
#include <CurveGui.h>
#include <CustomParamInteract.h>
#include <DockablePanel.h>
#include <EditExpressionDialog.h>
#include <Gui.h>
#include <GuiAppInstance.h>
#include <GuiApplicationManager.h>
#include <KnobGuiGroup.h>
#include <LineEdit.h>
#include <LinkToKnobDialog.h>
#include <Menu.h>
#include <Menu.h>
#include <NodeCreationDialog.h>
#include <NodeGui.h>
#include <NodeSettingsPanel.h>
#include <ScriptTextEdit.h>
#include <SequenceFileDialog.h>
#include <SpinBox.h>
#include <TabWidget.h>
#include <TimeLineGui.h>
#include <ViewerTab.h>

NATRON_NAMESPACE_ENTER;


struct KnobGuiPrivate
{
    bool triggerNewLine;
    int spacingBetweenItems;
    bool widgetCreated;
    KnobGuiContainerI*  container;
    QMenu* copyRightClickMenu;
    QHBoxLayout* fieldLayout; //< the layout containing the widgets of the knob

    ////A vector of all other knobs on the same line.
    std::vector< boost::weak_ptr< KnobI > > knobsOnSameLine;
    QWidget* field;
    QWidget* labelContainer;
    KnobClickableLabel* descriptionLabel;
    Label* warningIndicator;
    std::map<KnobGui::KnobWarningEnum, QString> warningsMapping;
    bool isOnNewLine;
    CustomParamInteract* customInteract;
    std::vector< boost::shared_ptr<Curve> > guiCurves;
    bool guiRemoved;

    // True if this KnobGui is used in the viewer
    bool isInViewerUIKnob;

    KnobGuiPrivate(KnobGuiContainerI* container);

    void removeFromKnobsOnSameLineVector(const boost::shared_ptr<KnobI>& knob);
};

NATRON_NAMESPACE_EXIT;

#endif // _Gui_KnobGuiPrivate_h_
