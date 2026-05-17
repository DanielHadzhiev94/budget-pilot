import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    Layout.fillWidth: true
    Layout.fillHeight: true

    color: AppTheme.backgroundAlt

    TransactionTableSection {
        viewModel: transactionTableVM

        anchors.fill: parent
        anchors.margins: 24
    }
}