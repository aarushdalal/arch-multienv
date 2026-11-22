import QtQuick
import QtQuick.Controls
import "SessionChoices.js" as SessionChoices

Item {
    id: root
    width: 1280; height: 800
    property string currentUser: userModel.lastUser || ""
    property bool pending: false
    property bool loginFailed: false
    property bool biometricPending: false
    property string message: ""
    property int sessionRevision: 0
    readonly property var rawNames: {
        var revision = sessionRevision;
        var names = [];
        for (var i = 0; i < rawSessions.count; i++) names.push(rawSessions.textAt(i));
        return names;
    }
    readonly property var aliases: {
        var base = SessionChoices.aliases(typeof config !== "undefined" && config.SessionAliases ? config.SessionAliases : "");
        
        
        
        
        
        return base;
    }
    readonly property var choices: SessionChoices.build(rawNames, aliases)
    Connections {
        target: sessionModel
        ignoreUnknownSignals: true
        function onDataChanged() { root.sessionRevision++; }
        function onRowsMoved() { root.sessionRevision++; }
        function onModelReset() { root.sessionRevision++; }
        function onRowsInserted() { root.sessionRevision++; }
        function onCountChanged() { root.sessionRevision++; }
    }
    readonly property bool validSession: sessions.currentIndex >= 0 && sessions.currentIndex < sessions.count
    readonly property bool fingerprintEnabled: typeof config !== "undefined" && config.Fingerprint === "true"
    property bool reducedMotion: typeof config !== "undefined" && config.ReducedMotion === "true"
    function login(biometric) {
        if (pending || !validSession || !root.currentUser.trim()) return;
        if (biometric && !fingerprintEnabled) { message = "Fingerprint is unavailable. Enter your password."; return; }
        if (!biometric && panel.passwordText.length === 0) return;
        pending = true; loginFailed = false; biometricPending = biometric;
        message = biometric ? "Touch the reader. Wait for the scan to finish before retrying." : "Signing in…";
        // The selected index is frozen while authentication is pending.
        sddm.login(root.currentUser.trim(), biometric ? "" : panel.passwordText, root.choices[sessions.currentIndex].sourceIndex);
        panel.passwordText = "";
    }
    Connections {
        target: sddm
        function onLoginFailed() {
            root.pending = false; root.biometricPending = false; root.loginFailed = true;
            root.message = "Could not sign in. Try your password or press Enter to scan again.";
            panel.passwordText = ""; panel.focusPassword();
        }
        function onLoginSucceeded() { panel.passwordText = ""; root.message = "Welcome back"; }
        function onInformationMessage(message) { root.message = message; }
    }
    ComboBox {
        id: rawSessions; objectName: "rawSessionSelector"; visible: false
        model: sessionModel; textRole: "name"
    }
    ComboBox {
        id: sessions; objectName: "sessionSelector"; visible: false
        model: root.choices; textRole: "name"
        currentIndex: SessionChoices.selected(root.choices, root.rawNames, sessionModel.lastIndex, root.aliases)
    }
    SecurePanel {
        id: panel; anchors.fill: parent
        backgroundPath: "/var/cache/multienv/background.png"
        userName: root.currentUser; editUser: !root.currentUser || root.currentUser.length === 0
        brand: "MULTIENV"; actionText: "Sign in"
        busy: root.pending; fingerprintBusy: root.biometricPending
        failed: root.loginFailed; message: root.message
        fingerprintAvailable: root.fingerprintEnabled
        reducedMotion: root.reducedMotion
        allowSleep: false; allowRestart: sddm.canReboot; allowShutdown: sddm.canPowerOff
        sessionIndex: sessions.currentIndex
        sessionNames: { var names = []; for (var i = 0; i < root.choices.length; i++) names.push(root.choices[i].name); return names; }
        onUserEdited: function(value) { root.currentUser = value; }
        onSessionSelected: function(index) { if (!root.pending) sessions.currentIndex = index; }
        onPasswordEdited: function(value) { passwordText = value; root.loginFailed = false; root.message = ""; }
        onSubmitted: root.login(false)
        onFingerprintRequested: root.login(true)
        onPowerRequested: function(action) {
            if (root.pending) return;
            if (action === "confirmed:Restart" && sddm.canReboot) sddm.reboot();
            else if (action === "confirmed:Shut down" && sddm.canPowerOff) sddm.powerOff();
            else if (action.indexOf("confirmed:") !== 0) confirmPower(action);
        }
    }
}
