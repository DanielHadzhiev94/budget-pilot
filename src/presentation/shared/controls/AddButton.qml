import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

Button {
    id: root

    Layout.preferredHeight: 44
    Layout.preferredWidth: 44
    hoverEnabled: true
    scale: down ? AppTheme.pressScale : hovered ? 1.08 : 1

    Behavior on scale {
        NumberAnimation { duration: AppTheme.motionFast; easing.type: Easing.OutCubic }
    }

    background: Rectangle {
        radius: 11
        color: root.hovered ? AppTheme.successSoft : AppTheme.success
        border.width: 1
        border.color: AppTheme.border

        Behavior on color {
            ColorAnimation { duration: AppTheme.motionFast }
        }
    }

    contentItem: Text {
        text: "+"
        color: AppTheme.textSecondary
        font.pixelSize: 14
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
