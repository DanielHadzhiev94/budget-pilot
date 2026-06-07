import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    required property var viewModel
    color: AppTheme.backgroundAlt

    ColumnLayout {

        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            spacing: 12

            BudgetCard {
                title: "Current Balance"
                mainValue: "€ " + viewModel.current_balance.toFixed(2)
                mainValueColor: AppTheme.primaryDark
                subtitle: "Available funds"
                iconSize: 60
            }

            BudgetCard {
                title: "Income This Month"
                mainValue: "€ " + viewModel.income.toFixed(2)
                subtitle: "vs last month"
                iconSource: AppTheme.incomeIcon
            }

            BudgetCard {
                title: "Expense This Month"
                mainValue: "€ " + viewModel.expense.toFixed(2)
                mainValueColor: AppTheme.danger
                subtitle: "vs last month"
                iconSource: AppTheme.expenseIcon
                iconSize: 30
            }

            BudgetCard {
                title: "Saving Rates"
                mainValue: "€ " + viewModel.saving_rate.toFixed(2)
                mainValueColor: AppTheme.chartPurple
                subtitle: "300 € saved Dummy data"
                iconSource: AppTheme.rateIcon
                iconSize: 30
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
