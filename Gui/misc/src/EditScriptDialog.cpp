/* ***** BEGIN LICENSE BLOCK *****
 * This file is part of Natron <https://natrongithub.github.io/>,
 * Copyright (C) 2013-2018 INRIA and Alexandre Gauthier-Foichat
 * Copyright (C) 2018-2020 The Natron developers
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

// ***** BEGIN PYTHON BLOCK *****
// from <https://docs.python.org/3/c-api/intro.html#include-files>:
// "Since Python may define some pre-processor definitions which affect the standard headers on some systems, you must include Python.h before any standard headers are included."
#include <Python.h>
// ***** END PYTHON BLOCK *****

#include <EditScriptDialog.h>

#include <cassert>
#include <climits>
#include <cfloat>
#include <stdexcept>

#include <boost/weak_ptr.hpp>

#include <QtCore/QString>
#include <QHBoxLayout>
#include <QPushButton>
#include <QFormLayout>
#include <QFileDialog>
#include <QTextEdit>
#include <QStyle> // in QtGui on Qt4, in QtWidgets on Qt5
#include <QtCore/QTimer>

GCC_DIAG_UNUSED_PRIVATE_FIELD_OFF
// /opt/local/include/QtGui/qmime.h:119:10: warning: private field 'type' is not used [-Wunused-private-field]
#include <QKeyEvent>
GCC_DIAG_UNUSED_PRIVATE_FIELD_ON
#include <QColorDialog>
#include <QGroupBox>
#include <QtGui/QVector4D>
#include <QStyleFactory>
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

#include <Button.h>
#include <ComboBox.h>
#include <CurveEditor.h>
#include <CurveGui.h>
#include <CustomParamInteract.h>
#include <DialogButtonBox.h>
#include <DockablePanel.h>
#include <Gui.h>
#include <GuiAppInstance.h>
#include <GuiApplicationManager.h>
#include <KnobGuiGroup.h>
#include <Label.h>
#include <LineEdit.h>
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

NATRON_NAMESPACE_ENTER

struct EditScriptDialogPrivate
{
    Gui *gui;
    QVBoxLayout *mainLayout;
    InputScriptTextEdit *expressionEdit;
    QWidget *midButtonsContainer;
    QHBoxLayout *midButtonsLayout;
    Button *useRetButton;
    OutputScriptTextEdit *resultEdit;
    DialogButtonBox *buttons;

    EditScriptDialogPrivate(Gui *gui)
        : gui(gui), mainLayout(0), expressionEdit(0), midButtonsContainer(0), midButtonsLayout(0), useRetButton(0), resultEdit(0), buttons(0)
    {
    }
};

EditScriptDialog::EditScriptDialog(Gui *gui,
                                   QWidget *parent)
    : QDialog(parent), _imp(new EditScriptDialogPrivate(gui))
{
    // cambia el tamanio del 'widget' y lo centra en el 'gui'
    setGeometry(0, 0, 1000, 500);
    QRect rec = gui->geometry();
    move(QPoint((rec.width() - 1000) / 2, (rec.height() - 500) / 2));

    setWindowFlags(windowFlags() | Qt::WindowStaysOnTopHint);
}

void EditScriptDialog::create(const QString &initialScript,
                              bool makeUseRetButton)
{
    setTitle();

    _imp->mainLayout = new QVBoxLayout(this);

    QStringList modules;
    getImportedModules(modules);
    std::list<std::pair<QString, QString>> variables;
    getDeclaredVariables(variables);

    _imp->midButtonsContainer = new QWidget(this);
    _imp->midButtonsContainer->setObjectName("midButtonsContainer");
    _imp->midButtonsLayout = new QHBoxLayout(_imp->midButtonsContainer);
    _imp->midButtonsLayout->setContentsMargins(0, 0, 0, 0);

    if (makeUseRetButton)
    {
        bool retVariable = hasRetVariable();
        _imp->useRetButton = new Button(tr("Multi-line"), _imp->midButtonsContainer);
        _imp->useRetButton->setToolTip(NATRON_NAMESPACE::convertFromPlainText(tr("When checked the Python expression will be interpreted "
                                                                                 "as series of statement. The return value should be then assigned to the "
                                                                                 "\"ret\" variable. When unchecked the expression must not contain "
                                                                                 "any new line character and the result will be interpreted from the "
                                                                                 "interpretation of the single line."),
                                                                              NATRON_NAMESPACE::WhiteSpaceNormal));
        _imp->useRetButton->setCheckable(true);
        bool checked = !initialScript.isEmpty() && retVariable;
        _imp->useRetButton->setChecked(checked);
        _imp->useRetButton->setDown(checked);
        QObject::connect(_imp->useRetButton, SIGNAL(clicked(bool)), this, SLOT(onUseRetButtonClicked(bool)));
        _imp->midButtonsLayout->addWidget(_imp->useRetButton);
    }

    _imp->midButtonsLayout->addStretch();

    _imp->mainLayout->addWidget(_imp->midButtonsContainer);

    _imp->resultEdit = new OutputScriptTextEdit(this);
    _imp->resultEdit->setFixedHeight(100);
    _imp->resultEdit->setFocusPolicy(Qt::NoFocus);
    _imp->resultEdit->setReadOnly(true);
    _imp->mainLayout->addWidget(_imp->resultEdit);

    _imp->expressionEdit = new InputScriptTextEdit(_imp->gui, this);
    _imp->expressionEdit->setAcceptDrops(true);
    _imp->expressionEdit->setMouseTracking(true);
    _imp->mainLayout->addWidget(_imp->expressionEdit);
    _imp->expressionEdit->setPlainText(initialScript);

    _imp->buttons = new DialogButtonBox(QDialogButtonBox::Ok | QDialogButtonBox::Cancel, Qt::Horizontal, this);
    _imp->mainLayout->addWidget(_imp->buttons);
    QObject::connect(_imp->buttons, SIGNAL(accepted()), this, SLOT(accept()));
    QObject::connect(_imp->buttons, SIGNAL(rejected()), this, SLOT(reject()));

    if (!initialScript.isEmpty())
    {
        compileAndSetResult(initialScript);
    }
    QObject::connect(_imp->expressionEdit, SIGNAL(textChanged()), this, SLOT(onTextEditChanged()));
    _imp->expressionEdit->setFocus();

    QString fontFamily = QString::fromUtf8(appPTR->getCurrentSettings()->getSEFontFamily().c_str());
    int fontSize = appPTR->getCurrentSettings()->getSEFontSize();
    QFont font(fontFamily, fontSize);
    if (font.exactMatch())
    {
        _imp->expressionEdit->setFont(font);
        _imp->resultEdit->setFont(font);
    }
    QFontMetrics fm = _imp->expressionEdit->fontMetrics();
    _imp->expressionEdit->setTabStopWidth(4 * fm.width(QLatin1Char(' ')));
} // EditScriptDialog::create

void EditScriptDialog::compileAndSetResult(const QString &script)
{
    QString ret = compileExpression(script);

    _imp->resultEdit->setPlainText(ret);
}

QString
EditScriptDialog::getHelpPart1()
{
    return tr("<p>Each node in the scope already has a variable declared with its name, e.g if you have a node named "
              "<b>Transform1</b> in your project, then you can type <i>Transform1</i> to reference that node.</p>"
              "<p>Note that the scope includes all nodes within the same group as thisNode and the parent group node itself, "
              "if the node belongs to a group. If the node itself is a group, then it can also have expressions depending "
              "on parameters of its children.</p>"
              "<p>Each node has all its parameters declared as fields and you can reference a specific parameter by typing its <b>script name</b>, e.g:</p>"
              "<pre>Transform1.rotate</pre>"
              "<p>The script name of a parameter is the name in bold that is shown in the tooltip when hovering a parameter with the mouse, this is what "
              "identifies a parameter internally.</p>");
}

QString
EditScriptDialog::getHelpThisNodeVariable()
{
    return tr("<p>The current node which expression is being edited can be referenced by the variable <i>thisNode</i> for convenience.</p>");
}

QString
EditScriptDialog::getHelpThisGroupVariable()
{
    return tr("<p>The parent group containing the thisNode can be referenced by the variable <i>thisGroup</i> for convenience, if and "
              "only if thisNode belongs to a group.</p>");
}

QString
EditScriptDialog::getHelpThisParamVariable()
{
    return tr("<p>The <i>thisParam</i> variable has been defined for convenience when editing an expression. It refers to the current parameter.</p>");
}

QString
EditScriptDialog::getHelpDimensionVariable()
{
    return tr("<p>In the same way the <i>dimension</i> variable has been defined and references the current dimension of the parameter which expression is being set"
              ".</p>"
              "<p>The <i>dimension</i> is a 0-based index identifying a specific field of a parameter. For instance if we're editing the expression of the y "
              "field of the translate parameter of Transform1, the <i>dimension</i> would be 1. </p>");
}

QString
EditScriptDialog::getHelpPart2()
{
    return tr("<p>To access values of a parameter several functions are made accessible: </p>"
              "<p>The <b>get()</b> function will return a Tuple containing all the values for each dimension of the parameter. For instance "
              "let's say we have a node Transform1 in our comp, we could then reference the x value of the <i>center</i> parameter this way:</p>"
              "<pre>Transform1.center.get().x</pre>"
              "<p>The <b>get(</b><i>frame</i><b>)</b> works exactly like the <b>get()</b> function excepts that it takes an extra "
              "<i>frame</i> parameter corresponding to the time at which we want to fetch the value. For parameters with an animation "
              "it would then return their value at the corresponding timeline position. That value would then be either interpolated "
              "with the current interpolation filter, or the exact keyframe at that time if one exists.</p>");
}

void EditScriptDialog::onHelpRequested()
{
    QString help = getCustomHelp();
    Dialogs::informationDialog(tr("Help").toStdString(), help.toStdString(), true);
}

QString
EditScriptDialog::getExpression(bool *hasRetVariable) const
{
    if (hasRetVariable)
    {
        *hasRetVariable = _imp->useRetButton ? _imp->useRetButton->isChecked() : false;
    }

    return _imp->expressionEdit->toPlainText();
}

bool EditScriptDialog::isUseRetButtonChecked() const
{
    return _imp->useRetButton->isChecked();
}

void EditScriptDialog::onTextEditChanged()
{
    compileAndSetResult(_imp->expressionEdit->toPlainText());
}

void EditScriptDialog::onUseRetButtonClicked(bool useRet)
{
    compileAndSetResult(_imp->expressionEdit->toPlainText());
    _imp->useRetButton->setDown(useRet);
}

EditScriptDialog::~EditScriptDialog()
{
}

void EditScriptDialog::keyPressEvent(QKeyEvent *e)
{
    if ((e->key() == Qt::Key_Return) || (e->key() == Qt::Key_Enter))
    {
        accept();
    }
    else if (e->key() == Qt::Key_Escape)
    {
        reject();
    }
    else
    {
        QDialog::keyPressEvent(e);
    }
}

NATRON_NAMESPACE_EXIT

NATRON_NAMESPACE_USING
#include "moc_EditScriptDialog.cpp"
