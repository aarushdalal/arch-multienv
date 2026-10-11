import QtQuick
import QtQuick.Window
import "../../sddm/themes/multienv-selector" as Theme
Window {
  id: window; width: 1280; height: 800; visible: true
  property var userModel: mockUser
  property var sessionModel: mockSessions
  property var sddm: mockSddm
  property var config: ({Fingerprint: "true", ReducedMotion: "false"})
  QtObject { id: mockUser; property string lastUser: "sample" }
  ListModel {
    id: mockSessions; property int lastIndex: 1
    ListElement { name: "Environment A" }
    ListElement { name: "Environment B" }
    ListElement { name: "Laboratory" }
  }
  QtObject {
    id: mockSddm
    property bool canReboot: true; property bool canPowerOff: true
    signal loginFailed(); signal loginSucceeded(); signal informationMessage(string message)
    function login(user, password, index) { console.log("MOCK_LOGIN", index); loginFailed(); }
    function reboot() { console.log("MOCK_REBOOT"); }
    function powerOff() { console.log("MOCK_POWER_OFF"); }
  }
  Theme.Main { id: greeter; anchors.fill: parent }
  Timer {
    interval: 800; running: true
    onTriggered: {
      greeter.grabToImage(function(result) { result.saveToFile(Qt.resolvedUrl("../../assets/showcase/greeter-preview.png").toString().replace("file://", "")); console.log("PREVIEW_OK"); Qt.quit(); });
    }
  }
}
