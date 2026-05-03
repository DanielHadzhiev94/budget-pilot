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

            Header {}

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Sidebar {
                    Layout.preferredWidth: 240
                    Layout.fillHeight: true
                }

                FinancialSummarySection {
                    viewModel: dashboardVM
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onAddTransactionClicked: addTransactionDialog.open()
                }
            }
        }
    }

    AddTransactionDialog {
        id: addTransactionDialog
    }
}
