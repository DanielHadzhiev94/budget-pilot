import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

Button {
    id: root

    Layout.preferredHeight: 44
    Layout.preferredWidth: 44

    background: Rectangle {
        radius: 11
        color: root.hovered ? AppTheme.successSoft : AppTheme.success
        border.width: 1
        border.color: AppTheme.border
    }

    contentItem: Text {
        text: "+"
        color: AppTheme.textSecondary
        font.pixelSize: 14
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
