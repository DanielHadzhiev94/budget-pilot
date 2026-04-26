import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

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
                source: "../images/rico_robot.png"
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