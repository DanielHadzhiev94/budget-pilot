import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    signal dateChanged(int month, int year)

    readonly property var months: [
        "January", "February", "March", "April",
        "May", "June", "July", "August",
        "September", "October", "November", "December"
    ]

    readonly property var years: [
        2022, 2023, 2024, 2025,
        2026, 2027, 2028, 2029
    ]

    readonly property int selectedMonth: monthBox.currentIndex + 1
    readonly property int selectedYear: root.years[yearBox.currentIndex]

    Layout.preferredWidth: 285
    Layout.preferredHeight: 42

    radius: 10
    color: AppTheme.backgroundMainCard
    border.color: Qt.rgba(120, 160, 220, 0.22)
    border.width: 1
    clip: true

    function emitDateChanged() {
        root.dateChanged(root.selectedMonth, root.selectedYear)
    }

    function setDate(month, year) {
        const monthIndex = Math.max(0, Math.min(11, Number(month) - 1))
        const yearIndex = root.years.indexOf(Number(year))

        monthBox.currentIndex = monthIndex
        if (yearIndex >= 0) {
            yearBox.currentIndex = yearIndex
        }

        root.emitDateChanged()
    }

    Component.onCompleted: {
        root.emitDateChanged()
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 0

        StyledComboBox {
            id: monthBox

            Layout.preferredWidth: 148
            Layout.fillHeight: true

            model: root.months
            currentIndex: new Date().getMonth()

            textLeftPadding: 14

            onActivated: root.emitDateChanged()
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 26
            Layout.alignment: Qt.AlignVCenter

            color: Qt.rgba(120, 160, 220, 0.18)
        }

        StyledComboBox {
            id: yearBox

            Layout.fillWidth: true
            Layout.fillHeight: true

            model: root.years
            currentIndex: Math.max(0, root.years.indexOf(new Date().getFullYear()))

            textLeftPadding: 18

            onActivated: root.emitDateChanged()
        }
    }

    component StyledComboBox: ComboBox {
        id: control

        property int textLeftPadding: 14

        padding: 0
        hoverEnabled: true

        background: Rectangle {
            radius: 8

            color: control.down
                ? Qt.rgba(80, 120, 255, 0.28)
                : control.hovered
                    ? Qt.rgba(80, 120, 255, 0.16)
                    : "transparent"

            border.color: control.down || control.hovered
                ? Qt.rgba(120, 160, 255, 0.35)
                : "transparent"

            border.width: 1

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        contentItem: Text {
            text: control.displayText

            color: AppTheme.textPrimary
            font.pixelSize: 14

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            leftPadding: control.textLeftPadding
            rightPadding: 32

            elide: Text.ElideRight
        }

        indicator: Text {
            text: "▾"

            color: control.hovered || control.down
                ? AppTheme.primary
                : AppTheme.textSecondary

            font.pixelSize: 15
            font.bold: true

            anchors.right: parent.right
            anchors.rightMargin: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        popup: Popup {
            y: control.height + 6
            width: control.width
            implicitHeight: Math.min(contentItem.implicitHeight, 260)

            padding: 4

            background: Rectangle {
                radius: 10
                color: AppTheme.backgroundMainCard
                border.color: Qt.rgba(120, 160, 220, 0.25)
                border.width: 1
            }

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight

                model: control.popup.visible
                    ? control.delegateModel
                    : null

                currentIndex: control.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator {}
            }
        }

        delegate: ItemDelegate {
            id: itemDelegate

            width: control.width
            height: 36

            hoverEnabled: true

            contentItem: Text {
                text: modelData

                color: itemDelegate.hovered || highlighted
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary

                font.pixelSize: 14
                font.bold: itemDelegate.hovered || highlighted

                verticalAlignment: Text.AlignVCenter
                leftPadding: 10

                elide: Text.ElideRight
            }

            background: Rectangle {
                radius: 7

                color: highlighted
                    ? Qt.rgba(80, 120, 255, 0.28)
                    : itemDelegate.hovered
                        ? Qt.rgba(80, 120, 255, 0.22)
                        : "transparent"

                border.color: itemDelegate.hovered || highlighted
                    ? Qt.rgba(120, 160, 255, 0.34)
                    : "transparent"

                border.width: 1

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }
        }
    }
}