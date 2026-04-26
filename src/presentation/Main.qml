import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

ApplicationWindow {
    visible: true
    width: 1440
    height: 900
    minimumWidth: 1200
    minimumHeight: 700

    title: "BudgetPilot"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Sidebar {
            Layout.preferredWidth: 240
            Layout.fillHeight: true
        }
    }

}