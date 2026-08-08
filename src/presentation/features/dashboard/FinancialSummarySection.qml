import QtQuick
import QtQuick.Layouts
import BudgetPilot

Item {
    id: root
    required property var viewModel

    RowLayout {
        anchors.fill: parent
        spacing: 16

        BudgetCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Current Balance"
            mainValue: "€ " + viewModel.current_balance.toFixed(2)
            mainValueColor: AppTheme.primaryLight
            subtitle: "Calculated account balance"
            iconSource: AppTheme.balanceIcon
            iconSize: 62
        }

        BudgetCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Income This Month"
            mainValue: "€ " + viewModel.income.toFixed(2)
            mainValueColor: AppTheme.success
            subtitle: "Income for selected month"
            iconSource: AppTheme.incomeIcon
            iconSize: 34
        }

        BudgetCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Expense This Month"
            mainValue: "€ " + viewModel.expense.toFixed(2)
            mainValueColor: AppTheme.danger
            subtitle: "Expenses for selected month"
            iconSource: AppTheme.expenseIcon
            iconSize: 32
        }

        BudgetCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Net cash flow"
            mainValue: (viewModel.saving_rate >= 0 ? "+ € " : "- € ") + Math.abs(viewModel.saving_rate).toFixed(2)
            mainValueColor: viewModel.saving_rate >= 0 ? AppTheme.success : AppTheme.danger
            subtitle: "Income minus expenses this month"
            iconSource: AppTheme.rateIcon
            iconSize: 32
        }
    }
}
