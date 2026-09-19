# Deep Technical Architecture

## 1. Core Architectural Philosophy

The **Arch Multi-Environment Architecture** solves a classic problem in Linux desktop customization:
How can a user maintain completely different workflows, display scalings, desktop shells, and visual setups without incurring the disk overhead, maintenance burden, and context switching friction of dual-booting or multiple Unix accounts?

The solution lies in a layered separation of concerns:
1. **Shared Foundation**: All core OS services, kernel, hardware drivers, user files, and application binaries remain strictly unified.
2. **Session Envelope**: Each environment is isolated at the session entrypoint and compositor execution level.
3. **Coordinated Switching**: A lightweight coordination engine manages login targets, signal traps, and graceful seat release.

```text
┌─────────────────────────────────────────────────────────────────┐
│                       Arch Linux Base                           │
│  • Linux Kernel (SMP PREEMPT_DYNAMIC)                           │
│  • Single UID (1000) / $HOME (/home/user)                       │
│  • Shared Binaries (/usr/bin) & Libraries (/usr/lib)            │
│  • Shared Audio Pipeline (PipeWire / WirePlumber)               │
│  • Shared Display Server Engine (Hyprland Binary)               │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Display Manager (SDDM)                       │
│  • Discovers sessions in /usr/share/wayland-sessions/           │
│  • Evaluates /etc/sddm.conf.d/autologin.conf                    │
│  • Renders dynamic session selector pills                       │
└────────────────┬───────────────────────────────┬────────────────┘
                 │                               │
                 ▼                               ▼
┌─────────────────────────────────┐ ┌─────────────────────────────────┐
│         Environment A           │ │         Environment B           │
│                                 │ │                                 │
│  • Entry: multienv-session      │ │  • Entry: multienv-session      │
│  • Systemd Target: envelope@A   │ │  • Systemd Target: envelope@B   │
│  • Config: env-a/hyprland.conf  │ │  • Config: env-b/hyprland.conf  │
│  • Display Scale: 1.50x         │ │  • Display Scale: 1.25x         │
│  • Shell: Full Production Shell │ │  • Shell: Snappy Minimal Bar    │
│  • Autostart: env-a/autostart   │ │  • Autostart: env-b/autostart   │
│  • Teardown: env-a/teardown     │ │  • Teardown: env-b/teardown     │
└─────────────────────────────────┘ └─────────────────────────────────┘
```

---

## 2. The Shared vs. Isolated Boundary

### What is Shared:
- **Root Filesystem & Btrfs / Ext4 Subvolumes**: Zero duplicate partitions or wasted disk storage.
- **Application Binaries & Compilers**: Web browsers, terminals, code editors, compilers, package managers (`pacman`, `paru`).
- **User Documents & Code Repositories**: All git repositories, documents, audio files, and downloads in `$HOME` are shared natively.
- **Audio & Media Daemons**: PipeWire audio pipelines, EQ filters, and Bluetooth connections survive across session switches without interruption.
- **Hardware & Device Rules**: Udev rules, GPU drivers (Mesa, Vulkan, NVIDIA), fingerprint sensors, and touchpad gesture definitions.

### What is Isolated:
- **Compositor Master Configuration**: Each environment passes its dedicated configuration file to the compositor (`--config <path>`).
- **Display Scale & DPI Viewport**: Allows a productivity environment to run at 1.5x scale while a gaming or coding environment runs at 1.0x or 1.25x scale.
- **Desktop Shell & Widgets**: Independent status bars, launchers, notification daemons, and system trays.
- **Window Rules & Opacity**: Custom tiling ratios, dwindle layout parameters, active/inactive window opacities, and border roundings.
- **Autostart Daemons**: Background utilities needed for specific workflows (e.g. IDE assistants, development servers) only run when that environment is active.
- **Session Teardown Hooks**: Custom cleanup actions executed when leaving an environment.

---

## 3. Session Lifecycle Management with UWSM

Universal Wayland Session Manager (UWSM) coordinates the startup and shutdown of the compositor:
- **Unit Isolation**: Each session is wrapped in a dedicated systemd target: `wayland-session-envelope@<session>.target`.
- **Environment Injection**: Cleanly imports graphical environment variables into `systemd --user` and `dbus` without polluting user shell profiles.
- **Process Supervision**: When the session ends, UWSM ensures all child processes spawned by the session are terminated, releasing hardware video seats cleanly.
