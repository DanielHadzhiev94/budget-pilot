import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    required property var dialogPopup
    signal viewAllTransactionsClicked()

    Layout.fillWidth: true
    Layout.fillHeight: true
    color: AppTheme.backgroundAlt

    function openAddTransactionDialog() {
        if (root.dialogPopup) {
            root.dialogPopup.openForCreate()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 86
            radius: AppTheme.radiusXL
            color: AppTheme.backgroundMainCard
            border.color: AppTheme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 22
                anchors.rightMargin: 18
                spacing: 16

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "Dashboard"
                        color: AppTheme.textPrimary
                        font.pixelSize: 28
                        font.bold: true
                    }

                    Text {
                        text: "Track your balance, monthly income and expenses."
                        color: AppTheme.textMuted
                        font.pixelSize: 14
                    }
                }

                DatePicker {
                    Layout.preferredWidth: 285
                    Layout.preferredHeight: 42
                    Layout.alignment: Qt.AlignVCenter

                    onDateChanged: function(month, year) {
                        financialSummaryVM.set_date(month, year)
                        financialSummaryVM.load_data(month, year)
                        recentTransactionsVM.load_data(month, year)
                    }
                }

                CustomButton {
                    title: "+ Add Transaction"
                    custom_width: 178
                    custom_height: 42
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: root.openAddTransactionDialog()
                }
            }
        }

        FinancialSummarySection {
            viewModel: financialSummaryVM
            Layout.fillWidth: true
            Layout.preferredHeight: 160
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20

            RecentTransactionsSection {
                viewModel: recentTransactionsVM
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 620
                Layout.minimumWidth: 560
                onViewAllTransactionsClicked: root.viewAllTransactionsClicked()
            }

            ExpenseCategoryPreviewSection {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 440
                Layout.minimumWidth: 360
            }
        }
    }
}
