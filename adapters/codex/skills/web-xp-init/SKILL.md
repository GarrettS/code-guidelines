---
name: web-xp-init
description: Create or update a project's CODEX.md contract for Web XP. Trigger when the user says "web-xp-init", asks to initialize Web XP in a Codex project, create CODEX.md, or update the Web XP project contract.
---

# Web XP Init — Codex Project Setup

Set up or update the current project to use Web XP with Codex.

## Procedure

### 1. Verify Web XP is installed

Check that `~/.web-xp/` exists. If it does not exist, report: "Install Web XP first: `git clone https://github.com/GarrettS/web-xp.git ~/.web-xp && ~/.web-xp/bin/install.sh`" and stop.

### 2. Delegate to the canonical bootstrap script

Run:

```bash
~/.web-xp/bin/web-xp-init codex
```

That script is the canonical implementation for creating or updating the project-local `CODEX.md` contract. Do not reimplement the bootstrap logic in this skill.

### 3. Report

Summarize what the script created or updated.
