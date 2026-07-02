pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root

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

    property string category_name: categoryField.text
    property bool is_expense: expenseButton.checked

    property string custom_title: "Custom Modal Title"
    property string custom_field_title: "Custom field title"
    property string custom_placeholder_text: "Custom placeholder text"

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
                text: root.custom_title
                color: AppTheme.textPrimary

                font.pixelSize: titleFontSize
                font.bold: true
            }
        }
    }

    contentItem: ColumnLayout {
        spacing: contentSpacing

        Label {
            text: root.custom_field_title
            color: AppTheme.textPrimary

            font.pixelSize: labelFontSize
            font.bold: true
        }

        CustomTextField {
            id: categoryField

            Layout.fillWidth: true

            custom_placeholder_text: root.custom_placeholder_text
        }

        Label {
            text: "Type"
            color: AppTheme.textPrimary

            font.pixelSize: labelFontSize
            font.bold: true
        }

        RowLayout {
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

            CustomButton {
                custom_width: buttonWidth
                custom_height: buttonHeight

                custom_hover_color_1: AppTheme.backgroundAlt
                custom_hover_color_2: AppTheme.transparent

                text: "Cancel"

                onClicked: root.close()
            }

            CustomButton {
                custom_width: buttonWidth
                custom_height: buttonHeight

                text: "Create"

                enabled: categoryField.text.trim().length > 0

                onClicked: {
                    // TODO:
                    // categoryService.createCategory(
                    //     categoryField.text,
                    //     expenseButton.checked
                    // )

                    root.accept();
                }
            }
        }
    }

    Component.onCompleted: categoryField.forceActiveFocus()
}
