#!/usr/bin/env bash
# dev-relay.sh — Local watcher/driver for agent handoff relay
#
# Watches the handoff files and notifies when either agent has
# new messages waiting. Reduces the "check your inbox" manual relay.
#
# Usage:
#   bash contrib/smux/dev-relay.sh [--interval SECONDS]
#
# Default poll interval: 3 seconds
#
# Expects to run from the repo root (where agent-handoff/ lives).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CLAUDE_INBOX="$REPO_ROOT/agent-handoff/codex-to-claude.md"
CODEX_INBOX="$REPO_ROOT/agent-handoff/claude-to-codex.md"
STATE_DIR="$REPO_ROOT/.dev-relay"
INTERVAL=3

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --interval)
      if [[ $# -lt 2 || "$2" =~ ^- ]]; then
        echo "Error: --interval requires a numeric value" >&2; exit 1
      fi
      INTERVAL="$2"; shift 2
      ;;
    --help|-h)
      echo "Usage: bash contrib/smux/dev-relay.sh [--interval SECONDS]"
      echo "  Watches agent-handoff files and notifies on changes."
      echo "  Default interval: 3 seconds."
      exit 0
      ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

# Ensure handoff files exist (they're gitignored, may not exist yet)
mkdir -p "$REPO_ROOT/agent-handoff"
touch "$CLAUDE_INBOX" "$CODEX_INBOX"

# State tracking — store last-seen checksums
mkdir -p "$STATE_DIR"
CLAUDE_HASH_FILE="$STATE_DIR/claude-inbox.hash"
CODEX_HASH_FILE="$STATE_DIR/codex-inbox.hash"

file_hash() {
  # Use md5 on macOS, md5sum on Linux
  if command -v md5 &>/dev/null; then
    md5 -q "$1" 2>/dev/null || echo "empty"
  elif command -v md5sum &>/dev/null; then
    md5sum "$1" 2>/dev/null | cut -d' ' -f1 || echo "empty"
  else
    # Fallback: use file size + mtime
    stat -f '%z-%m' "$1" 2>/dev/null || stat -c '%s-%Y' "$1" 2>/dev/null || echo "empty"
  fi
}

save_hash() {
  local file="$1" hash_file="$2"
  file_hash "$file" > "$hash_file"
}

has_changed() {
  local file="$1" hash_file="$2"
  local current_hash
  current_hash="$(file_hash "$file")"

  if [[ ! -f "$hash_file" ]]; then
    return 0  # No previous state = treat as changed
  fi

  local saved_hash
  saved_hash="$(cat "$hash_file")"

  [[ "$current_hash" != "$saved_hash" ]]
}

last_heading() {
  # Extract the last ## heading from a handoff file
  grep '^## ' "$1" 2>/dev/null | tail -1 | sed 's/^## //'
}

notify() {
  local side="$1" file="$2" heading="$3"
  local ts
  ts="$(date '+%H:%M:%S')"
  local label

  if [[ "$side" == "claude" ]]; then
    label="CLAUDE has mail"
  else
    label="CODEX has mail"
  fi

  echo "[$ts] $label — $heading"

  # macOS notification (non-blocking, best-effort — heading is sanitized
  # to prevent AppleScript injection from quotes in markdown headings)
  if command -v osascript &>/dev/null; then
    local safe_heading safe_label
    safe_heading="${heading//\"/\\\"}"
    safe_label="${label//\"/\\\"}"
    osascript -e "display notification \"$safe_heading\" with title \"dev-relay: $safe_label\"" 2>/dev/null || true
  fi
}

# Initialize state on first run (don't notify for existing content)
if [[ ! -f "$CLAUDE_HASH_FILE" ]]; then
  save_hash "$CLAUDE_INBOX" "$CLAUDE_HASH_FILE"
fi
if [[ ! -f "$CODEX_HASH_FILE" ]]; then
  save_hash "$CODEX_INBOX" "$CODEX_HASH_FILE"
fi

echo "dev-relay: watching agent-handoff/ (poll every ${INTERVAL}s)"
echo "  Claude inbox: $CLAUDE_INBOX"
echo "  Codex inbox:  $CODEX_INBOX"
echo "  Ctrl-C to stop"
echo ""

# Main loop
while true; do
  if has_changed "$CLAUDE_INBOX" "$CLAUDE_HASH_FILE"; then
    heading="$(last_heading "$CLAUDE_INBOX")"
    notify "claude" "$CLAUDE_INBOX" "${heading:-new message}"
    save_hash "$CLAUDE_INBOX" "$CLAUDE_HASH_FILE"
  fi

  if has_changed "$CODEX_INBOX" "$CODEX_HASH_FILE"; then
    heading="$(last_heading "$CODEX_INBOX")"
    notify "codex" "$CODEX_INBOX" "${heading:-new message}"
    save_hash "$CODEX_INBOX" "$CODEX_HASH_FILE"
  fi

  sleep "$INTERVAL"
done
