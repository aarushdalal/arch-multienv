#!/usr/bin/env bash
# Teardown hook for Environment A
echo "Environment A tearing down: $(date)" >> "${XDG_STATE_HOME:-$HOME/.local/state}/multienv-env-a.log"
