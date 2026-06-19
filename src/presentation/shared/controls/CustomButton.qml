import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Button {
    id: btn

    property string title: "Default text"
    property int custom_height: 42
    property int custom_width: 164

    property color custom_hover_color_1: AppTheme.primaryLight
    property color custom_hover_color_2: AppTheme.primary

    text: title
    hoverEnabled: true

    Layout.preferredHeight: custom_height
    Layout.preferredWidth: custom_width

    background: Rectangle {
        radius: 12
        color: btn.down ? AppTheme.primaryDark : btn.hovered ? custom_hover_color_1 : custom_hover_color_2
        border.color: Qt.rgba(255, 255, 255, 0.10)
        border.width: 1

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    contentItem: Text {
        text: btn.text
        color: "white"
        font.pixelSize: 14
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
