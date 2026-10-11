#!/usr/bin/env bash
# Audit the codebase for personal identifiers, machine names, hardcoded paths, or credentials
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "=== Running Clean-Room Privacy & Sanitization Audit ==="

FORBIDDEN_TERMS=(
    "daemon0"
    "DaemonOS"
    "daemon-os"
    "/home/""daemon0"
    "nvme0n1p"
    "omarchy-cloud-sync"
    "DAEMONOS_BACKUP"
    "ghp_"
    "gho_"
)

FAILED=0
for term in "${FORBIDDEN_TERMS[@]}"; do
    echo "Checking for pattern: '$term'..."
    # Search tracked text files excluding git and RELEASE_MANIFEST (where excluded items are noted)
    MATCHES=$(grep -rn -I --exclude-dir=".git" --exclude="RELEASE_MANIFEST.md" --exclude="test_clean_room.sh" "$term" "$REPO_ROOT" || true)
    if [[ -n "$MATCHES" ]]; then
        echo "[VIOLATION] Found forbidden pattern '$term' in:" >&2
        echo "$MATCHES" >&2
        FAILED=1
    fi
done

if [[ $FAILED -eq 1 ]]; then
    echo "Clean-room audit FAILED: personal or machine-specific data detected!" >&2
    exit 1
fi

echo "Clean-room audit PASSED: Zero personal identifiers, host paths, or tokens found."
