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
