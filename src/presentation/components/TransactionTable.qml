import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property var viewModel

    signal editTransactionClicked(var row)
    signal deleteTransactionClicked(int rowIndex)

    property int headerHeight: 52
    property int rowHeight: 58
    property int cellPadding: 18

    radius: 16
    color: AppTheme.tableSurface
    border.color: AppTheme.border
    border.width: 1
    clip: true

    /*
        Professional table sizing strategy:

        Fixed columns:
        - Date
        - Type
        - Category
        - Amount
        - Actions

        Flexible columns:
        - Source
        - Note

        Source and Note get the remaining width because they contain
        the longest user-entered text.
    */

    readonly property int dateColumnWidth: 136
    readonly property int typeColumnWidth: 124
    readonly property int categoryColumnWidth: 190
    readonly property int amountColumnWidth: 150
    readonly property int actionsColumnWidth: 120

    readonly property int sourceMinWidth: 230
    readonly property int noteMinWidth: 200

    readonly property int fixedColumnsWidth: dateColumnWidth + typeColumnWidth + categoryColumnWidth + amountColumnWidth + actionsColumnWidth

    readonly property int minimumTableWidth: fixedColumnsWidth + sourceMinWidth + noteMinWidth

    readonly property int flexibleWidth: Math.max(sourceMinWidth + noteMinWidth, tableView.width - fixedColumnsWidth)

    readonly property int sourceColumnWidth: Math.round(flexibleWidth * 0.43)
    readonly property int noteColumnWidth: Math.round(flexibleWidth * 0.57)

    readonly property int totalTableWidth: dateColumnWidth + typeColumnWidth + categoryColumnWidth + sourceColumnWidth + noteColumnWidth + amountColumnWidth + actionsColumnWidth

    readonly property var columns: [
        {
            title: "Date",
            align: Text.AlignLeft
        },
        {
            title: "Type",
            align: Text.AlignHCenter
        },
        {
            title: "Category",
            align: Text.AlignLeft
        },
        {
            title: "Source",
            align: Text.AlignLeft
        },
        {
            title: "Note",
            align: Text.AlignLeft
        },
        {
            title: "Amount",
            align: Text.AlignRight
        },
        {
            title: "Actions",
            align: Text.AlignHCenter
        }
    ]

    function columnWidth(column) {
        switch (column) {
        case 0:
            return root.dateColumnWidth;
        case 1:
            return root.typeColumnWidth;
        case 2:
            return root.categoryColumnWidth;
        case 3:
            return root.sourceColumnWidth;
        case 4:
            return root.noteColumnWidth;
        case 5:
            return root.amountColumnWidth;
        case 6:
            return root.actionsColumnWidth;
        default:
            return 100;
        }
    }

    function cellData(rowIndex, columnIndex) {
        if (!tableView.model) {
            return "";
        }

        var value = tableView.model.index(rowIndex, columnIndex).data();

        if (value === undefined || value === null) {
            return "";
        }

        return value;
    }

    function transactionType(rowIndex) {
        return String(root.cellData(rowIndex, 1));
    }

    function formatDate(value) {
        if (value === undefined || value === null) {
            return "";
        }

        var text = String(value);

        // Handles values like:
        // 2026-05-28
        // 2026-05-28 00:00:00
        // 2026-05-28T00:00:00
        if (text.length >= 10) {
            return text.substring(0, 10);
        }

        return text;
    }

    function displayTextForColumn(columnIndex, value) {
        if (value === undefined || value === null) {
            return "";
        }

        if (columnIndex === 0) {
            return root.formatDate(value);
        }

        return String(value);
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
        };
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.headerHeight

            color: AppTheme.backgroundMainCard
            clip: true

            Row {
                id: headerRow

                x: -tableView.contentX
                width: root.totalTableWidth
                height: root.headerHeight
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

            columnWidthProvider: function (column) {
                return root.columnWidth(column);
            }

            rowHeightProvider: function (row) {
                return root.rowHeight;
            }

            ScrollBar.horizontal: ScrollBar {
                policy: root.totalTableWidth > tableView.width ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            delegate: Rectangle {
                implicitWidth: root.columnWidth(column)
                implicitHeight: root.rowHeight

                color: rowMouseArea.containsMouse ? AppTheme.tableRowHover : row % 2 === 0 ? "transparent" : AppTheme.tableRowAlt

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

                // Text cells: Date, Category, Source, Note
                Text {
                    id: normalCellText

                    visible: column !== 1 && column !== 5 && column !== 6

                    anchors.fill: parent
                    anchors.leftMargin: root.cellPadding
                    anchors.rightMargin: root.cellPadding

                    text: root.displayTextForColumn(column, display)

                    color: column === 0 || column === 4 ? AppTheme.textSecondary : AppTheme.textPrimary

                    font.pixelSize: 14

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    ToolTip.visible: normalCellMouseArea.containsMouse && truncated
                    ToolTip.text: text

                    MouseArea {
                        id: normalCellMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                    }
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
                        var value = Number(display);
                        return isNaN(value) ? 0 : value;
                    }

                    text: typeText === "Income" ? "+ €" + amountValue.toFixed(2) : "- €" + amountValue.toFixed(2)

                    color: typeText === "Income" ? AppTheme.success : AppTheme.danger

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
                    spacing: 10

                    TransactionActionButton {
                        width: 34
                        height: 34

                        text: "✎"
                        textColor: AppTheme.textPrimary

                        onClicked: {
                            var selectedRow = root.viewModel.transactionAt(row);
                            console.log("TransactionTable edit row:", JSON.stringify(selectedRow));
                            root.editTransactionClicked(selectedRow);
                        }
                    }

                    TransactionActionButton {
                        width: 34
                        height: 34

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
