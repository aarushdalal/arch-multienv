import QtQuick
import QtTest
import "../../sddm/themes/multienv-selector" as Theme

Item {
    width: 1280; height: 800
    property var userModel: mockUser
    property var sessionModel: mockSessions
    property var sddm: mockSddm
    property var config: ({Fingerprint: "true", ReducedMotion: "true"})
    QtObject { id: mockUser; property string lastUser: "sample" }
    ListModel { id: mockSessions; property int lastIndex: 0 }
    QtObject {
        id: mockSddm
        property bool canReboot: true
        property bool canPowerOff: true
        property int calls: 0
        property int chosen: -1
        property string submittedPassword: ""
        signal loginFailed()
        signal loginSucceeded()
        signal informationMessage(string message)
        function login(user, password, index) { calls++; chosen = index; submittedPassword = password; }
        function reboot() { throw new Error("Power action during test"); }
        function powerOff() { throw new Error("Power action during test"); }
    }
    Theme.Main { id: greeter; anchors.fill: parent }
    TestCase {
        name: "MultiEnvKeyboard"
        when: windowShown
        function init() {
            mockSessions.clear(); mockSessions.append({name: "Environment A"}); mockSessions.append({name: "Environment B"});
            greeter.currentUser = "sample"; mockSddm.loginFailed();
            mockSddm.calls = 0; mockSddm.submittedPassword = "";
            var selector = findChild(greeter, "sessionSelector"); selector.currentIndex = 0;
            wait(30); findChild(greeter, "passwordField").forceActiveFocus();
        }
        function test_tab_cycles_and_keeps_password_focus() {
            var password = findChild(greeter, "passwordField");
            keyClick(Qt.Key_Tab); compare(findChild(greeter, "sessionSelector").currentIndex, 1); verify(password.activeFocus);
            keyClick(Qt.Key_Tab); compare(findChild(greeter, "sessionSelector").currentIndex, 0);
            keyClick(Qt.Key_Backtab); compare(findChild(greeter, "sessionSelector").currentIndex, 1);
        }
        function test_empty_enter_starts_biometric_once() {
            keyClick(Qt.Key_Tab); keyClick(Qt.Key_Return);
            compare(mockSddm.calls, 1); compare(mockSddm.submittedPassword, ""); compare(mockSddm.chosen, 1);
            keyClick(Qt.Key_Return); keyClick(Qt.Key_Tab);
            compare(mockSddm.calls, 1); compare(findChild(greeter, "sessionSelector").currentIndex, 1);
            mockSddm.loginFailed(); keyClick(Qt.Key_Return); compare(mockSddm.calls, 2);
        }
        function test_typed_password_and_failure_clear() {
            keyClick(Qt.Key_A); keyClick(Qt.Key_B); keyClick(Qt.Key_C); keyClick(Qt.Key_Return);
            compare(mockSddm.calls, 1); compare(mockSddm.submittedPassword, "abc");
            compare(findChild(greeter, "passwordField").text, "");
            mockSddm.loginFailed(); verify(!greeter.pending); verify(findChild(greeter, "passwordField").activeFocus);
        }
        function test_escape_and_environment_preserve_input() {
            keyClick(Qt.Key_A); keyClick(Qt.Key_Tab); compare(findChild(greeter, "passwordField").text, "a");
            keyClick(Qt.Key_Escape); compare(findChild(greeter, "passwordField").text, "");
        }
        function test_zero_one_and_five_sessions() {
            mockSessions.clear(); wait(20); greeter.login(true); compare(mockSddm.calls, 0);
            mockSessions.append({name: "Only session"}); wait(20); keyClick(Qt.Key_Tab);
            compare(findChild(greeter, "sessionSelector").currentIndex, 0);
            for (var i = 1; i < 5; i++) mockSessions.append({name: "Environment " + i});
            wait(20); keyClick(Qt.Key_Backtab); compare(findChild(greeter, "sessionSelector").currentIndex, 4);
            keyClick(Qt.Key_Return); compare(mockSddm.chosen, 4);
        }
        function test_password_keyboard_does_not_trigger_power() {
            keyClick(Qt.Key_Right); keyClick(Qt.Key_Left); keyClick(Qt.Key_Down); keyClick(Qt.Key_Up);
            compare(mockSddm.calls, 0);
        }
        function test_ctrl_tab_reaches_action_controls() {
            keyClick(Qt.Key_Tab, Qt.ControlModifier);
            verify(findChild(greeter, "unlockButton").activeFocus);
            compare(mockSddm.calls, 0);
        }
    }
}
