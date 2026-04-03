#!/usr/bin/env bash
# Post-clone / post-pull install for Web XP.
# Copies Claude skill files into ~/.claude/skills/.

set -euo pipefail

WEB_XP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_SRC="${WEB_XP_DIR}/.claude/skills"
SKILLS_DEST="${HOME}/.claude/skills"
CODEX_SKILL_SRC="${WEB_XP_DIR}/adapters/codex/skills/web-xp-init"
CODEX_SKILL_DEST="${HOME}/.agents/skills/web-xp-init"
CODEX_REMOVE_SKILL_SRC="${WEB_XP_DIR}/adapters/codex/skills/web-xp-remove"
CODEX_REMOVE_SKILL_DEST="${HOME}/.agents/skills/web-xp-remove"

if [ ! -d "$SKILLS_SRC" ]; then
  echo "error: skill source not found at ${SKILLS_SRC}" >&2
  exit 1
fi

mkdir -p "$SKILLS_DEST"
cp -r "$SKILLS_SRC"/* "$SKILLS_DEST"/

mkdir -p "$(dirname "$CODEX_SKILL_DEST")"
rm -rf "$CODEX_SKILL_DEST"
cp -r "$CODEX_SKILL_SRC" "$CODEX_SKILL_DEST"
rm -rf "$CODEX_REMOVE_SKILL_DEST"
cp -r "$CODEX_REMOVE_SKILL_SRC" "$CODEX_REMOVE_SKILL_DEST"

echo "Web XP skills installed to ${SKILLS_DEST}"
echo "Web XP bootstrap command available at ${WEB_XP_DIR}/bin/web-xp-init"
echo "Web XP project cleanup command available at ${WEB_XP_DIR}/bin/web-xp-remove"
echo "Codex bootstrap skill installed to ${CODEX_SKILL_DEST}"
echo "Codex project cleanup skill installed to ${CODEX_REMOVE_SKILL_DEST}"
