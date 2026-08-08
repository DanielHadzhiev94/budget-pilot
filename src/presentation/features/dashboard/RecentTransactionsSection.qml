import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import BudgetPilot

Rectangle {
    id: root

    signal viewAllTransactionsClicked()

    property var viewModel

    readonly property int rowHeight: 46
    readonly property int dateColumnWidth: 108
    readonly property int typeColumnWidth: 104
    readonly property int categoryColumnWidth: 125
    readonly property int amountColumnWidth: 108

    readonly property bool hasTransactions: root.viewModel
        && root.viewModel.transactions
        && root.viewModel.transactions.length > 0

    color: AppTheme.surface
    radius: AppTheme.radiusXL
    border.color: AppTheme.border
    border.width: 1
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: AppTheme.spacingLarge
        spacing: AppTheme.spacingMedium

        // SECTION HEADER
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 34

            ColumnLayout {
                spacing: 2

                Text {
                    text: "Recent transactions"
                    color: AppTheme.textPrimary
                    font.pixelSize: 18
                    font.bold: true
                }

                Text {
                    text: root.hasTransactions ? "Your latest income and expenses" : "Add your first entry to start tracking"
                    color: AppTheme.textSecondary
                    font.pixelSize: AppTheme.fontSmall
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        // TABLE CONTAINER
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

            radius: AppTheme.radiusMedium
            color: AppTheme.tableSurface
            border.color: AppTheme.border
            border.width: 1
            clip: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // TABLE HEADER
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42

                    color: AppTheme.tableHeaderSurface

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: AppTheme.spacingLarge
                        anchors.rightMargin: AppTheme.spacingLarge
                        spacing: AppTheme.radiusLarge

                        Text {
                            text: "Date"
                            color: AppTheme.textSecondary
                            font.pixelSize: AppTheme.fontSmall
                            font.bold: true
                            Layout.preferredWidth: root.dateColumnWidth
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: "Type"
                            color: AppTheme.textSecondary
                            font.pixelSize: AppTheme.fontSmall
                            font.bold: true
                            Layout.preferredWidth: root.typeColumnWidth
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: "Category"
                            color: AppTheme.textSecondary
                            font.pixelSize: AppTheme.fontSmall
                            font.bold: true
                            Layout.preferredWidth: root.categoryColumnWidth
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: "Amount"
                            color: AppTheme.textSecondary
                            font.pixelSize: AppTheme.fontSmall
                            font.bold: true
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.preferredWidth: root.amountColumnWidth
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: AppTheme.border
                }

                // EMPTY STATE
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: !root.hasTransactions

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: "No transactions for this month"
                            color: AppTheme.textPrimary
                            font.pixelSize: AppTheme.fontMedium
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Choose another month or add a transaction to get started."
                            color: AppTheme.textSecondary
                            font.pixelSize: AppTheme.fontBody
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // TABLE BODY
                ListView {
                    id: transactionList

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    visible: root.hasTransactions
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    model: root.hasTransactions
                        ? root.viewModel.transactions
                        : []

                    delegate: Rectangle {
                        id: row

                        required property var modelData
                        required property int index

                        width: ListView.view.width
                        height: root.rowHeight

                        color: row.hovered
                            ? AppTheme.tableRowHover
                            : row.index % 2 === 0 ? "transparent" : AppTheme.tableRowAlt

                        property bool hovered: rowMouseArea.containsMouse

                        Behavior on color {
                            ColorAnimation { duration: AppTheme.motionFast }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: AppTheme.spacingLarge
                            anchors.rightMargin: AppTheme.spacingLarge
                            spacing: AppTheme.radiusLarge

                            Text {
                                text: row.modelData.date
                                color: AppTheme.textSecondary
                                font.pixelSize: AppTheme.fontBody
                                Layout.preferredWidth: root.dateColumnWidth
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            // TYPE COLUMN
                            Item {
                                Layout.preferredWidth: root.typeColumnWidth
                                Layout.fillHeight: true

                                TypeBadge {
                                    anchors.centerIn: parent
                                    width: 92
                                    height: 26
                                    radius: 13
                                    value: row.modelData.type
                                }
                            }

                            Text {
                                text: row.modelData.category
                                color: AppTheme.textPrimary
                                font.pixelSize: AppTheme.fontBody
                                Layout.preferredWidth: root.categoryColumnWidth
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            Text {
                                text: AppTheme.formattedAmount(row.modelData.amount, row.modelData.type)

                                color: AppTheme.isIncome(row.modelData.type)
                                    ? AppTheme.success
                                    : AppTheme.danger

                                font.pixelSize: AppTheme.fontBody
                                font.bold: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                Layout.preferredWidth: root.amountColumnWidth
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: AppTheme.spacingLarge
                            anchors.rightMargin: AppTheme.spacingLarge

                            height: 1
                            color: AppTheme.border
                            opacity: 0.35
                        }

                        MouseArea {
                            id: rowMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.NoButton
                        }
                    }
                }
            }
        }

        Button {
            id: viewAllButton

            Layout.alignment: Qt.AlignRight

            background: Rectangle {
                color: "transparent"
            }

            contentItem: Text {
                text: "View all transactions →"
                color: viewAllButton.hovered
                    ? AppTheme.primary
                    : AppTheme.textPrimary

                font.pixelSize: 14
                font.bold: true

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            scale: pressed ? AppTheme.pressScale : hovered ? 1.02 : 1

            Behavior on scale {
                NumberAnimation { duration: AppTheme.motionFast; easing.type: Easing.OutCubic }
            }

            onClicked: {
                root.viewAllTransactionsClicked()
            }
        }
    }
}
