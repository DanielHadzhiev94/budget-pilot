import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    property var popup
    property bool entered: false

    Layout.fillWidth: true
    Layout.fillHeight: true
    color: AppTheme.backgroundAlt
    opacity: entered ? 1 : 0

    Component.onCompleted: entered = true

    Behavior on opacity {
        NumberAnimation { duration: AppTheme.motionNormal; easing.type: Easing.OutCubic }
    }

    TransactionTableSection {
        viewModel: transactionTableVM
        dialogPopup: popup
        anchors.fill: parent
        anchors.margins: 24
    }
}
