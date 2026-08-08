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
    scale: down ? AppTheme.pressScale : hovered ? 1.08 : 1
    Accessible.name: root.accessibleName
    ToolTip.visible: hovered
    ToolTip.text: root.accessibleName

    Behavior on scale {
        NumberAnimation { duration: AppTheme.motionFast; easing.type: Easing.OutCubic }
    }

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
        property color animatedColor: root.hovered ? root.hoverColor() : root.normalColor()
        property color animatedBorderColor: root.hovered ? root.hoverBorderColor() : AppTheme.border

        radius: 8
        color: animatedColor
        border.color: animatedBorderColor
        border.width: 1

        Behavior on animatedColor { ColorAnimation { duration: AppTheme.motionFast } }
        Behavior on animatedBorderColor { ColorAnimation { duration: AppTheme.motionFast } }
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
