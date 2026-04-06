#!/usr/bin/env bash
# Sets up a clean test project for the webxp-test user.
# Run as: sudo -u webxp-test -H bash test/e2e-setup.sh
#
# Cleans Codex state, creates a fresh git project with bad code fixtures.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEST_DIR="$HOME/tmp/web-xp-test"

# Clean Codex session state
bash "$REPO_ROOT/test/webxp-test-user-clean-settings.sh"

# Create fresh test project
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cp "$REPO_ROOT/test/badcode-test-website/index.html" "$TEST_DIR/"
cp "$REPO_ROOT/test/badcode-test-website/app.js" "$TEST_DIR/"
cd "$TEST_DIR"
git init
git add .
git commit -m "initial"
echo "// touched" >> app.js

echo "Test project ready at $TEST_DIR"
echo "Unstaged diff in app.js for web-xp-check."
