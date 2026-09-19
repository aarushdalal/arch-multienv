# Switching Lifecycle & Teardown Trace

## 1. Complete Switching Flow

```text
User executes: multienv switch <env_id> [--now]
       │
       ▼
1. Pre-Flight Validation
   • Checks target config syntax with `Hyprland --verify-config`
   • Checks existence of target session .desktop file
   • Validates executable permissions on autostart / teardown scripts
       │
       ▼
2. State Mutation
   • Writes [Autologin] configuration to /etc/sddm.conf.d/autologin.conf:
       [Autologin]
       User=$USER
       Session=multienv-<env_id>.desktop
       │
       ▼
3. Graceful Teardown (multienv-logout)
   • Runs environment teardown script (if defined)
   • Terminates background video wallpaper daemons (mpvpaper, swww)
   • Dispatches 3-second watchdog timer in background
   • Dispatches window close requests to client applications
   • Shuts down UWSM session envelope or exits compositor
       │
       ▼
4. Display Server Release
   • Compositor exits with code 0 (guaranteed by session signal trap)
   • SDDM-helper completes cleanly
       │
       ▼
5. SDDM Booting Target Environment
   • SDDM reads autologin.conf
   • Dispatches multienv-session <env_id>
   • Target Hyprland environment starts cleanly!
```

---

## 2. Preventing Wayland Seat Hangs

A critical bug in multi-environment switching is the "stuck seat" issue:
If a background process (such as a video wallpaper engine, a polkit daemon, or an unmanaged shell instance) remains running and attached to the Wayland socket, the DRM/KMS graphics device will not be released. This causes SDDM to hang with a black screen.

`multienv-logout` solves this systematically:
1. **Pre-compositor termination**: Explicitly stops graphical background daemons.
2. **Window grace period**: Gives GUI applications 1 second to flush file buffers.
3. **Safety watchdog**: Dispatches a detached background timer that forcibly triggers `uwsm stop` if a hung window attempts to block exit.
