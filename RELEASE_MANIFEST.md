# Release Manifest: Arch Multi-Environment Architecture v1.0.0

This manifest details the extraction, sanitization, rewriting, and validation process undertaken to create the public, reusable `arch-multienv` release.

---

## 1. What Was Extracted

From the prototype research and implementation evidence:
- **Core Multi-Environment Concept**: The architecture of running multiple independent Wayland desktop sessions on top of a single shared Arch Linux user account, kernel, application tree, and audio pipeline.
- **Display Manager Interop**: SDDM session discovery mechanisms, dynamic session selection pills in QML, and autologin session target manipulation.
- **Session Protection Wrapper**: The signal trap mechanism (`trap 'exit 0' TERM HUP INT EXIT`) preventing SDDM-helper from encountering non-zero status codes during compositor exits.
- **UWSM Integration**: Execution of the compositor inside systemd user session targets (`wayland-session-envelope@*.target`).
- **Teardown & Seat Release Engine**: The sequence of shutting down seat-locking graphical workers (video wallpapers, layer shells, watchers), gracefully signaling client application windows to save state, and dispatching a non-blocking watchdog timeout.

---

## 2. What Was Rewritten

- **Master Management CLI (`multienv`)**:
  - Replaced ad-hoc, hardcoded bash scripts (`switch-profile`, `deploy-multi-environment`) with a unified, modular Python 3 CLI supporting arbitrary user-defined environments.
  - Added pre-flight environment validation (`multienv validate`), automated Wayland session generation (`multienv generate-sessions`), system diagnostic checks (`multienv doctor`), and emergency fallback (`multienv fallback`).
- **Declarative Configuration Schema**:
  - Introduced a clean, human-readable TOML configuration format (`multienv.toml`) with support for arbitrary environment IDs, names, descriptions, display scalings, autostarts, and teardown hooks.
- **Display Manager Greeter Theme**:
  - Rewrote the SDDM QML greeter component into a generic, brand-free interface that dynamically reads any number of environments from `sessionModel` instead of hardcoding OS names.
- **Installation Tooling (`multienv-install`)**:
  - Created a standards-compliant installer/uninstaller supporting both system (`/usr/local`) and user (`~/.local`) installation targets.
- **Universal AI-Agent Skill**:
  - Authored a clean, portable AI skill (`skills/arch-multi-environment/`) teaching coding assistants how to operate defensively on any Arch multi-environment workstation.

---

## 3. What Was Removed

- All hardcoded usernames (e.g. `daemon0`), hostnames, home directory paths, and absolute mounts.
- Hardcoded hardware mounts (e.g. Windows NTFS partition mount commands `/dev/nvme0n1p*`).
- Distribution-specific branding, proprietary rices, and personal wallpapers.
- Fixed display scale and viewport assumptions (e.g. forced 1.33x vs 1.6x); display scaling is now an editable parameter in each environment's config.
- Stale script defects (such as references to non-existent session entries).

---

## 4. Intentionally Excluded

The following items were explicitly and deliberately excluded from this public release:
- Personal `~/.config` files (Waybar, Ghostty, Kitty, Fish, Nvim, Tmux, Cava).
- Personal wallpapers, screenshots, and visual assets.
- Personal cloud synchronization scripts, rclone configurations, and backup manifests.
- Hardware-specific fan curves, thermal limiters, and audio DSP presets (JBL 770NC, ALC236).
- Browser profiles, cookies, OAuth tokens, API credentials, and SSH keys.
- Proprietary video download suite scripts and widevine/playready configurations.

---

## 5. What Remains Configurable

- Environment IDs, human-readable display names, and descriptions.
- Compositor binary and configuration path (`--config <path>`).
- Display scale factor and toolkit DPI environment variables.
- Custom autostart and teardown shell scripts per environment.
- Accent colors for UI elements and SDDM session pills.
- Session manager choice (`uwsm` vs direct execution).
- SDDM autologin drop-in path and default environment.

---

## 6. System Dependencies

### Required:
- **Arch Linux** (x86_64)
- **Hyprland** (0.40+ or 0.50+)
- **Python** (3.11+ with standard `tomllib`)
- **SDDM** (0.20+ or 0.21+)

### Recommended:
- **UWSM** (Universal Wayland Session Manager)

---

## 7. What Was Tested

- **Syntax & Portability**: Verified all shell scripts using `bash -n` and python scripts using compilation checks.
- **Configuration Parsing**: Validated TOML schema loading, defaults expansion, and environment discovery.
- **State Mutation**: Verified SDDM autologin generation and emergency fallback rollback in an isolated sandbox.
- **Clean-Room Test**: Verified that the entire codebase contains zero references to private hostnames, usernames, or absolute host paths.

---

## 8. What Could Not Be Tested

- Live physical monitor switching across multiple hardware displays (simulated in software).
- Live graphical SDDM theme rendering with active user authentication (verified syntactically and logically; manual visual testing recommended on deployment).

---

## 9. Known Limitations

- SDDM autologin manipulation requires write access to `/etc/sddm.conf.d/autologin.conf` (managed via `sudo` or appropriate group permissions).
- Dual environments must currently use Wayland-compatible compositors; X11 desktop environments are not currently supported by the UWSM envelope wrapper.
