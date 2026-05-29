import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import BudgetPilot

Item {
    id: root

    property var viewModel
    property var dialogPopup
    property int rowIndex: -1

    signal editTransactionClicked(var row)
    signal deleteTransactionClicked(int rowIndex)

    Dialog {
        id: deleteDialog

        title: "Delete transaction?"
        modal: true

        onAccepted: {
            if (root.rowIndex !== -1 && root.viewModel) {
                root.viewModel.deleteTransaction(root.rowIndex)
                root.rowIndex = -1
            }
        }

        onRejected: {
            root.rowIndex = -1
        }

        onClosed: {
            root.rowIndex = -1
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 22

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 90

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Transactions"
                    color: AppTheme.textPrimary
                    font.pixelSize: 36
                    font.bold: true
                }

                Text {
                    text: "Full transaction history"
                    color: AppTheme.textSecondary
                    font.pixelSize: 18
                }
            }

            Item {
                Layout.fillWidth: true
            }

            DatePicker {
                Layout.preferredWidth: 285
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignVCenter

                onDateChanged: function(month, year) {
                    if (!root.viewModel) {
                        console.log("TransactionsPage: viewModel is undefined")
                        return
                    }

                    root.viewModel.loadData(month, year)
                    root.viewModel.setDate(month, year)
                }
            }

            Item {
                Layout.preferredWidth: 5
            }

            CustomButton {
                title: "Add Transaction"
                custom_width: 160
                custom_height: 40
                Layout.alignment: Qt.AlignRight

                onClicked: {
                    if (!root.dialogPopup) {
                        console.log("TransactionsPage: dialogPopup is undefined")
                        return
                    }

                    root.dialogPopup.openForCreate()
                }
            }
        }

        TransactionTable {
            id: transactionTable

            Layout.fillWidth: true
            Layout.fillHeight: true

            viewModel: root.viewModel

            onEditTransactionClicked: function(row) {
                if (!root.dialogPopup) {
                    console.log("TransactionsPage: dialogPopup is undefined")
                    return
                }

                if (row === undefined || row === null) {
                    console.log("TransactionsPage: edit row is undefined/null")
                    return
                }

                console.log("TransactionsPage: edit row:", JSON.stringify(row))

                root.dialogPopup.openForEdit(row)
            }

            onDeleteTransactionClicked: function(rowIndex) {
                if (rowIndex === undefined || rowIndex === null || rowIndex < 0) {
                    console.log("TransactionsPage: invalid delete rowIndex:", rowIndex)
                    return
                }

                root.rowIndex = rowIndex
                deleteDialog.open()
            }
        }
    }
}