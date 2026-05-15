import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    required property var dialogPopup

    Layout.fillWidth: true
    Layout.fillHeight: true

    color: AppTheme.backgroundAlt

    function openAddTransactionDialog() {
        if (root.dialogPopup) {
            root.dialogPopup.open()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Rectangle {
            radius: 12
            color: AppTheme.backgroundMainCard
            border.color: AppTheme.border
            border.width: 1

            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.topMargin: 20

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                DatePicker {
                    onDateChanged: function(month, year) {
                        financialSummaryVM.set_date(month, year)
                        financialSummaryVM.load_data(month, year)
                        transactionTableVM.load_data(month, year)
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                CustomButton {
                    text: "Add Transaction"

                    onClicked: {
                        root.openAddTransactionDialog()
                    }
                }
            }
        }

        FinancialSummarySection {
            viewModel: financialSummaryVM

            Layout.fillWidth: true
            Layout.preferredHeight: 220

            onAddTransactionClicked: {
                root.openAddTransactionDialog()
            }
        }

        TransactionTableSection {
            viewModel: transactionTableVM
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}