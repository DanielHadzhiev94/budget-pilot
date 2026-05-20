import QtQuick
import QtQuick.Layouts
import BudgetPilot

Item {
    id: root

    property var viewModel

    signal addTransactionClicked()

    signal editTransactionClicked(int row)

    signal deleteTransactionClicked(int row)

    Dialog {
        id: deleteDialog
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
                    root.viewModel.loadData(month, year);
                }
            }

            CustomButton {
                title: "Add Transaction"
                custom_width: 190
                custom_height: 48
                Layout.alignment: Qt.Alignment.AlignRight

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

            onDeleteTransactionClicked: function (row) {
                deleteDialog.open()
                root.deleteTransactionClicked(row)
            }
        }
    }
}