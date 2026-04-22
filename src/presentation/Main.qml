import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1200
    height: 700
    title: "BudgetPilot"

    Rectangle {
        anchors.fill: parent
        color: "#F5F7FB"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Label {
                    text: "Dashboard"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#1F2937"
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    text: "+ Add Transaction"
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 140
                    radius: 16
                    color: "#2563EB"

                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 10

                        Label {
                            text: "Current Balance"
                            color: "white"
                            font.pixelSize: 18
                            font.bold: true
                        }

                        Label {
                            text: "8,450 лв."
                            color: "white"
                            font.pixelSize: 38
                            font.bold: true
                        }

                        Label {
                            text: "Available funds"
                            color: "#DCE8FF"
                            font.pixelSize: 14
                        }
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 240
                    Layout.preferredHeight: 140
                    radius: 16
                    color: "white"
                    border.color: "#E5E7EB"

                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 10

                        Label {
                            text: "Income This Month"
                            color: "#374151"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        Label {
                            text: "3,200 лв."
                            color: "#16A34A"
                            font.pixelSize: 30
                            font.bold: true
                        }
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 240
                    Layout.preferredHeight: 140
                    radius: 16
                    color: "white"
                    border.color: "#E5E7EB"

                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 10

                        Label {
                            text: "Expenses This Month"
                            color: "#374151"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        Label {
                            text: "2,750 лв."
                            color: "#EA580C"
                            font.pixelSize: 30
                            font.bold: true
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 16
                color: "white"
                border.color: "#E5E7EB"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16

                    Label {
                        text: "Recent Transactions"
                        font.pixelSize: 22
                        font.bold: true
                        color: "#1F2937"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 44
                        radius: 10
                        color: "#F3F4F6"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16

                            Label { text: "Date"; Layout.preferredWidth: 140; font.bold: true }
                            Label { text: "Type"; Layout.preferredWidth: 140; font.bold: true }
                            Label { text: "Category"; Layout.preferredWidth: 180; font.bold: true }
                            Label { text: "Source"; Layout.fillWidth: true; font.bold: true }
                            Label { text: "Amount"; Layout.preferredWidth: 140; font.bold: true }
                        }
                    }

                    Repeater {
                        model: 4

                        delegate: Rectangle {
                            required property int index

                            Layout.fillWidth: true
                            Layout.preferredHeight: 52
                            radius: 8
                            color: index % 2 === 0 ? "#FFFFFF" : "#FAFAFA"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16

                                Label {
                                    text: ["10 Apr 2024", "15 Apr 2024", "18 Apr 2024", "20 Apr 2024"][index]
                                    Layout.preferredWidth: 140
                                    color: "#374151"
                                }

                                Rectangle {
                                    Layout.preferredWidth: 140
                                    Layout.preferredHeight: 30
                                    radius: 15
                                    color: index < 2 ? "#DCFCE7" : "#FEE2E2"

                                    Label {
                                        anchors.centerIn: parent
                                        text: index < 2 ? "Income" : "Expense"
                                        color: index < 2 ? "#166534" : "#991B1B"
                                        font.bold: true
                                    }
                                }

                                Label {
                                    text: ["Salary", "Freelance", "Groceries", "Cinema"][index]
                                    Layout.preferredWidth: 180
                                    color: "#374151"
                                }

                                Label {
                                    text: ["Company XYZ", "Upwork", "Supermarket", "Entertainment"][index]
                                    Layout.fillWidth: true
                                    color: "#374151"
                                }

                                Label {
                                    text: ["+2,500 лв.", "+500 лв.", "-250 лв.", "-180 лв."][index]
                                    Layout.preferredWidth: 140
                                    color: index < 2 ? "#16A34A" : "#DC2626"
                                    font.bold: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}