import QtQuick
import QtQuick.Layouts
import BudgetPilot

Item {
    id: root
    required property var viewModel
    property bool accountBreakdownOpen: false
    z: accountBreakdownOpen ? 10 : 0

    RowLayout {
        id: summaryCards
        anchors.fill: parent
        spacing: 16

        BudgetCard {
            id: currentBalanceCard
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Current Balance"
            mainValue: "€ " + viewModel.current_balance.toFixed(2)
            mainValueColor: AppTheme.primaryLight
            subtitle: "Click to view accounts"
            iconSource: AppTheme.balanceIcon
            iconSize: 62
            clickable: true
            hoverHighlightEnabled: true
            onClicked: root.accountBreakdownOpen = !root.accountBreakdownOpen
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

    Rectangle {
        id: accountBreakdown
        x: summaryCards.x + currentBalanceCard.x
        y: summaryCards.y + currentBalanceCard.y + currentBalanceCard.height + 8
        width: currentBalanceCard.width
        height: root.accountBreakdownOpen
                ? Math.min(248, 58 + accountList.count * 42)
                : 0
        opacity: root.accountBreakdownOpen ? 1 : 0
        visible: height > 0
        clip: true
        z: 20

        radius: AppTheme.radiusLarge
        color: AppTheme.surfaceElevated
        border.color: AppTheme.borderLight
        border.width: 1

        Behavior on height {
            NumberAnimation { duration: AppTheme.motionSlow; easing.type: Easing.OutCubic }
        }

        Behavior on opacity {
            NumberAnimation { duration: AppTheme.motionNormal; easing.type: Easing.OutCubic }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 8

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Accounts"
                    color: AppTheme.textPrimary
                    font.pixelSize: 13
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: accountList.count + (accountList.count === 1 ? " account" : " accounts")
                    color: AppTheme.textMuted
                    font.pixelSize: 11
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: AppTheme.divider
            }

            ListView {
                id: accountList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 4
                model: root.viewModel.accounts

                delegate: Rectangle {
                    required property var modelData
                    width: ListView.view.width
                    height: 36
                    radius: AppTheme.radiusSmall
                    color: accountRowMouseArea.containsMouse
                           ? AppTheme.tableRowHover
                           : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8

                        Text {
                            text: modelData.name
                            color: AppTheme.textSecondary
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: "€ " + Number(modelData.balance).toFixed(2)
                            color: Number(modelData.balance) >= 0
                                   ? AppTheme.success
                                   : AppTheme.danger
                            font.pixelSize: 12
                            font.bold: true
                        }
                    }

                    MouseArea {
                        id: accountRowMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: accountList.count === 0
                    text: "No accounts yet"
                    color: AppTheme.textMuted
                    font.pixelSize: 12
                }
            }
        }
    }
}
