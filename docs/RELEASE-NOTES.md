# arch-multienv 1.4.2

### Pure Transparent Frosted Glass Monolith, Ultra-Smooth Ambient Blur & Vector SVG Suite

This release delivers a major visual and tactile refinement to the Multi-Environment SDDM greeter: a 100% transparent frosted glass password field with zero white fills, ultra-smooth creamy Gaussian background blur, fluid physics-based animations, and a pure SVG vector icon suite eliminating all emojis.

### Key Changes
- **Pure Transparent Frosted Glass Password Field**:
  - Replaced all opaque white button fills and heavy borders with a single unified translucent frosted glass capsule (`color: Qt.rgba(0, 0, 0, 0.28)`).
  - Subtle specular outline with cyan/sky accent illumination on focus.
  - Seamlessly embedded submit button with pure SVG directional arrow.
- **Ultra-Smooth Gaussian Wallpaper Blur**:
  - Upgraded fullscreen ambient wallpaper blur to high-fidelity parameters (`blurMax: 64; blurMultiplier: 2.5`), providing a silky, noise-free frosted background.
  - Secondary card refractive blur with calibrated luminance stops and specular edge rim.
- **Pure SVG Vector Icon Suite**:
  - Replaced all Unicode font glyphs and emojis with dedicated SVG vector assets:
    - Lock glyph (`icons/lock.svg`)
    - Forward submit arrow (`icons/arrow-right.svg`)
    - User avatar glyph (`icons/user.svg`)
    - Biometric sensor glyph (`icons/fingerprint.svg`)
    - Power controls (`icons/restart.svg`, `icons/power.svg`)
    - Notification icon (`omarchy-sync.svg`)
- **Fluid Motion & Error Physics**:
  - Smooth animated pill indicator sliding between environment tabs (`Easing.OutQuint`).
  - Visceral horizontal card shake animation on authentication failure.
  - Subtle breathing pulse animation on biometric sensor idle state.
- **Automated Live Theme Sync**:
  - SDDM theme assets verified and synced live with zero configuration drift.
- **Clean-Room Privacy & Compliance**:
  - 100% clean-room audit compliance with zero host-specific paths or credentials.
