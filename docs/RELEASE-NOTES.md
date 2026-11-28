# arch-multienv 1.5.0

### Opt-In SDDM Brand Logo, Dynamic `MultiEffect` Icon Tinting, Optional Frosted Plymouth Theme & Enhanced Installer

Release `1.5.0` makes every SDDM greeter icon and contrast token fully theme-adaptive, introduces an opt-in brand logo slot above the blurred backdrop, adds an optional theme-adaptive Plymouth boot/LUKS/loading/shutdown package (`multienv-monolith`), and upgrades `multienv-install` with rich customization flags so everything configures cleanly in one command.

### Highlights
- **Opt-In SDDM Branding (`theme.conf` & Installer Flags)**:
  - Configure `Brand`, `BrandTagline`, `BrandLogo`, and `BrandLogoColorize` via `theme.conf` or directly with `./bin/multienv-install --user --theme --brand ... --brand-logo ...`.
  - Generic `MULTIENV` remains the default when no brand flags are passed—zero forced branding.
- **Complete SDDM Theme Adaptation & Contrast Guards**:
  - All bundled UI SVG icons are now dynamically tinted with Qt 6 `MultiEffect`, remaining hardcoded sky-blue halos and modal colors are wired to `ThemeColors.palette`, and luminance guards keep `secondary`/`muted` labels crisp on both dark and light themes.
- **Optional `multienv-monolith` Plymouth Package & `multienv-plymouth-sync`**:
  - Install with `--plymouth` (and optionally `--activate-plymouth`) to get a matching theme-adapted frosted-glass LUKS unlock screen (logo floating above the card), branded post-unlock loading screen, and animated 50 FPS shutdown/reboot screen.
- **Verified**:
  - Full `tests/run_all_tests.sh`, `tests/test_refinement.py`, `tools/release_privacy_check.py`, `GreeterTests.qml`, and `qmltestrunner` QML suites pass cleanly.
