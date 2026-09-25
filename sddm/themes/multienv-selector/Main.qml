import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 640
    height: 480
    color: "#0f1419"

    property string currentUser: userModel.lastUser
    property bool loginFailed: false
    property int selectedSessionIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0

    Connections {
        target: sddm
        function onLoginFailed() {
            root.loginFailed = true
            passwordInput.text = ""
            passwordInput.focus = true
        }
        function onLoginSucceeded() {
            root.loginFailed = false
        }
    }

    function getSessionCount() {
        if (typeof sessionModel.rowCount === "function") {
            return sessionModel.rowCount();
        }
        return sessionModel.count || 0;
    }

    // Centered Login Card
    Rectangle {
        id: card
        width: 380
        height: 310
        anchors.centerIn: parent
        color: "#1a212a"
        radius: 12
        border.color: "#2e3a47"
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 16
            width: parent.width - 48

            // Greeter Title
            Text {
                text: "Arch Multi-Environment"
                color: "#ffffff"
                font.pixelSize: 18
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // User Label
            Text {
                text: root.currentUser ? root.currentUser : "User"
                color: "#8ea89d"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Password Field
            Rectangle {
                width: parent.width
                height: 42
                color: "#121820"
                radius: 6
                border.color: root.loginFailed ? "#e06c75" : (passwordInput.activeFocus ? "#58c89c" : "#2e3a47")
                border.width: passwordInput.activeFocus ? 2 : 1

                TextInput {
                    id: passwordInput
                    anchors.fill: parent
                    anchors.margins: 10
                    echoMode: TextInput.Password
                    color: "#ffffff"
                    font.pixelSize: 14
                    verticalAlignment: TextInput.AlignVCenter
                    focus: true

                    onTextChanged: root.loginFailed = false

                    Keys.onPressed: {
                        var count = root.getSessionCount();
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(root.currentUser, passwordInput.text, root.selectedSessionIndex)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Tab || event.key === Qt.Key_Right || event.key === Qt.Key_Down) {
                            if (count > 0) {
                                root.selectedSessionIndex = (root.selectedSessionIndex + 1) % count
                            }
                            event.accepted = true
                        } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Up) {
                            if (count > 0) {
                                root.selectedSessionIndex = (root.selectedSessionIndex - 1 + count) % count
                            }
                            event.accepted = true
                        }
                    }
                }
            }

            // Dynamic Session Selection Pills
            Text {
                text: "Select Environment:"
                color: "#6b7d8e"
                font.pixelSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Flow {
                width: parent.width
                spacing: 8
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: sessionModel

                    Rectangle {
                        id: sessionPill
                        width: Math.max(90, pillText.implicitWidth + 20)
                        height: 32
                        radius: 6
                        color: root.selectedSessionIndex === index ? "#2d4d40" : "#141c24"
                        border.color: root.selectedSessionIndex === index ? "#58c89c" : "#2e3a47"
                        border.width: root.selectedSessionIndex === index ? 2 : 1

                        Text {
                            id: pillText
                            anchors.centerIn: parent
                            text: model.name || "Session"
                            color: root.selectedSessionIndex === index ? "#ffffff" : "#8ea89d"
                            font.pixelSize: 12
                            font.bold: root.selectedSessionIndex === index
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.selectedSessionIndex = index
                                passwordInput.forceActiveFocus()
                            }
                        }
                    }
                }
            }

            // Keyboard Navigation Hint
            Text {
                text: "Press [Tab] or [↑/↓/←/→] to switch environment"
                color: "#4e6070"
                font.pixelSize: 11
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    // Power Actions (Reboot / Shutdown)
    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 16

        Rectangle {
            width: 84
            height: 28
            radius: 4
            color: "#161d26"
            border.color: "#2e3a47"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "Reboot"
                color: "#8ea89d"
                font.pixelSize: 11
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: sddm.reboot()
            }
        }

        Rectangle {
            width: 84
            height: 28
            radius: 4
            color: "#161d26"
            border.color: "#2e3a47"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "Shutdown"
                color: "#8ea89d"
                font.pixelSize: 11
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: sddm.powerOff()
            }
        }
    }
}
