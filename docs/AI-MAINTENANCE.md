# AI Agent Maintenance Protocol

This document establishes the operational rules for AI coding agents (such as Antigravity, Claude, Copilot, Codex) interacting with an Arch Linux multi-environment system.

## 1. Identity & Scope Detection
An AI agent must **never** assume which environment is active.
Before proposing or making changes, run:
```bash
multienv status
```
Identify:
- Active environment name and ID
- Active compositor configuration file
- Target autologin environment

---

## 2. Non-Interference Rules
1. **Never edit files of an inactive environment** unless explicitly instructed to do so.
2. **Never modify shared system libraries or packages** to solve a desktop rice issue.
3. **Never modify display server settings** in `/etc/sddm.conf.d/` directly without using `multienv switch` or validating syntax first.

---

## 3. Pre-Flight Verification
Always run `multienv validate <env-id>` before advising the user to log out or reboot. Never leave a configuration in a broken state that could drop the user into an unbootable black screen.
