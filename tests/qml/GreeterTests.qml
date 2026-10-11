import QtQuick
import QtQuick.Window
import "../../sddm/themes/multienv-selector" as Theme
Window {
 id: window; width: 1280; height: 800; visible: true
 property var userModel: mockUser
 property var sessionModel: mockSessions
 property var sddm: mockSddm
 property var config: ({Fingerprint:"true",ReducedMotion:"false"})
 QtObject { id: mockUser; property string lastUser:"sample" }
 ListModel { id: mockSessions; property int lastIndex: 99 }
 QtObject {
  id: mockSddm; property bool canReboot:true; property bool canPowerOff:true
  property int calls:0; property int chosen:-1
  signal loginFailed(); signal loginSucceeded(); signal informationMessage(string message)
  function login(user,password,index) { calls++; chosen=index; }
  function reboot() { throw new Error("Power action must remain inert"); }
  function powerOff() { throw new Error("Power action must remain inert"); }
 }
 Theme.Main { id: greeter; anchors.fill: parent }
 function child(item,name) { if(item.objectName===name)return item; for(var c of item.children||[]) { var found=child(c,name); if(found)return found; } return null; }
 function check(value,message) { if(!value) throw new Error(message); }
 property int stage:0
 Timer { interval:150; repeat:true; running:true; onTriggered: {
  try {
   var selector=window.child(greeter,"sessionSelector");
   if(window.stage===0) {
    var motion=Qt.createComponent("../../sddm/themes/multienv-selector/GreeterMotion.qml").createObject(window);
    window.check(Object.keys(motion.signatures).length===19,"greeter preset coverage");
    for(var preset of Object.keys(motion.signatures)) for(var intensity of ["subtle","balanced","expressive"]) for(var reduced of [false,true]) {
     motion.preset=preset;motion.intensity=intensity;motion.reduced=reduced;
     window.check(motion.duration>0&&motion.initialScale>=.96&&(!reduced||(motion.initialScale===1&&motion.xOffset===0&&motion.yOffset===0)),"greeter geometry");
    }
    motion.destroy(); window.check(!greeter.validSession,"zero sessions"); greeter.login(false); window.check(mockSddm.calls===0,"invalid login"); mockSessions.append({name:"Environment A"}); }
   if(window.stage===1) { window.check(selector.currentIndex===0,"one session fallback"); for(var i=0;i<4;i++)mockSessions.append({name:"Environment "+(i+2)}); }
   if(window.stage===2) { window.check(selector.count===5,"all five sessions"); selector.currentIndex=4; window.child(greeter,"passwordField").text="fixture"; greeter.login(false); greeter.login(false); window.check(mockSddm.calls===1&&mockSddm.chosen===4,"duplicate guard or index"); mockSddm.loginFailed(); window.check(!greeter.pending&&window.child(greeter,"passwordField").text==="","failed auth clears secret"); window.width=1024; window.height=768; }
   if(window.stage===3) { var card=window.child(greeter,"floatingCard"); window.check(card.width<=window.width&&card.height<=window.height,"small layout bounds"); mockSessions.move(4,0,1); selector.currentIndex=0; greeter.login(true); window.check(mockSddm.chosen===0,"reordered session"); mockSddm.loginFailed(); window.width=1920; window.height=1080; }
   if(window.stage===4) { console.log("GREETER_TEST_OK: zero/one/five/reordered sessions, invalid last index, auth failure, duplicate guard, responsive sizes"); Qt.quit(); }
   window.stage++;
  } catch(error) { console.error("GREETER_TEST_FAILED",error); Qt.quit(); }
 }}
}
