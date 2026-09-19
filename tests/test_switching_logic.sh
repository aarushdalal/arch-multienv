#!/usr/bin/env bash
# Test switching logic and autologin mutation inside an isolated sandbox
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SANDBOX="$REPO_ROOT/tests/sandbox"
mkdir -p "$SANDBOX/etc/sddm.conf.d" "$SANDBOX/sessions" "$SANDBOX/state"

echo "=== Running Switching Logic Sandbox Tests ==="

# Create mock session desktop files
cat << 'DESK' > "$SANDBOX/sessions/multienv-env-a.desktop"
[Desktop Entry]
Name=Environment A
Exec=/usr/local/bin/multienv-session env-a
DESK

cat << 'DESK' > "$SANDBOX/sessions/multienv-env-b.desktop"
[Desktop Entry]
Name=Environment B
Exec=/usr/local/bin/multienv-session env-b
DESK

# Create mock config
MOCK_CONFIG="$SANDBOX/multienv.toml"
cat << TOML > "$MOCK_CONFIG"
[general]
default_environment = "env-a"
sddm_autologin_path = "$SANDBOX/etc/sddm.conf.d/autologin.conf"
wayland_sessions_dir = "$SANDBOX/sessions"
state_dir = "$SANDBOX/state"
autologin_user = "testuser"
confirm_logout = false

[environments.env-a]
name = "Environment A"
compositor = "hyprland"
config_path = "$SANDBOX/env-a.conf"
session_desktop = "multienv-env-a.desktop"

[environments.env-b]
name = "Environment B"
compositor = "hyprland"
config_path = "$SANDBOX/env-b.conf"
session_desktop = "multienv-env-b.desktop"
TOML

touch "$SANDBOX/env-a.conf" "$SANDBOX/env-b.conf"

CLI="$REPO_ROOT/bin/multienv"

echo "1. Testing switch to env-b (A -> B)..."
"$CLI" --config "$MOCK_CONFIG" switch env-b --no-prompt

grep -q "Session=multienv-env-b.desktop" "$SANDBOX/etc/sddm.conf.d/autologin.conf"
grep -q "User=testuser" "$SANDBOX/etc/sddm.conf.d/autologin.conf"
echo "   Switch to B verified."

echo "2. Testing switch to env-a (B -> A)..."
"$CLI" --config "$MOCK_CONFIG" switch env-a --no-prompt

grep -q "Session=multienv-env-a.desktop" "$SANDBOX/etc/sddm.conf.d/autologin.conf"
grep -q "User=testuser" "$SANDBOX/etc/sddm.conf.d/autologin.conf"
echo "   Switch to A verified."

echo "3. Testing fallback reset..."
"$CLI" --config "$MOCK_CONFIG" fallback
if [[ -f "$SANDBOX/etc/sddm.conf.d/autologin.conf" ]]; then
    echo "Error: autologin.conf was not removed by fallback" >&2
    exit 1
fi
echo "   Fallback successfully removed autologin target."

# Cleanup sandbox artifacts
rm -rf "$SANDBOX"/*

echo "Switching logic tests PASSED."
