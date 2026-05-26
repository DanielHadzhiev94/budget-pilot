import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import BudgetPilot

Item {
    id: root

    property var viewModel
    property int rowIndex: -1

    signal addTransactionClicked()

    signal editTransactionClicked(var row)

    signal deleteTransactionClicked(int rowIndex)

    Dialog {
        id: deleteDialog

        title: "Delete transaction?"
        modal: true

        onAccepted: {
            root.viewModel.deleteTransaction(root.rowIndex)

            if (root.rowIndex !== -1) {
                root.viewModel.deleteTransaction(root.rowIndex)
                root.rowIndex = -1
            }
        }

        onRejected: {
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

                onDateChanged: function (month, year) {
                    root.viewModel.loadData(month, year)
                    root.viewModel.setDate(month, year)
                }
            }

            CustomButton {
                title: "Add Transaction"
                custom_width: 190
                custom_height: 48
                Layout.alignment: Qt.AlignRight

                onClicked: root.addTransactionClicked()
            }
        }

        TransactionTable {
            Layout.fillWidth: true
            Layout.fillHeight: true

            viewModel: root.viewModel

            onEditTransactionClicked: function (row) {
                root.editTransactionClicked(row)
            }

            onDeleteTransactionClicked: function (rowIndex) {
                root.rowIndex = rowIndex
                deleteDialog.open()
            }
        }
    }
}