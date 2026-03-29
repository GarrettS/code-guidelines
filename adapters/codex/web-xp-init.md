# Web XP Init — Project Setup

Set up a project to use Web XP with Codex.

## Procedure

### 1. Copy pre-commit script

If `bin/pre-commit-check.sh` does not exist in the project, copy it from the Web XP source. Create `bin/` if needed.

If it already exists: "Pre-commit script already exists — skipping."

### 2. Create project contract

If no `AGENTS.md` exists, create one. The content depends on how the project consumes Web XP:

**Submodule consumer** (`.web-xp/` directory exists):

Use the template from `AGENTS.submodule.example.md`.

**Spec file consumer** (no `.web-xp/` directory):

Use the template from `AGENTS.skill.example.md`.

If `AGENTS.md` already exists: "AGENTS.md already exists — skipping."

### 3. Report

Summarize what was created, copied, or skipped.
