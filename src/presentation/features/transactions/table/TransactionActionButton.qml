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

    border.color: mouseArea.containsMouse ? root.hoverBorderColor() : AppTheme.border

    border.width: 1

    function normalColor() {
        return danger
            ? AppTheme.dangerSoft
            : "transparent"
    }

    function hoverColor() {
        return danger
            ? AppTheme.dangerSoft
            : AppTheme.rowHighlight
    }

    function hoverBorderColor() {
        return danger
            ? AppTheme.danger
            : AppTheme.primaryBorder
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
