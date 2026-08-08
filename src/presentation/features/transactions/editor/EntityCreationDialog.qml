pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Dialog {
    id: root

    required property var viewModel

    // ===== Layout =====
    readonly property int dialogWidth: 420
    readonly property int dialogPadding: 20
    readonly property int dialogRadius: 18

    readonly property int headerHeight: 70
    readonly property int footerHeight: 90

    readonly property int margin: 20
    readonly property int contentSpacing: 18
    readonly property int controlSpacing: 12

    // ===== Typography =====
    readonly property int titleFontSize: 22
    readonly property int labelFontSize: 15

    // ===== Controls =====
    readonly property int buttonWidth: 112
    readonly property int buttonHeight: 42

    modal: true
    anchors.centerIn: parent

    width: dialogWidth
    padding: dialogPadding
    closePolicy: Popup.CloseOnEscape

    property string entityType: "category"
    property bool defaultIsExpense: true
    readonly property bool isCategory: entityType === "category"
    readonly property string dialogTitle: isCategory ? "Add Category" : "Add Account"
    readonly property string fieldTitle: isCategory ? "Category Name" : "Account Name"
    readonly property string fieldPlaceholder: isCategory ? "e.g. Groceries" : "e.g. Checking account"

    onOpened: {
        categoryField.text = ""
        expenseButton.checked = root.defaultIsExpense
        categoryField.forceActiveFocus()
    }

    enter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: AppTheme.motionNormal; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale"; from: 0.96; to: 1; duration: AppTheme.motionNormal; easing.type: Easing.OutCubic }
        }
    }

    exit: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: AppTheme.motionFast; easing.type: Easing.InCubic }
            NumberAnimation { property: "scale"; from: 1; to: 0.98; duration: AppTheme.motionFast; easing.type: Easing.InCubic }
        }
    }

    background: Rectangle {
        radius: dialogRadius
        color: AppTheme.backgroundMainCard
        border.width: 1
        border.color: AppTheme.border
    }

    header: Rectangle {
        implicitHeight: headerHeight
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.margins: margin

            Text {
                text: root.dialogTitle
                color: AppTheme.textPrimary

                font.pixelSize: titleFontSize
                font.bold: true
            }
        }
    }

    contentItem: ColumnLayout {
        spacing: contentSpacing

        Label {
            text: root.fieldTitle
            color: AppTheme.textPrimary

            font.pixelSize: labelFontSize
            font.bold: true
        }

        AppTextField {
            id: categoryField

            Layout.fillWidth: true

            placeholderText: root.fieldPlaceholder
        }

        Label {
            Layout.fillWidth: true
            visible: root.viewModel.errorMessage.length > 0
            text: root.viewModel.errorMessage
            color: AppTheme.danger
            font.pixelSize: 13
            wrapMode: Text.WordWrap
        }

        Label {
            visible: root.isCategory
            text: "Type"
            color: AppTheme.textPrimary

            font.pixelSize: labelFontSize
            font.bold: true
        }

        RowLayout {
            visible: root.isCategory
            spacing: controlSpacing

            ButtonGroup {
                id: typeGroup
            }

            RadioButton {
                id: expenseButton

                text: "Expense"
                checked: true

                ButtonGroup.group: typeGroup
            }

            RadioButton {
                id: incomeButton

                text: "Income"

                ButtonGroup.group: typeGroup
            }
        }
    }

    footer: Rectangle {
        implicitHeight: footerHeight
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.margins: margin
            spacing: controlSpacing

            Item {
                Layout.fillWidth: true
            }

            AppButton {
                label: "Cancel"
                preferredWidth: buttonWidth
                preferredHeight: buttonHeight
                normalColor: "transparent"
                hoverColor: AppTheme.backgroundAlt
                pressedColor: AppTheme.surfaceLight

                onClicked: root.close()
            }

            AppButton {
                label: "Create"
                preferredWidth: buttonWidth
                preferredHeight: buttonHeight

                enabled: categoryField.text.trim().length > 0

                onClicked: {
                    const created = root.isCategory
                        ? root.viewModel.createCategory(categoryField.text, expenseButton.checked)
                        : root.viewModel.createAccount(categoryField.text)

                    if (created) {
                        root.accept()
                    }
                }
            }
        }
    }
}
