# Security & Privacy Model

## 1. Privilege Boundaries

`arch-multienv` operates primarily at the unprivileged user level.
Privileged operations are restricted strictly to:
- Writing to `/etc/sddm.conf.d/autologin.conf` during session switches (managed via `sudo tee` or direct write if permissions allow).
- Installing system-wide Wayland session desktop entries to `/usr/share/wayland-sessions/`.
- Installing system binaries to `/usr/local/bin/`.

The core CLI and session wrappers do **not** run as root and do not require setuid binaries.

---

## 2. Secrets & Privacy Policy

- **No Secrets in Repositories**: API keys, OAuth tokens, SSH keys, passwords, and browser profile cookies must never be committed.
- **Clean State Directories**: Runtime state is confined to `~/.local/state/multienv/` and excluded via `.gitignore`.
- **Sanitized Logging**: Log files record only command execution timestamps and non-sensitive diagnostic codes.
