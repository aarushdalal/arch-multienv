#!/usr/bin/env bash
# Master test suite runner for arch-multienv
set -euo pipefail

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "=================================================================="
echo "          Running Arch Multi-Environment Test Suite               "
echo "=================================================================="

"$TEST_DIR/test_syntax.sh"
echo ""

"$TEST_DIR/test_config_parser.sh"
echo ""

"$TEST_DIR/test_switching_logic.sh"
echo ""

"$TEST_DIR/test_failure_modes.sh"
echo ""

"$TEST_DIR/test_clean_room.sh"
echo ""

echo "=================================================================="
echo "          ALL TESTS PASSED SUCCESSFULLY!                          "
echo "=================================================================="
