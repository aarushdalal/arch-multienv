# Configuration Guide

All environment definitions and system switching policies are stored in:
`~/.config/multienv/multienv.toml` (or `/etc/multienv/multienv.toml`).

---

## 1. The Configuration Schema

```toml
[general]
# The fallback environment to load if no session is requested
default_environment = "environment-a"

# Location where the switcher writes SDDM autologin drop-ins
sddm_autologin_path = "/etc/sddm.conf.d/autologin.conf"

# Directory containing Wayland session desktop entries
wayland_sessions_dir = "/usr/share/wayland-sessions"

# User state and log directory
state_dir = "~/.local/state/multienv"

# Autologin user (defaults to current $USER if empty)
autologin_user = ""

# Whether to prompt before logging out upon switching
confirm_logout = true

# Session envelope manager ("uwsm" or "direct")
session_manager = "uwsm"

# ------------------------------------------------------------------------------
# ENVIRONMENT DEFINITIONS
# ------------------------------------------------------------------------------

[environments.<environment_id>]
# Human-readable display name
name = "Work Desktop"

# Brief description
description = "Focused productivity configuration"

# Compositor binary name
compositor = "hyprland"

# Path to the compositor configuration file
config_path = "~/.config/multienv/environments/work/hyprland.conf"

# Wayland desktop identification name
desktop_names = "Hyprland:Work"

# Session desktop filename
session_desktop = "multienv-work.desktop"

# Optional autostart script
autostart = "~/.config/multienv/environments/work/autostart.sh"

# Optional teardown script
teardown = "~/.config/multienv/environments/work/teardown.sh"

# Display scale factor (for documentation / tools)
display_scale = 1.5

# UI accent color
color_accent = "#58c89c"
```

---

## 2. Adding a New Custom Environment

Suppose you want to create a `minimal` environment:

1. **Create the Directory**:
   ```bash
   mkdir -p ~/.config/multienv/environments/minimal
   ```

2. **Create `hyprland.conf`**:
   Write your custom Hyprland configuration inside `~/.config/multienv/environments/minimal/hyprland.conf`.

3. **Register in `multienv.toml`**:
   Add the following block to `~/.config/multienv/multienv.toml`:
   ```toml
   [environments.minimal]
   name = "Minimal"
   description = "Distraction-free environment"
   compositor = "hyprland"
   config_path = "~/.config/multienv/environments/minimal/hyprland.conf"
   desktop_names = "Hyprland:Minimal"
   session_desktop = "multienv-minimal.desktop"
   display_scale = 1.0
   ```

4. **Generate Session Files**:
   ```bash
   multienv generate-sessions
   ```

5. **Verify**:
   ```bash
   multienv validate minimal
   ```


## Modern selector keyboard controls

The selector discovers every installed SDDM session and preserves the remembered index. From the password field, Tab cycles forward and Shift+Tab cycles backward through environments. Ctrl+Tab moves to the action controls, where Tab/Shift+Tab navigate normally. Enter with text submits that password; empty Enter requests fingerprint through the host's existing SDDM PAM stack when Fingerprint=true in theme.conf. Escape clears the field.

Selection is frozen during authentication, duplicate submissions are ignored, and passwords clear after submission or failure. Fingerprint sign-in requires an enrolled reader and a correctly configured host PAM stack; the theme never enrolls fingerprints or changes PAM. Restart and shutdown ask for confirmation.

Validate the mock keyboard flows without accessing real authentication:

```sh
QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software /usr/lib/qt6/bin/qmltestrunner -input tests/qml/tst_Keyboard.qml
```


### Grouping compatibility sessions in the greeter

The MultiEnv theme groups the standard Hyprland launcher under Secondary Environment and
collapses Primary Environment compatibility launchers into a single choice. It preserves
SDDM's original session indexes for authentication, prefers the explicitly named
Secondary Environment entry, and restores the last selection even when it was an alias.
Other sessions remain visible independently, including custom desktops.
No session desktop files need to be removed. The QML regression tests cover
duplicate entries, remembered aliases, reordered models and the third environment.

The alias grouping is configured per installation in `theme.conf`, for example:
`SessionAliases=Hyprland=Secondary Environment;Primary Environment=Primary Environment;Daemon OS=Primary Environment`.
The default is empty so a generic MultiEnv installation does not relabel a
standalone Hyprland session. Other sessions with matching display names remain
independent unless explicitly grouped.


### This workstation's two-session registry (2026-10-25)

SDDM's Wayland `SessionDir` is explicitly set by
`/etc/sddm.conf.d/99-zzz-multienv-sessions.conf` to
`/usr/local/share/multienv/wayland-sessions`. This directory has exactly two
symlinks: `primary-env.desktop` and `hyprland-uwsm.desktop`, targeting their
existing definitions in `/usr/share/wayland-sessions`. Compatibility launchers
remain intact. This also avoids the extra `Secondary Environment (Hyprland uwsm)` launcher
in `/usr/local/share/wayland-sessions` appearing as another desktop.

If an environment is intentionally added later, update this explicit registry
along with its MultiEnv configuration. Removing the SDDM override restores
default session discovery; it can also restore duplicate launcher choices.

---

## 3. SDDM Theme Customization (`theme.conf`)

`/usr/share/sddm/themes/multienv-selector/theme.conf` supports opt-in branding, motion, and session-alias controls under `[General]`:

```ini
[General]
Fingerprint=true
ReducedMotion=false
MotionPreset=cosmic
MotionIntensity=balanced
SessionAliases=Hyprland=Desktop
Brand=MULTIENV
BrandTagline=WORKSTATION MONOLITH
BrandLogo=
BrandLogoColorize=false
```

- **`Brand` / `BrandTagline`**: Controls the floating top-left header lockup rendered above the blurred wallpaper.
- **`BrandLogo`**: Path relative to the theme directory (e.g. `icons/brand-logo.svg`) or an absolute path (e.g. `/var/cache/multienv/brand-logo.svg`). Leave empty for the minimal accent dot indicator.
- **`BrandLogoColorize`**: Set `true` to tint monochrome SVGs dynamically with `ThemeColors.palette.accent`. Keep `false` when providing a pre-tinted dual-tone SVG.
- **Dynamic Icon & Light-Theme Adaptation**: All bundled UI SVG icons (`user.svg`, `lock.svg`, `arrow-right.svg`, `fingerprint.svg`, `restart.svg`, `power.svg`) are tinted via Qt 6 `MultiEffect`, and `SecurePanel.qml` automatically enforces luminance contrast for `secondary`/`muted` labels and adapts scrim/input translucency when `ThemeColors.palette.mode === "light"`.
