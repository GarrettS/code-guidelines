#!/usr/bin/env bash
# Cleans Codex session state for the webxp-test user.
# Run before and after e2e tests to ensure a clean slate.
#
# Usage: sudo -u webxp-test -H bash test/webxp-test-user-clean-settings.sh
#
# Preserves directory structure (Codex may expect dirs to exist)
# but removes all files within them.

set -euo pipefail

echo "Cleaning Codex session state for $(whoami)..."

# Remove session file contents but keep directory structure
find ~/.codex/sessions -type f -delete 2>/dev/null || true
find ~/.codex/memories -type f -delete 2>/dev/null || true
find ~/.codex/shell_snapshots -type f -delete 2>/dev/null || true

# Remove state files (Codex recreates these on startup)
rm -f ~/.codex/history.jsonl
rm -f ~/.codex/state_5.sqlite
rm -f ~/.codex/state_5.sqlite-shm
rm -f ~/.codex/state_5.sqlite-wal

echo "Done. Clean Codex state."
echo "Directories preserved, file contents removed."
