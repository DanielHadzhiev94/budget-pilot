import QtQuick
import QtQuick.Layouts
import BudgetPilot

Row {
    id: root

    property var columns: []
    property int cellPadding: 18
    property int headerHeight: 52

    // Function passed from TransactionTable.qml
    property var columnWidthProvider

    height: headerHeight
    clip: true

    Repeater {
        model: root.columns

        Rectangle {
            width: root.columnWidthProvider
                ? root.columnWidthProvider(index)
                : 100

            height: root.headerHeight
            color: AppTheme.tableHeaderSurface

            Text {
                anchors.fill: parent
                anchors.leftMargin: root.cellPadding
                anchors.rightMargin: root.cellPadding

                text: modelData.title
                color: AppTheme.textMuted

                font.pixelSize: 11
                font.bold: true
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 0.5

                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: modelData.align
            }
        }
    }
}
