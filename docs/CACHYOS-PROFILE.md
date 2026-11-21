# CachyOS Hyprland in MultiEnv

Installed on 24 October 2026 as the third desktop profile in the existing arch-multienv project.

Log out when ready, select **CachyOS Hyprland**, and sign in. The chooser now shows exactly three options: CachyOS Hyprland, Environment A and Environment B. Compatibility session files remain installed, and the chooser maps each option to the correct original SDDM session index.

This is an isolated CachyOS desktop profile on the existing Arch system. Its kernel, installed applications, user files, audio and hardware remain shared. It does not turn the other profiles into the CachyOS distribution.

## Keyboard and themes

All 277 keyboard assignments match the current Environment B defaults plus your overrides. Window management, workspaces, application shortcuts, media and screenshots keep their familiar keys. Shell actions use CachyOS tools where possible. Environment B-only widgets display an availability message; their UI is not copied into the CachyOS desktop.

- **Super + Space / D / R:** application launcher.
- **Super + Return:** terminal.
- **Super + B:** browser.
- **Super + E / Shift + F:** file manager.
- **Super + Q / W:** close window.
- **Super + T:** float or tile.
- **Super + F:** fullscreen.
- **Super + K:** shortcut reference.
- **Super + Escape:** session and power menu.
- **Super + Shift + T:** native theme gallery with group covers.
- **Super + Shift + Space:** themes in the active group.
- **Super + Alt + T / Ctrl + M:** all themes.
- **Super + Alt + N:** next background in the selected theme.

All **275 installed themes** are available with previews and colour palettes. The gallery reads your existing collection without duplicating its media. CachyOS saves its own selection, applies colours to Hyprland, Waybar, Wofi, Alacritty, Mako and swaylock, and runs its own wallpaper process. Video backgrounds use the already-installed mpvpaper. Environment B's theme application scripts and global application-theme hooks are not executed by this picker.

## Isolation and checks

34 signed Arch packages were added. No pre-existing packages were upgraded, removed or replaced. CachyOS repositories, kernel packages, display-manager replacements and a system upgrade were not needed. Environment B's mirror lacked several matching KDE packages; the dependency transaction used matching signed packages from the official Arch archive with signature verification required.

The two newly installed applet autostarts have user overrides so they start only through the CachyOS desktop supervisor. Mako's automatic service activation is restricted to the CachyOS profile. Its desktop processes and wallpaper belong to the graphical-session lifecycle. The existing Environment B and Environment A startup files remain unchanged.

Validation completed:

- All three MultiEnv profiles pass configuration checks.
- 16 theme-chooser keyboard and session-index regression checks pass, plus the three-option preview check.
- The CachyOS compositor, bar, terminal and native theme gallery launched in a nested window.
- Every theme preview exists and every palette parses.
- The nested profile has the same 277 keyboard assignments as the active Environment B session.
- Selecting a theme through the native gallery successfully applied profile-only state, colours and wallpaper.
- The test compositor and its processes were cleaned up; Environment B remains active with no configuration errors.
- Backup manifests and Work mirrors are updated. The final backup audit reports 408 passed checks, zero errors and three warnings for missing LM Studio folders (`~/.config/LM Studio`, `~/.config/LM-Studio`, `~/.lmstudio`). CachyOS paths are covered; those unrelated warnings prevent claiming a fully clean backup audit. The audit does not confirm a completed cloud upload.

A complete physical login, fingerprint sign-in, suspend/resume and logout in the new profile remain to be exercised on your next session switch. The current session was not logged out or restarted.

## Configuration and recovery

- Profile registration: `~/.config/multienv/multienv.toml`, environment ID `cachyos`.
- Compositor: `~/.config/hypr/cachyos/hyprland.lua`.
- Application settings and copied native gallery: `~/.config/cachyos-hyprland/`.
- Theme state: `~/.local/state/cachyos-hyprland/`.
- Session entry: `/usr/share/wayland-sessions/cachyos-hyprland.desktop`.
- Profile helpers: `~/.local/bin/*cachyos*`.
- Project source and tests: `~/Work/arch-multienv/`.
- Recovery copies and implementation receipts: `~/Work/multienv-cachyos-20261024/`.

If a login fails, choose Environment B at the greeter. From a text console, `multienv fallback` restores manual session selection. No automatic login target was set by this installation.

Upstream: [CachyOS Hyprland settings](https://github.com/CachyOS/cachyos-hyprland-settings), pinned at `4aa4a28450f4f5dd6d2af84e80bc402817396606`, located through [CachyOS PKGBUILDs](https://github.com/CachyOS/CachyOS-PKGBUILDS/tree/master/cachyos-hyprland-settings). Adaptations and original configuration copies are retained in the profile.


Starter reference: [Printable guide](CachyOS-Starter-Guide.pdf), [editable guide](CachyOS-Starter-Guide.md), and [all registered shortcuts](CachyOS-All-Registered-Shortcuts.md).
