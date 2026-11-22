# arch-multienv 1.4.4

### Dynamic Wallpaper Palette Integration, Silky Bokeh Blur & Zero-White Frosted Monolith

This release introduces native dynamic palette synchronization directly from your active desktop theme's `colors.toml`, upgrades the background wallpaper with rich creamy bokeh blur, and completely eliminates specular white halo bleeding for a truly bespoke, professional look.

### Key Changes
- **Dynamic `colors.toml` Palette Synchronization**:
  - Automatically parses the active theme's `colors.toml` (`~/.local/state/omarchy/current/theme/colors.toml`) into a synchronous `ThemeColors.js` QML library.
  - Dynamically drives greeter accents, typography, translucent card acrylic gradients, button active states, and focus rings directly from the wallpaper palette.
  - Automatically updates on every wallpaper change via the zero-prompt `25-sddm-wallpaper-sync.sh` hook.
- **Rich Creamy Bokeh Wallpaper Blur**:
  - Pre-computed 20px Gaussian bokeh cache (`background_blurred.png`) combined with QML GPU atmospheric blur for an unmistakable frosted depth behind the monolith card.
  - Fail-safe fallback engine ensuring buttery smooth frosted depth across all resolutions and hardware.
- **Complete Elimination of White Glow & Specular Bleeding**:
  - Removed `#ffffff` layer masks and specular line highlights.
  - Replaced all card and button borders with subtle theme-tinted translucency.
- **Clean-Room Verified**:
  - 100% test pass across all syntax, session choice, keyboard interaction, and clean-room privacy checks.
