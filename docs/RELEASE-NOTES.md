# arch-multienv 1.4.1

### Real-Time Sync Notifications, Frosted Monolith SDDM & Dual-Screen Visuals

This release brings real-time desktop notification feedback for automated wallpaper synchronization, adds high-definition visual showcases for both the Multi-Environment SDDM greeter and early-boot Encrypted Disk (LUKS) unlock screen, and hardens background initramfs builds.

### Key Changes
- **Real-Time Desktop Sync Notifications**:
  - Live desktop alerts (`notify-send`) fire whenever the active wallpaper changes, confirming sync initiation and updating in-place to "Sync Complete" upon initramfs generation.
- **Dual-Screen Visual Showcase**:
  - Added 1080p rendered previews of the Multi-Environment SDDM Greeter (`assets/showcase/greeter-preview.png`) and Early-Boot Encrypted Storage Unlock Screen (`assets/showcase/boot-unlock-preview.png`).
- **Double-Layer Frosted Monolith Architecture**:
  - Transparent frosted glass center deck with specular highlights and secondary masked Gaussian blur (`blurMax: 56; blurMultiplier: 2.2; brightness: 0.14`).
  - Transparent frosted glass "Sign in" button with white typography and specular top highlight.
  - Responsive environment switcher pills (`[ ● Primary Environment ]  [ Secondary Environment ]`).
- **100% Automated Zero-Prompt Synchronization**:
  - Instant unprivileged greeter wallpaper updates via `/var/cache/multienv/background.png`.
  - Non-interactive Limine bootloader initramfs builds directly invoking `limine-mkinitcpio`.
- **Privacy & Quality Audit**:
  - 100% clean-room compliance with zero personal identifiers or tokens.
  - Full passing suite across QML keyboard navigation, session model handling, and backup drift checks.
