import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property var viewModel

    signal editTransactionClicked(var row)
    signal deleteTransactionClicked(int rowIndex)

    property int headerHeight: 50
    property int rowHeight: 58
    property int cellPadding: 16

    radius: 16
    color: AppTheme.tableSurface
    border.color: AppTheme.border
    border.width: 1
    clip: true

    readonly property int dateColumnWidth: 125
    readonly property int typeColumnWidth: 110
    readonly property int amountColumnWidth: 130
    readonly property int actionsColumnWidth: 108

    readonly property int fixedColumnsWidth:
        dateColumnWidth +
        typeColumnWidth +
        amountColumnWidth +
        actionsColumnWidth

    readonly property int flexibleAreaWidth: Math.max(
        360,
        tableView.width - fixedColumnsWidth
    )

    readonly property int categoryColumnWidth: Math.max(120, flexibleAreaWidth * 0.24)
    readonly property int sourceColumnWidth: Math.max(140, flexibleAreaWidth * 0.30)
    readonly property int noteColumnWidth: Math.max(160, flexibleAreaWidth * 0.46)

    readonly property var columns: [
        { title: "Date",     align: Text.AlignLeft },
        { title: "Type",     align: Text.AlignHCenter },
        { title: "Category", align: Text.AlignLeft },
        { title: "Source",   align: Text.AlignLeft },
        { title: "Note",     align: Text.AlignLeft },
        { title: "Amount",   align: Text.AlignRight },
        { title: "Actions",  align: Text.AlignHCenter }
    ]

    function columnWidth(column) {
        switch (column) {
            case 0:
                return root.dateColumnWidth
            case 1:
                return root.typeColumnWidth
            case 2:
                return root.categoryColumnWidth
            case 3:
                return root.sourceColumnWidth
            case 4:
                return root.noteColumnWidth
            case 5:
                return root.amountColumnWidth
            case 6:
                return root.actionsColumnWidth
            default:
                return 100
        }
    }

    function cellData(rowIndex, columnIndex) {
        if (!tableView.model) {
            return ""
        }

        var value = tableView.model.index(rowIndex, columnIndex).data()

        if (value === undefined || value === null) {
            return ""
        }

        return value
    }

    function transactionType(rowIndex) {
        return String(root.cellData(rowIndex, 1))
    }

    function transactionRow(rowIndex) {
        return {
            rowIndex: rowIndex,
            date: String(root.cellData(rowIndex, 0)),
            type: String(root.cellData(rowIndex, 1)),
            category: String(root.cellData(rowIndex, 2)),
            source: String(root.cellData(rowIndex, 3)),
            note: String(root.cellData(rowIndex, 4)),
            amount: Number(root.cellData(rowIndex, 5))
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.headerHeight

            color: AppTheme.backgroundMainCard

            Row {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: root.columns.length

                    delegate: Rectangle {
                        width: root.columnWidth(index)
                        height: root.headerHeight
                        color: "transparent"

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: root.cellPadding
                            anchors.rightMargin: root.cellPadding

                            text: root.columns[index].title
                            color: AppTheme.textSecondary
                            font.pixelSize: 12
                            font.bold: true
                            font.capitalization: Font.AllUppercase

                            horizontalAlignment: root.columns[index].align
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: AppTheme.border
            }
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
                    opacity: 0.75
                }

                // Normal text cells: Date, Category, Source, Note
                Text {
                    visible: column !== 1 && column !== 5 && column !== 6

                    anchors.fill: parent
                    anchors.leftMargin: root.cellPadding
                    anchors.rightMargin: root.cellPadding

                    text: display === undefined || display === null ? "" : String(display)

                    color: column === 0 || column === 4
                        ? AppTheme.textSecondary
                        : AppTheme.textPrimary

                    font.pixelSize: 14

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                // Type badge
                TypeBadge {
                    visible: column === 1
                    anchors.centerIn: parent

                    value: display === undefined || display === null ? "" : String(display)
                }

                // Amount
                Text {
                    visible: column === 5

                    anchors.fill: parent
                    anchors.leftMargin: root.cellPadding
                    anchors.rightMargin: root.cellPadding

                    property string typeText: root.transactionType(row)
                    property real amountValue: {
                        var value = Number(display)
                        return isNaN(value) ? 0 : value
                    }

                    text: typeText === "Income"
                        ? "+ €" + amountValue.toFixed(2)
                        : "- €" + amountValue.toFixed(2)

                    color: typeText === "Income"
                        ? AppTheme.success
                        : AppTheme.danger

                    font.pixelSize: 15
                    font.bold: true

                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                // Actions
                Row {
                    visible: column === 6

                    anchors.centerIn: parent
                    spacing: 8

                    TransactionActionButton {
                        width: 32
                        height: 32

                        text: "✎"
                        textColor: AppTheme.textPrimary

                        onClicked: {
                            var selectedRow = root.transactionRow(row)
                            console.log("TransactionTable edit row:", JSON.stringify(selectedRow))
                            root.editTransactionClicked(selectedRow)
                        }
                    }

                    TransactionActionButton {
                        width: 32
                        height: 32

                        text: "🗑"
                        textColor: AppTheme.danger
                        danger: true

                        onClicked: root.deleteTransactionClicked(row)
                    }
                }
            }
        }
    }
}