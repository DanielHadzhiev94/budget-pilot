import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

// A consistent confirmation prompt for destructive or otherwise irreversible actions.
Dialog {
    id: root

    property string dialogTitle: "Confirm action"
    property string subtitle: "Please confirm this action"
    property string message: "Are you sure you want to continue?"
    property string informativeText: ""
    property string confirmText: "Confirm"
    property string cancelText: "Cancel"
    property string iconText: "!"
    property bool destructive: false

    modal: true
    anchors.centerIn: parent
    width: 420
    height: 292
    padding: 0
    title: ""
    header: null

    readonly property color actionColor: destructive ? AppTheme.danger : AppTheme.primary
    readonly property color actionSoftColor: destructive ? AppTheme.dangerSoft : AppTheme.primaryLight

    enter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: AppTheme.motionNormal; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale"; from: 0.96; to: 1; duration: AppTheme.motionNormal; easing.type: Easing.OutCubic }
        }
    }

    exit: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: AppTheme.motionFast; easing.type: Easing.InCubic }
            NumberAnimation { property: "scale"; from: 1; to: 0.98; duration: AppTheme.motionFast; easing.type: Easing.InCubic }
        }
    }

    background: Rectangle {
        radius: AppTheme.radiusXL
        color: AppTheme.backgroundMainCard
        border.color: AppTheme.border
        border.width: 1
        clip: true
    }

    contentItem: Rectangle {
        radius: AppTheme.radiusXL
        color: AppTheme.backgroundMainCard
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    Layout.preferredWidth: 44
                    Layout.preferredHeight: 44
                    radius: 14
                    color: root.actionSoftColor
                    border.color: root.actionColor
                    border.width: 1
                    opacity: 0.95

                    Text {
                        anchors.centerIn: parent
                        text: root.iconText
                        color: root.actionColor
                        font.pixelSize: 28
                        font.bold: true
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3

                    Text {
                        Layout.fillWidth: true
                        text: root.dialogTitle
                        color: AppTheme.textPrimary
                        font.pixelSize: 20
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.subtitle
                        visible: text.length > 0
                        color: AppTheme.textMuted
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: AppTheme.divider
            }

            Text {
                Layout.fillWidth: true
                text: root.message
                color: AppTheme.textSecondary
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                lineHeight: 1.15
            }

            Text {
                Layout.fillWidth: true
                text: root.informativeText
                visible: text.length > 0
                color: AppTheme.textMuted
                font.pixelSize: 13
                wrapMode: Text.WordWrap
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                spacing: 10

                Item { Layout.fillWidth: true }

                Button {
                    id: cancelButton
                    text: root.cancelText
                    Layout.preferredWidth: 104
                    Layout.preferredHeight: 42

                    background: Rectangle {
                        radius: AppTheme.radiusMedium
                        color: cancelButton.hovered ? AppTheme.surfaceLight : AppTheme.backgroundMainCard
                        border.color: AppTheme.border
                        border.width: 1
                    }

                    contentItem: Text {
                        text: cancelButton.text
                        color: AppTheme.textPrimary
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: root.reject()
                }

                Button {
                    id: confirmButton
                    text: root.confirmText
                    Layout.preferredWidth: 104
                    Layout.preferredHeight: 42

                    background: Rectangle {
                        radius: AppTheme.radiusMedium
                        color: confirmButton.hovered ? root.actionColor : root.actionSoftColor
                        border.color: root.actionColor
                        border.width: 1
                    }

                    contentItem: Text {
                        text: confirmButton.text
                        color: confirmButton.hovered || !root.destructive ? "white" : root.actionColor
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: root.accept()
                }
            }
        }
    }
}
