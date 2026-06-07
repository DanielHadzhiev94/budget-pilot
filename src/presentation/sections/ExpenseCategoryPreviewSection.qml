import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

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
                    text: "Reserved space for the category chart"
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
                anchors.centerIn: parent
                width: Math.min(parent.width - 48, 260)
                spacing: 14

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 96
                    Layout.preferredHeight: 96
                    radius: 48
                    color: AppTheme.primarySubtle
                    border.color: AppTheme.primarySoft
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "◔"
                        color: AppTheme.primaryLight
                        font.pixelSize: 42
                        font.bold: true
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: "Category chart"
                    color: AppTheme.textPrimary
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    Layout.fillWidth: true
                    text: "Later this card can show a chart with Food, Rent, Car and other expense categories."
                    color: AppTheme.textSecondary
                    font.pixelSize: 13
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
