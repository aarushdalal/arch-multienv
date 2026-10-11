# Troubleshooting & Diagnostics

## 1. Diagnostic Matrix

### Black screen upon switching / login
- **Symptom**: After selecting a session or switching, the screen goes black and never loads.
- **Cause**: Syntax error in `hyprland.conf`, or target config file path does not exist.
- **Fix**:
  1. Switch to a virtual console: `Ctrl + Alt + F3`.
  2. Log in and run `multienv fallback`.
  3. Validate the broken environment: `multienv validate <env_id>`.
  4. Fix any reported syntax errors or missing paths.

### Session loops back to SDDM login screen
- **Symptom**: SDDM accepts password, attempts to launch, but immediately returns to login.
- **Cause**: Session wrapper exited with non-zero status, or target `.desktop` entry points to a missing binary.
- **Fix**:
  1. Check SDDM system journal:
     ```bash
     journalctl -u sddm -b -e
     ```
  2. Verify that `multienv-session` is installed in PATH (`/usr/local/bin/multienv-session` or `/usr/bin/multienv-session`).
  3. Preserve the failed launch status and fix the reported compositor, configuration or session-entry error; do not hide failures with an EXIT trap.

### Freeze on logout / DRM seat retention
- **Symptom**: Selecting logout causes the screen to freeze with the mouse cursor visible; SDDM never reappears.
- **Cause**: Background process (e.g. video wallpaper, audio daemon, polkit authentication agent) holding open Wayland display or DRM seat locks.
- **Fix**:
  1. From a TTY, inspect the selected session and its UWSM unit. Terminating a session is a deliberate recovery action that can discard unsaved work.
  2. Inspect session ownership and configured teardown hooks. The logout helper pauses for unsaved windows; it does not kill broadly matched background processes.
  3. Verify that `multienv-logout` was invoked rather than raw `hyprctl dispatch exit`.

### Blurred or incorrectly sized windows
- **Symptom**: Fonts and windows appear tiny or fuzzy after switching between environments with different scales.
- **Cause**: Mismatched toolkit variables (`GDK_SCALE`, `QT_SCALE_FACTOR`, `ELM_SCALE`).
- **Fix**:
  Define toolkit scaling explicitly inside each environment's `env.conf` or `autostart.sh` rather than globally in `~/.bashrc` or `~/.profile`.

---

## 2. Display Manager & SDDM Issues

### SDDM greeter missing session selector or overwritten by package updates
- **Symptom**: SDDM displays a generic login screen with only a password field and no session pills or chooser. Environment switching is impossible from the GUI.
- **Cause**: Distribution updates (e.g., `pacman -Syu` upgrading desktop themes or SDDM packages) overwrite custom themes in `/usr/share/sddm/themes/` or reset `/etc/sddm.conf.d/10-theme.conf` to a minimal vendor theme.
- **Fix**:
  1. Reinstall or restore the multi-environment selector theme:
     ```bash
     multienv-install --theme-only
     ```
  2. Verify that `/etc/sddm.conf.d/10-theme.conf` specifies the multi-environment theme:
     ```ini
     [Theme]
     Current=multienv-selector
     ```
  3. Test the greeter in a virtual testbed without logging out:
     ```bash
     sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/multienv-selector
     ```

### Autologin bypass loop (unable to reach SDDM greeter)
- **Symptom**: Rebooting or logging out immediately re-launches the last used desktop session without presenting the SDDM login screen or session choices.
- **Cause**: An autologin configuration drop-in exists in `/etc/sddm.conf.d/` (such as `autologin.conf`) directing SDDM to bypass authentication and launch a session directly.
- **Fix**:
  1. Disable autologin and restore the manual greeter:
     ```bash
     multienv disable-autologin
     ```
  2. Or disable autologin and immediately exit to the greeter:
     ```bash
     multienv greeter --now
     ```
  3. Verify `/etc/sddm.conf.d/autologin.conf` has been removed.

---

## 3. Desktop Shell & QML UI Diagnostics

