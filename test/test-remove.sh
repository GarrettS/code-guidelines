#!/usr/bin/env bash
# Internal maintainer regression coverage for Web XP project removal.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INIT_SCRIPT="$REPO_ROOT/bin/web-xp-on"
REMOVE_SCRIPT="$REPO_ROOT/bin/web-xp-off"

pass_count=0

pass() {
  pass_count=$((pass_count + 1))
  echo "ok - $1"
}

fail() {
  echo "not ok - $1" >&2
  exit 1
}

assert_contains() {
  local file="$1"
  local needle="$2"
  grep -Fq "$needle" "$file" || fail "$file does not contain: $needle"
}

assert_not_contains() {
  local file="$1"
  local needle="$2"
  if [ -f "$file" ] && grep -Fq "$needle" "$file"; then
    fail "$file still contains: $needle"
  fi
}

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

(
  cd "$tmpdir"
  bash "$INIT_SCRIPT" > /dev/null
  bash "$REMOVE_SCRIPT" all > /dev/null
  [ ! -e CLAUDE.md ] || fail "CLAUDE.md should be removed when it only contains Web XP"
  [ ! -e CODEX.md ] || fail "CODEX.md should be removed when it only contains Web XP"
)
pass "removes contract files that only contain Web XP"

(
  cd "$tmpdir"
  cat > CLAUDE.md <<'EOF'
# Local Notes

Keep this content.
EOF
  bash "$INIT_SCRIPT" claude > /dev/null
  bash "$REMOVE_SCRIPT" claude > /dev/null
  [ -f CLAUDE.md ] || fail "CLAUDE.md should remain when local content exists"
  assert_contains CLAUDE.md '# Local Notes'
  assert_contains CLAUDE.md 'Keep this content.'
  assert_not_contains CLAUDE.md '<!-- BEGIN WEB-XP: managed block. Edit outside this block. Changes inside may be replaced by Web XP commands. -->'
)
pass "removes only the managed block when local content exists"

(
  cd "$tmpdir"
  bash "$REMOVE_SCRIPT" codex >stdout.txt
  assert_contains stdout.txt 'no CODEX.md'
)
pass "reports missing contract cleanly"

echo "$pass_count passed, 0 failed"
