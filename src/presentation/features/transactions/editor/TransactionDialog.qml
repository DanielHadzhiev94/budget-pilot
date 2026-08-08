import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

Dialog {
    id: root

    required property var viewModel
    property bool isEditMode: false
    property int editingTransactionId: -1
    property var editingTransaction: null
    property string entityToDelete: ""
    property int entityIdToDelete: -1
    property string entityNameToDelete: ""

    function clearData() {
        isEditMode = false
        editingTransactionId = -1
        editingTransaction = null
        transactionForm.clearData()
    }
    function openForCreate() {
        clearData()
        open()
    }
    function openForEdit(row) {
        if (row === undefined || row === null) {
            console.log("TransactionDialog: invalid edit row")
            return
        }
        viewModel.loadInitialData()
        isEditMode = true
        editingTransactionId = row.id === undefined ? -1 : row.id
        editingTransaction = row
        open()
    }
    function openCreateDialog(entityType) {
        createDialog.entityType = entityType
        createDialog.defaultIsExpense = transactionForm.transactionType !== "Income"
        createDialog.open()
    }
    function confirmEntityDeletion(entityType, entityId, entityName) {
        entityToDelete = entityType
        entityIdToDelete = entityId
        entityNameToDelete = entityName
        deleteEntityDialog.open()
    }

    modal: true
    anchors.centerIn: parent
    width: 460
    height: 620
    padding: 0
    // Avoid accidentally discarding a partially completed transaction.
    closePolicy: Popup.CloseOnEscape

    onClosed: clearData()

    onOpened: {
        viewModel.loadInitialData()
        if (isEditMode && editingTransaction !== null) transactionForm.populate(editingTransaction)
        transactionForm.focusAmount()
    }

    background: Rectangle {
        radius: 18
        color: AppTheme.backgroundMainCard
        border.color: AppTheme.border
        border.width: 1
    }

    contentItem: ColumnLayout {
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 74
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 18
                spacing: 14
                Rectangle {
                    Layout.preferredWidth: 44
                    Layout.preferredHeight: 44
                    radius: 12
                    color: AppTheme.purpleSoft
                    Text { anchors.centerIn: parent; text: "+"; color: AppTheme.primary; font.pixelSize: 28; font.bold: true }
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text { text: root.isEditMode ? "Edit transaction" : "Add transaction"; color: AppTheme.textPrimary; font.pixelSize: 20; font.bold: true }
                    Text { text: root.isEditMode ? "Update an existing income or expense entry" : "Create a new income or expense entry"; color: AppTheme.textSecondary; font.pixelSize: 13 }
                }
            }
            Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: AppTheme.border }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            Layout.topMargin: viewModel.errorMessage.length > 0 ? 16 : 0
            Layout.bottomMargin: viewModel.errorMessage.length > 0 ? 4 : 0
            Layout.preferredHeight: viewModel.errorMessage.length > 0 ? errorText.implicitHeight + 22 : 0
            visible: viewModel.errorMessage.length > 0
            radius: 11
            color: "#2A1215"
            border.color: AppTheme.danger
            border.width: 1
            Text {
                id: errorText
                anchors.fill: parent
                anchors.margins: 11
                text: root.viewModel.errorMessage
                color: AppTheme.danger
                font.pixelSize: 13
                font.bold: true
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
            }
        }

        TransactionForm {
            id: transactionForm
            viewModel: root.viewModel
            onCreateEntityRequested: function(type) { root.openCreateDialog(type) }
            onEntityDeletionRequested: function(type, id, name) { root.confirmEntityDeletion(type, id, name) }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 74
            Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; height: 1; color: AppTheme.border }
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                spacing: 12
                Item { Layout.fillWidth: true }
                AppButton {
                    label: "Cancel"
                    preferredWidth: 104
                    preferredHeight: 42
                    normalColor: "transparent"
                    hoverColor: AppTheme.backgroundAlt
                    pressedColor: AppTheme.surfaceLight
                    onClicked: { root.clearData(); root.close() }
                }
                AppButton {
                    label: root.viewModel.isSaving ? "Saving…" : root.isEditMode ? "Update" : "Save"
                    preferredWidth: 112
                    preferredHeight: 42
                    enabled: transactionForm.isValid && !root.viewModel.isSaving
                    onClicked: {
                        const data = transactionForm.transactionData()
                        const saved = root.viewModel.saveTransaction(root.isEditMode, root.isEditMode ? root.editingTransactionId : -1,
                            data.amount, data.type, data.accountId, data.categoryId, data.source, data.date, data.note)
                        if (saved) root.clearData()
                    }
                }
            }
        }
    }

    EntityCreationDialog { id: createDialog; viewModel: root.viewModel }
    ConfirmationDialog {
        id: deleteEntityDialog
        dialogTitle: "Delete " + root.entityToDelete
        subtitle: "This action cannot be undone."
        message: root.entityToDelete === "category"
            ? "Delete ‘" + root.entityNameToDelete + "’? Transactions using it will be reassigned to the matching Other category."
            : "Delete ‘" + root.entityNameToDelete + "’? Its transactions will also be permanently deleted."
        confirmText: "Delete"
        iconText: "×"
        destructive: true
        onAccepted: {
            if (root.entityToDelete === "category") root.viewModel.deleteCategory(root.entityIdToDelete)
            else root.viewModel.deleteAccount(root.entityIdToDelete)
            root.entityIdToDelete = -1
            root.entityNameToDelete = ""
        }
        onRejected: { root.entityIdToDelete = -1; root.entityNameToDelete = "" }
    }
}
