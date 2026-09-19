#!/usr/bin/env bash
# Teardown hook for Environment B
echo "Environment B tearing down: $(date)" >> "${XDG_STATE_HOME:-$HOME/.local/state}/multienv-env-b.log"
