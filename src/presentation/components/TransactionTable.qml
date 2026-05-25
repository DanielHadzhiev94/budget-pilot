import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property var viewModel

    signal editTransactionClicked(int row)

    signal deleteTransactionClicked(int rowIndex)

    property int headerHeight: 52
    property int rowHeight: 62
    property int cellPadding: 18

    readonly property var columns: [
        {title: "Date", ratio: 0.13, align: Text.AlignLeft},
        {title: "Type", ratio: 0.12, align: Text.AlignHCenter},
        {title: "Category", ratio: 0.14, align: Text.AlignLeft},
        {title: "Source", ratio: 0.15, align: Text.AlignLeft},
        {title: "Note", ratio: 0.22, align: Text.AlignLeft},
        {title: "Amount", ratio: 0.14, align: Text.AlignRight},
        {title: "Actions", ratio: 0.10, align: Text.AlignHCenter}
    ]

    radius: 14
    color: AppTheme.tableSurface
    border.color: AppTheme.border
    border.width: 1
    clip: true

    function columnWidth(column) {
        return Math.max(80, tableView.width * columns[column].ratio)
    }

    function transactionType(rowIndex) {
        if (!tableView.model)
            return ""

        return tableView.model.index(rowIndex, 1).data()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TransactionTableHeader {
            Layout.fillWidth: true
            Layout.preferredHeight: root.headerHeight

            columns: root.columns
            cellPadding: root.cellPadding

            columnWidthProvider: function (column) {
                return root.columnWidth(column)
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: AppTheme.border
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

            columnWidthProvider: function (column) {
                return root.columnWidth(column)
            }

            rowHeightProvider: function (row) {
                return root.rowHeight
            }

            delegate: Rectangle {
                implicitWidth: root.columnWidth(column)
                implicitHeight: root.rowHeight

                color: rowMouseArea.containsMouse
                    ? AppTheme.tableRowHover
                    : row % 2 === 0
                        ? "transparent"
                        : AppTheme.tableRowAlt

                MouseArea {
                    id: rowMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: AppTheme.border
                }

                Text {
                    visible: column !== 1 && column !== 5 && column !== 6

                    anchors.fill: parent
                    anchors.leftMargin: root.cellPadding
                    anchors.rightMargin: root.cellPadding

                    text: display
                    color: column === 0
                        ? AppTheme.textSecondary
                        : AppTheme.textPrimary

                    font.pixelSize: 15
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                TypeBadge {
                    visible: column === 1
                    anchors.centerIn: parent

                    value: display
                }

                Text {
                    visible: column === 5

                    anchors.fill: parent
                    anchors.leftMargin: root.cellPadding
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

                RowLayout {
                    visible: column === 6
                    anchors.centerIn: parent
                    spacing: 8

                    TransactionActionButton {
                        text: "✎"
                        textColor: AppTheme.textPrimary

                        onClicked: root.editTransactionClicked(row)
                    }

                    TransactionActionButton {
                        text: "🗑"
                        textColor: AppTheme.danger
                        danger: true

                        onClicked: {
                            root.deleteTransactionClicked(row)
                        }
                    }
                }
            }
        }
    }
}