import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    property var popup

    Layout.fillWidth: true
    Layout.fillHeight: true
    color: AppTheme.backgroundAlt

    TransactionTableSection {
        viewModel: transactionTableVM
        dialogPopup: popup
        anchors.fill: parent
        anchors.margins: 24
    }
}