### Desktop clock punctuation (colon) vertical misalignment
- **Symptom**: On lock screens or status bars, the colon `:` separator between hours and minutes sits noticeably too high, floating above numeral digits.
- **Cause**: Font metrics treat punctuation glyphs differently than numerals; punctuation bounds are anchored relative to the font baseline and x-height, whereas numbers use cap-height. Simple baseline offsets shift the colon to the top edge of the numeral bounding box rather than true mathematical center.
- **Fix**:
  In QtQuick/Quickshell TextMetrics layouts, offset the colon relative to the cap-height digit box:
  ```qml
  // 1. Pull the colon glyph up to y = 0 relative to cap-height digits:
  // 2. Add half of the difference between digit height and colon height:
  y: -root.calcTopOff(colonMetrics) + (hourMetrics.tightBoundingRect.height - colonMetrics.tightBoundingRect.height) / 2
  ```

### Wayland layer-shell notification stutter and layout jumping
- **Symptom**: Notifications jitter, jump abruptly, or flicker when sliding onto or off the screen.
- **Cause**: Wayland layer shells recalculate surface constraints dynamically. Animating `scale` or applying a `Behavior on implicitHeight` causes rapid geometry re-evaluations between the compositor's layer-shell manager and the UI layout engine.
- **Fix**:
  1. **Do not animate `scale`** on layer-shell items.
  2. **Do not use `Behavior on implicitHeight`** on notification item roots.
  3. Animate strictly `opacity` and X/Y translation:
     ```qml
     transform: Translate {
         x: root.shown ? 0 : 40
         Behavior on x {
             NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
         }
     }
     Behavior on opacity {
         NumberAnimation { duration: 200 }
     }
     ```

### Modern Quickshell / Qt 6.8+ C++ MapNode iteration errors
- **Symptom**: Shell fails to load with error: `TypeError: Result of expression 'map' [MapNode(...)] is not iterable` or `Object.values(...)` returns incomplete data.
- **Cause**: Modern Quickshell exposes nested C++ maps as `MapNode` wrapper objects rather than native JavaScript objects. Standard JavaScript `for...of` syntax cannot iterate `MapNode` directly without accessing its QList export.
- **Fix**:
  1. Use the `.values` property:
     ```javascript
     for (const item of mapNode.values) {
         // Process item
     }
     ```
  2. Or iterate via `Object.keys()`:
     ```javascript
     for (const key of Object.keys(mapNode)) {
         const val = mapNode[key];
     }
     ```

---

## 4. Biometrics & Fingerprint Authentication (`fprintd`)

### Fingerprint sensor reports transfer errors or disconnects during verify
- **Symptom**: Lock screen or greeter shows `FP ERROR` or log reports `USB error on device 06cb:00f0: No such device (it may have been disconnected) [-4]` or `transfer timed out`.
- **Cause**: Linux kernel USB runtime autosuspend places the fingerprint reader in a low-power suspended state when idle.
- **Fix**:
  Ensure `/etc/udev/rules.d/99-fingerprint-autosuspend.rules` disables USB autosuspend:
  ```udev
  ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="06cb", ATTR{idProduct}=="00f0", TEST=="power/control", ATTR{power/control}="on"
  ```
  Reload rules with `sudo udevadm control --reload-rules && sudo udevadm trigger --subsystem-match=usb`.

### Greeter or lock screen spams "Device was already claimed"
- **Symptom**: `journalctl -u fprintd` shows rapid rejections: `Authorization denied ... Device was already claimed`.
- **Cause**: An authentication client (e.g. Quickshell `PamContext`) retried too quickly after an error before `fprintd` finished asynchronous D-Bus cleanup of the previous device proxy.
- **Fix**:
  Enforce a minimum backoff of 2500ms on PAM error retries in `Pam.qml` and cap rapid re-tries to 3 attempts.

### How to use fingerprint login on the multi-env SDDM logout screen
- **Password Login**: Type your password and hit **Enter** for immediate authentication.
- **Fingerprint Login**: Press **Enter** on an empty password field or click the **󰈷 Scan Fingerprint to Log In** badge. The greeter will display `Place finger on reader...`. Touch the fingerprint scanner with your enrolled finger to log into the selected environment.


### Theme falls back to the embedded default

A `Library import requires a version` error with this Qt 6 theme means the Qt 5 greeter was selected. Ensure `metadata.desktop` contains `QtVersion=6` under `[SddmGreeterTheme]`, and that `sddm-greeter-qt6` is installed. Use its `--test-mode --theme` preview before deploying. The theme declaration is read when the next greeter is created; restarting SDDM terminates active sessions.
