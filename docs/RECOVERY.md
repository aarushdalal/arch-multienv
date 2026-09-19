# Disaster Recovery Procedures

If a system misconfiguration prevents graphical access, follow these recovery procedures.

## 1. TTY Recovery Access

At any time, you can access a Linux virtual console independently of the graphical compositor:
1. Press `Ctrl + Alt + F3` (or `Ctrl + Alt + F4`).
2. Enter your Linux username and password.

---

## 2. Emergency SDDM Greeter Reset

If SDDM is stuck attempting to autologin to a failing environment:
```bash
multienv fallback
```
This command removes `/etc/sddm.conf.d/autologin.conf`.
Next, restart SDDM to return to the interactive login screen:
```bash
sudo systemctl restart sddm
```

---

## 3. Restoring Environment Configurations

If a recent edit to an environment's configuration caused a crash:
1. Locate the backup file:
   ```bash
   ls -la ~/.config/multienv/environments/<env-id>/
   ```
2. Restore from the last known good configuration:
   ```bash
   cp ~/.config/multienv/environments/<env-id>/hyprland.conf.bak \
      ~/.config/multienv/environments/<env-id>/hyprland.conf
   ```
3. Test syntax before logging in:
   ```bash
   multienv validate <env-id>
   ```

---

## 4. Resetting Stuck User Sessions

If session processes remain frozen:
```bash
loginctl terminate-user "$USER"
```
This forces systemd to terminate all lingering processes owned by the user, freeing GPU locks.
