---
name: arch-multi-environment
description: Operational memory, engineering protocols, and safety procedures for inspecting, managing, configuring, validating, and recovering Arch Linux multi-environment desktop installations.
---

# Arch Linux Multi-Environment Architecture (`arch-multi-environment`)

- **Skill**: `arch-multi-environment`
- **Target OS**: Arch Linux (x86_64)
- **Scope**: Multi-profile Wayland/Hyprland desktop setups running on a shared user account
- **Classification**: System Architecture & AI Automation Operational Protocol

---

## 1. Purpose & Core Principles

This skill instructs an AI assistant on how to inspect, maintain, configure, switch, and recover multi-environment desktop installations on Arch Linux without breaking user data or creating configuration collisions.

In this architecture, multiple distinct desktop environments (e.g., Environment A for production, Environment B for minimal development/gaming) coexist on top of a single, shared Arch Linux system.

### Fundamental System Invariants:
1. **Single User & Kernel**: All environments run under the primary user account ($USER) sharing the Linux kernel, system packages in `/usr/bin`, and user data in `$HOME`.
2. **Strict Configuration Isolation**: Compositor configurations, desktop shells, scaling factors, and visual themes are isolated per environment.
3. **Session Lifecycle Envelopes**: Each session is launched with distinct Wayland desktop names and wrapped in UWSM systemd targets to prevent orphaned processes.
4. **Preserve Launch Failures**: Session wrappers return compositor or UWSM failures. Never mask errors with an EXIT trap.
5. **Universal Portability**: Agents must always use `$HOME`, `$XDG_CONFIG_HOME`, `$XDG_STATE_HOME`, and relative paths—never assume a specific username, machine hostname, or distribution rice.

---

## 2. Quick Command Reference

```bash
# Inspect current active environment and autologin target
multienv status

# List all configured environments
multienv list

# Validate an environment configuration before making changes
multienv validate <environment-id>

# Run comprehensive diagnostic doctor
multienv doctor

# Switch to target environment (pre-flights automatically)
multienv switch <environment-id>

# Switch and log out immediately
multienv switch <environment-id> --now

# Emergency fallback: restore manual SDDM login greeter
multienv fallback

# Explicitly disable autologin drop-ins
multienv disable-autologin

# Return to SDDM greeter immediately
multienv greeter --now

# Regenerate Wayland session desktop entries
multienv generate-sessions
```

---

## 3. Mandatory AI Operational Protocol

Whenever an AI agent is requested to inspect, modify, or extend an Arch multi-environment system, it must strictly follow these six phases:

1. **Phase 1: Active Configuration Detection**:
   Execute `multienv status` to determine which environment is currently running. Never guess or assume.
2. **Phase 2: Isolation Verification**:
   Verify whether the file to be edited belongs to the shared layer or a specific environment. Never edit Environment B files while the user is asking to modify Environment A.
3. **Phase 3: Backup Before Edit**:
   Before modifying any compositor configuration or script, create a timestamped backup copy (`.bak` or snapshot).
4. **Phase 4: Pre-Flight Syntax Check**:
   Always validate the modified configuration file syntax (`Hyprland --verify-config --config <path>` or `multienv validate <env-id>`) before suggesting a logout or reload.
5. **Phase 5: Targeted Reload**:
   Only reload the specific component modified:
   - Compositor reload: `hyprctl reload`
   - Specific environment shell reload: invoke that environment's shell reload script.
6. **Phase 6: Rollback Preparedness**:
   If a change causes a failure or session crash, immediately provide the TTY fallback command: `multienv fallback`.

---

## 4. Documentation Map

- [Architecture Guide](architecture.md): Deep breakdown of shared system vs isolated environment components.
- [Configuration Guide](configuration.md): Step-by-step instructions for adding, editing, or removing environments.
- [Switching Mechanics](switching.md): Complete lifecycle trace of SDDM, UWSM, autologin, and teardown.
- [AI Safety Rules](safety.md): Strict boundaries, forbidden actions, and defensive guardrails for AI agents.
- [Recovery Procedures](recovery.md): Step-by-step instructions to recover from black screens, syntax errors, or seat locks.
- [Troubleshooting Reference](troubleshooting.md): Diagnosis matrix for scaling bugs, orphaned processes, and session loop errors.
