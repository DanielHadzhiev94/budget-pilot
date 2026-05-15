import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    color: AppTheme.backgroundMainCard
    radius: 12
    border.color: AppTheme.border
    border.width: 1
    clip: true

    property var viewModel

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            spacing: 0

            Text {
                text: "Date"
                color: AppTheme.textPrimary
                font.bold: true
                Layout.preferredWidth: 140
            }

            Text {
                text: "Type"
                color: AppTheme.textPrimary
                font.bold: true
                Layout.preferredWidth: 110
            }

            Text {
                text: "Category"
                color: AppTheme.textPrimary
                font.bold: true
                Layout.preferredWidth: 140
            }

            Text {
                text: "Source"
                color: AppTheme.textPrimary
                font.bold: true
                Layout.fillWidth: true
            }

            Text {
                text: "Amount"
                color: AppTheme.textPrimary
                font.bold: true
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 130
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: AppTheme.border
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            model: root.viewModel.transactions

            delegate: RowLayout {
                width: ListView.view.width
                height: 44
                spacing: 0

                Text {
                    text: modelData.date
                    color: AppTheme.textSecondary
                    Layout.preferredWidth: 140
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    text: modelData.type
                    color: modelData.type === "Income"
                        ? AppTheme.success
                        : AppTheme.danger
                    Layout.preferredWidth: 110
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    text: modelData.category
                    color: AppTheme.textSecondary
                    Layout.preferredWidth: 140
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    text: modelData.source
                    color: AppTheme.textSecondary
                    Layout.fillWidth: true
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                Text {
                    text: modelData.type === "Income"
                        ? "+ €" + Number(modelData.amount).toFixed(2)
                        : "- €" + Number(modelData.amount).toFixed(2)

                    color: modelData.type === "Income"
                        ? AppTheme.success
                        : AppTheme.danger

                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    Layout.preferredWidth: 130
                }
            }
        }
    }
}