import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

ScrollView {
    id: form

    required property var viewModel
    property string transactionType: "Expense"
    readonly property var filteredCategories: viewModel.categories.filter(function(category) {
        return Number(category.type) === (form.transactionType === "Income" ? 1 : 2)
    })
    signal createEntityRequested(string entityType)
    signal entityDeletionRequested(string entityType, int entityId, string entityName)

    function findIndexByValue(selector, value) {
        for (let index = 0; index < selector.count; ++index) {
            if (Number(selector.valueAt(index)) === Number(value)) return index
        }
        return -1
    }
    function clearData() {
        amountInput.text = ""
        typeInput.currentIndex = 0
        transactionType = "Expense"
        categoryInput.currentIndex = categoryInput.count > 0 ? 0 : -1
        accountInput.currentIndex = accountInput.count > 0 ? 0 : -1
        sourceInput.text = ""
        noteInput.text = ""
    }
    function populate(row) {
        amountInput.text = row.amount === undefined || row.amount === null ? "" : String(row.amount)
        sourceInput.text = row.source === undefined || row.source === null ? "" : String(row.source)
        noteInput.text = row.note === undefined || row.note === null ? "" : String(row.note)
        typeInput.currentIndex = row.type === "Income" ? 1 : 0
        categoryInput.currentIndex = Math.max(0, findIndexByValue(categoryInput, row.categoryId))
        accountInput.currentIndex = Math.max(0, findIndexByValue(accountInput, row.accountId))
        if (row.date !== undefined && row.date !== null) datePicker.setDateFromString(String(row.date))
    }
    function focusAmount() { amountInput.forceActiveFocus() }
    function transactionData() {
        return { amount: Number(amountInput.text), type: typeInput.currentText,
            accountId: accountInput.currentValue, categoryId: categoryInput.currentValue,
            source: sourceInput.text, date: new Date(datePicker.selectedYear, datePicker.selectedMonth - 1, 1), note: noteInput.text }
    }

    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
        width: form.width
        spacing: 14
        Item { Layout.preferredHeight: 6 }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            spacing: 13

            ColumnLayout {
                Layout.fillWidth: true; spacing: 6
                Text { text: "Amount"; color: AppTheme.textSecondary; font.pixelSize: 12; font.bold: true }
                CustomTextField { id: amountInput; placeholderText: "0.00" }
            }
            RowLayout {
                Layout.fillWidth: true; spacing: 12
                ColumnLayout {
                    Layout.fillWidth: true; spacing: 6
                    Text { text: "Type"; color: AppTheme.textSecondary; font.pixelSize: 12; font.bold: true }
                    ComboBox {
                        id: typeInput
                        Layout.fillWidth: true; Layout.preferredHeight: 44
                        model: ["Expense", "Income"]
                        onCurrentTextChanged: form.transactionType = currentText
                        background: Rectangle { radius: 11; color: AppTheme.backgroundAlt; border.color: typeInput.activeFocus ? AppTheme.primary : AppTheme.border; border.width: 1 }
                        contentItem: Text { text: typeInput.displayText; color: form.transactionType === "Income" ? "#00A86B" : AppTheme.danger; font.pixelSize: 14; font.bold: true; verticalAlignment: Text.AlignVCenter; leftPadding: 13 }
                    }
                }
                EntitySelector {
                    id: categoryInput
                    Layout.fillWidth: true
                    label: "Category"
                    entities: form.filteredCategories
                    protectsOtherCategories: true
                    onAddRequested: form.createEntityRequested("category")
                    onDeletionRequested: function(id, name) { form.entityDeletionRequested("category", id, name) }
                }
            }
            EntitySelector {
                id: accountInput
                label: "Account"
                entities: form.viewModel.accounts
                onAddRequested: form.createEntityRequested("account")
                onDeletionRequested: function(id, name) { form.entityDeletionRequested("account", id, name) }
            }
            ColumnLayout {
                Layout.fillWidth: true; spacing: 6
                Text { text: form.transactionType === "Income" ? "Source" : "Merchant / Source"; color: AppTheme.textSecondary; font.pixelSize: 12; font.bold: true }
                CustomTextField {
                    id: sourceInput
                    placeholderText: form.transactionType === "Income" ? "Salary, bonus, freelance..." : "Lidl, rent, Amazon..."
                }
            }
            ColumnLayout {
                Layout.fillWidth: true; spacing: 6
                Text { text: "Date"; color: AppTheme.textSecondary; font.pixelSize: 12; font.bold: true }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 44; radius: 11; color: AppTheme.backgroundAlt; border.color: AppTheme.border; border.width: 1
                    DatePicker {
                        id: datePicker; anchors.fill: parent; anchors.margins: 2
                        function setDateFromString(value) { const date = new Date(value); if (!isNaN(date.getTime())) setDate(date.getMonth() + 1, date.getFullYear()) }
                    }
                }
            }
            ColumnLayout {
                Layout.fillWidth: true; spacing: 6
                Text { text: "Note"; color: AppTheme.textSecondary; font.pixelSize: 12; font.bold: true }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 92; radius: 11; color: AppTheme.backgroundAlt; border.color: noteInput.activeFocus ? AppTheme.primary : AppTheme.border; border.width: 1
                    TextArea { id: noteInput; anchors.fill: parent; anchors.margins: 8; placeholderText: "Optional note..."; placeholderTextColor: AppTheme.textSecondary; color: AppTheme.textPrimary; font.pixelSize: 14; wrapMode: TextArea.Wrap; selectionColor: AppTheme.primary; background: Rectangle { color: "transparent" } }
                }
            }
        }
        Item { Layout.preferredHeight: 8 }
    }
}
