# Installation

Requires Python 3.11+, Hyprland and SDDM. UWSM is required when selected as the
session manager. Install required packages using your distribution tools.

Run `./bin/multienv-install --user --dry-run` to review destinations, then
`./bin/multienv-install --user` to install commands under ~/.local/bin. Ensure
that directory is in PATH. Existing user configuration is preserved. Review
the example profiles and paths before generating sessions.

`--prefix ABSOLUTE_DIRECTORY` selects another command prefix. A system prefix
requires running the installer with appropriate privileges. `--theme` installs
the owned MultiEnv theme separately with a privileged helper; `--theme-only`
installs only its files. Preimages and installed hashes are recorded in the
prefix's share/arch-multienv/install directory (or /var/lib/arch-multienv/theme
for the theme-only operation).

Activate the theme with a separate reviewed SDDM drop-in containing:

```ini
[Theme]
Current=multienv-selector
```

Review existing SDDM configuration precedence before activation. No vendor
theme, PAM stack or USB rule is overwritten. `--fingerprint` explains that
fprintd setup is host-specific and returns an error; password login remains
available. Fingerprint UI needs an already configured authentication backend.

Run `multienv generate-sessions`, `multienv validate` and `multienv doctor` after
reviewing the profile definitions. Generation and next-session writes preserve
preimages. Do not restart SDDM during an active session.

`--uninstall` restores/removes unchanged files recorded in the ownership journal.
Locally modified files, user profiles, session entries and autologin settings
are preserved. Review the journal and remaining files before manual cleanup.

The theme supports `MotionPreset` (all 19 existing names), `MotionIntensity`
(subtle/balanced/expressive), and `ReducedMotion` in theme.conf. Greeter motion
uses this safe installed configuration; it does not read a logged-in user
shell or silently elevate privileges when that user changes a preset.
