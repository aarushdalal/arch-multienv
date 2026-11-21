# arch-multienv 1.4.0

### Frosted Monolith Double-Layer Blur & Automated Wallpaper Synchronization

This release introduces the **Double-Layer Frosted Monolith** visual system and real-time automated wallpaper synchronization across the multi-environment workstation.

### Key Changes
- **Double-Layer Frosted Monolith SDDM Theme**:
  - Center deck transformed into a transparent frosted glass container with specular rim and ambient depth.
  - Secondary masked Gaussian blur (`blurMax: 56; blurMultiplier: 2.2; brightness: 0.14`) elevated over atmospheric background wallpaper blur.
  - Transparent frosted glass "Sign in" button with specular highlight and high-contrast typography.
  - Fully integrated environment switcher pills (`[ ● Primary Environment ]  [ Secondary Environment ]`) and discrete bottom power controls.
- **100% Automated Wallpaper Synchronization**:
  - Live wallpaper caching through `/var/cache/multienv/background.png` allowing instant, unprivileged SDDM greeter background updates on every wallpaper switch.
  - Clean background synchronization with Limine / Plymouth early-boot kernel unlock prompts.
- **Privacy & Clean-Room Compliance**:
  - Full audit passing zero personal host identifiers, hardcoded paths, or credentials.
  - 100% passing automated QML and session navigation test suites.
