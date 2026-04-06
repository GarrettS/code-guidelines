#!/usr/bin/env bash
# Tears down the test project and cleans Codex state for webxp-test user.
# Run as: sudo -u webxp-test -H bash test/e2e-teardown.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEST_DIR="$HOME/tmp/web-xp-test"

# Remove test project (includes any CODEX.md/CLAUDE.md created during tests)
rm -rf "$TEST_DIR"

# Clean Codex session state so no test residue persists
bash "$REPO_ROOT/test/webxp-test-user-clean-settings.sh"

echo "Test project removed. Codex state cleaned."
