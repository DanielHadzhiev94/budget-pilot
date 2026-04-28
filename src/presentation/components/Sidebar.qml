import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    color: AppTheme.background

    Rectangle {
        width: 1
        color: AppTheme.border
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }
}