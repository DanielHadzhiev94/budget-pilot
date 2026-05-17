import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Item {
    id: root

    property var viewModel

    signal addTransactionClicked()
    signal editTransactionClicked(int row)
    signal deleteTransactionClicked(int row)

    // Page layout
    property int headerHeight: 90
    property int tableHeaderHeight: 54
    property int rowHeight: 64
    property int tableRadius: 14

    // Table spacing
    property int cellPadding: 26

    // Column widths — tuned for your current 1440-ish layout
    property int dateColumnWidth: 165
    property int typeColumnWidth: 165
    property int categoryColumnWidth: 165
    property int sourceColumnWidth: 185
    property int noteColumnWidth: 250
    property int amountColumnWidth: 190
    property int actionsColumnWidth: 135

    // Badge
    property int typeBadgeWidth: 108
    property int typeBadgeHeight: 30
    property int typeBadgeRadius: 15

    // Colors
    property color tableSurface: "#07101C"
    property color tableHeaderSurface: "#0B182A"
    property color rowAltColor: "#0A1627"
    property color rowHoverColor: Qt.rgba(0.08, 0.28, 0.62, 0.18)

    property color tableBorder: Qt.rgba(120, 160, 220, 0.18)
    property color separatorColor: Qt.rgba(120, 160, 220, 0.12)

    property color incomeBadgeColor: Qt.rgba(0.0, 0.75, 0.42, 0.14)
    property color expenseBadgeColor: Qt.rgba(1.0, 0.20, 0.25, 0.15)

    function columnWidth(column) {
        switch (column) {
            case 0: return root.dateColumnWidth
            case 1: return root.typeColumnWidth
            case 2: return root.categoryColumnWidth
            case 3: return root.sourceColumnWidth
            case 4: return root.noteColumnWidth
            case 5: return root.amountColumnWidth
            case 6: return root.actionsColumnWidth
            default: return 120
        }
    }

    function transactionType(rowIndex) {
        if (!tableView.model)
            return ""

        return tableView.model.index(rowIndex, 1).data()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 22

        // TOP PAGE HEADER — no card around it
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: root.headerHeight

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Transactions"
                    color: AppTheme.textPrimary
                    font.pixelSize: 36
                    font.bold: true
                }

                Text {
                    text: "Full transaction history"
                    color: AppTheme.textSecondary
                    font.pixelSize: 18
                }
            }

            Button {
                id: addButton

                Layout.preferredWidth: 190
                Layout.preferredHeight: 48
                Layout.alignment: Qt.AlignVCenter

                text: "+  Add Transaction"

                background: Rectangle {
                    radius: 9

                    color: addButton.hovered
                        ? Qt.lighter(AppTheme.primary, 1.12)
                        : AppTheme.primary

                    border.color: Qt.rgba(255, 255, 255, 0.14)
                    border.width: 1

                    Behavior on color {
                        ColorAnimation { duration: 120 }
                    }
                }

                contentItem: Text {
                    text: addButton.text
                    color: "white"
                    font.pixelSize: 15
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: root.addTransactionClicked()
            }
        }

        // TABLE CARD — only one border
        Rectangle {
            id: tableCard

            Layout.fillWidth: true
            Layout.fillHeight: true

            radius: root.tableRadius
            color: root.tableSurface
            border.color: root.tableBorder
            border.width: 1
            clip: true

            // very subtle premium shine
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 1
                color: Qt.rgba(255, 255, 255, 0.08)
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // TABLE HEADER
                Row {
                    id: headerRow

                    Layout.fillWidth: true
                    Layout.preferredHeight: root.tableHeaderHeight
                    clip: true

                    Repeater {
                        model: ["Date", "Type", "Category", "Source", "Note", "Amount", "Actions"]

                        Rectangle {
                            width: root.columnWidth(index)
                            height: root.tableHeaderHeight
                            color: root.tableHeaderSurface

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: root.cellPadding
                                anchors.right: parent.right
                                anchors.rightMargin: root.cellPadding

                                text: modelData
                                color: AppTheme.textSecondary
                                font.pixelSize: 14
                                font.bold: true
                                elide: Text.ElideRight

                                horizontalAlignment: {
                                    if (index === 5)
                                        return Text.AlignRight

                                    if (index === 6)
                                        return Text.AlignHCenter

                                    return Text.AlignLeft
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: root.separatorColor
                }

                TableView {
                    id: tableView

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: root.viewModel

                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    columnSpacing: 0
                    rowSpacing: 0

                    columnWidthProvider: function(column) {
                        return root.columnWidth(column)
                    }

                    rowHeightProvider: function(row) {
                        return root.rowHeight
                    }

                    delegate: Rectangle {
                        id: cell

                        implicitWidth: root.columnWidth(column)
                        implicitHeight: root.rowHeight

                        color: rowMouseArea.containsMouse
                            ? root.rowHoverColor
                            : row % 2 === 0
                                ? "transparent"
                                : root.rowAltColor

                        Behavior on color {
                            ColorAnimation { duration: 120 }
                        }

                        MouseArea {
                            id: rowMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.NoButton
                        }

                        // row separator only, no cell border
                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: 1
                            color: root.separatorColor
                        }

                        // NORMAL CELLS: Date, Category, Source, Note
                        Text {
                            visible: column !== 1 && column !== 5 && column !== 6

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: root.cellPadding
                            anchors.right: parent.right
                            anchors.rightMargin: root.cellPadding

                            text: display

                            color: column === 0
                                ? AppTheme.textSecondary
                                : AppTheme.textPrimary

                            font.pixelSize: 15
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }

                        // TYPE BADGE
                        Item {
                            visible: column === 1
                            anchors.fill: parent

                            Rectangle {
                                width: root.typeBadgeWidth
                                height: root.typeBadgeHeight
                                radius: root.typeBadgeRadius

                                anchors.centerIn: parent

                                color: display === "Income"
                                    ? root.incomeBadgeColor
                                    : root.expenseBadgeColor

                                Text {
                                    anchors.centerIn: parent

                                    text: display
                                    color: display === "Income"
                                        ? AppTheme.success
                                        : AppTheme.danger

                                    font.pixelSize: 13
                                    font.bold: true
                                }
                            }
                        }

                        // AMOUNT
                        Text {
                            visible: column === 5

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: root.cellPadding
                            anchors.right: parent.right
                            anchors.rightMargin: root.cellPadding

                            property string typeText: root.transactionType(row)
                            property real amountValue: Number(display)

                            text: typeText === "Income"
                                ? "+ €" + amountValue.toFixed(2)
                                : "- €" + amountValue.toFixed(2)

                            color: typeText === "Income"
                                ? AppTheme.success
                                : AppTheme.danger

                            font.pixelSize: 16
                            font.bold: true
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }

                        // ACTIONS
                        RowLayout {
                            visible: column === 6

                            anchors.centerIn: parent
                            spacing: 10

                            Rectangle {
                                Layout.preferredWidth: 42
                                Layout.preferredHeight: 38
                                radius: 8

                                color: editArea.containsMouse
                                    ? Qt.rgba(255, 255, 255, 0.09)
                                    : Qt.rgba(255, 255, 255, 0.035)

                                border.color: editArea.containsMouse
                                    ? Qt.rgba(150, 190, 255, 0.45)
                                    : Qt.rgba(120, 160, 220, 0.22)

                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: "✎"
                                    color: AppTheme.textPrimary
                                    font.pixelSize: 18
                                    font.bold: true
                                }

                                MouseArea {
                                    id: editArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: root.editTransactionClicked(row)
                                }
                            }

                            Rectangle {
                                Layout.preferredWidth: 42
                                Layout.preferredHeight: 38
                                radius: 8

                                color: deleteArea.containsMouse
                                    ? Qt.rgba(1.0, 0.20, 0.25, 0.18)
                                    : Qt.rgba(1.0, 0.20, 0.25, 0.08)

                                border.color: deleteArea.containsMouse
                                    ? AppTheme.danger
                                    : Qt.rgba(1.0, 0.20, 0.25, 0.35)

                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: "🗑"
                                    color: AppTheme.danger
                                    font.pixelSize: 16
                                }

                                MouseArea {
                                    id: deleteArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: root.deleteTransactionClicked(row)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}