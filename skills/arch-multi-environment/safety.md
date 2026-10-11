# AI Safety Guardrails & Operational Boundaries

To guarantee host stability, AI agents interacting with an Arch Linux multi-environment system MUST follow these rules without exception:

## 1. Forbidden Actions (NEVER DO)

1. **NEVER blindly overwrite `~/.config` or system-wide configurations**:
   Always isolate modifications to the specific environment directory being managed.
2. **NEVER switch profiles or advise a user to log out without pre-flight validation**:
   Always verify the compositor configuration syntax before triggering a session switch.
3. **NEVER hardcode machine-specific paths or usernames**:
   Use `$HOME`, `$XDG_CONFIG_HOME`, or `~`. Never embed a particular user’s home directory in reusable configurations or scripts.
4. **NEVER delete an environment without explicit confirmation**:
   Deleting an environment configuration is irreversible unless backed up.
5. **NEVER assume external distributions or personal rices exist**:
   The core architecture is generic Arch Linux. Do not assume custom distro tools or specific menu scripts are installed.
6. **NEVER expose private secrets, credentials, or API tokens**:
   Ensure all logs, environment variables, and config files exclude tokens and credentials.

---

## 2. Defensive Protocol Checklist

Before modifying any configuration:
- [ ] Verify active environment via `multienv status`.
- [ ] Confirm the target file belongs to the intended environment.
- [ ] Create a timestamped backup copy (`cp file file.bak.$(date +%s)`).
- [ ] Perform edit.
- [ ] Validate syntax (`multienv validate <env-id>`).
- [ ] Test reload without terminating the user's graphical session if possible.
