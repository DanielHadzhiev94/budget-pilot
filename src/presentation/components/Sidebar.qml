import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot


Rectangle {
    id: root

    property int selectedIndex: 0
    signal itemSelected(int index)

    width: 240
    color: AppTheme.sidebar
    border.color: AppTheme.border
}