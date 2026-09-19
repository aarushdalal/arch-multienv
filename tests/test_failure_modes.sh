#!/usr/bin/env bash
# Test failure handling: invalid configs must be rejected and not corrupt active state
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SANDBOX="$REPO_ROOT/tests/sandbox"
mkdir -p "$SANDBOX/etc/sddm.conf.d" "$SANDBOX/sessions" "$SANDBOX/state"

echo "=== Running Failure Modes & Safety Tests ==="

MOCK_CONFIG="$SANDBOX/multienv-fail.toml"
cat << TOML > "$MOCK_CONFIG"
[general]
default_environment = "valid-env"
sddm_autologin_path = "$SANDBOX/etc/sddm.conf.d/autologin.conf"
wayland_sessions_dir = "$SANDBOX/sessions"
state_dir = "$SANDBOX/state"
autologin_user = "testuser"
confirm_logout = false

[environments.valid-env]
name = "Valid Environment"
compositor = "hyprland"
config_path = "$SANDBOX/valid.conf"
session_desktop = "valid.desktop"

[environments.broken-env]
name = "Broken Environment"
compositor = "hyprland"
config_path = "$SANDBOX/NONEXISTENT.conf"
session_desktop = "NONEXISTENT.desktop"
TOML

touch "$SANDBOX/valid.conf"
touch "$SANDBOX/sessions/valid.desktop"

CLI="$REPO_ROOT/bin/multienv"

echo "1. Setting initial valid state..."
"$CLI" --config "$MOCK_CONFIG" switch valid-env --no-prompt
grep -q "Session=valid.desktop" "$SANDBOX/etc/sddm.conf.d/autologin.conf"

echo "2. Attempting to switch to broken environment (must be rejected)..."
set +e
"$CLI" --config "$MOCK_CONFIG" switch broken-env --no-prompt >/dev/null 2>&1
SWITCH_STATUS=$?
set -e

if [[ $SWITCH_STATUS -eq 0 ]]; then
    echo "Error: Switch to broken environment should have failed!" >&2
    exit 1
fi
echo "   Switch rejected as expected (exit code: $SWITCH_STATUS)."

echo "3. Verifying that active autologin configuration was NOT corrupted..."
grep -q "Session=valid.desktop" "$SANDBOX/etc/sddm.conf.d/autologin.conf"
echo "   Active configuration preserved intact."

# Cleanup sandbox artifacts
rm -rf "$SANDBOX"/*

echo "Failure modes tests PASSED."
