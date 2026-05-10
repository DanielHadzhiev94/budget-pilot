import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Dialog {
    id: root

    required property var viewModel
    property string transactionType: "Expense"

    title: "Add Transaction"
    modal: true

    width: 420
    height: 560

    anchors.centerIn: parent

    onOpened:{
        root.viewModel.loadInitialData()
    }

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

            model: root.viewModel.categories
            textRole: "name"
            valueRole: "id"

            contentItem: Text {
                text: categoryInput.displayText
                color: AppTheme.textPrimary
                verticalAlignment: Text.AlignVCenter
                leftPadding: 10
                rightPadding: categoryInput.indicator.width + 10
                elide: Text.ElideRight
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            visible: root.transactionType == "Income"

            Text {
                id: accountTitle
                text: "Account"
                color: AppTheme.textPrimary
            }

            ComboBox {
                id: accountInput
                Layout.fillWidth: true

                model: root.viewModel.accounts
                textRole: "name"
                valueRole: "id"

                contentItem: Text {
                    text: accountInput.displayText
                    color: AppTheme.textPrimary
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 10
                    rightPadding: accountInput.indicator.width + 10
                    elide: Text.ElideRight
                }
            }
        }

        TextField {
            id: sourceInput
            placeholderText: "Source"
            Layout.fillWidth: true
        }

        DatePicker {
            id: datePicker
        }

        Rectangle {
            radius: 6
            Layout.fillWidth: true
            Layout.preferredHeight: 90
            border.color: AppTheme.border
            color: AppTheme.backgroundMainCard

            TextArea {
                id: noteInput
                placeholderText: "Note"
                anchors.fill: parent;
            }
        }


        Rectangle {
            id: errorBox

            Layout.fillWidth: true
            Layout.preferredHeight: errorText.implicitHeight + 20

            visible: viewModel.errorMessage.length > 0

            radius: 8
            color: "#2A1215"
            border.color: AppTheme.danger
            border.width: 1

            Text {
                id: errorText

                anchors.fill: parent
                anchors.margins: 10

                text: viewModel.errorMessage
                color: AppTheme.danger
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
            }
        }

        RowLayout {
            Layout.margins: 5
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
                    let month = datePicker.selectedMonth
                    let year = datePicker.selectedYear
                    let date = new Date(year, month, 1)

                    const success = root.viewModel.saveTransaction(
                        Number(amountInput.text),
                        typeInput.currentText,
                        accountInput.currentValue,
                        categoryInput.currentText,
                        sourceInput.text,
                        date,
                        noteInput.text
                    )

                    if (success) {
                        root.close()
                    }
                }
            }
        }
    }
}
