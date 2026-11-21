import QtQuick
import QtTest
import "../../sddm/themes/multienv-selector" as Theme

Item {
    width: 1280; height: 800
    property var userModel: mockUser
    property var sessionModel: mockSessions
    property var sddm: mockSddm
    property var config: ({Fingerprint: "true", ReducedMotion: "true", SessionAliases: "Hyprland=Environment B;Environment A=Environment A;Daemon OS=Environment A"})
    QtObject { id: mockUser; property string lastUser: "sample" }
    ListModel { id: mockSessions; property int lastIndex: 0 }
    QtObject {
        id: mockSddm
        property bool canReboot: false
        property bool canPowerOff: false
        property int chosen: -1
        signal loginFailed()
        signal loginSucceeded()
        signal informationMessage(string message)
        function login(user, password, index) { chosen = index; }
    }
    property var greeter: null
    Component { id: greeterComponent; Theme.Main {} }
    TestCase {
        name: "MultiEnvSessionChoices"
        when: windowShown
        function init() {
            mockSessions.clear(); mockSessions.lastIndex = 0;
            mockSessions.append({name: "Environment A"});
            mockSessions.append({name: "Environment A"});
            mockSessions.append({name: "Environment B"});
            mockSessions.append({name: "Hyprland"});
            greeter = greeterComponent.createObject(parent, {width: 1280, height: 800});
            mockSddm.loginFailed(); mockSddm.chosen = -1;
            wait(30);
        }
        function cleanup() { greeter.destroy(); greeter = null; wait(10); }
        function test_duplicates_become_two() {
            var selector = findChild(greeter, "sessionSelector");
            compare(selector.count, 2);
            compare(selector.textAt(0), "Environment A"); compare(selector.textAt(1), "Environment B");
            selector.currentIndex = 1; greeter.login(true); compare(mockSddm.chosen, 2);
        }
        function test_third_environment_uses_original_sddm_index() {
            mockSessions.append({name: "Environment C"}); wait(30);
            var selector = findChild(greeter, "sessionSelector"); compare(selector.count, 3);
            selector.currentIndex = 2; greeter.login(true); compare(mockSddm.chosen, 4);
        }
        function test_last_alias_restores_canonical_selection() {
            mockSessions.lastIndex = 3; wait(30);
            var selector = findChild(greeter, "sessionSelector"); compare(selector.currentIndex, 1);
            greeter.login(true); compare(mockSddm.chosen, 2);
        }
        function test_explicit_omarchy_preferred_after_alias() {
            mockSessions.clear(); mockSessions.append({name: "Hyprland"}); mockSessions.append({name: "Environment B"}); wait(30);
            compare(findChild(greeter, "sessionSelector").count, 1);
            greeter.login(true); compare(mockSddm.chosen, 1);
        }
        function test_reordered_model_and_unrelated_sessions() {
            mockSessions.append({name: "Environment C"}); mockSessions.move(4, 0, 1); wait(30);
            var selector = findChild(greeter, "sessionSelector");
            compare(selector.textAt(0), "Environment C"); selector.currentIndex = 0;
            greeter.login(true); compare(mockSddm.chosen, 0);
            mockSddm.loginFailed(); mockSessions.append({name: "Other"}); mockSessions.append({name: "Other"}); wait(30);
            compare(selector.count, 5);
        }
    }
}
