import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot


Rectangle {
    id: root

    property string text: ""
    property bool active: false
        signal clicked

    radius: 10
    color: active ? AppTheme.sidebarItemActive : (mouseArea.containsMouse ? AppTheme.sidebarItemHover : "transparent")

    implicitHeight: 48
    implicitWidth: 220

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 12

        Rectangle {
            width: 18
            height: 18
            radius: 4
            color: active ? "white" : AppTheme.textSecondary
            opacity: 0.9
        }

        Text {
            text: root.text
            color: active ? "white" : AppTheme.textPrimary
            font.pixelSize: AppTheme.fontMedium
            font.bold: active
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}