.pragma library

// Keep the display choices separate from SDDM's original login indexes.
function aliases(setting) {
    var result = {};
    for (var entry of setting.split(";")) {
        var split = entry.indexOf("=");
        if (split > 0) result[entry.slice(0, split).trim().toLowerCase()] = entry.slice(split + 1).trim();
    }
    return result;
}

function identity(name, mapping) {
    var value = name.trim().toLowerCase();
    if (mapping[value]) return mapping[value];
    for (var key in mapping)
        if (mapping[key].toLowerCase() === value) return mapping[key];
    return "";
}

function build(names, mapping) {
    var choices = [];
    var known = {};
    for (var i = 0; i < names.length; i++) {
        var label = identity(names[i], mapping);
        if (label && known[label] !== undefined) {
            // Prefer the explicitly named desktop over its compatibility launcher.
            if (names[i] === label) choices[known[label]].sourceIndex = i;
            continue;
        }
        if (label) known[label] = choices.length;
        choices.push({name: label || names[i], sourceIndex: i});
    }
    return choices;
}

function selected(choices, names, lastIndex, mapping) {
    if (lastIndex >= 0 && lastIndex < names.length) {
        var label = identity(names[lastIndex], mapping);
        for (var i = 0; i < choices.length; i++)
            if (choices[i].sourceIndex === lastIndex || (label && choices[i].name === label)) return i;
    }
    return choices.length ? 0 : -1;
}
