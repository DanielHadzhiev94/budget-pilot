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
    border.color: AppTheme.border
    border.width: 1

    implicitWidth: 270
    implicitHeight: 150
    property bool hovered: cardMouseArea.containsMouse
    scale: hovered ? 1.012 : 1

    Behavior on scale {
        NumberAnimation { duration: AppTheme.motionNormal; easing.type: Easing.OutCubic }
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
                border.color: AppTheme.primaryBorder
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

    MouseArea {
        id: cardMouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }
}
