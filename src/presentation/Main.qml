import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

ApplicationWindow {
    id: appRoot

    visible: true
    width: 1440
    height: 900
    title: "BudgetPilot"

    property int currentPage: 0

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

                    selectedIndex: appRoot.currentPage

                    onItemSelected: function(index) {
                        appRoot.currentPage = index
                    }
                }

                Loader {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    sourceComponent: {
                        switch (appRoot.currentPage) {
                            case 0:
                                return dashboardPage
                            case 1:
                                return transactionsPage
                            default:
                                return dashboardPage
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

    Component {
        id: dashboardPage

        DashboardPage {
            dialogPopup: addTransactionDialog

            onViewAllTransactionsClicked: {
                appRoot.currentPage = 1
            }
        }
    }

    Component {
        id: transactionsPage

        TransactionsPage {
            popup: addTransactionDialog
        }
    }
}