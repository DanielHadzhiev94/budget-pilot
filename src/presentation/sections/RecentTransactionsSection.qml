import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import BudgetPilot

Rectangle {
    id: root

    signal viewAllTransactionsClicked()

    property var viewModel

    // Root layout sizes
    property int tableWidth: 720
    property int tableHeight: 460
    property int rootTopMargin: 0
    property int rootLeftMargin: 20
    property int rootRadius: 16
    property int borderWidth: 1

    // Inner layout sizes
    property int contentMargin: 18
    property int contentSpacing: 14
    property int sectionHeaderHeight: 34
    property int tableContainerRadius: 12
    property int tableHeaderHeight: 44
    property int rowHeight: 48
    property int rowHorizontalMargin: 16
    property int separatorHeight: 1

    // Text sizes
    property int titleFontSize: 18
    property int subtitleFontSize: 12
    property int headerFontSize: 12
    property int rowFontSize: 13
    property int badgeFontSize: 12
    property int emptyTitleFontSize: 16
    property int emptySubtitleFontSize: 13

    // Column sizes
    property int columnSpacing: 18
    property int dateColumnSize: 150
    property int typeColumnSize: 126
    property int categoryColumnSize: 105
    property int amountColumnSize: 115

    // Type badge sizes
    property int typeBadgeWidth: 92
    property int typeBadgeHeight: 26
    property int typeBadgeRadius: 13

    // Colors
    property color zebraRowColor: Qt.rgba(255, 255, 255, 0.035)
    property color hoverRowColor: Qt.rgba(255, 255, 255, 0.07)
    property color incomeBadgeColor: Qt.rgba(0.1, 0.8, 0.45, 0.12)
    property color expenseBadgeColor: Qt.rgba(1.0, 0.25, 0.25, 0.12)

    // Helper property
    readonly property bool hasTransactions: root.viewModel
        && root.viewModel.transactions
        && root.viewModel.transactions.length > 0

    // Root size
    Layout.preferredWidth: root.tableWidth
    Layout.preferredHeight: root.tableHeight
    Layout.topMargin: root.rootTopMargin
    Layout.leftMargin: root.rootLeftMargin

    color: AppTheme.backgroundMainCard
    radius: root.rootRadius
    border.color: AppTheme.border
    border.width: root.borderWidth
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.contentMargin
        spacing: root.contentSpacing

        // SECTION HEADER
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: root.sectionHeaderHeight

            ColumnLayout {
                spacing: 2

                Text {
                    text: "Recent 15 Transactions"
                    color: AppTheme.textPrimary
                    font.pixelSize: root.titleFontSize
                    font.bold: true
                }

                Text {
                    text: "Overview of your latest income and expenses"
                    color: AppTheme.textSecondary
                    font.pixelSize: root.subtitleFontSize
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

            radius: root.tableContainerRadius
            color: AppTheme.background
            border.color: AppTheme.border
            border.width: root.borderWidth
            clip: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // TABLE HEADER
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.tableHeaderHeight

                    color: AppTheme.backgroundAlt

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: root.rowHorizontalMargin
                        anchors.rightMargin: root.rowHorizontalMargin
                        spacing: root.columnSpacing

                        Text {
                            text: "Date"
                            color: AppTheme.textSecondary
                            font.pixelSize: root.headerFontSize
                            font.bold: true
                            Layout.preferredWidth: root.dateColumnSize
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: "Type"
                            color: AppTheme.textSecondary
                            font.pixelSize: root.headerFontSize
                            font.bold: true
                            Layout.preferredWidth: root.typeColumnSize
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: "Category"
                            color: AppTheme.textSecondary
                            font.pixelSize: root.headerFontSize
                            font.bold: true
                            Layout.preferredWidth: root.categoryColumnSize
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: "Source"
                            color: AppTheme.textSecondary
                            font.pixelSize: root.headerFontSize
                            font.bold: true
                            Layout.fillWidth: true
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: "Amount"
                            color: AppTheme.textSecondary
                            font.pixelSize: root.headerFontSize
                            font.bold: true
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            Layout.preferredWidth: root.amountColumnSize
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.separatorHeight
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
                            text: "No transactions yet"
                            color: AppTheme.textPrimary
                            font.pixelSize: root.emptyTitleFontSize
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Your transactions will appear here."
                            color: AppTheme.textSecondary
                            font.pixelSize: root.emptySubtitleFontSize
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

                        color: mouseArea.containsMouse
                            ? root.hoverRowColor
                            : row.index % 2 === 0
                                ? "transparent"
                                : root.zebraRowColor

                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: root.rowHorizontalMargin
                            anchors.rightMargin: root.rowHorizontalMargin
                            spacing: root.columnSpacing

                            Text {
                                text: row.modelData.date
                                color: AppTheme.textSecondary
                                font.pixelSize: root.rowFontSize
                                Layout.preferredWidth: root.dateColumnSize
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            // TYPE COLUMN
                            Item {
                                Layout.preferredWidth: root.typeColumnSize
                                Layout.fillHeight: true

                                Rectangle {
                                    width: root.typeBadgeWidth
                                    height: root.typeBadgeHeight
                                    radius: root.typeBadgeRadius

                                    anchors.centerIn: parent

                                    color: row.modelData.type === "Income"
                                        ? root.incomeBadgeColor
                                        : root.expenseBadgeColor

                                    Text {
                                        anchors.centerIn: parent

                                        text: row.modelData.type

                                        color: row.modelData.type === "Income"
                                            ? AppTheme.success
                                            : AppTheme.danger

                                        font.pixelSize: root.badgeFontSize
                                        font.bold: true
                                    }
                                }
                            }

                            Text {
                                text: row.modelData.category
                                color: AppTheme.textPrimary
                                font.pixelSize: root.rowFontSize
                                Layout.preferredWidth: root.categoryColumnSize
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            Text {
                                text: row.modelData.source
                                color: AppTheme.textSecondary
                                font.pixelSize: root.rowFontSize
                                Layout.fillWidth: true
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            Text {
                                text: row.modelData.type === "Income"
                                    ? "+ €" + Number(row.modelData.amount).toFixed(2)
                                    : "- €" + Number(row.modelData.amount).toFixed(2)

                                color: row.modelData.type === "Income"
                                    ? AppTheme.success
                                    : AppTheme.danger

                                font.pixelSize: root.rowFontSize
                                font.bold: true
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                Layout.preferredWidth: root.amountColumnSize
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: root.rowHorizontalMargin
                            anchors.rightMargin: root.rowHorizontalMargin

                            height: root.separatorHeight
                            color: AppTheme.border
                            opacity: 0.35
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
                text: "View all transactions ->"
                color: viewAllButton.hovered
                    ? AppTheme.primary
                    : AppTheme.textPrimary

                font.pixelSize: 14
                font.bold: true

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                root.viewAllTransactionsClicked()
            }
        }
    }
}