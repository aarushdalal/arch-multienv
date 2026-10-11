import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 1280; height: 800
    color: "#0f1419"
    property string currentUser: userModel.lastUser || ""
    property bool pending: false
    property bool loginFailed: false
    property string message: ""
    property bool appeared: false
    property bool reducedMotion: typeof config !== "undefined" && config.ReducedMotion === "true"
    readonly property color accent: "#58c89c"
    readonly property bool validSession: sessions.currentIndex >= 0 && sessions.currentIndex < sessions.count
    GreeterMotion {
        id: motion
        reduced: root.reducedMotion
        preset: typeof config !== "undefined" && config.MotionPreset ? config.MotionPreset : "default"
        intensity: typeof config !== "undefined" && config.MotionIntensity ? config.MotionIntensity : "balanced"
    }
    Component.onCompleted: { appeared = true; password.forceActiveFocus(); }

    function login(biometric) {
        if (pending || !validSession || !username.text.trim()) return;
        pending = true; loginFailed = false;
        message = biometric ? "Place your finger on the reader" : "Signing in…";
        sddm.login(username.text.trim(), biometric ? "" : password.text, sessions.currentIndex);
    }
    Connections {
        target: sddm
        function onLoginFailed() {
            root.pending = false; root.loginFailed = true;
            root.message = "Authentication failed. Please try again.";
            password.clear(); password.forceActiveFocus();
        }
        function onLoginSucceeded() { password.clear(); root.message = "Welcome back"; }
        function onInformationMessage(message) { root.message = message; }
    }

    Rectangle {
        id: card; objectName: "floatingCard"
        anchors.centerIn: parent
        width: Math.min(440, root.width - 32)
        height: Math.min(content.implicitHeight + 56, root.height - 100)
        radius: 24; color: "#1a212a"; border.color: "#2e3a47"
        opacity: root.appeared ? 1 : 0
        scale: root.appeared ? 1 : motion.initialScale
        transform: Translate { x: root.appeared ? 0 : motion.xOffset; y: root.appeared ? 0 : motion.yOffset; Behavior on x { NumberAnimation { duration: motion.duration; easing.type: motion.curve } } Behavior on y { NumberAnimation { duration: motion.duration; easing.type: motion.curve } } }
        Behavior on opacity { NumberAnimation { duration: motion.duration } }
        Behavior on scale { NumberAnimation { duration: motion.duration; easing.type: motion.curve } }

        ScrollView {
            anchors.fill: parent; anchors.margins: 28
            contentWidth: availableWidth
            clip: true
            Column {
                id: content
                width: parent.width
                spacing: 18
                Text {
                    text: "Welcome back"; color: "#ffffff"; font.pixelSize: 27; font.weight: Font.DemiBold
                }
                Text {
                    text: "Choose your environment and sign in"; color: "#8ea89d"; font.pixelSize: 13
                    width: parent.width; wrapMode: Text.WordWrap
                }
                TextField {
                    id: username; objectName: "usernameField"; width: parent.width; text: root.currentUser
                    leftPadding: 14; rightPadding: 14
                    placeholderText: "Username"; enabled: !root.pending
                    Accessible.name: "Username"
                    color: "white"; selectByMouse: true; font.pixelSize: 15
                    background: FieldBackground { focused: username.activeFocus }
                    KeyNavigation.tab: sessions
                }
                ComboBox {
                    id: sessions; width: parent.width; model: sessionModel; textRole: "name"
                    objectName: "sessionSelector"
                    currentIndex: sessionModel.lastIndex >= 0 && sessionModel.lastIndex < count ? sessionModel.lastIndex : (count > 0 ? 0 : -1)
                    enabled: !root.pending && count > 0
                    Accessible.name: "Desktop environment"
                    font.pixelSize: 14
                    background: FieldBackground { focused: sessions.activeFocus }
                    contentItem: Text {
                        text: sessions.displayText || "No sessions available"; color: "white"
                        verticalAlignment: Text.AlignVCenter; leftPadding: 14; rightPadding: 28
                        elide: Text.ElideRight; font: sessions.font
                    }
                    KeyNavigation.tab: password
                    onActivated: password.forceActiveFocus()
                }
                TextField {
                    id: password; objectName: "passwordField"; width: parent.width; echoMode: TextInput.Password
                    leftPadding: 14; rightPadding: 14
                    placeholderText: "Password"; color: "white"; font.pixelSize: 15
                    enabled: !root.pending; selectByMouse: true
                    Accessible.name: "Password"
                    background: FieldBackground { focused: password.activeFocus; failed: root.loginFailed }
                    onAccepted: root.login(password.text.length === 0)
                    KeyNavigation.tab: submit
                }
                Button {
                    id: submit; width: parent.width; height: 46
                    text: root.pending ? "Signing in…" : "Sign in"
                    enabled: !root.pending && root.validSession && username.text.trim().length > 0
                    onClicked: root.login(password.text.length === 0)
                    background: Rectangle {
                        radius: 14; color: submit.down ? "#389878" : root.accent
                        opacity: submit.enabled ? 1 : 0.5
                        border.width: submit.activeFocus ? 2 : 0; border.color: "white"
                        Behavior on color { ColorAnimation { duration: 100 } }
                    }
                    contentItem: Text { text: submit.text; color: "#0f1419"; font.pixelSize: 15; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    KeyNavigation.tab: biometric
                }
                Button {
                    id: biometric; width: parent.width; text: "Use fingerprint"
                    visible: typeof config === "undefined" || config.Fingerprint !== "false"
                    enabled: !root.pending && root.validSession
                    onClicked: root.login(true)
                    background: FieldBackground { focused: biometric.activeFocus }
                    contentItem: Text { text: biometric.text; color: "#8ea89d"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; font.pixelSize: 13 }
                    KeyNavigation.tab: username
                }
                Text {
                    width: parent.width; text: root.message || (!root.validSession ? "No desktop sessions are installed." : "Your session choice is remembered after sign-in.")
                    wrapMode: Text.WordWrap; color: root.loginFailed ? "#e06c75" : "#8ea89d"
                    font.pixelSize: 12; Accessible.role: Accessible.StaticText
                    Behavior on color { ColorAnimation { duration: 140 } }
                }
            }
        }
    }
    Row {
        opacity: root.appeared ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: motion.duration } }
        anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 24
        spacing: 12
        QuietButton { text: "Restart"; enabled: !root.pending && sddm.canReboot; onClicked: { powerDialog.action = "restart"; powerDialog.open(); } }
        QuietButton { text: "Shut down"; enabled: !root.pending && sddm.canPowerOff; onClicked: { powerDialog.action = "shutdown"; powerDialog.open(); } }
    }
    Dialog {
        id: powerDialog
        property string action: ""
        anchors.centerIn: parent; modal: true; title: action === "restart" ? "Restart this computer?" : "Shut down this computer?"
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: { if (action === "restart") sddm.reboot(); else sddm.powerOff(); }
        palette.window: "#1a212a"
        palette.windowText: "white"
        background: Rectangle { radius: 18; color: "#1a212a"; border.color: "#2e3a47" }
    }
    component QuietButton: Button {
        id: quiet
        implicitHeight: 36; implicitWidth: label.implicitWidth + 32
        background: FieldBackground { focused: quiet.activeFocus; color: quiet.down ? "#22382e" : "#1a212a" }
        contentItem: Text { id: label; text: quiet.text; color: "#8ea89d"; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
    }
    component FieldBackground: Rectangle {
        property bool focused: false
        property bool failed: false
        implicitHeight: 46
        radius: 14; color: "#121820"; border.width: focused ? 2 : 1
        border.color: failed ? "#e06c75" : focused ? root.accent : "#2e3a47"
        Behavior on border.color { ColorAnimation { duration: root.reducedMotion ? 40 : 120 } }
    }
}
