#!/usr/bin/env bash
# Test syntax of all shell scripts and python scripts
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "=== Running Syntax Checks ==="

echo "1. Checking Shell Scripts with bash -n..."
while IFS= read -r -d '' file; do
    if [[ "$file" == *.sh ]]; then
        echo "   Checking bash: $file"
        bash -n "$file"
    elif [[ -x "$file" && ! "$file" == *.py ]]; then
        first_line=$(head -n 1 "$file" 2>/dev/null || true)
        if [[ "$first_line" =~ (bash|sh) ]]; then
            echo "   Checking bash: $file"
            bash -n "$file"
        fi
    fi
done < <(find "$REPO_ROOT" -type f ! -path "*/.git/*" -print0)

echo "2. Checking Python scripts..."
while IFS= read -r -d '' file; do
    if [[ "$file" == *.py ]]; then
        echo "   Compiling python: $file"
        python3 -m py_compile "$file"
    elif [[ -x "$file" ]]; then
        first_line=$(head -n 1 "$file" 2>/dev/null || true)
        if [[ "$first_line" =~ python ]]; then
            echo "   Compiling python: $file"
            python3 -m py_compile "$file"
        fi
    fi
done < <(find "$REPO_ROOT" -type f ! -path "*/.git/*" -print0)

echo "Syntax checks PASSED."
