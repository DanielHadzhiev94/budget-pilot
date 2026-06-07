import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property string title: "Default"
    property string mainValue: "Default"
    property string subtitle: "Default"
    property color cardColor: AppTheme.surface
    property url iconSource: AppTheme.balanceIcon
    property color mainValueColor: AppTheme.success
    property int iconBoxSize: 48
    property int iconSize: 34

    radius: AppTheme.radiusXL
    color: cardColor
    border.color: Qt.rgba(148 / 255, 163 / 255, 184 / 255, 0.16)
    border.width: 1

    implicitWidth: 270
    implicitHeight: 150

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 1
        color: Qt.rgba(255, 255, 255, 0.08)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                Layout.preferredWidth: root.iconBoxSize
                Layout.preferredHeight: root.iconBoxSize
                radius: 14
                color: AppTheme.primarySubtle
                border.color: Qt.rgba(79 / 255, 140 / 255, 255 / 255, 0.18)
                border.width: 1

                Image {
                    anchors.centerIn: parent
                    source: root.iconSource
                    width: root.iconSize
                    height: root.iconSize
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }
            }

            Text {
                text: root.title
                color: AppTheme.textSecondary
                font.pixelSize: 13
                font.bold: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                elide: Text.ElideRight
            }
        }

        Text {
            text: root.mainValue
            color: root.mainValueColor
            font.pixelSize: 28
            font.bold: true
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        Text {
            text: root.subtitle
            color: AppTheme.textMuted
            font.pixelSize: 12
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }
}
