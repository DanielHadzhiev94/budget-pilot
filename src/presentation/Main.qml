import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

ApplicationWindow {
    visible: true
    width: 1440
    height: 900
    title: "BudgetPilot"

    Rectangle {
        anchors.fill: parent
        color: AppTheme.background

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Header {
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Sidebar {
                    Layout.preferredWidth: 240
                    Layout.fillHeight: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: AppTheme.backgroundAlt

                    ColumnLayout {
                        anchors.fill: parent

                        spacing: 12

                        FinancialSummarySection {
                            viewModel: financialSummaryVM

                            Layout.fillWidth: true
                            Layout.preferredHeight: 220

                            onAddTransactionClicked: addTransactionDialog.open()
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

            }
        }
    }

    AddTransactionDialog {
        id: addTransactionDialog
        viewModel: addTransactionVM
    }
}
