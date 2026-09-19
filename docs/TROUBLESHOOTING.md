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
  2. Verify that `multienv-session` is installed in PATH (`/usr/local/bin/multienv-session`).
  3. Ensure `trap 'exit 0' TERM HUP INT EXIT` is present in the session script.

### Freeze on logout
- **Symptom**: Selecting logout causes the screen to freeze with the mouse cursor visible; SDDM never reappears.
- **Cause**: Background process (e.g. video wallpaper, audio daemon, polkit) holding the Wayland display lock.
- **Fix**:
  1. From TTY: `loginctl terminate-user $USER`.
  2. Add the offending daemon to the termination list in `multienv-logout`.

### Blurred or incorrectly sized windows
- **Symptom**: Fonts and windows appear tiny or fuzzy after switching between environments with different scales.
- **Cause**: Mismatched toolkit variables (`GDK_SCALE`, `QT_SCALE_FACTOR`).
- **Fix**:
  Define toolkit scaling explicitly inside each environment's `env.conf` or `autostart.sh` rather than globally in `~/.bashrc`.
