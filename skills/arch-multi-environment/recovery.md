# Disaster Recovery & Rollback Protocols

If an environment configuration fails, the user encounters a black screen, or SDDM enters a reboot loop, follow these proven recovery paths:

## 1. TTY Emergency Access

If the graphical interface fails:
1. Press `Ctrl + Alt + F3` (or `F4`, `F5`) to switch to a virtual console (TTY).
2. Log in with your username and password.

---

## 2. Immediate Autologin Reset (Fallback)

If an invalid environment was selected and SDDM is failing to boot:
```bash
multienv fallback
```
This removes `/etc/sddm.conf.d/autologin.conf`, forcing SDDM back into manual greeter mode so the user can log into a working environment.

---

## 3. Reverting Broken Configurations

If a recent edit to `hyprland.conf` broke an environment:
1. Inspect the Hyprland log:
   ```bash
   cat "$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/hyprland.log
   ```
2. Restore from backup:
   ```bash
   cp ~/.config/multienv/environments/<env-id>/hyprland.conf.bak \
      ~/.config/multienv/environments/<env-id>/hyprland.conf
   ```
3. Verify syntax:
   ```bash
   Hyprland --verify-config --config ~/.config/multienv/environments/<env-id>/hyprland.conf
   ```

---

## 4. Releasing Stuck Wayland Seats

If a session fails to exit cleanly and freezes:
```bash
loginctl terminate-user "$USER"
```
This terminates all processes owned by the user, releasing graphical hardware locks and restarting SDDM.
