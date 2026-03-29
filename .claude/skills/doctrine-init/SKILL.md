---
name: doctrine-init
description: "Set up a project with code standards. Trigger: 'set up project', 'initialize', 'create CLAUDE.md', 'add pre-commit', 'init doctrine'."
---

# Doctrine Init — Project Setup

Set up a project to use the web-app-code-standards skill.

## Procedure

### 1. Copy pre-commit script

If `bin/pre-commit-check.sh` does not exist in the project, copy it using `cp ${CLAUDE_SKILL_DIR}/../pre-commit-check.sh bin/pre-commit-check.sh`. Create `bin/` if needed.

If it already exists, report: "Pre-commit script already exists — skipping."

### 2. Create workflow contract

If no `CLAUDE.md` exists, create a starter. The content depends on how the project consumes the doctrine:

**Submodule consumer** (`.doctrine/` directory exists):

```markdown
# Claude Code — Project Contract

Read this file first on every task.

## On every session

If the task involves JS, HTML, or CSS, read `.doctrine/code-guidelines.md` before writing or reviewing code. Read `.doctrine/code-philosophy.md` for explanatory context when needed.

## Before every commit

1. Run `bash .doctrine/bin/pre-commit-check.sh` — catches mechanical violations.
2. Review the diff against Patterns and Fail-Safe in `.doctrine/code-guidelines.md`.
```

**Skill consumer** (no `.doctrine/` directory):

```markdown
# Claude Code — Project Contract

Read this file first on every task.

## On every session

If the task involves JS, HTML, or CSS, run `/doctrine` before writing or reviewing code.

## Before every commit

1. Run `/doctrine-check` — audit the diff against doctrine patterns.
2. Run `bash bin/pre-commit-check.sh` — catches mechanical violations.
```

If `CLAUDE.md` already exists, report: "CLAUDE.md already exists — skipping."

### 3. Report

Summarize what was created, copied, or skipped.
