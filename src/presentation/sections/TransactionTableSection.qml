import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import BudgetPilot

Item {
    id: root

    property var viewModel
    property var dialogPopup
    property int rowIndex: -1

    signal editTransactionClicked(var row)
    signal deleteTransactionClicked(int rowIndex)

    Dialog {
        id: deleteDialog

        modal: true
        anchors.centerIn: parent
        title: ""
        header: null
        width: 420
        height: 292
        padding: 0

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
                        color: AppTheme.dangerSoft
                        border.color: Qt.rgba(1.0, 0.32, 0.32, 0.30)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "×"
                            color: AppTheme.danger
                            font.pixelSize: 28
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
                            text: "This action cannot be undone."
                            color: AppTheme.textMuted
                            font.pixelSize: 13
                            Layout.fillWidth: true
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
                    text: "Are you sure you want to permanently delete this transaction?"
                    color: AppTheme.textSecondary
                    font.pixelSize: 14
                    wrapMode: Text.WordWrap
                    lineHeight: 1.15
                }

                Item { Layout.fillHeight: true }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42
                    spacing: 10

                    Item { Layout.fillWidth: true }

                    Button {
                        id: cancelDeleteButton

                        text: "Cancel"
                        Layout.preferredWidth: 104
                        Layout.preferredHeight: 42

                        background: Rectangle {
                            radius: AppTheme.radiusMedium
                            color: cancelDeleteButton.hovered ? AppTheme.surfaceLight : AppTheme.backgroundMainCard
                            border.color: AppTheme.border
                            border.width: 1
                        }

                        contentItem: Text {
                            text: cancelDeleteButton.text
                            color: AppTheme.textPrimary
                            font.pixelSize: 14
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: deleteDialog.reject()
                    }

                    Button {
                        id: confirmDeleteButton

                        text: "Delete"
                        Layout.preferredWidth: 104
                        Layout.preferredHeight: 42

                        background: Rectangle {
                            radius: AppTheme.radiusMedium
                            color: confirmDeleteButton.hovered ? AppTheme.dangerStrong : AppTheme.dangerSoft
                            border.color: AppTheme.dangerStrong
                            border.width: 1
                        }

                        contentItem: Text {
                            text: confirmDeleteButton.text
                            color: confirmDeleteButton.hovered ? "white" : AppTheme.danger
                            font.pixelSize: 14
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: deleteDialog.accept()
                    }
                }
            }
        }

        onAccepted: {
            if (root.rowIndex !== -1 && root.viewModel) {
                root.viewModel.deleteTransaction(root.rowIndex)
                root.rowIndex = -1
            }
        }

        onRejected: root.rowIndex = -1
        onClosed: root.rowIndex = -1
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 18

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 88
            radius: AppTheme.radiusXL
            color: AppTheme.backgroundMainCard
            border.color: AppTheme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 22
                anchors.rightMargin: 18
                spacing: 16

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "Transactions"
                        color: AppTheme.textPrimary
                        font.pixelSize: 28
                        font.bold: true
                    }

                    Text {
                        text: "Review, edit and manage your monthly transaction history."
                        color: AppTheme.textMuted
                        font.pixelSize: 14
                    }
                }

                DatePicker {
                    Layout.preferredWidth: 285
                    Layout.preferredHeight: 42
                    Layout.alignment: Qt.AlignVCenter

                    onDateChanged: function(month, year) {
                        if (!root.viewModel) {
                            console.log("TransactionsPage: viewModel is undefined")
                            return
                        }

                        root.viewModel.loadData(month, year)
                        root.viewModel.setDate(month, year)
                    }
                }

                CustomButton {
                    title: "+ Add Transaction"
                    custom_width: 178
                    custom_height: 42
                    Layout.alignment: Qt.AlignVCenter

                    onClicked: {
                        if (!root.dialogPopup) {
                            console.log("TransactionsPage: dialogPopup is undefined")
                            return
                        }

                        root.dialogPopup.openForCreate()
                    }
                }
            }
        }

        TransactionTable {
            id: transactionTable
            Layout.fillWidth: true
            Layout.fillHeight: true
            viewModel: root.viewModel

            onEditTransactionClicked: function(row) {
                if (!root.dialogPopup) {
                    console.log("TransactionsPage: dialogPopup is undefined")
                    return
                }

                if (row === undefined || row === null) {
                    console.log("TransactionsPage: edit row is undefined/null")
                    return
                }

                root.dialogPopup.openForEdit(row)
            }

            onDeleteTransactionClicked: function(rowIndex) {
                if (rowIndex === undefined || rowIndex === null || rowIndex < 0) {
                    console.log("TransactionsPage: invalid delete rowIndex:", rowIndex)
                    return
                }

                root.rowIndex = rowIndex
                deleteDialog.open()
            }
        }
    }
}
