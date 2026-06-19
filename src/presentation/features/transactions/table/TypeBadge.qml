import QtQuick
import BudgetPilot

Rectangle {
    id: root

    property string value: ""

    readonly property bool isIncome: value === "Income"

    width: 100
    height: 30
    radius: 15

    color: root.isIncome
        ? Qt.rgba(0.0, 0.75, 0.42, 0.14)
        : Qt.rgba(1.0, 0.20, 0.25, 0.15)

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