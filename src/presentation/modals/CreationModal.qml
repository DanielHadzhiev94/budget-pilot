pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root

    modal: true
    anchors.centerIn: parent

    width: 420
    padding: 20

    property string category_name: categoryField.text
    property bool is_expense: expenseButton.checked

    property string custom_title: "Custom Modal Title"
    property string custom_field_title: "Custom field title"

    property string custom_placeholder_text: "Custom placeholder text"

    background: Rectangle {
        radius: 18
        color: AppTheme.backgroundMainCard
        border.width: 1
        border.color: AppTheme.border
    }

    header: Rectangle {
        implicitHeight: 70
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 20

            Text {
                text: root.custom_title
                font.pixelSize: 22
                font.bold: true
                color: AppTheme.textPrimary
            }
        }
    }

    contentItem: ColumnLayout {
        spacing: 18

        Label {
            text: root.custom_field_title
            color: AppTheme.textPrimary
            font.bold: true
        }

        CustomTextField {
            id: categoryField

            custom_placeholder_text: root.custom_placeholder_text
        }

        Label {
            text: "Type"
            color: AppTheme.textPrimary
            font.bold: true
        }

        RowLayout {
            spacing: 12

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
        implicitHeight: 90
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            Item {
                Layout.fillWidth: true
            }

            CustomButton {
                custom_height: 42
                custom_width: 112
                custom_hover_color_1: AppTheme.backgroundAlt
                custom_hover_color_2: AppTheme.transparent
                text: "Cancel"

                onClicked: root.close()
            }

            CustomButton {
                custom_height: 42
                custom_width: 112

                text: "Create"

                enabled: categoryField.text.trim().length > 0

                onClicked: {
                    // TODO:
                    // categoryService.createCategory(
                    //      categoryField.text,
                    //      expenseButton.checked
                    // )

                    root.accept();
                }
            }
        }
    }

    Component.onCompleted: categoryField.forceActiveFocus()
}
