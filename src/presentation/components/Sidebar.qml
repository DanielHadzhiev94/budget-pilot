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
        anchors.margins: 16
        spacing: 8

        Text {
            text: "Menu"
            color: AppTheme.textDisabled
            font.pixelSize: 11
            font.bold: true
            font.capitalization: Font.AllUppercase
            Layout.leftMargin: 8
            Layout.topMargin: 4
            Layout.bottomMargin: 6
        }

        SidebarItem {
            title: "Dashboard"
            iconText: "⌂"
            selected: root.selectedIndex === 0
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            onClicked: root.itemSelected(0)
        }

        SidebarItem {
            title: "Transactions"
            iconText: "≡"
            selected: root.selectedIndex === 1
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            onClicked: root.itemSelected(1)
        }

        Item { Layout.fillHeight: true }
    }

    Rectangle {
        width: 1
        color: AppTheme.divider
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }
}
