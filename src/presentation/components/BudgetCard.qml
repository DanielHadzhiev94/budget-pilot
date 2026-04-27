import QtQuick
import QtQuick.Layouts
import BudgetPilot

import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property string title: "Default"
    property string main_value: "Default"
    property string subtitle: "Default"

    radius: 12
    color: AppTheme.surface
    border.color: AppTheme.border
    border.width: 1

    implicitWidth: 260
    implicitHeight: 160

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 6

        Text {
            text: root.title
            color: AppTheme.textSecondary
            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: root.main_value
            color: AppTheme.textPrimary
            font.pixelSize: 28
            font.bold: true
        }

        Text {
            text: root.subtitle
            color: AppTheme.textSecondary
            font.pixelSize: 12
        }
    }
}