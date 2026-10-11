# Architecture Model & Component Partitioning

## 1. System Topology

The architecture separates the operating environment into two distinct layers:
1. **Shared System & Application Base**: Shared across all desktop profiles.
2. **Isolated Environment Layer**: Scoped exclusively to each profile.

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                           Shared Linux Base                             │
│  • Linux Kernel & Systemd PID 1        • Hardware Drivers & PipeWire     │
│  • Single User Account ($HOME)         • Shared Applications (/usr/bin)  │
│  • Compositor Binary (/usr/bin/Hyprland) • Display Manager (SDDM)        │
└────────────────────────────────────┬────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                       Session Dispatch Layer (SDDM)                     │
│  • Session Discovery: /usr/share/wayland-sessions/                      │
│  • Dynamic Autologin: /etc/sddm.conf.d/autologin.conf                   │
│  • Full Session Selector / Greeter UI                               │
└──────────────────┬───────────────────────────────────┬──────────────────┘
                   │                                   │
                   ▼                                   ▼
┌─────────────────────────────────────┐ ┌─────────────────────────────────────┐
│           Environment A             │ │           Environment B             │
│                                     │ │                                     │
│  • Session Entry: multienv-env-a    │ │  • Session Entry: multienv-env-b    │
│  • Hyprland Config: env-a/hypr.conf │ │  • Hyprland Config: env-b/hypr.conf │
│  • Display Scale: 1.50x             │ │  • Display Scale: 1.25x             │
│  • Desktop Shell: Environment Shell │ │  • Desktop Shell: Minimal Shell     │
│  • Autostart: env-a/autostart.sh    │ │  • Autostart: env-b/autostart.sh    │
│  • Teardown: env-a/teardown.sh      │ │  • Teardown: env-b/teardown.sh      │
└─────────────────────────────────────┘ └─────────────────────────────────────┘
```

---

## 2. Shared vs. Isolated Matrix

| Component / Layer | Shared or Isolated? | Description |
|---|---|---|
| **Linux Kernel & Modules** | **Shared** | All environments execute on the single booted kernel. |
| **User Data & Home Directory** | **Shared** | Documents, downloads, repositories, and caches persist across environments. |
| **Installed Applications** | **Shared** | Browsers, IDEs, office suites, and command-line utilities in `/usr/bin`. |
| **Audio Pipeline (PipeWire)** | **Shared** | Audio daemons survive across environment switches without interrupting streams. |
| **Input Hardware Configurations** | **Shared** | Mouse sensitivity, touchpad gestures, and natural scroll parameters. |
| **Compositor Master Configuration** | **Isolated** | Each profile points to its own config file via `--config <path>`. |
| **Desktop Scaling & Viewport** | **Isolated** | Allows one profile to use fractional scaling (e.g. 1.25x) and another 1.5x. |
| **Desktop Shell & Panels** | **Isolated** | Status bars, notification daemons, and application menus run independently. |
| **Window Rules, Gaps & Themes** | **Isolated** | Visual styles, borders, roundings, and animations are unique per environment. |
| **Autostart Daemons** | **Isolated** | Environment-specific background tools are initiated only when that profile boots. |
| **Session Teardown Scripts** | **Isolated** | Custom hooks to shut down environment-specific services cleanly before exit. |
