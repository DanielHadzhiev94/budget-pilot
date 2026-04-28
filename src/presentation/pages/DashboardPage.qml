import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    color: AppTheme.backgroundAlt

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Rectangle {
            radius: 12
            color: AppTheme.backgroundMainCard
            border.color: AppTheme.border

            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.topMargin: 20

            RowLayout {
                anchors.fill: parent

                DatePicker {
                    Layout.leftMargin: 12
                }

                Item {
                    Layout.fillWidth: true
                }

                CustomButton {
                    text: "Add Transaction"
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            spacing: 12

            BudgetCard {
                title: "Current Balance"
                mainValue: "€ 3458"
                mainValueColor: AppTheme.primaryDark
                subtitle: "Available funds"
                iconSize: 60
            }

            BudgetCard {
                title: "Income This Month"
                mainValue: "€ 3000"
                subtitle: "vs last month"
                iconSource: AppTheme.incomeIcon
            }

            BudgetCard {
                title: "Expense This Month"
                mainValue: "€ 1458"
                mainValueColor: AppTheme.warning
                subtitle: "vs last month"
                iconSource: AppTheme.expenseIcon
                iconSize: 30
            }

            BudgetCard {
                title: "Saving Rates"
                mainValue: "€ 258"
                mainValueColor: AppTheme.chartPurple
                subtitle: "300 € saved"
                iconSource: AppTheme.rateIcon
                iconSize: 30
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}