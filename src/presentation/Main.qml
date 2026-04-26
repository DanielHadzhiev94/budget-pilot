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
            Header{}

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
                    color: AppTheme.backgroundAlt
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignTop

                    ColumnLayout {
                        anchors.fill: parent

                        Rectangle {
                            radius: 12
                            color: AppTheme.surface
                            border.color: AppTheme.border


                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            Layout.margins: 20
                        }
                    }
                }
            }
        }
    }
}