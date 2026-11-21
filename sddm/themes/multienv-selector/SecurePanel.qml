import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root

    // Palette Tokens matching Lock Screen & Dark Theme
    readonly property color canvasColor: "#08090d"
    readonly property color mainColor: "#f1f5f9"
    readonly property color secondaryColor: "#94a3b8"
    readonly property color mutedColor: "#64748b"

    readonly property color accent: "#38bdf8"
    readonly property color accentHover: "#60a5fa"
    readonly property color pressedAccent: "#0284c7"
    readonly property color actionInk: "#060b13"

    readonly property color fieldBg: Qt.rgba(0.04, 0.06, 0.10, 0.78)
    readonly property color fieldBorder: Qt.rgba(1, 1, 1, 0.12)
    readonly property color fieldBorderActive: accent

    readonly property color sessionActiveBg: Qt.rgba(0.09, 0.15, 0.24, 0.88)
    readonly property color sessionInactiveBg: Qt.rgba(0.04, 0.06, 0.10, 0.65)

    readonly property color buttonBg: Qt.rgba(0.07, 0.09, 0.14, 0.75)
    readonly property color buttonHoverBg: Qt.rgba(0.12, 0.16, 0.24, 0.85)
    readonly property color buttonBorder: Qt.rgba(1, 1, 1, 0.10)

    readonly property color errorColor: "#f87171"
    readonly property color errorBg: Qt.rgba(0.25, 0.08, 0.10, 0.85)
    readonly property color errorBorder: Qt.rgba(0.97, 0.44, 0.44, 0.4)

    property string userName: ""
    property bool editUser: false
    property string passwordText: ""
    property bool busy: false
    property bool fingerprintBusy: false
    property bool fingerprintAvailable: true
    property bool failed: false
    property string message: ""
    property string brand: "MULTIENV"
    property string heading: "Welcome back"
    property string actionText: "Sign in"
    property string backgroundPath: "/var/cache/multienv/background.png"
    property var sessionNames: []
    property int sessionIndex: -1
    property bool reducedMotion: false
    property bool centeredLayout: true
    property bool mediaWidgetVisible: false
    property bool allowSleep: false
    property bool allowRestart: true
    property bool allowShutdown: true
    property string timeFormat: "HH:mm"
    property string dateFormat: "dddd, MMMM d"
    property date now: new Date()
    property bool appeared: false
    readonly property bool compact: width < 960
    readonly property bool hasSessions: sessionNames.length > 0

    signal passwordEdited(string value)
    signal userEdited(string value)
    signal submitted(string value)
    signal fingerprintRequested()
    signal sessionSelected(int index)
    signal powerRequested(string action)
    signal activity()

    function focusPassword() { password.forceActiveFocus(); }

    function cycleSession(delta) {
        if (busy || !hasSessions) return;
        sessionSelected((sessionIndex + delta + sessionNames.length) % sessionNames.length);
        focusPassword();
    }

    function submit() {
        if (busy) return;
        if (password.text.length > 0) submitted(password.text);
        else if (fingerprintAvailable) fingerprintRequested();
    }

    Component.onCompleted: { appeared = true; Qt.callLater(focusPassword); }
    onPasswordTextChanged: { if (password.text !== passwordText) password.text = passwordText; }
    Timer { interval: 1000; repeat: true; running: root.visible; onTriggered: root.now = new Date() }

    // --- Fallback Pure Dark Background ---
    Rectangle {
        anchors.fill: parent
        color: root.canvasColor
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#0d1018" }
            GradientStop { position: 0.5; color: "#08090d" }
            GradientStop { position: 1.0; color: "#050608" }
        }
    }

    // --- Active Wallpaper Image with Soft Blur (Matching Lock Screen) ---
    Image {
        id: bgImage
        anchors.fill: parent
        source: root.backgroundPath
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: Math.min(1920, Math.max(1, root.width))
        asynchronous: true
        cache: false
    }

    MultiEffect {
        anchors.fill: parent
        source: bgImage
        autoPaddingEnabled: false
        blurEnabled: bgImage.status === Image.Ready
        blur: 1
        blurMax: 14
        blurMultiplier: 1
        opacity: bgImage.status === Image.Ready ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 250 } }
    }

    // Dark Scrim Overlay for perfect legibility
    Rectangle {
        anchors.fill: parent
        color: "#34000000"
    }

    // Top Navigation / Header (Minimal Brand)
    Row {
        x: Math.max(32, root.width * 0.05)
        y: 28
        spacing: 10

        Rectangle {
            width: 7; height: 7; radius: 3.5
            color: root.accent
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.brand
            color: root.mainColor
            font.family: "Noto Sans"
            font.pixelSize: 11
            font.letterSpacing: 2.5
            font.weight: Font.Bold
        }

        Rectangle {
            width: 1; height: 10
            color: Qt.rgba(1, 1, 1, 0.2)
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "STATION"
            color: root.mutedColor
            font.family: "Noto Sans"
            font.pixelSize: 10
            font.letterSpacing: 2
        }
    }

    // Top Right Host Status Pill
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: Math.max(32, root.width * 0.05)
        anchors.top: parent.top
        anchors.topMargin: 24
        height: 26
        width: hostLabel.implicitWidth + 20
        radius: 13
        color: Qt.rgba(0.05, 0.07, 0.11, 0.75)
        border.color: Qt.rgba(1, 1, 1, 0.10)

        Row {
            anchors.centerIn: parent
            spacing: 6
            Rectangle {
                width: 6; height: 6; radius: 3
                color: "#10b981"
            }
            Text {
                id: hostLabel
                text: "ARCH LINUX • HYPRLAND"
                color: root.secondaryColor
                font.family: "Noto Sans"
                font.pixelSize: 10
                font.letterSpacing: 1.2
                font.weight: Font.Medium
            }
        }
    }

    // Monolith Mask Item for the Secondary Focused Blur Layer
    Item {
        id: cardMaskItem
        width: card.width; height: card.height
        visible: false
        layer.enabled: true
        Rectangle {
            anchors.fill: parent
            radius: 26
            color: "#ffffff"
        }
    }

    // --- Minimal Centered Deck (Identical to Lock Screen Architecture) ---
    Item {
        id: card
        objectName: "floatingCard"
        width: Math.min(380, root.width - 48)
        height: contentCol.implicitHeight + 48
        anchors.centerIn: parent

        opacity: root.appeared ? 1 : 0
        transform: Translate { y: root.reducedMotion ? 0 : (1 - (root.appeared ? 1 : 0)) * 6 }
        Behavior on opacity { NumberAnimation { duration: root.reducedMotion ? 1 : 180; easing.type: Easing.OutCubic } }

        // Ambient Drop Shadow
        Rectangle {
            anchors.fill: parent
            radius: 26
            color: "#000000"
            opacity: 0.35
            scale: 0.98
        }

        // Frosted Glass Core with Layer 2 Nested Blur
        Item {
            id: frostedGlassCore
            anchors.fill: parent
            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: cardMaskItem
            }

            Image {
                id: innerBg
                x: -card.x
                y: -card.y
                width: root.width
                height: root.height
                source: bgImage.source
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                visible: bgImage.status === Image.Ready
            }

            MultiEffect {
                anchors.fill: innerBg
                source: innerBg
                blurEnabled: bgImage.status === Image.Ready
                blur: 1.0
                blurMax: 56
                blurMultiplier: 2.2
                brightness: 0.14
                contrast: 0.15
                saturation: 0.15
            }

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.16) }
                    GradientStop { position: 0.2; color: Qt.rgba(1, 1, 1, 0.06) }
                    GradientStop { position: 0.8; color: Qt.rgba(0, 0, 0, 0.06) }
                    GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.22) }
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 26
                color: "transparent"
                border.color: Qt.rgba(1, 1, 1, 0.36)
                border.width: 1.5
            }
        }

        Column {
            id: contentCol
            width: parent.width - 48
            anchors.centerIn: parent
            spacing: 18

            // Digital Clock & Date
            Column {
                width: parent.width
                spacing: 6

                Text {
                    width: parent.width
                    text: Qt.formatDateTime(root.now, root.timeFormat)
                    color: root.mainColor
                    font.family: "Noto Sans Light"
                    font.letterSpacing: -2.5
                    font.pixelSize: Math.min(84, root.height * 0.13)
                    horizontalAlignment: Text.AlignHCenter
                    style: Text.Outline
                    styleColor: Qt.rgba(0, 0, 0, 0.5)
                }

                Text {
                    width: parent.width
                    text: Qt.formatDateTime(root.now, root.dateFormat)
                    color: root.secondaryColor
                    font.family: "Noto Sans"
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter
                    style: Text.Outline
                    styleColor: Qt.rgba(0, 0, 0, 0.35)
                }

                Text {
                    visible: !root.editUser && root.userName.length > 0
                    width: parent.width
                    text: "@" + root.userName
                    color: root.mutedColor
                    font.family: "Noto Sans"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // Optional Username Field (if editUser enabled)
            TextField {
                id: username
                objectName: "usernameField"
                visible: root.editUser
                width: parent.width
                height: 42
                text: root.userName || ""
                color: root.mainColor
                placeholderText: "Username"
                placeholderTextColor: root.mutedColor
                font.family: "Noto Sans"
                font.pixelSize: 13
                horizontalAlignment: TextInput.AlignHCenter
                readOnly: root.busy
                Accessible.name: "Username"
                background: Rectangle {
                    radius: 11
                    color: root.fieldBg
                    border.width: username.activeFocus ? 2 : 1
                    border.color: username.activeFocus ? root.accent : root.fieldBorder
                }
                onTextEdited: root.userEdited(text)
                onAccepted: root.focusPassword()
            }

            // Segmented Environment Switcher (Integrated Capsule)
            Rectangle {
                visible: root.hasSessions
                width: parent.width
                height: 42
                radius: 12
                color: root.sessionInactiveBg
                border.color: root.fieldBorder
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 3
                    spacing: 4

                    Repeater {
                        model: root.sessionNames
                        Button {
                            id: envBtn
                            required property int index
                            required property string modelData
                            text: modelData
                            width: (parent.width - (root.sessionNames.length - 1) * 4) / root.sessionNames.length
                            height: parent.height
                            enabled: !root.busy
                            activeFocusOnTab: false
                            Accessible.name: "Environment: " + text
                            Accessible.checkable: true
                            Accessible.checked: root.sessionIndex === index

                            onClicked: {
                                root.sessionSelected(index);
                                root.focusPassword();
                            }

                            background: Rectangle {
                                radius: 9
                                color: root.sessionIndex === envBtn.index ? root.sessionActiveBg : "transparent"
                                border.color: root.sessionIndex === envBtn.index ? root.accent : "transparent"
                                border.width: root.sessionIndex === envBtn.index ? 1 : 0
                                Behavior on color { ColorAnimation { duration: root.reducedMotion ? 1 : 120 } }
                            }

                            contentItem: Row {
                                anchors.centerIn: parent
                                spacing: 6
                                Rectangle {
                                    width: 6; height: 6; radius: 3
                                    color: root.accent
                                    visible: root.sessionIndex === envBtn.index
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: envBtn.text
                                    color: root.sessionIndex === envBtn.index ? root.mainColor : root.secondaryColor
                                    font.family: "Noto Sans"
                                    font.pixelSize: 12
                                    font.weight: root.sessionIndex === envBtn.index ? Font.DemiBold : Font.Normal
                                    anchors.verticalCenter: parent.verticalCenter
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }

            // Password Input Field (Centered with Discrete Styling)
            TextField {
                id: password
                objectName: "passwordField"
                width: parent.width
                height: 52
                text: root.passwordText
                echoMode: TextInput.Password
                passwordCharacter: "●"
                readOnly: root.busy
                selectByMouse: true
                maximumLength: 1024
                color: root.mainColor
                font.family: "Noto Sans"
                font.pixelSize: 16
                leftPadding: 16
                rightPadding: 16
                horizontalAlignment: TextInput.AlignHCenter
                Accessible.name: "Password. Enter with an empty field to use fingerprint."

                background: Rectangle {
                    radius: 13
                    color: root.fieldBg
                    border.width: password.activeFocus ? 2 : 1
                    border.color: root.failed ? root.errorColor : password.activeFocus ? root.fieldBorderActive : root.fieldBorder
                    Behavior on border.color { ColorAnimation { duration: root.reducedMotion ? 1 : 120 } }
                }

                Text {
                    anchors.fill: parent
                    visible: password.length === 0
                    text: root.busy ? "Authenticating…" : "Password"
                    color: root.mutedColor
                    font: password.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onTextChanged: {
                    if (text !== root.passwordText) {
                        root.passwordEdited(text);
                        root.activity();
                    }
                }
                onAccepted: root.submit()

                Keys.onPressed: function(event) {
                    root.activity();
                    if (root.hasSessions && event.key === Qt.Key_Tab && (event.modifiers & Qt.ControlModifier)) {
                        unlock.forceActiveFocus();
                        event.accepted = true;
                    } else if (root.hasSessions && (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab)) {
                        root.cycleSession(event.key === Qt.Key_Backtab || (event.modifiers & Qt.ShiftModifier) ? -1 : 1);
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Escape && !root.busy) {
                        root.passwordEdited("");
                        event.accepted = true;
                    }
                }
            }

            // Primary Sign In Button (Minimalist Pill)
            Button {
                id: unlock
                objectName: "unlockButton"
                width: parent.width
                height: 46
                enabled: !root.busy
                text: root.busy ? "Authenticating…" : root.actionText

                onClicked: root.submit()

                background: Rectangle {
                    radius: 12
                    color: unlock.down ? Qt.rgba(1, 1, 1, 0.16) : unlock.hovered ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(1, 1, 1, 0.08)
                    opacity: unlock.enabled ? 1 : 0.6
                    border.color: unlock.activeFocus ? "#ffffff" : Qt.rgba(1, 1, 1, 0.28)
                    border.width: unlock.activeFocus ? 2 : 1
                    Behavior on color { ColorAnimation { duration: 100 } }

                    Rectangle {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 20
                        height: 1
                        color: Qt.rgba(1, 1, 1, 0.35)
                    }
                }

                contentItem: Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Text {
                        text: unlock.text
                        color: "#ffffff"
                        font.family: "Noto Sans"
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: "→"
                        color: Qt.rgba(1, 1, 1, 0.85)
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // Biometric / Fingerprint Action
            Button {
                id: fingerprint
                width: parent.width
                height: 28
                visible: root.fingerprintAvailable
                text: root.fingerprintBusy ? "Touch reader now…" : "Use Fingerprint"
                enabled: !root.busy
                onClicked: root.fingerprintRequested()

                background: Rectangle {
                    radius: 8
                    color: fingerprint.activeFocus || fingerprint.hovered ? root.buttonHoverBg : "transparent"
                    border.color: fingerprint.activeFocus ? root.accent : "transparent"
                }

                contentItem: Text {
                    text: fingerprint.text
                    color: fingerprint.hovered ? root.mainColor : root.secondaryColor
                    font.family: "Noto Sans"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // Status Message Pill (Centrally Displayed)
            Rectangle {
                width: parent.width
                height: statusMsg.implicitHeight + 10
                radius: 8
                visible: (root.message.length > 0) || root.failed
                color: root.failed ? root.errorBg : Qt.rgba(0.06, 0.08, 0.12, 0.8)
                border.color: root.failed ? root.errorBorder : root.buttonBorder

                Text {
                    id: statusMsg
                    anchors.centerIn: parent
                    width: parent.width - 20
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    text: root.message || (root.failed ? "Authentication failed. Try your password again." : "")
                    color: root.failed ? root.errorColor : root.secondaryColor
                    font.family: "Noto Sans"
                    font.pixelSize: 11
                }
            }
        }
    }

    // --- Bottom Power Controls (Discreet Minimal Pills) ---
    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 26
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12

        Repeater {
            model: ["Restart", "Shut down"]
            Button {
                id: powerBtn
                required property string modelData
                text: modelData
                height: 32
                width: 96
                enabled: !root.busy
                onClicked: root.powerRequested(text)

                background: Rectangle {
                    radius: 9
                    color: powerBtn.activeFocus || powerBtn.hovered ? root.buttonHoverBg : root.buttonBg
                    border.color: powerBtn.activeFocus ? root.accent : root.buttonBorder
                    Behavior on color { ColorAnimation { duration: 100 } }
                }

                contentItem: Text {
                    text: powerBtn.text
                    color: powerBtn.hovered ? root.mainColor : root.secondaryColor
                    font.family: "Noto Sans"
                    font.pixelSize: 11
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    // Bottom Left Keyboard Hints
    Text {
        visible: !root.compact
        x: Math.max(32, root.width * 0.05)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        text: root.hasSessions ? "TAB: Switch Desktop   CTRL+TAB: Controls   ENTER: Sign In   ESC: Clear" : "ENTER: Sign In   ESC: Clear"
        color: root.mutedColor
        font.family: "Noto Sans"
        font.pixelSize: 10
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.5)
    }

    // Modal Confirmation Dialog for Power Actions
    Dialog {
        id: powerDialog
        anchors.centerIn: parent
        modal: true
        property string action: ""
        title: action + " workstation?"
        standardButtons: Dialog.Ok | Dialog.Cancel

        palette.windowText: root.mainColor
        palette.text: root.mainColor
        palette.buttonText: root.mainColor
        palette.button: root.buttonBg

        background: Rectangle {
            color: "#121622"
            radius: 14
            border.color: Qt.rgba(1, 1, 1, 0.15)
            border.width: 1
        }

        onAccepted: root.powerRequested("confirmed:" + action)
    }

    function confirmPower(action) {
        powerDialog.action = action;
        powerDialog.open();
    }
}
