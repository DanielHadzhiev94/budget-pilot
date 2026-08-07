import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Button {
    id: root

    property string label: ""
    property int preferredWidth: 164
    property int preferredHeight: 42
    property color normalColor: AppTheme.primary
    property color hoverColor: AppTheme.primaryLight
    property color pressedColor: AppTheme.primaryDark

    text: label
    hoverEnabled: true

    Layout.preferredHeight: preferredHeight
    Layout.preferredWidth: preferredWidth

    background: Rectangle {
        radius: 12
        color: root.down ? root.pressedColor : root.hovered ? root.hoverColor : root.normalColor
        border.color: AppTheme.borderLight
        border.width: 1

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    contentItem: Text {
        text: root.text
        color: "white"
        font.pixelSize: 14
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
