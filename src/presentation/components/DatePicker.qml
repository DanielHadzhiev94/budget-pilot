import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    color: AppTheme.purpleSoft
    radius: 8
    border.color: AppTheme.border
    border.width: 1

    Layout.preferredWidth: 285
    Layout.preferredHeight: 40

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 0

        ComboBox {
            id: monthBox

            Layout.preferredWidth: 140
            Layout.fillHeight: true
            model: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
            currentIndex: new Date().getMonth()

            background: Rectangle {
                radius: 12
                color: monthBox.hovered ? AppTheme.surfaceLight : "transparent"
            }

            contentItem: Text {
                text: monthBox.displayText
                color: AppTheme.textPrimary
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
                leftPadding: 16
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

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 30
            color: AppTheme.border
        }

        ComboBox {
            id: yearBox

            Layout.preferredWidth: 140
            Layout.fillHeight: true

            model: [2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029]

            currentIndex: model.indexOf(new Date().getFullYear())

            background: Rectangle {
                radius: 12
                color: yearBox.hovered ? AppTheme.surfaceLight : "transparent"
            }

            contentItem: Text {
                text: yearBox.displayText
                color: AppTheme.textPrimary
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
                leftPadding: 26
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
}
