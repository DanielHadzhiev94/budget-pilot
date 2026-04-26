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


        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Header
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                color: AppTheme.background

                Rectangle {
                    height: 1
                    color: AppTheme.border
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }
            }

            // Main
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // Sidebar
                Rectangle {
                    Layout.preferredWidth: 240
                    Layout.fillHeight: true
                    color: AppTheme.background

                    Rectangle {
                        width: 1
                        color: AppTheme.border
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                    }
                }

                // Content
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: AppTheme.backgroundAlt
                }
            }
        }
    }
}