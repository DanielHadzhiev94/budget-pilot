import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property int selectedIndex: 0

    signal itemSelected(int index)

    color: AppTheme.background

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        SidebarItem {
            title: "Dashboard"
            selected: root.selectedIndex === 0
            Layout.fillWidth: true
            Layout.preferredHeight: 44

            onClicked: root.itemSelected(0)
        }

        SidebarItem {
            title: "Transactions"
            selected: root.selectedIndex === 1
            Layout.fillWidth: true
            Layout.preferredHeight: 44

            onClicked: root.itemSelected(1)
        }

        Item {
            Layout.fillHeight: true
        }

        SidebarItem {
            title: "Test"
            selected: root.selectedIndex === 4
            Layout.fillWidth: true
            Layout.preferredHeight: 44

            onClicked: root.itemSelected(2)
        }

    }

    // Right border only
    Rectangle {
        width: 1
        color: AppTheme.border

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }
}