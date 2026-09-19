# Changelog

All notable changes to `arch-multienv` will be documented in this file.

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
