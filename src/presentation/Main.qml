import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

ApplicationWindow {
    id: appRoot

    visible: true
    width: 1440
    height: 900
    minimumWidth: 1120
    minimumHeight: 720
    title: "BudgetPilot"

    property int currentPage: 0

    Rectangle {
        anchors.fill: parent
        color: AppTheme.background

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Header {}

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Sidebar {
                    Layout.preferredWidth: 248
                    Layout.fillHeight: true
                    selectedIndex: appRoot.currentPage
                    onItemSelected: function(index) { appRoot.currentPage = index }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: AppTheme.backgroundAlt

                    Loader {
                        id: pageLoader
                        anchors.fill: parent
                        opacity: status === Loader.Ready ? 1 : 0
                        transform: Translate {
                            id: pageSlide
                            x: pageLoader.status === Loader.Ready ? 0 : 12

                            Behavior on x {
                                NumberAnimation { duration: AppTheme.motionNormal; easing.type: Easing.OutCubic }
                            }
                        }
                        sourceComponent: {
                            switch (appRoot.currentPage) {
                                case 0: return dashboardPage
                                case 1: return transactionsPage
                                case 2: return expenseCategoriesPage
                                default: return dashboardPage
                            }
                        }

                        Behavior on opacity {
                            NumberAnimation { duration: AppTheme.motionNormal; easing.type: Easing.OutCubic }
                        }
                    }
                }
            }
        }
    }

    TransactionDialog {
        id: addTransactionDialog
        viewModel: addTransactionVM
    }

    Component {
        id: dashboardPage
        DashboardPage {
            dialogPopup: addTransactionDialog
            onViewAllTransactionsClicked: appRoot.currentPage = 1
            onViewAllCategoriesClicked: appRoot.currentPage = 2
        }
    }

    Component {
        id: transactionsPage
        TransactionsPage { popup: addTransactionDialog }
    }

    Component {
        id: expenseCategoriesPage
        ExpenseCategoriesPage {}
    }
}
