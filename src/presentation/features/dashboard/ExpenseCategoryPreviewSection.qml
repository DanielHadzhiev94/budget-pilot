import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property var viewModel
    readonly property var categoryTotals: root.viewModel && root.viewModel.expenseCategoryTotals
        ? root.viewModel.expenseCategoryTotals.slice(0, 4) : []
    readonly property real totalExpenses: categoryTotals.reduce(function(total, item) { return total + item.amount }, 0)

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumWidth: 360

    radius: AppTheme.radiusXL
    color: AppTheme.surface
    border.color: AppTheme.border
    border.width: 1
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            spacing: 10

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: "Expenses by category"
                    color: AppTheme.textPrimary
                    font.pixelSize: 18
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Text {
                    text: root.totalExpenses > 0 ? "Top categories for the selected month" : "Your spending breakdown will appear here"
                    color: AppTheme.textMuted
                    font.pixelSize: 12
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: AppTheme.radiusLarge
            color: AppTheme.tableSurface
            border.color: AppTheme.border
            border.width: 1
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 14
                visible: root.categoryTotals.length > 0

                Repeater {
                    model: root.categoryTotals

                    delegate: ColumnLayout {
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: modelData.name; color: AppTheme.textPrimary; font.pixelSize: 14; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "€ " + modelData.amount.toFixed(2); color: AppTheme.textSecondary; font.pixelSize: 13 }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 7
                            radius: 4
                            color: AppTheme.surfaceElevated
                            Rectangle {
                                width: parent.width * (root.totalExpenses > 0 ? modelData.amount / root.totalExpenses : 0)
                                height: parent.height
                                radius: parent.radius
                                color: AppTheme.chartBlue

                                Behavior on width {
                                    NumberAnimation { duration: AppTheme.motionSlow; easing.type: Easing.OutCubic }
                                }
                            }
                        }
                    }
                }
                Item { Layout.fillHeight: true }
                Text { text: "All expenses in the selected month"; color: AppTheme.textMuted; font.pixelSize: 12; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
            }

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width - 48, 260)
                visible: root.categoryTotals.length === 0
                spacing: 10
                Text { Layout.fillWidth: true; text: "No expenses yet"; color: AppTheme.textPrimary; font.pixelSize: 16; font.bold: true; horizontalAlignment: Text.AlignHCenter }
                Text { Layout.fillWidth: true; text: "Add an expense to see where your money is going."; color: AppTheme.textSecondary; font.pixelSize: 13; wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter }
            }
        }
    }
}
