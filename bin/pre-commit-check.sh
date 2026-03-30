#!/bin/bash
# Distributed to consuming projects by /web-xp-init.
# Canonical copy — also synced to .claude/skills/ by check-web-xp-sync.sh.
#
# pre-commit-check.sh
# Catches mechanical code-guideline violations that are greppable.
# This is a tripwire, not a review. Structural rules (Active Object pattern,
# event delegation, async .catch, fetch status checks) require manual
# inspection or /web-xp-check.
#
# Generalized checks only — project-specific checks (asset integrity,
# service worker, PRD references) belong in the project's own script.
#
# Usage: bash bin/pre-commit-check.sh
# Exit code 0 = clean, 1 = violations found.

set -euo pipefail

FAIL=0
WARN_COUNT=0
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

EXCLUDES="node_modules|\.git|pre-commit-check\.sh|code-guidelines\.md"

# $4 (optional): "overridable" — if set, a comment on the line above
# the match downgrades the hit from FAIL to WARN. A comment means the
# developer documented why the exception exists. Recognized comment
# forms: <!-- ... -->, // ..., /* ... */.
# Only enable for checks where code-guidelines.md acknowledges that
# documented exceptions are legitimate.
check() {
  local label="$1"
  local pattern="$2"
  local glob="$3"
  local overridable="${4:-}"
  local hits

  hits=$(grep -rn --include="$glob" -E "$pattern" . 2>/dev/null \
    | grep -Ev "$EXCLUDES" \
    || true)

  if [ -z "$hits" ]; then
    echo -e "${GREEN}PASS${NC}  $label"
    return
  fi

  # If overrides are not allowed for this check, all hits are failures.
  if [ "$overridable" != "overridable" ]; then
    echo -e "${RED}FAIL${NC}  $label"
    echo "$hits" | head -20
    echo ""
    FAIL=1
    return
  fi

  local fail_hits="" warn_hits=""

  while IFS= read -r hit; do
    local file line_num prev_line
    file=$(echo "$hit" | cut -d: -f1)
    line_num=$(echo "$hit" | cut -d: -f2)

    # Check the previous line for a comment
    if [ "$line_num" -gt 1 ]; then
      prev_line=$(sed -n "$((line_num - 1))p" "$file" 2>/dev/null || true)
    else
      prev_line=""
    fi

    if echo "$prev_line" | grep -qE '<!--|//|/\*'; then
      warn_hits="${warn_hits}${hit}
"
    else
      fail_hits="${fail_hits}${hit}
"
    fi
  done <<< "$hits"

  if [ -n "$fail_hits" ]; then
    echo -e "${RED}FAIL${NC}  $label"
    echo "$fail_hits" | head -20
    echo ""
    FAIL=1
  fi

  if [ -n "$warn_hits" ]; then
    echo -e "${YELLOW}WARN${NC}  $label  [commented exception]"
    echo "$warn_hits" | head -20
    echo ""
    WARN_COUNT=$((WARN_COUNT + 1))
  fi

  if [ -z "$fail_hits" ] && [ -z "$warn_hits" ]; then
    echo -e "${GREEN}PASS${NC}  $label"
  fi
}

echo "=== Pre-Commit Checks ==="
echo ""

# ---- HTML ----

check "Inline event handlers (onclick, onchange, etc.)" \
  '\bon(click|change|submit|keydown|keyup|keypress|focus|blur|load|mouse\w+)=' \
  '*.html'

check "javascript: pseudo-protocol" \
  'href\s*=\s*["'"'"']javascript:' \
  '*.html'

check "Inline <style> blocks" \
  '<style[ >]' \
  '*.html' \
  overridable

check "Self-closing slash on void elements" \
  '<(img|br|hr|input|meta|link|area|base|col|embed|source|track|wbr)\b[^>]*/>' \
  '*.html'

# ---- JS ----

check "fetch() in .js  [verify: caught and handled, not re-thrown]" \
  '\bfetch\(' \
  '*.js' \
  overridable

check "fetch() in .html  [verify: caught and handled, not re-thrown]" \
  '\bfetch\(' \
  '*.html' \
  overridable

check "JSON.parse() in .js  [verify: caught and handled, not re-thrown]" \
  'JSON\.parse\(' \
  '*.js' \
  overridable

check "JSON.parse() in .html  [verify: caught and handled, not re-thrown]" \
  'JSON\.parse\(' \
  '*.html' \
  overridable

check "throw in .js  [verify: not in production code path]" \
  '\bthrow\b' \
  '*.js' \
  overridable

check "throw in .html  [verify: not in production code path]" \
  '\bthrow\b' \
  '*.html' \
  overridable

check "return null/undefined in .js  [verify: not a silent failure]" \
  'return\s+(null|undefined)\s*;' \
  '*.js' \
  overridable

