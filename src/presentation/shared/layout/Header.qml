import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 64

    color: AppTheme.background

    Rectangle {
        height: 1
        color: AppTheme.divider
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 22
        anchors.rightMargin: 22
        spacing: 12

        Rectangle {
            Layout.preferredWidth: 42
            Layout.preferredHeight: 42
            radius: 14
            color: AppTheme.primarySubtle
            border.color: Qt.rgba(79 / 255, 140 / 255, 255 / 255, 0.28)
            border.width: 1

            Image {
                source: AppTheme.ricoRobotIcon
                width: 32
                height: 32
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
            }
        }

        ColumnLayout {
            spacing: 0
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: "BudgetPilot"
                color: AppTheme.textPrimary
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "Personal finance dashboard"
                color: AppTheme.textMuted
                font.pixelSize: 12
            }
        }

        Item {
            Layout.fillWidth: true
        }
    }
}
