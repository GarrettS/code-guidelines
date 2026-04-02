---
name: web-xp-remove
description: Remove Web XP from the current Codex project by deleting the managed block from CODEX.md or removing the file if it only contains Web XP. Trigger when the user says "web-xp-remove", asks to remove Web XP from a project, uninstall Web XP from the local project, or clean up CODEX.md.
---

# Web XP Remove — Codex Project Cleanup

Remove Web XP from the current project for Codex.

## Procedure

### 1. Verify Web XP is installed

Check that `~/.web-xp/` exists. If it does not exist, report: "Web XP is not installed at `~/.web-xp`." and stop.

### 2. Delegate to the canonical cleanup script

Run:

```bash
~/.web-xp/bin/web-xp-remove codex
```

That script is the canonical implementation for removing the Web XP-managed block from the project-local `CODEX.md` contract, or removing the file entirely if it only contains Web XP.

### 3. Report

Summarize what the script removed or updated.
