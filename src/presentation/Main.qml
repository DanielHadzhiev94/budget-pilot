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
                Layout.preferredHeight: 50

                color: AppTheme.background

                // Botton border
                Rectangle {
                    height: 1
                    color: AppTheme.border
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }

                // Left Elements
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16

                    RowLayout {
                        spacing: 8

                        Image {
                            source: "images/rico_robot.png"
                            Layout.preferredWidth: 35
                            Layout.preferredHeight: 35

                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            text: "BudgetPilot"
                            color: AppTheme.textPrimary
                            font.pixelSize: 18
                            font.bold: true

                            Layout.alignment: Qt.AlignVCenter
                        }
                    }


                    Item {
                        Layout.fillWidth: true
                    }

                    // RIGHT SIDE

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