import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property string title: ""
    property string iconText: "•"
    property bool selected: false
    property color animatedBorderColor: selected ? AppTheme.primaryBorder : "transparent"

    signal clicked()

    radius: AppTheme.radiusLarge
    color: selected
        ? AppTheme.sidebarItemActive
        : mouseArea.containsMouse
            ? AppTheme.sidebarItemHover
            : "transparent"

    border.color: animatedBorderColor
    border.width: 1

    Behavior on color { ColorAnimation { duration: AppTheme.motionFast } }
    Behavior on animatedBorderColor { ColorAnimation { duration: AppTheme.motionFast } }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 10
        transform: Translate {
            x: mouseArea.containsMouse && !root.selected ? 2 : 0

            Behavior on x {
                NumberAnimation { duration: AppTheme.motionFast; easing.type: Easing.OutCubic }
            }
        }

        Rectangle {
            Layout.preferredWidth: 26
            Layout.preferredHeight: 26
            radius: 9
            color: root.selected ? AppTheme.primary : AppTheme.surfaceLight

            Behavior on color { ColorAnimation { duration: AppTheme.motionFast } }

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

            Behavior on color { ColorAnimation { duration: AppTheme.motionFast } }
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
