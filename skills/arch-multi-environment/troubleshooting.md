# Diagnostic & Troubleshooting Guide

## Matrix of Common Issues and Solutions

| Symptom | Probable Cause | Diagnostic Command | Remediation |
|---|---|---|---|
| **Black screen upon login** | Invalid compositor config path or syntax error in `hyprland.conf` | `multienv validate <target>` | Switch to TTY3 (`Ctrl+Alt+F3`), run `multienv fallback`, fix syntax. |
| **Session loops back to SDDM immediately** | Missing signal trap in session script; SDDM-helper received exit code != 0 | Check `journalctl -u sddm -b -e` | Ensure `trap 'exit 0' TERM HUP INT EXIT` is in the session wrapper. |
| **Screen freezes on logout** | Video wallpaper (e.g. mpvpaper) or layer shell holding Wayland seat open | Check `pgrep -a mpvpaper` from TTY | Use `multienv-logout` which terminates background daemons prior to compositor exit. |
| **Display scaling appears blurry or wrong size** | Mismatched fractional scale or missing toolkit variables | Check `hyprctl monitors` | Adjust `monitor=,preferred,auto,<scale>` in `hyprland.conf` and configure toolkit scale. |
| **Application menu missing or panel invisible** | Environment desktop shell crashed or failed to autostart | Check autostart log in `~/.local/state/` | Run the environment's shell command in a terminal to inspect stderr. |
| **SDDM does not list environment** | Session `.desktop` file missing from `/usr/share/wayland-sessions/` | `ls -la /usr/share/wayland-sessions/` | Run `multienv generate-sessions`. |
| **SDDM greeter has no session selector** | Theme overwritten by distro updates or missing selector component | `cat /etc/sddm.conf.d/10-theme.conf` | Run `multienv-install --theme-only` and set `Current=multienv-selector`. |
| **Autologin bypasses greeter completely** | Leftover autologin drop-in file in `/etc/sddm.conf.d/` | `ls -la /etc/sddm.conf.d/*autologin*` | Run `multienv disable-autologin` or `multienv greeter --now`. |
| **Lock screen clock colon misaligned** | Punctuation glyph bounding box anchored at x-height baseline vs cap-height | Inspect QML TextMetrics calculation | Offset colon: `y: -calcTopOff(colon) + (hourHeight - colonHeight) / 2`. |
| **Notification popups jitter or jump** | Wayland layer shell constraint fighting with `scale` or `implicitHeight` | Inspect notification QML root animations | Remove `scale` animations and `Behavior on implicitHeight`; animate X/Y translation and opacity only. |
| **Quickshell MapNode TypeError** | Modern Quickshell / Qt 6.8+ exposes C++ MapNode instead of plain JS Object | Check terminal stderr for `not iterable` | Iterate with `.values` property: `for (const x of map.values)`. |
