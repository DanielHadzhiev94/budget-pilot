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

    ConfirmationDialog {
        id: deleteDialog

        dialogTitle: "Delete transaction"
        subtitle: "This action cannot be undone."
        message: "Are you sure you want to permanently delete this transaction?"
        confirmText: "Delete"
        iconText: "×"
        destructive: true

        onAccepted: {
            if (root.rowIndex !== -1 && root.viewModel) {
                root.viewModel.deleteTransaction(root.rowIndex);
                root.rowIndex = -1;
            }
        }

        onRejected: root.rowIndex = -1
        onClosed: root.rowIndex = -1
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 18

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 88
            radius: AppTheme.radiusXL
            color: AppTheme.backgroundMainCard
            border.color: AppTheme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 22
                anchors.rightMargin: 18
                spacing: 16

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "Transactions"
                        color: AppTheme.textPrimary
                        font.pixelSize: 28
                        font.bold: true
                    }

                    Text {
                        text: "Review, edit and manage your monthly transaction history."
                        color: AppTheme.textMuted
                        font.pixelSize: 14
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                MonthPicker {
                    Layout.preferredWidth: 285
                    Layout.preferredHeight: 42
                    Layout.alignment: Qt.AlignVCenter

                    onDateChanged: function (month, year) {
                        if (!root.viewModel) {
                            console.log("TransactionsPage: viewModel is undefined");
                            return;
                        }

                        root.viewModel.loadData(month, year);
                        root.viewModel.setDate(month, year);
                    }
                }

                AppButton {
                    label: "+ Add Transaction"
                    preferredWidth: 178
                    preferredHeight: 42
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: {
                        if (!root.dialogPopup) {
                            console.log("TransactionsPage: dialogPopup is undefined");
                            return;
                        }

                        root.dialogPopup.openForCreate();
                    }
                }
            }
        }

        TransactionTable {
            id: transactionTable
            Layout.fillWidth: true
            Layout.fillHeight: true
            viewModel: root.viewModel

            onEditTransactionClicked: function (row) {
                if (!root.dialogPopup) {
                    console.log("TransactionsPage: dialogPopup is undefined");
                    return;
                }

                if (row === undefined || row === null) {
                    console.log("TransactionsPage: edit row is undefined/null");
                    return;
                }

                root.dialogPopup.openForEdit(row);
            }

            onDeleteTransactionClicked: function (rowIndex) {
                if (rowIndex === undefined || rowIndex === null || rowIndex < 0) {
                    console.log("TransactionsPage: invalid delete rowIndex:", rowIndex);
                    return;
                }

                root.rowIndex = rowIndex;
                deleteDialog.open();
            }
        }
    }
}
