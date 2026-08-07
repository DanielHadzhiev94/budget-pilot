import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property string title: ""
    property string iconText: "•"
    property bool selected: false

    signal clicked()

    radius: AppTheme.radiusLarge
    color: selected
        ? AppTheme.sidebarItemActive
        : mouseArea.containsMouse
            ? AppTheme.sidebarItemHover
            : "transparent"

    border.color: selected ? AppTheme.primaryBorder : "transparent"
    border.width: 1

    Behavior on color { ColorAnimation { duration: 120 } }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 10

        Rectangle {
            Layout.preferredWidth: 26
            Layout.preferredHeight: 26
            radius: 9
            color: root.selected ? AppTheme.primary : AppTheme.surfaceLight

            Text {
                anchors.centerIn: parent
                text: root.iconText
                color: root.selected ? "white" : AppTheme.textMuted
                font.pixelSize: 14
                font.bold: true
            }
        }

        Text {
            text: root.title
            color: selected ? AppTheme.sidebarItemActiveText : AppTheme.textSecondary
            font.pixelSize: 14
            font.bold: selected
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
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
