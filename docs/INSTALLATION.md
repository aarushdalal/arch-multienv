# Installation & Setup Guide

## 1. System Prerequisites

The architecture is built for **Arch Linux** (and Arch-based distributions) running Wayland.

### Core Required Packages:
```bash
sudo pacman -S hyprland python sddm
```

### Strongly Recommended Packages:
- **UWSM**: `sudo pacman -S uwsm` (Provides robust systemd session envelope management).
- **TOML Support**: Python 3.11+ includes `tomllib` in the standard library.

---

## 2. Installation Steps

### Step 1: Clone the Repository
```bash
git clone https://github.com/aarushdalal/arch-multienv.git
cd arch-multienv
```

### Step 2: Run the Installer
Install executables to `/usr/local/bin` (or use `--user` for `~/.local/bin`):
```bash
./bin/multienv-install
```

The installer will:
1. Install `multienv`, `multienv-session`, and `multienv-logout`.
2. Initialize `~/.config/multienv/multienv.toml` if not already present.
3. Install sample environment definitions to `~/.config/multienv/environments/`.

### Step 3: Generate Wayland Session Entries
Create the `.desktop` entries in `/usr/share/wayland-sessions/`:
```bash
multienv generate-sessions
```

### Step 4: Validate Installation
Run the diagnostic doctor to verify all paths and dependencies:
```bash
multienv doctor
```

---

## 3. SDDM Theme Setup (Optional but Recommended)

To enable dynamic visual session pill buttons on the SDDM login screen:
1. Copy the generic theme to `/usr/share/sddm/themes/`:
   ```bash
   sudo cp -r sddm/themes/multienv-selector /usr/share/sddm/themes/
   ```
2. Set the theme in `/etc/sddm.conf.d/10-theme.conf`:
   ```ini
   [Theme]
   Current=multienv-selector
   ```
3. Enable session memory in `/etc/sddm.conf.d/99-session.conf`:
   ```ini
   [Users]
   RememberLastSession=true
   RememberLastUser=true
   ```

---

## 4. Uninstallation

To cleanly remove `arch-multienv` without affecting any user data:
```bash
multienv-install --uninstall
```
