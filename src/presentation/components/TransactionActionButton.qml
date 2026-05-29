import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property string text: ""
    property color textColor: AppTheme.textPrimary
    property bool danger: false

    signal clicked()

    Layout.preferredWidth: 38
    Layout.preferredHeight: 36

    radius: 8

    color: mouseArea.containsMouse
        ? root.hoverColor()
        : root.normalColor()

    border.color: mouseArea.containsMouse
        ? root.hoverBorderColor()
        : Qt.rgba(120, 160, 220, 0.22)

    border.width: 1

    function normalColor() {
        return danger
            ? Qt.rgba(1.0, 0.20, 0.25, 0.08)
            : Qt.rgba(255, 255, 255, 0.035)
    }

    function hoverColor() {
        return danger
            ? Qt.rgba(1.0, 0.20, 0.25, 0.18)
            : Qt.rgba(255, 255, 255, 0.09)
    }

    function hoverBorderColor() {
        return danger
            ? AppTheme.danger
            : Qt.rgba(150, 190, 255, 0.45)
    }

    Text {
        anchors.centerIn: parent

        text: root.text
        color: root.textColor

        font.pixelSize: 16
        font.bold: !root.danger
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.clicked()
    }
}