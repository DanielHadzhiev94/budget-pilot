import QtQuick
import QtQuick.Layouts
import BudgetPilot

Rectangle {
    id: root

    property string title: "Default"
    property string mainValue: "Default"
    property string subtitle: "Default"
    property color cardColor: AppTheme.surface
    property url iconSource: AppTheme.balanceIcon
    property color mainValueColor: AppTheme.success

    property int iconBoxSize: 48
    property int iconSize: 40

    radius: 12
    color: cardColor
    border.color: AppTheme.border
    border.width: 1

    implicitWidth: 282
    implicitHeight: 160

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 6

        RowLayout {
            Layout.fillWidth: true

            Item {
                Layout.preferredWidth: root.iconBoxSize
                Layout.preferredHeight: root.iconBoxSize

                Image {
                    anchors.centerIn: parent
                    source: root.iconSource

                    width: root.iconSize
                    height: root.iconSize

                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }
            }

            Text {
                text: root.title
                color: AppTheme.textPrimary
                font.pixelSize: 13
                font.bold: true
                Layout.alignment: Qt.AlignVCenter
            }
        }

        Text {
            text: root.mainValue
            color: root.mainValueColor
            font.pixelSize: 28
            font.bold: true
        }

        Item {
            Layout.preferredHeight: 12
        }

        Text {
            text: root.subtitle
            color: AppTheme.textSecondary
            font.pixelSize: 12
        }
    }
}
