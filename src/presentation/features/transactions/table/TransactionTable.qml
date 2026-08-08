import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property var viewModel

    signal editTransactionClicked(var row)
    signal deleteTransactionClicked(int rowIndex)

    property int headerHeight: 48
    property int rowHeight: 56
    property int cellPadding: 18

    radius: AppTheme.radiusXL
    color: AppTheme.tableSurface
    border.color: AppTheme.border
    border.width: 1
    clip: true

    readonly property int dateColumnWidth: 132
    readonly property int typeColumnWidth: 118
    readonly property int categoryColumnWidth: 168
    readonly property int amountColumnWidth: 142
    readonly property int actionsColumnWidth: 112
    readonly property int sourceMinWidth: 210
    readonly property int noteMinWidth: 220
    readonly property int fixedColumnsWidth: dateColumnWidth + typeColumnWidth + categoryColumnWidth + amountColumnWidth + actionsColumnWidth
    readonly property int flexibleWidth: Math.max(sourceMinWidth + noteMinWidth, tableView.width - fixedColumnsWidth)
    readonly property int sourceColumnWidth: Math.round(flexibleWidth * 0.44)
    readonly property int noteColumnWidth: Math.round(flexibleWidth * 0.56)
    readonly property int totalTableWidth: dateColumnWidth + typeColumnWidth + categoryColumnWidth + sourceColumnWidth + noteColumnWidth + amountColumnWidth + actionsColumnWidth

    readonly property var columns: [
        { title: "Date", align: Text.AlignLeft },
        { title: "Type", align: Text.AlignHCenter },
        { title: "Category", align: Text.AlignLeft },
        { title: "Source", align: Text.AlignLeft },
        { title: "Note", align: Text.AlignLeft },
        { title: "Amount", align: Text.AlignRight },
        { title: "Actions", align: Text.AlignHCenter }
    ]

    function columnWidth(column) {
        switch (column) {
        case 0: return root.dateColumnWidth;
        case 1: return root.typeColumnWidth;
        case 2: return root.categoryColumnWidth;
        case 3: return root.sourceColumnWidth;
        case 4: return root.noteColumnWidth;
        case 5: return root.amountColumnWidth;
        case 6: return root.actionsColumnWidth;
        default: return 100;
        }
    }

    function cellData(rowIndex, columnIndex) {
        if (!tableView.model) {
            return "";
        }

        var value = tableView.model.index(rowIndex, columnIndex).data();
        return value === undefined || value === null ? "" : value;
    }

    function transactionType(rowIndex) {
        return String(root.cellData(rowIndex, 1));
    }

    function formatDate(value) {
        if (value === undefined || value === null) {
            return "";
        }

        var text = String(value);
        return text.length >= 10 ? text.substring(0, 10) : text;
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

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.headerHeight
            color: AppTheme.tableHeaderSurface
            clip: true

            TransactionTableHeader {
                x: -tableView.contentX
                width: root.totalTableWidth
                columns: root.columns
                cellPadding: root.cellPadding
                headerHeight: root.headerHeight
                columnWidthProvider: root.columnWidth
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: AppTheme.divider
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            TableView {
                id: tableView
                anchors.fill: parent
                model: root.viewModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                columnSpacing: 0
                rowSpacing: 0

                columnWidthProvider: function(column) { return root.columnWidth(column); }
                rowHeightProvider: function(row) { return root.rowHeight; }

                ScrollBar.horizontal: ScrollBar {
                    policy: root.totalTableWidth > tableView.width ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                }

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                delegate: Rectangle {
                implicitWidth: root.columnWidth(column)
                implicitHeight: root.rowHeight
                color: row % 2 === 0 ? "transparent" : AppTheme.tableRowAlt

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: AppTheme.divider
                    opacity: 0.72
                }

                Text {
                    id: normalCellText
                    visible: column !== 1 && column !== 5 && column !== 6
                    anchors.fill: parent
                    anchors.leftMargin: root.cellPadding
                    anchors.rightMargin: root.cellPadding
                    text: root.displayTextForColumn(column, display)
                    color: column === 0 || column === 3 || column === 4 ? AppTheme.textSecondary : AppTheme.textPrimary
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

                TypeBadge {
                    visible: column === 1
                    anchors.centerIn: parent
                    value: display === undefined || display === null ? "" : String(display)
                }

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

                    text: AppTheme.formattedAmount(amountValue, typeText)
                    color: AppTheme.isIncome(typeText) ? AppTheme.success : AppTheme.danger
                    font.pixelSize: 14
                    font.bold: true
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                Row {
                    visible: column === 6
                    anchors.centerIn: parent
                    spacing: 8

                    TransactionActionButton {
                        width: 32
                        height: 32
                        iconText: "✎"
                        accessibleName: "Edit transaction"
                        textColor: AppTheme.textPrimary
                        onClicked: root.editTransactionClicked(root.viewModel.transactionAt(row))
                    }

                    TransactionActionButton {
                        width: 32
                        height: 32
                        iconText: "×"
                        accessibleName: "Delete transaction"
                        textColor: AppTheme.danger
                        danger: true
                        onClicked: root.deleteTransactionClicked(row)
                    }
                }
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width - 48, 320)
                visible: tableView.rows === 0
                spacing: AppTheme.spacingSmall

                Text {
                    Layout.fillWidth: true
                    text: "No transactions for this month"
                    color: AppTheme.textPrimary
                    font.pixelSize: AppTheme.fontMedium
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    Layout.fillWidth: true
                    text: "Add a transaction to begin tracking this period."
                    color: AppTheme.textMuted
                    font.pixelSize: AppTheme.fontBody
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
