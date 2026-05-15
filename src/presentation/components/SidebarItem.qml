import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property string title: ""
    property bool selected: false

    signal clicked()

    Layout.preferredHeight: 44

    radius: 10

    color: selected
        ? AppTheme.primary
        : mouseArea.containsMouse
            ? AppTheme.backgroundMainCard
            : "transparent"

    border.color: selected ? AppTheme.primary : "transparent"
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14

        Text {
            text: root.title
            color: selected ? "white" : AppTheme.textSecondary
            font.pixelSize: 14
            font.bold: selected

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