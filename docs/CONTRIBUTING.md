# Contributing Guidelines

We welcome contributions to `arch-multienv`!

## 1. Principles
- **No Machine-Specific Assumptions**: All code, examples, and documentation must use portable variables (`$HOME`, `$XDG_CONFIG_HOME`, `~`). Never hardcode usernames, hostnames, or hardware IDs.
- **Defensive Shell Scripting**: Shell scripts must pass `bash -n`, use `set -uo pipefail`, and handle signals cleanly.
- **Safe Fallbacks**: Any tool mutating display manager configuration must provide safe rollbacks and validate inputs before writing.

## 2. Development Workflow
1. Fork and clone the repository.
2. Make your modifications on a feature branch.
3. Run the automated test suite:
   ```bash
   ./tests/run_all_tests.sh
   ```
4. Verify that no private data or secrets are present:
   ```bash
   ./tests/test_clean_room.sh
   ```
5. Submit a clear, well-documented pull request.
