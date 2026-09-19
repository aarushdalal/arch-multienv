# Environment Configuration & Management

All environments are defined centrally in `~/.config/multienv/multienv.toml` (or `/etc/multienv/multienv.toml`).

## 1. Defining a New Environment

To add a new environment (e.g., `gaming` or `focused`):

1. **Create the Environment Directory**:
   ```bash
   mkdir -p ~/.config/multienv/environments/gaming
   ```

2. **Create the Compositor Configuration** (`hyprland.conf`):
   ```ini
   # ~/.config/multienv/environments/gaming/hyprland.conf
   monitor=,preferred,auto,1.0
   general {
       gaps_in = 0
       gaps_out = 0
       border_size = 1
   }
   # Keybindings, input, and decorations
   ```

3. **Register in `multienv.toml`**:
   ```toml
   [environments.gaming]
   name = "Gaming & Performance"
   description = "Zero-overhead gaming environment with native 1.0 scale"
   compositor = "hyprland"
   config_path = "~/.config/multienv/environments/gaming/hyprland.conf"
   desktop_names = "Hyprland:Gaming"
   session_desktop = "multienv-gaming.desktop"
   display_scale = 1.0
   color_accent = "#e06c75"
   ```

4. **Generate the Wayland Session Desktop Entry**:
   ```bash
   multienv generate-sessions
   ```

5. **Validate Configuration**:
   ```bash
   multienv validate gaming
   ```

---

## 2. Modifying Existing Environments

- **Targeted Edits**: Only edit files inside `~/.config/multienv/environments/<target-id>/`.
- **Verify Syntax**: After editing, always run `multienv validate <target-id>` or `Hyprland --verify-config --config <path>`.
- **Compositor Live Reload**: If modifying the currently active environment, reload live via `hyprctl reload`.
