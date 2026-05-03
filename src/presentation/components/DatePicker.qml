import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    signal dateChanged(int month, int year)

    readonly property int selectedMonth: monthBox.currentIndex + 1
    readonly property int selectedYear: root.years[yearBox.currentIndex]

    readonly property var months: [
        "January", "February", "March", "April",
        "May", "June", "July", "August",
        "September", "October", "November", "December"
    ]

    readonly property var years: [
        2022, 2023, 2024, 2025,
        2026, 2027, 2028, 2029
    ]

    color: AppTheme.purpleSoft
    radius: 8
    border.color: AppTheme.border
    border.width: 1

    Layout.preferredWidth: 285
    Layout.preferredHeight: 40

    function emitDateChanged() {
        root.dateChanged(root.selectedMonth, root.selectedYear)
    }

    Component.onCompleted: {
        root.emitDateChanged()
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 0

        StyledComboBox {
            id: monthBox

            Layout.preferredWidth: 140
            Layout.fillHeight: true

            model: root.months
            currentIndex: new Date().getMonth()

            textLeftPadding: 16

            onActivated: root.emitDateChanged()
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 30
            color: AppTheme.border
        }

        StyledComboBox {
            id: yearBox

            Layout.preferredWidth: 140
            Layout.fillHeight: true

            model: root.years
            currentIndex: Math.max(0, root.years.indexOf(new Date().getFullYear()))

            textLeftPadding: 26

            onActivated: root.emitDateChanged()
        }
    }

    component StyledComboBox: ComboBox {
        id: control

        property int textLeftPadding: 16

        background: Rectangle {
            radius: 8
            color: control.hovered ? AppTheme.purple : "transparent"
        }

        contentItem: Text {
            text: control.displayText
            color: AppTheme.textPrimary
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
            leftPadding: control.textLeftPadding
        }

        indicator: Text {
            text: "▾"
            color: AppTheme.textSecondary
            font.pixelSize: 14

            anchors.right: parent.right
            anchors.rightMargin: 18
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}