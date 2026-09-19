#!/usr/bin/env bash
# Test configuration parsing and schema validation
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "=== Running Configuration Parser Tests ==="

CONFIG_FILE="$REPO_ROOT/config/multienv.toml.example"
echo "Testing parsing of default configuration: $CONFIG_FILE"

python3 -c "
import tomllib
with open('$CONFIG_FILE', 'rb') as f:
    cfg = tomllib.load(f)

assert 'general' in cfg, 'Missing [general] table'
assert 'environments' in cfg, 'Missing [environments] table'
assert 'environment-a' in cfg['environments'], 'Missing environment-a'
assert 'environment-b' in cfg['environments'], 'Missing environment-b'

env_a = cfg['environments']['environment-a']
assert env_a.get('name') == 'Environment A'
assert env_a.get('compositor') == 'hyprland'
assert 'config_path' in env_a
assert 'session_desktop' in env_a

print('Config parsed and validated successfully.')
"

echo "Configuration parser tests PASSED."
