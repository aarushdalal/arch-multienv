# arch-multienv 1.4.3

### Hardened Wallpaper Synchronization, Zero-Flicker Monolith & Unified Plymouth Unlock

This release ensures 100% reliable automated wallpaper synchronization from active desktop themes to boot and login environments, eliminates greeter flicker, optimizes vertical layout for known user logins, and mirrors the transparent frosted glass capsule into early-boot LUKS disk encryption.

### Key Changes
- **Hardened Wallpaper Synchronization**:
  - Resolved hook argument mismatch in `25-sddm-wallpaper-sync.sh`: when called via `omarchy-hook theme-set <theme_name>`, correctly identifies non-file arguments and resolves `$HOME/.local/state/omarchy/current/background`.
  - Guarantees immediate zero-prompt cache updates to `/var/cache/multienv/background.png` on every desktop wallpaper change.
- **Zero-Flicker Greeter Ingestion**:
  - Switched `asynchronous: false` on background and internal card refraction layers in `SecurePanel.qml` to eliminate gray/blank frames during SDDM greeter display.
- **Streamlined Layout on Small/Compact Screens**:
  - Dynamically hides the redundant username input field when the active user is already resolved, keeping the focus entirely on the transparent password capsule, session switcher, and biometric status.
- **Unified Frosted Monolith for Boot Unlock**:
  - Embedded the transparent frosted glass capsule directly into Plymouth's `card.png` and disabled legacy opaque entry borders in `omarchy.script`.
- **Verified Clean-Room Parity**:
  - 100% test pass across all syntax, session choice, keyboard interaction, and privacy checks.
