import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Dialog {
    id: root

    title: "Add Transaction"
    modal: true

    width: 420
    height: 520

    anchors.centerIn: parent

    property string transactionType: "Expense"

    background: Rectangle {
        radius: 14
        color: AppTheme.backgroundMainCard
        border.color: AppTheme.border
    }

    contentItem: ColumnLayout {
        spacing: 14

        TextField {
            id: amountInput
            placeholderText: "Amount"
            Layout.fillWidth: true
        }

        ComboBox {
            id: typeInput
            Layout.fillWidth: true
            model: ["Expense", "Income"]
            currentIndex: 0

            onCurrentTextChanged: {
                root.transactionType = currentText;
            }
        }

        ComboBox {
            id: categoryInput
            Layout.fillWidth: true
            model: ["Food", "Salary", "Transport", "Shopping", "Other"]
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            visible: root.transactionType == "Income"

            Text {
                id: accountTitle
                text: "Account"
                color:AppTheme.textPrimary
            }

            ComboBox {
                id: accountInput
                Layout.fillWidth: true
                model: ["Sparkasse", "Paypal"]
            }
        }

        TextField {
            id: sourceInput
            placeholderText: "Source"
            Layout.fillWidth: true
        }

        TextArea {
            id: noteInput
            placeholderText: "Note"
            Layout.fillWidth: true
            Layout.preferredHeight: 90
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: "Cancel"
                onClicked: root.close()
            }

            Button {
                text: "Save"

                onClicked: {
                    console.log("Amount:", amountInput.text);
                    console.log("Type:", typeInput.currentText);
                    console.log("Category:", categoryInput.currentText);
                    console.log("Source:", sourceInput.text);
                    console.log("Note:", noteInput.text);

                    root.close();
                }
            }
        }
    }
}
