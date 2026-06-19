import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Dialog {
    id: root

    modal: true
    anchors.centerIn: parent

    width: 420
    padding: 20

    property string categoryName: categoryField.text
    property bool isExpense: expenseButton.checked

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
                text: "Add Category"
                font.pixelSize: 22
                font.bold: true
                color: AppTheme.textPrimary
            }
        }
    }

    contentItem: ColumnLayout {
        spacing: 18

        Label {
            text: "Category name"
            color: AppTheme.textPrimary
            font.bold: true
        }

        CustomTextField {
            id: categoryField

            custom_placeholder_text: "e.g. Groceries"
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
