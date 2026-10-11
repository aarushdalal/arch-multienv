import QtQuick
QtObject {
    property string preset: "default"
    property string intensity: "balanced"
    property bool reduced: false
    readonly property var signatures: ({
        "default": [220, Easing.OutCubic, 8, .98],
        "tokyo": [240, Easing.OutQuint, 0, 1],
        "cosmic": [300, Easing.OutBack, 12, .98],
        "ghost": [180, Easing.OutSine, 4, 1],
        "quantum": [120, Easing.OutExpo, 4, .99],
        "snap": [140, Easing.OutQuart, 6, .99],
        "snappy": [160, Easing.OutCubic, 6, .99],
        "unfold": [280, Easing.OutQuint, 10, .98],
        "liquid": [320, Easing.OutCubic, 12, .97],
        "bloom": [300, Easing.OutBack, 0, .96],
        "ignition": [240, Easing.OutExpo, 16, .98],
        "morph": [280, Easing.InOutCubic, 6, .98],
        "orbit": [300, Easing.OutSine, 10, .98],
        "parallax": [280, Easing.OutCubic, 8, .98],
        "cyberpunk": [180, Easing.OutExpo, 6, .99],
        "fluid": [320, Easing.OutSine, 12, .98],
        "comic": [260, Easing.OutBack, 10, .97],
        "jelly": [320, Easing.OutBack, 8, .97],
        "matrix": [240, Easing.OutQuart, 10, .99]
    })
    readonly property var signature: signatures[preset] || signatures.default
    readonly property real amplitude: reduced ? 0 : intensity === "subtle" ? .5 : intensity === "expressive" ? 1 : .8
    readonly property int duration: reduced ? 40 : Math.round(signature[0] * (intensity === "subtle" ? .85 : intensity === "expressive" ? 1.1 : 1))
    readonly property int curve: reduced ? Easing.Linear : signature[1]
    readonly property real yOffset: signature[2] * amplitude
    readonly property real xOffset: (preset === "tokyo" ? -14 : preset === "parallax" ? -6 : 0) * amplitude
    readonly property real initialScale: 1 - (1 - signature[3]) * amplitude
}
