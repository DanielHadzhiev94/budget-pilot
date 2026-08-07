import QtQuick
import BudgetPilot

Rectangle {
    id: root

    property string value: ""

    readonly property bool isIncome: AppTheme.isIncome(value)

    width: 100
    height: 30
    radius: 15

    color: root.isIncome
        ? AppTheme.incomeBadge
        : AppTheme.expenseBadge

    Text {
        anchors.centerIn: parent

        text: root.value

        color: root.isIncome
            ? AppTheme.success
            : AppTheme.danger

        font.pixelSize: 13
        font.bold: true
    }
}
