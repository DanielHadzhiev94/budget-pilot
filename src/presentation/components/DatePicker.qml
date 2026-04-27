import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

RowLayout {
    anchors.left: parent.left
    anchors.leftMargin: 12

    width: 190
    height: 65
    spacing: 8

    ComboBox {
        id: monthBox

        Layout.preferredWidth: 80
        Layout.preferredHeight: 65

        model: [
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ]

        currentIndex: new Date().getMonth()
    }

    ComboBox {
        id: yearBox

        Layout.preferredWidth: 100
        Layout.preferredHeight: 65

        model: [2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029]

        currentIndex: model.indexOf(new Date().getFullYear())
    }
}