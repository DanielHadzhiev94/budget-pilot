import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

Button {
    id: root

    property string iconText: ""
    property string accessibleName: ""
    property color textColor: AppTheme.textPrimary
    property bool danger: false

    Layout.preferredWidth: 38
    Layout.preferredHeight: 36

    hoverEnabled: true
    Accessible.name: root.accessibleName
    ToolTip.visible: hovered
    ToolTip.text: root.accessibleName

    function normalColor() {
        return danger
            ? AppTheme.dangerSoft
            : "transparent"
    }

    function hoverColor() {
        return danger
            ? AppTheme.dangerSoft
            : AppTheme.rowHighlight
    }

    function hoverBorderColor() {
        return danger
            ? AppTheme.danger
            : AppTheme.primaryBorder
    }

    background: Rectangle {
        radius: 8
        color: root.hovered ? root.hoverColor() : root.normalColor()
        border.color: root.hovered ? root.hoverBorderColor() : AppTheme.border
        border.width: 1
    }

    contentItem: Text {
        text: root.iconText
        color: root.textColor
        font.pixelSize: 16
        font.bold: !root.danger
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
