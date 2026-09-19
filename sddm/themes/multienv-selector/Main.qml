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

    // Centered Login Card
    Rectangle {
        id: card
        width: 360
        height: 280
        anchors.centerIn: parent
        color: "#1a212a"
        radius: 12
        border.color: "#2e3a47"
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 18
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
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(root.currentUser, passwordInput.text, root.selectedSessionIndex)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Tab || event.key === Qt.Key_Right) {
                            if (sessionModel.count > 0) {
                                root.selectedSessionIndex = (root.selectedSessionIndex + 1) % sessionModel.count
                            }
                            event.accepted = true
                        } else if (event.key === Qt.Key_Left) {
                            if (sessionModel.count > 0) {
                                root.selectedSessionIndex = (root.selectedSessionIndex - 1 + sessionModel.count) % sessionModel.count
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
        }
    }
}
