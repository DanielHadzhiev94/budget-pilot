import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

TextField {
    id: root

    property int preferredHeight: 44

    Layout.fillWidth: true
    Layout.preferredHeight: preferredHeight

    color: AppTheme.textPrimary
    placeholderTextColor: AppTheme.inputPlaceholder
    font.pixelSize: AppTheme.fontBody
    selectionColor: AppTheme.primary

    leftPadding: 13
    rightPadding: 13

    background: Rectangle {
        radius: 11
        color: AppTheme.inputBackground
        border.color: root.activeFocus ? AppTheme.primary : AppTheme.inputBorder
        border.width: 1
    }
}