check "return null/undefined in .html  [verify: not a silent failure]" \
  'return\s+(null|undefined)\s*;' \
  '*.html' \
  overridable

check "innerHTML in .js  [verify justified — inserting HTML tags]" \
  '\.innerHTML\s*=' \
  '*.js' \
  overridable

check "innerHTML in .html  [verify justified — inserting HTML tags]" \
  '\.innerHTML\s*=' \
  '*.html' \
  overridable

check "Banner/landmark comments in JS" \
  '[═─━]{3,}|[*]{4,}' \
  '*.js'

check "var declaration  [prefer const/let]" \
  '(^|[^a-zA-Z])\bvar\b\s' \
  '*.js'

check "console.log/error/warn in JS" \
  '\bconsole\.(log|error|warn)\b' \
  '*.js' \
  overridable

check "debugger statement" \
  '\bdebugger\b' \
  '*.js'

check "alert() / eval() / document.write()" \
  '\b(alert|eval|document\.write)\s*\(' \
  '*.js'

check "Loose equality  [use === or !==]" \
  '[^!<>=]==[^=]|[^!]!=[^=]' \
  '*.js'

# ---- Line length (JS and CSS) ----

LONG_LINES=$(find . \( -name '*.js' -o -name '*.css' \) \
  | grep -Ev "$EXCLUDES" \
  | xargs awk 'length > 90 {print FILENAME ":" NR ": " $0}' \
  2>/dev/null | head -20 || true)

if [ -n "$LONG_LINES" ]; then
  echo -e "${RED}FAIL${NC}  Line length > 90 chars"
  echo "$LONG_LINES"
  echo ""
  FAIL=1
else
  echo -e "${GREEN}PASS${NC}  Line length (90 max)"
fi

# ---- Trailing whitespace ----

TRAILING=$(find . \( -name '*.js' -o -name '*.css' -o -name '*.html' \) \
  | grep -Ev "$EXCLUDES" \
  | xargs grep -Pn '\s+$' 2>/dev/null \
  | head -20 || true)

if [ -n "$TRAILING" ]; then
  echo -e "${RED}FAIL${NC}  Trailing whitespace"
  echo "$TRAILING"
  echo ""
  FAIL=1
else
  echo -e "${GREEN}PASS${NC}  No trailing whitespace"
fi

# ---- File names (JS and CSS) ----

JUNK_DRAWER=$(find . \( -name '*.js' -o -name '*.css' \) \
  | grep -Ev "$EXCLUDES" \
  | grep -iE '(util|helper|tool|misc|common|shared|lib|component)[s]?\.' \
  || true)

if [ -n "$JUNK_DRAWER" ]; then
  echo -e "${RED}FAIL${NC}  Junk-drawer file name  [name after domain concept, not role]"
  echo "$JUNK_DRAWER"
  echo ""
  FAIL=1
else
  echo -e "${GREEN}PASS${NC}  No junk-drawer file names"
fi

# ---- CSS ----

check "CSS missing space after colon" \
  '^\s+[a-z-]+:[^ /]' \
  '*.css'

check "Hardcoded hex color  [only valid inside :root definitions]" \
  '#[0-9a-fA-F]{3,8}' \
  '*.css' \
  overridable

check "Fixed px font-size  [use clamp() custom property]" \
  'font-size:\s*[0-9]+px' \
  '*.css' \
  overridable

check "Fixed rem font-size  [use clamp() custom property]" \
  'font-size:\s*[0-9]+(\.[0-9]+)?rem' \
  '*.css' \
  overridable

check "CDN font import" \
  'fonts\.googleapis\.com|fonts\.gstatic\.com' \
  '*.css' \
  overridable

check "Banner/landmark comments in CSS" \
  '[═─━]{3,}|[*]{4,}' \
  '*.css'

check "Leading zero on decimal  [use .5 not 0.5]" \
  '[ ,:;(]0\.[0-9]' \
  '*.css'

# ---- Summary ----

echo ""
if [ $FAIL -ne 0 ]; then
  echo -e "${RED}Items flagged for review.${NC}"
  echo "Not all flags are violations — review each in context."
  if [ $WARN_COUNT -gt 0 ]; then
    echo "$WARN_COUNT commented exception(s) acknowledged."
  fi
  echo "Structural rules require manual inspection (see /web-xp-check)."
  exit 1
else
  if [ $WARN_COUNT -gt 0 ]; then
    echo -e "${GREEN}All mechanical checks passed.${NC} $WARN_COUNT commented exception(s)."
  else
    echo -e "${GREEN}All mechanical checks passed.${NC}"
  fi
  echo "Structural rules require manual inspection (see /web-xp-check)."
  exit 0
fi
