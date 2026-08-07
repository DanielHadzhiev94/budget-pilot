import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import BudgetPilot

ColumnLayout {
    id: entitySelector

    property string label: ""
    property var entities: []
    property bool protectsOtherCategories: false
    readonly property var dropdownEntities: entities.map(function(entity) {
        return {
            id: entity.id,
            name: entity.name,
            deletable: !entitySelector.protectsOtherCategories
                || (entity.name !== "Other Expense" && entity.name !== "Other Income"),
            deleteAction: entitySelector.deleteEntity
        }
    })
    property alias currentIndex: combo.currentIndex
    readonly property alias currentValue: combo.currentValue
    readonly property alias count: combo.count
    signal addRequested()
    signal deletionRequested(int entityId, string entityName)

    function valueAt(index) {
        return combo.valueAt(index)
    }

    function currentEntity() {
        return combo.currentIndex >= 0 ? entities[combo.currentIndex] : null
    }

    function canDeleteCurrentEntity() {
        const entity = currentEntity()
        return entity !== null && (!protectsOtherCategories
            || (entity.name !== "Other Expense" && entity.name !== "Other Income"))
    }

    function deleteEntity(entityId, entityName) {
        combo.popup.close()
        deletionRequested(entityId, entityName)
    }

    Layout.fillWidth: true
    spacing: 6

    Text {
        text: entitySelector.label
        color: AppTheme.textSecondary
        font.pixelSize: 12
        font.bold: true
    }

    RowLayout {
        Layout.fillWidth: true

        ComboBox {
            id: combo
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            model: entitySelector.dropdownEntities
            textRole: "name"
            valueRole: "id"
            onModelChanged: currentIndex = count > 0 ? 0 : -1

            background: Rectangle {
                radius: 11
                color: AppTheme.backgroundAlt
                border.color: combo.activeFocus ? AppTheme.primary : AppTheme.border
                border.width: 1
            }
            contentItem: Text {
                text: combo.displayText
                color: AppTheme.textPrimary
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
                leftPadding: 13
                rightPadding: combo.indicator.width + 13
                elide: Text.ElideRight
            }
            indicator: Text {
                x: combo.width - width - 13
                y: combo.topPadding + (combo.availableHeight - height) / 2
                text: "▾"
                color: AppTheme.textSecondary
                font.pixelSize: 12
            }
            delegate: ItemDelegate {
                width: combo.width
                height: 38
                background: Rectangle { radius: 8; color: highlighted ? AppTheme.backgroundAlt : "transparent" }
                contentItem: RowLayout {
                    spacing: 4
                    Text {
                        Layout.fillWidth: true
                        text: modelData.name
                        color: AppTheme.textPrimary
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 10
                        elide: Text.ElideRight
                    }
                    Button {
                        text: "×"
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        enabled: modelData.deletable
                        contentItem: Text {
                            text: parent.text
                            color: parent.enabled ? AppTheme.danger : AppTheme.textMuted
                            font.pixelSize: 20
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle { radius: 6; color: parent.hovered ? AppTheme.dangerSoft : "transparent" }
                        onClicked: {
                            modelData.deleteAction(modelData.id, modelData.name)
                        }
                    }
                }
            }
            popup: Popup {
                y: combo.height + 6
                width: combo.width
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
                    model: combo.popup.visible ? combo.delegateModel : null
                    currentIndex: combo.highlightedIndex
                }
            }
        }
        AddButton { onClicked: entitySelector.addRequested() }
    }
}
