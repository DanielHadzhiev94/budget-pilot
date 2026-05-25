import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

Dialog {
    id: root

    modal: true
    anchors.centerIn: parent

    title: ""
    header: null

    width: 390
    height: 310

    padding: 0

    background: Rectangle {
        radius: 16
        color: AppTheme.backgroundMainCard
        border.color: AppTheme.border
        border.width: 1
        clip: true
    }

    contentItem: Rectangle {
        color: AppTheme.backgroundMainCard
        radius: 16
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    Layout.preferredWidth: 42
                    Layout.preferredHeight: 42
                    radius: 12
                    color: AppTheme.purpleSoft

                    Text {
                        anchors.centerIn: parent
                        text: "!"
                        color: AppTheme.purple
                        font.pixelSize: 22
                        font.bold: true
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3

                    Text {
                        text: "Delete transaction"
                        color: AppTheme.textPrimary
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "Please confirm this action"
                        color: AppTheme.textSecondary
                        font.pixelSize: 13
                        Layout.fillWidth: true
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: AppTheme.border
            }

            Text {
                text: "Are you sure you want to delete this transaction?"
                color: AppTheme.textPrimary
                font.pixelSize: 15
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Text {
                text: "This action cannot be undone."
                color: AppTheme.textSecondary
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                spacing: 10

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: cancelButton

                    text: "Cancel"

                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40

                    background: Rectangle {
                        radius: 10
                        color: cancelButton.hovered
                            ? AppTheme.backgroundAlt
                            : AppTheme.backgroundMainCard
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

                    onClicked: {
                        root.reject()
                    }
                }

                Button {
                    id: deleteButton

                    text: "Delete"

                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40

                    background: Rectangle {
                        radius: 10
                        color: deleteButton.hovered
                            ? AppTheme.purple
                            : AppTheme.purpleSoft
                        border.color: AppTheme.purple
                        border.width: 1
                    }

                    contentItem: Text {
                        text: deleteButton.text
                        color: AppTheme.textPrimary
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        root.accept()
                    }
                }
            }
        }
    }
}