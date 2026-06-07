import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

Dialog {
    id: root

    required property var viewModel
    property string transactionType: "Expense"

    property bool isEditMode: false
    property int editingTransactionId: -1
    property var editingTransaction: null

    function clearData() {
        isEditMode = false;
        editingTransactionId = -1;
        editingTransaction = null;

        amountInput.text = "";
        typeInput.currentIndex = 0;
        root.transactionType = "Expense";

        categoryInput.currentIndex = 0 ?? -1;
        accountInput.currentIndex = 0 ?? -1;

        sourceInput.text = "";
        noteInput.text = "";
    }

    function openForCreate() {
        root.clearData();
        root.open();
    }

    function openForEdit(row) {
        if (row === undefined || row === null) {
            console.log("AddTransactionDialog: invalid edit row");
            return;
        }

        console.log("ROW ID:", row.id);

        root.isEditMode = true;
        root.editingTransactionId = row.id !== undefined ? row.id : -1;

        amountInput.text = row.amount !== undefined && row.amount !== null ? String(row.amount) : "";

        sourceInput.text = row.source !== undefined && row.source !== null ? String(row.source) : "";

        noteInput.text = row.note !== undefined && row.note !== null ? String(row.note) : "";

        if (row.type === "Income") {
            typeInput.currentIndex = 1;
        } else {
            typeInput.currentIndex = 0;
        }

        var categoryIndex = categoryInput.model.indexOf(row.category);

        categoryInput.currentIndex = categoryIndex >= 0 ? categoryIndex : 0;

        root.open();
    }

    modal: true
    anchors.centerIn: parent

    width: 460
    height: 620
    padding: 0

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    onOpened: {
        root.viewModel.loadInitialData();
        amountInput.forceActiveFocus();
    }

    background: Rectangle {
        radius: 18
        color: AppTheme.backgroundMainCard
        border.color: AppTheme.border
        border.width: 1
    }

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // =========================
            // Header
            // =========================
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

                        Text {
                            anchors.centerIn: parent
                            text: "+"
                            color: AppTheme.primary
                            font.pixelSize: 28
                            font.bold: true
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: root.isEditMode ? "Edit transaction" : "Add transaction"
                            color: AppTheme.textPrimary
                            font.pixelSize: 20
                            font.bold: true
                        }

                        Text {
                            text: root.isEditMode ? "Update an existing income or expense entry" : "Create a new income or expense entry"
                            color: AppTheme.textSecondary
                            font.pixelSize: 13
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

            // =========================
            // Error message - shown at top
            // =========================
            Rectangle {
                id: errorBox

                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: root.viewModel.errorMessage.length > 0 ? 16 : 0
                Layout.bottomMargin: root.viewModel.errorMessage.length > 0 ? 4 : 0

                Layout.preferredHeight: root.viewModel.errorMessage.length > 0 ? errorText.implicitHeight + 22 : 0

                visible: root.viewModel.errorMessage.length > 0

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

            // =========================
            // Body
            // =========================
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                ColumnLayout {
                    width: root.width
                    spacing: 14

                    Item {
                        Layout.preferredHeight: 6
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: 24
                        Layout.rightMargin: 24
                        spacing: 13

                        // Amount
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: "Amount"
                                color: AppTheme.textSecondary
                                font.pixelSize: 12
                                font.bold: true
                            }

                            TextField {
                                id: amountInput

                                Layout.fillWidth: true
                                Layout.preferredHeight: 44

                                placeholderText: "0.00"
                                color: AppTheme.textPrimary
                                placeholderTextColor: AppTheme.textSecondary
                                font.pixelSize: 15
                                selectionColor: AppTheme.primary

                                leftPadding: 13
                                rightPadding: 13

                                background: Rectangle {
                                    radius: 11
                                    color: AppTheme.backgroundAlt
                                    border.color: amountInput.activeFocus ? AppTheme.primary : AppTheme.border
                                    border.width: 1
                                }
                            }
                        }

                        // Type + Category
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6

                                Text {
                                    text: "Type"
                                    color: AppTheme.textSecondary
                                    font.pixelSize: 12
                                    font.bold: true
                                }

                                ComboBox {
                                    id: typeInput

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 44

                                    model: ["Expense", "Income"]
                                    currentIndex: 0

                                    onCurrentTextChanged: {
                                        root.transactionType = currentText;
                                    }

                                    background: Rectangle {
                                        radius: 11
                                        color: AppTheme.backgroundAlt
                                        border.color: typeInput.activeFocus ? AppTheme.primary : AppTheme.border
                                        border.width: 1
                                    }

                                    contentItem: Text {
                                        text: typeInput.displayText
                                        color: root.transactionType === "Income" ? "#00A86B" : AppTheme.danger
                                        font.pixelSize: 14
                                        font.bold: true
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: 13
                                        rightPadding: typeInput.indicator.width + 13
                                        elide: Text.ElideRight
                                    }

                                    indicator: Text {
                                        x: typeInput.width - width - 13
                                        y: typeInput.topPadding + (typeInput.availableHeight - height) / 2
                                        text: "▾"
                                        color: AppTheme.textSecondary
                                        font.pixelSize: 12
                                    }

                                    delegate: ItemDelegate {
                                        width: typeInput.width
                                        height: 38

                                        background: Rectangle {
                                            radius: 8
                                            color: highlighted ? AppTheme.backgroundAlt : "transparent"
                                        }

                                        contentItem: Text {
                                            text: modelData
                                            color: modelData === "Income" ? "#00A86B" : AppTheme.danger
                                            font.pixelSize: 14
                                            font.bold: true
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: 10
                                        }
                                    }

                                    popup: Popup {
                                        y: typeInput.height + 6
                                        width: typeInput.width
                                        implicitHeight: contentItem.implicitHeight
                                        padding: 4

                                        background: Rectangle {
                                            radius: 10
                                            color: AppTheme.backgroundMainCard
                                            border.color: AppTheme.border
                                            border.width: 1
                                        }

                                        contentItem: ListView {
                                            clip: true
                                            implicitHeight: contentHeight
                                            model: typeInput.popup.visible ? typeInput.delegateModel : null
                                            currentIndex: typeInput.highlightedIndex
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 6

                                Text {
                                    text: "Category"
                                    color: AppTheme.textSecondary
                                    font.pixelSize: 12
                                    font.bold: true
                                }

                                ComboBox {
                                    id: categoryInput

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 44

                                    model: root.viewModel.categories
                                    textRole: "name"
                                    valueRole: "id"

                                    background: Rectangle {
                                        radius: 11
                                        color: AppTheme.backgroundAlt
                                        border.color: categoryInput.activeFocus ? AppTheme.primary : AppTheme.border
                                        border.width: 1
                                    }

                                    contentItem: Text {
                                        text: categoryInput.displayText
                                        color: AppTheme.textPrimary
                                        font.pixelSize: 14
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: 13
                                        rightPadding: categoryInput.indicator.width + 13
                                        elide: Text.ElideRight
                                    }

                                    indicator: Text {
                                        x: categoryInput.width - width - 13
                                        y: categoryInput.topPadding + (categoryInput.availableHeight - height) / 2
                                        text: "▾"
                                        color: AppTheme.textSecondary
                                        font.pixelSize: 12
                                    }

                                    delegate: ItemDelegate {
                                        width: categoryInput.width
                                        height: 38

                                        background: Rectangle {
                                            radius: 8
                                            color: highlighted ? AppTheme.backgroundAlt : "transparent"
                                        }

                                        contentItem: Text {
                                            text: modelData.name
                                            color: AppTheme.textPrimary
                                            font.pixelSize: 14
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: 10
                                            elide: Text.ElideRight
                                        }
                                    }

                                    popup: Popup {
                                        y: categoryInput.height + 6
                                        width: categoryInput.width
                                        implicitHeight: Math.min(contentItem.implicitHeight, 220)
                                        padding: 4

                                        background: Rectangle {
                                            radius: 10
                                            color: AppTheme.backgroundMainCard
                                            border.color: AppTheme.border
                                            border.width: 1
                                        }

                                        contentItem: ListView {
                                            clip: true
                                            implicitHeight: contentHeight
                                            model: categoryInput.popup.visible ? categoryInput.delegateModel : null
                                            currentIndex: categoryInput.highlightedIndex
                                        }
                                    }
                                }
                            }
                        }

                        // Account
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: "Account"
                                color: AppTheme.textSecondary
                                font.pixelSize: 12
                                font.bold: true
                            }

                            ComboBox {
                                id: accountInput

                                Layout.fillWidth: true
                                Layout.preferredHeight: 44

                                model: root.viewModel.accounts
                                textRole: "name"
                                valueRole: "id"

                                background: Rectangle {
                                    radius: 11
                                    color: AppTheme.backgroundAlt
                                    border.color: accountInput.activeFocus ? AppTheme.primary : AppTheme.border
                                    border.width: 1
                                }

                                contentItem: Text {
                                    text: accountInput.displayText
                                    color: AppTheme.textPrimary
                                    font.pixelSize: 14
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 13
                                    rightPadding: accountInput.indicator.width + 13
                                    elide: Text.ElideRight
                                }

                                indicator: Text {
                                    x: accountInput.width - width - 13
                                    y: accountInput.topPadding + (accountInput.availableHeight - height) / 2
                                    text: "▾"
                                    color: AppTheme.textSecondary
                                    font.pixelSize: 12
                                }

                                delegate: ItemDelegate {
                                    width: accountInput.width
                                    height: 38

                                    background: Rectangle {
                                        radius: 8
                                        color: highlighted ? AppTheme.backgroundAlt : "transparent"
                                    }

                                    contentItem: Text {
                                        text: modelData.name
                                        color: AppTheme.textPrimary
                                        font.pixelSize: 14
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: 10
                                        elide: Text.ElideRight
                                    }
                                }

                                popup: Popup {
                                    y: accountInput.height + 6
                                    width: accountInput.width
                                    implicitHeight: Math.min(contentItem.implicitHeight, 220)
                                    padding: 4

                                    background: Rectangle {
                                        radius: 10
                                        color: AppTheme.backgroundMainCard
                                        border.color: AppTheme.border
                                        border.width: 1
                                    }

                                    contentItem: ListView {
                                        clip: true
                                        implicitHeight: contentHeight
                                        model: accountInput.popup.visible ? accountInput.delegateModel : null
                                        currentIndex: accountInput.highlightedIndex
                                    }
                                }
                            }
                        }

                        // Source
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: root.transactionType === "Income" ? "Source" : "Merchant / Source"
                                color: AppTheme.textSecondary
                                font.pixelSize: 12
                                font.bold: true
                            }

                            TextField {
                                id: sourceInput

                                Layout.fillWidth: true
                                Layout.preferredHeight: 44

                                placeholderText: root.transactionType === "Income" ? "Salary, bonus, freelance..." : "Lidl, rent, Amazon..."
                                color: AppTheme.textPrimary
                                placeholderTextColor: AppTheme.textSecondary
                                font.pixelSize: 14
                                selectionColor: AppTheme.primary

                                leftPadding: 13
                                rightPadding: 13

                                background: Rectangle {
                                    radius: 11
                                    color: AppTheme.backgroundAlt
                                    border.color: sourceInput.activeFocus ? AppTheme.primary : AppTheme.border
                                    border.width: 1
                                }
                            }
                        }

                        // Date
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: "Date"
                                color: AppTheme.textSecondary
                                font.pixelSize: 12
                                font.bold: true
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 44
                                radius: 11
                                color: AppTheme.backgroundAlt
                                border.color: AppTheme.border
                                border.width: 1

                                DatePicker {
                                    id: datePicker
                                    anchors.fill: parent
                                    anchors.margins: 2
                                }
                            }
                        }

                        // Note
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: "Note"
                                color: AppTheme.textSecondary
                                font.pixelSize: 12
                                font.bold: true
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 92

                                radius: 11
                                color: AppTheme.backgroundAlt
                                border.color: noteInput.activeFocus ? AppTheme.primary : AppTheme.border
                                border.width: 1

                                TextArea {
                                    id: noteInput

                                    anchors.fill: parent
                                    anchors.margins: 8

                                    placeholderText: "Optional note..."
                                    placeholderTextColor: AppTheme.textSecondary
                                    color: AppTheme.textPrimary
                                    font.pixelSize: 14
                                    wrapMode: TextArea.Wrap
                                    selectionColor: AppTheme.primary

                                    background: Rectangle {
                                        color: "transparent"
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.preferredHeight: 8
                    }
                }
            }

            // =========================
            // Footer
            // =========================
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 74

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: 1
                    color: AppTheme.border
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    spacing: 12

                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        id: cancelButton

                        Layout.preferredWidth: 104
                        Layout.preferredHeight: 42

                        text: "Cancel"

                        background: Rectangle {
                            radius: 11
                            color: cancelButton.hovered ? AppTheme.backgroundAlt : "transparent"
                            border.color: AppTheme.border
                            border.width: 1
                        }

                        contentItem: Text {
                            text: cancelButton.text
                            color: AppTheme.textPrimary
                            font.pixelSize: 14
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            root.clearData();
                            root.close();
                        }
                    }

                    Button {
                        id: saveButton

                        Layout.preferredWidth: 112
                        Layout.preferredHeight: 42

                        text: root.isEditMode ? "Update" : "Save"

                        background: Rectangle {
                            radius: 11
                            color: saveButton.hovered ? AppTheme.primaryDark : AppTheme.primary
                            border.color: AppTheme.primary
                            border.width: 1
                        }

                        contentItem: Text {
                            text: saveButton.text
                            color: "white"
                            font.pixelSize: 14
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            let month = datePicker.selectedMonth;
                            let year = datePicker.selectedYear;
                            let date = new Date(year, month, 1);

                            let success = false;

                            success = root.viewModel.saveTransaction(root.isEditMode, root.isEditMode ? root.editingTransactionId : -1, Number(amountInput.text), typeInput.currentText, accountInput.currentValue, categoryInput.currentValue, sourceInput.text, date, noteInput.text);

                            if (success) {
                                root.clearData();
                            }
                        }
                    }
                }
            }
        }
    }
}
