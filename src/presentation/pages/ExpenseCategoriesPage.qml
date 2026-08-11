import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property bool entered: false
    readonly property var categoryTotals: recentTransactionsVM.expenseCategoryTotals
        ? recentTransactionsVM.expenseCategoryTotals : []
    readonly property real totalExpenses: categoryTotals.reduce(function(total, item) {
        return total + item.amount
    }, 0)

    color: AppTheme.backgroundAlt
    opacity: entered ? 1 : 0

    Component.onCompleted: entered = true

    Behavior on opacity {
        NumberAnimation { duration: AppTheme.motionNormal; easing.type: Easing.OutCubic }
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
                        text: "Expense categories"
                        color: AppTheme.textPrimary
                        font.pixelSize: 28
                        font.bold: true
                    }
                    Text {
                        text: "All expense categories and totals for the selected month."
                        color: AppTheme.textMuted
                        font.pixelSize: 14
                    }
                }

                MonthPicker {
                    Layout.preferredWidth: 285
                    Layout.preferredHeight: 42
                    Layout.alignment: Qt.AlignVCenter
                    onDateChanged: function(month, year) {
                        recentTransactionsVM.load_data(month, year)
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: AppTheme.radiusXL
            color: AppTheme.surface
            border.color: AppTheme.border
            border.width: 1
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 12

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36

                    Text {
                        text: root.categoryTotals.length + (root.categoryTotals.length === 1 ? " category" : " categories")
                        color: AppTheme.textSecondary
                        font.pixelSize: 14
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "Total: € " + root.totalExpenses.toFixed(2)
                        color: AppTheme.textPrimary
                        font.pixelSize: 15
                        font.bold: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42
                    radius: AppTheme.radiusMedium
                    color: AppTheme.surfaceElevated

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        Text { text: "Category"; color: AppTheme.textMuted; font.pixelSize: 12; font.bold: true; Layout.fillWidth: true }
                        Text { text: "Share"; color: AppTheme.textMuted; font.pixelSize: 12; font.bold: true; Layout.preferredWidth: 100; horizontalAlignment: Text.AlignRight }
                        Text { text: "Amount"; color: AppTheme.textMuted; font.pixelSize: 12; font.bold: true; Layout.preferredWidth: 130; horizontalAlignment: Text.AlignRight }
                    }
                }

                ListView {
                    id: categoryList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 8
                    model: root.categoryTotals
                    visible: root.categoryTotals.length > 0

                    delegate: Rectangle {
                        required property var modelData
                        required property int index
                        width: categoryList.width
                        height: 58
                        radius: AppTheme.radiusMedium
                        color: index % 2 === 0 ? AppTheme.tableSurface : AppTheme.surface
                        border.color: AppTheme.border
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 16

                            Text {
                                text: modelData.name
                                color: AppTheme.textPrimary
                                font.pixelSize: 14
                                font.bold: true
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                            Text {
                                text: root.totalExpenses > 0
                                    ? (modelData.amount / root.totalExpenses * 100).toFixed(1) + "%"
                                    : "0.0%"
                                color: AppTheme.textSecondary
                                font.pixelSize: 13
                                Layout.preferredWidth: 100
                                horizontalAlignment: Text.AlignRight
                            }
                            Text {
                                text: "€ " + modelData.amount.toFixed(2)
                                color: AppTheme.textPrimary
                                font.pixelSize: 14
                                font.bold: true
                                Layout.preferredWidth: 130
                                horizontalAlignment: Text.AlignRight
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {}
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: root.categoryTotals.length === 0
                    spacing: 10

                    Item { Layout.fillHeight: true }
                    Text {
                        Layout.fillWidth: true
                        text: "No expenses for this month"
                        color: AppTheme.textPrimary
                        font.pixelSize: 18
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text {
                        Layout.fillWidth: true
                        text: "Choose another month or add an expense to see its category here."
                        color: AppTheme.textSecondary
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Item { Layout.fillHeight: true }
                }
            }
        }
    }
}
