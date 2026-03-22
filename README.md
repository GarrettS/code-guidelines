# Code Guidelines

Canonical vanilla-JS RIA doctrine for AI tools and human programmers. No frameworks, no build tools. Maximum readability and performance.
## What's Here

- **`code-guidelines.md`** — Operational rules, patterns, defaults, and constraints. What the code must look like.
- **`code-philosophy.md`** — Rationale, tradeoffs, and reasoning framework. Why the doctrine exists and how to think under it.

## How to Use

Copy `code-guidelines.md` and `code-philosophy.md` into your project root. Keep them as checked-in files — they are living documents that the project's contributors (human and AI) read on every task.

Project-specific decisions — directory structure, asset strategy, content authority, breakpoints, theming — belong in a **project overlay** file (e.g. `project.md`, `CLAUDE.md`, or a PRD), not in a fork of the doctrine. When an overlay overrides a doctrine default, it must state which rule is overridden and why.

## Workflow Strategy

These guidelines are designed for AI-assisted development where a human drives and the AI proposes. The workflow resembles XP-style pairing — the human reviews and edits every line the AI produces. The guidelines constrain the AI's output and give the human a shared vocabulary for directing corrections.

The guidelines are honed iteratively. When the AI produces an anti-pattern — a silent failure, a magic number, a speculative DOM cache — the fix is not just correcting the code. It is tightening the rule so the pattern does not recur. Each rule in the doctrine traces back to a specific failure observed during development. The commit history tells this story.

## Upstream / Downstream

- **Generalized improvements** to principles, patterns, or rules should be upstreamed back to this repo so all projects benefit.
- **Project-specific exceptions** stay in the project's overlay files. Do not pollute the doctrine with rules that only serve one codebase.

## Claude Code Skills

Two skills in `.claude/skills/` for structural doctrine review:

- **`/doctrine-check`** — Read-only audit. Runs mechanical pre-commit checks (if available), then reviews the current diff against doctrine patterns (Event Delegation, Active Object, Shared Key, Ancestor Class, Fail-Safe, etc.). Reports violations and opportunities without editing files.
- **`/doctrine-apply`** — Interactive refactoring. Walks through doctrine-check findings one at a time, presenting each proposed change for approval before editing.

Projects with the `.doctrine` submodule get these automatically. Projects without it can copy the `.claude/skills/` directory.

## Pre-commit Checks

`bin/pre-commit-check.sh` enforces mechanical doctrine checks: inline event handlers, hardcoded colors, junk-drawer filenames, loose equality, long lines, etc. It covers generalized checks only — project-specific checks (asset integrity, service worker manifests, PRD references) belong in the project's own script.
