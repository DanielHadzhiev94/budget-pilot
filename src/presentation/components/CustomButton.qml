import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Button {

    property string title: "Default text"
    property int custom_height: 35
    property int custom_width: 160

    id: btn

    text: title
    hoverEnabled: true

    Layout.rightMargin: 12
    Layout.topMargin: 8
    Layout.bottomMargin: 8

    Layout.preferredHeight: custom_height
    Layout.preferredWidth: custom_width

    scale: btn.hovered ? 1.05 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: 120
            easing.type: Easing.OutQuad
        }
    }

    background: Rectangle {
        radius: 8
        border.color: AppTheme.border
        color: AppTheme.primary
    }
}

