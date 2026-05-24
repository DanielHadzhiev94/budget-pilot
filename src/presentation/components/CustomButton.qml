import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Button {

    property string title: "Default text"
    property int custom_height: 40
    property int custom_width: 160

    id: btn

    text: title
    hoverEnabled: true

    Layout.rightMargin: 12
    Layout.topMargin: 8
    Layout.bottomMargin: 8

    Layout.preferredHeight: custom_height
    Layout.preferredWidth: custom_width

    background: Rectangle {
        radius: 10
        color: btn.hovered ? AppTheme.primaryLight : AppTheme.primarySoft
        border.color: AppTheme.primary
        border.width: 1
    }

    contentItem: Text {
        text: btn.text
        color: AppTheme.textPrimary
        font.pixelSize: 14
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}

