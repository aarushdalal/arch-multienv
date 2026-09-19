# Session Switching & Lifecycle Mechanics

## 1. The Switching Lifecycle

Switching between environments can occur via:
1. **Interactive Display Manager (SDDM)**: Selecting the environment pill on the login screen.
2. **Programmatic Switcher (`multienv switch`)**: Updating autologin state via CLI or keyboard shortcut.

```text
User executes: multienv switch <target> [--now]
       ↓
Pre-Flight Validation Check:
  - Target config exists and has valid syntax
  - Target session .desktop exists in /usr/share/wayland-sessions/
       ↓
Updates /etc/sddm.conf.d/autologin.conf:
  [Autologin]
  User=$USER
  Session=multienv-<target>.desktop
       ↓
Optional Teardown Trigger (multienv logout):
  1. Executes environment-specific teardown.sh
  2. Stops video wallpaper / layer shell daemons
  3. Dispatches watchdog timeout (3s)
  4. Gracefully signals client windows to close
  5. Stops UWSM envelope or issues hyprctl exit
       ↓
SDDM reads autologin.conf and boots directly into target environment!
```

---

## 2. The Critical Signal Trap

In `multienv-session`, the signal trap is essential:
```bash
trap 'exit 0' TERM HUP INT EXIT
```
**Why this is mandatory:**
When Hyprland exits or is terminated during logout, standard processes may emit a non-zero status code. When `sddm-helper` sees a non-zero exit code, it may mark the session as a failure and immediately try to restart or drop into a crash loop. Trapping signals ensures `sddm-helper` receives clean return code 0, returning gracefully to the greeter or executing autologin.
