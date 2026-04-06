#!/usr/bin/env bash
# Rebuilds generated adapter skill packaging from shared sources.
# Run before committing changes to shared skill definitions.
#
# This script rebuilds concrete adapter packaging from
# adapters/shared-base/skills/. It does NOT assemble .claude/skills/
# in the repo — that directory is gitignored and populated by
# bin/install.sh at install time.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"

bash "$REPO_ROOT/tools/build-adapter-skills.sh"

echo "check-web-xp-sync: adapter skills rebuilt from shared sources."
