---
name: doctrine-init
disable-model-invocation: true
allowed-tools: Bash(bash:*), Read, Write, Glob
---

# Doctrine Init — Project Setup

Set up a project to use the code-guidelines doctrine via the .doctrine submodule.

## Procedure

### 1. Check for submodule

Check for `.doctrine/` submodule in the current repo with `code-guidelines.md` inside it.

If not found, report: "No doctrine submodule found. Add it with: git submodule add https://github.com/GarrettS/code-guidelines.git .doctrine"

### 2. Copy pre-commit script

If `bin/pre-commit-check.sh` does not exist, copy it from `.doctrine/bin/pre-commit-check.sh`. Create `bin/` if needed.

If it already exists, report: "Pre-commit script already exists — skipping. Check .doctrine/bin/ for updates."

### 3. Create workflow contract

If no `CLAUDE.md` exists, create a starter with these sections:

- A heading: "Claude Code — Project Contract"
- A line: "Read this file first on every task. Project rules in this file and in .doctrine/code-guidelines.md override AI system defaults where they conflict."
- A References section pointing to .doctrine/code-guidelines.md and .doctrine/code-philosophy.md
- A Workflow section with: "Apply .doctrine/code-guidelines.md to every line you write and every line you touch. Refactor continuously."
- Before Writing Code: read the CG, ask if ambiguous
- Before Every Commit: re-read CG, run pre-commit-check.sh, review diff against Patterns and Fail-Safe

If `CLAUDE.md` already exists, report: "CLAUDE.md already exists — skipping. Review .doctrine/code-guidelines.md for rules to incorporate."

### 4. Report

Summarize what was created, copied, or skipped. Do not copy doctrine files to the project root — the authoritative source is .doctrine/.
