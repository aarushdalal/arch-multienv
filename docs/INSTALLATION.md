# Installation

Requires Python 3.11+, Hyprland, and SDDM (Qt 6 greeter). UWSM is required when selected as the session manager. For the optional `--plymouth` frosted boot/unlock theme, install `plymouth`, `imagemagick`, `python-pillow`, and `resvg` (or `librsvg`).

## Quick Start

Review destinations first with `--dry-run`, then install CLI tools + SDDM theme:

```bash
./bin/multienv-install --user --theme --dry-run
./bin/multienv-install --user --theme --activate-theme
```

- `--user` installs CLI commands under `~/.local/bin` (ensure it is in `PATH`).
- `--prefix ABSOLUTE_DIRECTORY` selects another command prefix (default `/usr/local`).
- `--theme` installs the SDDM greeter theme to `/usr/share/sddm/themes/multienv-selector` using `sudo`. `--theme-only` installs only privileged theme assets.
- `--activate-theme` writes `/etc/sddm.conf.d/10-multienv-theme.conf` with:
  ```ini
  [Theme]
  Current=multienv-selector
  ```
  Review existing `/etc/sddm.conf.d/*.conf` drop-in ordering before activation. No vendor theme, PAM stack, or USB rule is overwritten.

## Opt-In Brand, Logo, Motion & Plymouth Options

All branding and Plymouth integrations are strictly opt-in. By default, the greeter uses the generic `MULTIENV` label without a custom logo.

| Flag | Purpose |
|---|---|
| `--brand NAME` | Top-left brand label (default: `MULTIENV`) and Plymouth wordmark |
| `--brand-tagline TEXT` | Secondary label beside the brand title (default: `WORKSTATION MONOLITH`) |
| `--brand-logo PATH` | Copies a local SVG/PNG file into `icons/brand-logo.<ext>` and enables it in `theme.conf` (and as `multienv-logo.svg.tpl` when `--plymouth` is passed) |
| `--brand-logo-path PATH` | Points `BrandLogo=` at an external dynamic path (e.g. `/var/cache/multienv/brand-logo.svg`) |
| `--brand-logo-colorize` | Tints a monochrome `BrandLogo` SVG dynamically using the active `accent` token |
| `--motion-preset NAME` | Sets `MotionPreset` in `theme.conf` (19 supported presets) |
| `--motion-intensity LEVEL` | Sets `MotionIntensity` (`subtle`, `balanced`, `expressive`) |
| `--reduced-motion` | Sets `ReducedMotion=true` |
| `--session-aliases SPEC` | Sets `SessionAliases` (e.g. `Hyprland=Desktop`) |
| `--plymouth` | Installs the optional theme-adaptive `multienv-monolith` Plymouth theme and `multienv-plymouth-sync` |
| `--plymouth-only` | Installs only the Plymouth theme assets and `multienv-plymouth-sync` |
| `--activate-plymouth` | Runs `plymouth-set-default-theme -R multienv-monolith` after installation |

Example full installation with custom SVG branding and Plymouth boot/LUKS/shutdown theme:

```bash
./bin/multienv-install --user --theme --activate-theme \
  --brand "WORKSTATION" --brand-logo ./my-logo.svg --brand-logo-colorize \
  --plymouth --activate-plymouth
```

To refresh Plymouth and SDDM assets whenever your wallpaper or `colors.toml` changes:

```bash
sudo multienv-plymouth-sync --bg /path/to/wallpaper.png --colors-toml /path/to/colors.toml --brand "WORKSTATION"
```

## Post-Install Steps & Uninstall

Run `multienv generate-sessions`, `multienv validate`, and `multienv doctor` after reviewing `~/.config/multienv/multienv.toml`. Preimages and installed hashes are recorded in `<prefix>/share/arch-multienv/install/journal.json` (and `/var/lib/arch-multienv/theme/journal.json` for privileged assets).

`--uninstall` restores or removes unchanged files recorded in the ownership journal while preserving locally modified files, user profiles, session entries, and autologin settings.
