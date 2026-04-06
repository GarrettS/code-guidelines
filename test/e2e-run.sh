#!/usr/bin/env bash
# Runs a single e2e test command as the webxp-test user.
# Captures output to ~/tmp/codex-test-results.txt.
#
# Usage:
#   bash test/e2e-run.sh "run web-xp-check"
#   bash test/e2e-run.sh "run web-xp-init"
#
# Prerequisites:
#   - webxp-test user exists (one-time: sudo sysadminctl -addUser webxp-test -password <pw>)
#   - Web XP installed for webxp-test (one-time: see test/E2E-README.md)
#   - Auth token copied (one-time: sudo cp ~/.codex/auth.json /Users/webxp-test/.codex/auth.json)
#
# This script runs setup, executes the test, saves results, and runs teardown.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROMPT="${1:?Usage: bash test/e2e-run.sh \"prompt for codex\"}"
RESULTS="$HOME/tmp/codex-test-results.txt"

echo "=== E2E Setup ==="
sudo -u webxp-test -H bash "$REPO_ROOT/test/e2e-setup.sh"

echo ""
echo "=== Running: $PROMPT ==="
sudo -u webxp-test -H bash -c "cd ~/tmp/web-xp-test && codex exec --full-auto \"$PROMPT\"" 2>&1 | tee "$RESULTS"

echo ""
echo "=== E2E Teardown ==="
sudo -u webxp-test -H bash "$REPO_ROOT/test/e2e-teardown.sh"

echo ""
echo "Results saved to $RESULTS"
