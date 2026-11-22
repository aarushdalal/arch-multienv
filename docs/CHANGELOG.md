# Changelog

All notable changes to `arch-multienv` will be documented in this file.

## [1.4.3] - 2026-11-22

- **Hardened Wallpaper Synchronization Hook**: Fixed argument resolution in `25-sddm-wallpaper-sync.sh` to correctly detect and fall back to the active desktop wallpaper symlink (`$HOME/.local/state/omarchy/current/background`) when invoked by `omarchy-hook theme-set <theme_name>`.
- **Zero-Flicker Synchronous Image Ingestion**: Configured `asynchronous: false` on background and internal frosted glass image layers in `SecurePanel.qml` to prevent blank rendering during initial greeter layout.
- **De-cluttered Layout for Known Users**: Dynamically hid the secondary username input field when `currentUser` is already known, maximizing vertical space and visual elegance on 720p/1080p displays.
- **Unified Frosted Monolith for Boot Unlock**: Directly integrated the 100% transparent frosted glass password capsule into Plymouth's `card.png` and disabled legacy opaque entry rendering.

## [1.4.2] - 2026-11-21

- **Pure Transparent Frosted Glass Password Field**: Redesigned password input and submit action into a unified translucent frosted glass capsule (`color: Qt.rgba(0, 0, 0, 0.28)`) with subtle specular outline and integrated forward button (100% transparent dark glass, no opaque white fills or thick white borders).
- **Ultra-Smooth Gaussian Wallpaper Blur**: Elevated background wallpaper blur to `blurMax: 64; blurMultiplier: 2.5` for a silky, creamy ambient backdrop behind the monolith card.
- **Pure SVG Vector Icon Suite**: Eliminated all Unicode font glyphs and emojis across SDDM greeter and desktop notifications in favor of razor-sharp, crisp SVG vector assets (`lock.svg`, `arrow-right.svg`, `user.svg`, `fingerprint.svg`, `restart.svg`, `power.svg`, `omarchy-sync.svg`).
- **Fluid Motion & Error Physics**: Integrated smooth sliding capsule transition for environment switching (`Easing.OutQuint`), biometric scan breathing pulsation, and visceral horizontal shake physics on authentication failure.
- **Zero-Drift Live Theme Synchronization**: Synchronized theme assets directly to both SDDM greeter engines and automated live cache.

## [1.4.1] - 2026-11-21

- **Real-Time Desktop Sync Notifications**: Integrated transient desktop notifications (`notify-send`) on wallpaper transitions displaying immediate sync start and in-place completion feedback without terminal interruption.
- **Dual-Screen Visual Showcase**: Added comprehensive 1080p visual previews for both the Multi-Environment SDDM Selector and the early-boot Encrypted Disk (LUKS) unlock screen.
- **Non-Interactive Limine Build Workflow**: Hardened Plymouth initramfs rebuild to invoke `limine-mkinitcpio` directly, eliminating interactive terminal prompt blocks.

## [1.4.0] - 2026-11-21

- **Double-Layer Frosted Monolith Architecture**: Upgraded the SDDM greeter UI with a fully transparent frosted glass monolith deck, elevated by a secondary masked Gaussian blur (`blurMax: 56; blurMultiplier: 2.2; brightness: 0.14`) over an atmospheric blurred wallpaper.
- **Transparent Frosted Sign-In Action**: Replaced solid white button fill with transparent frosted glass, specular rim highlight, and high-contrast typography.
- **100% Automated Wallpaper Synchronization**: Integrated live wallpaper caching via `/var/cache/multienv/background.png` for instantaneous, unprivileged greeter wallpaper updates on every desktop wallpaper change.
- **Universal Keyboard & Biometric Navigation**: Fully validated Tab cycling, Ctrl+Tab action focus, Escape password clear, and Enter-to-scan biometric triggers.
- **Clean-Room Privacy & Compliance**: Fully audited and verified clean of personal host identifiers and secrets.

## [1.3.2] - 2026-10-12

- Match the actual Lua/legacy compositor command API during window closure and standalone exit.
- Validate exact hexadecimal addresses and tolerate windows that disappear during closure.
- Exercise the real compositor with an owned disposable window; intercept final logout in the integration check.

## [1.3.1] - 2026-10-11

- Recognize the selected UWSM launcher ancestor and report duplicate logout requests as busy.
- Declare QtVersion=6 so SDDM selects the matching greeter instead of rejecting the QML and displaying its embedded default theme.
- Add a regression check for the metadata and verify loading with the actual Qt 6 SDDM greeter in test mode.

