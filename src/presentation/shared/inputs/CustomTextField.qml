import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

TextField {
    id: root

    property string custom_placeholder_text: "Placeholder text here..."
    property int custom_font_size: 15
    property int custom_height: 44

    property color custom_color: AppTheme.textPrimary
    property color custom_placeholder_text_color: AppTheme.textSecondary
    property color custom_selection_color: AppTheme.primary

    Layout.fillWidth: true
    Layout.preferredHeight: custom_height

    placeholderText: custom_placeholder_text
    color: custom_color
    placeholderTextColor: custom_placeholder_text_color
    font.pixelSize: 15
    selectionColor: custom_selection_color

    leftPadding: 13
    rightPadding: 13

    background: Rectangle {
        radius: 11
        color: AppTheme.backgroundAlt
        border.color: root.activeFocus ? AppTheme.primary : AppTheme.border
        border.width: 1
    }
}