## [1.3.0] - 2026-10-11

- Responsive floating greeter with a dynamic full session model, confirmed power actions and duplicate-login prevention.
- Save-aware scoped logout; explicit force only, no detached watchdog or broad process killing.
- Safe path expansion, compositor readiness before autostart, preserved launch failures.
- Serialized atomic next-session/session-entry writes with preimages, accurate active-instance detection, failing doctor exit status.
- Installer ownership journal and preimages; preserve modified files and existing profiles on uninstall. Removed automatic host-specific PAM/USB edits and vendor-theme overwrite.
- Backend and greeter fixture regressions passed. Actual authentication and full profile switching still require an interactive host test.

Earlier entries describe historical behavior superseded by 1.3.0.

## [1.2.0] - 2026-09-30

### Added
- **SDDM Biometric Fingerprint Authentication**: Added interactive fingerprint scan badge and direct Enter key trigger on the login card, enabling seamless biometric login into the selected environment.
- **Biometric PAM & Udev Setup Automation**: Added `--fingerprint` flag to `bin/multienv-install` to automatically install the USB autosuspend prevention rule (`/etc/udev/rules.d/99-fingerprint-autosuspend.rules`) and configure `/etc/pam.d/sddm` for dual password and fingerprint authentication (`pam_fprintd.so`).
- **Targeted Dual-Session Navigation**: Updated SDDM greeter pills to dedicated environment selectors with active status indicators.
- **Biometric Diagnostics**: Expanded `docs/TROUBLESHOOTING.md` with troubleshooting steps for `fprintd` D-Bus claim backoff and kernel USB autosuspend timeouts.

## [1.1.0] - 2026-09-26

### Added
- **SDDM Greeter Keyboard Navigation**: Full 4-way arrow key navigation (`Tab`, `Left`, `Right`, `Up`, `Down`) for switching environments directly from the password prompt.
- **Power Actions in Greeter**: Built-in Reboot and Shutdown controls directly on the multi-environment SDDM card.
- **New CLI Commands**: Added `multienv disable-autologin` and `multienv greeter` commands with optional `--now` (`-n`) flag for immediate logout into the SDDM greeter.
- **Model Compatibility**: Added robust `getSessionCount()` helper supporting both `QAbstractItemModel.rowCount()` and `.count` properties in SDDM QML.
- **Enhanced Seat Release**: Added explicit Polkit authentication agent termination (`polkit-agent`) to `multienv-logout` to prevent lingering background agents from holding Wayland DRM seats open.
- **Installer SDDM Theme Flags**: Added `--theme` and `--theme-only` options to `multienv-install` to quickly install, repair, or restore the multi-environment SDDM greeter after distribution upgrades.
- **Comprehensive UI & Shell Diagnostics**: Expanded `docs/TROUBLESHOOTING.md` and the `arch-multi-environment` skill with verified solutions for SDDM theme overwrites, autologin bypass loops, Wayland layer-shell notification animation jitter, desktop clock punctuation (colon) typography alignment, and modern Quickshell / Qt 6.8+ `MapNode.values` iteration.

## [1.0.0] - 2026-09-19

### Initial Release
- **Generic Core Architecture**:
  - Implemented `multienv` CLI for status, listing, validation, switching, diagnostics, and session generation.
  - Implemented `multienv-session` entrypoint with protected signal traps (`trap 'exit 0' TERM HUP INT EXIT`) preventing SDDM crash loops.
  - Implemented `multienv-logout` graceful teardown engine with non-blocking watchdog timeout.
  - Implemented `multienv-install` system and user installer/uninstaller.
- **Generic Configuration Format**:
  - Declarative TOML configuration (`multienv.toml`) with support for arbitrary user-defined environments.
- **Display Manager Integration**:
  - Generic, brand-free SDDM greeter theme component with dynamic multi-session pill buttons.
  - Safe autologin switcher with pre-flight verification and emergency fallback.
- **Example Environments**:
  - `environment-a`: Full production desktop configuration with 1.5x scaling.
  - `environment-b`: Minimal / developer desktop configuration with 1.25x scaling.
- **Universal AI Maintenance Skill**:
  - Authoritative `arch-multi-environment` skill for AI coding assistants.
- **Documentation & Test Suite**:
  - Complete engineering documentation suite (Architecture, Installation, Configuration, Switching, Recovery, Troubleshooting, Security, AI Maintenance).
  - Automated test harness covering syntax, config parsing, state mutation, and clean-room sandboxing.
