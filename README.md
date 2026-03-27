# Code Guidelines

Canonical vanilla-JS RIA doctrine for AI tools and human programmers. No frameworks or build tools required. Maximum readability and performance.
## What's Here

- **`code-guidelines.md`** — Governing standards: principles, patterns, language rules, formatting.
- **`code-philosophy.md`** — Explanatory context: how and why the doctrine works, historical framing, and supporting examples.

## How to Use

Add this repo as a submodule. The doctrine files, skills, and pre-commit script live in your project, versioned and pinned. The AI reads the actual files — rules are enforceable across sessions and contributors.

    git submodule add https://github.com/GarrettS/code-guidelines.git .doctrine

The authoritative doctrine lives only in `.doctrine/`. Do not copy the files into the project root — a second editable copy drifts. The parent repo records which doctrine commit it is pinned to via the submodule ref.

Reference the doctrine from your project's workflow contract (e.g. `CLAUDE.md`):

    - **`.doctrine/code-guidelines.md`** — governing standards
    - **`.doctrine/code-philosophy.md`** — explanatory context

Project-specific decisions — directory structure, asset strategy, content authority, breakpoints, theming — belong in a **project overlay** file (e.g. `project.md`, `CLAUDE.md`, or a PRD), not in a fork of the doctrine. When an overlay overrides a doctrine default, it must state which rule is overridden and why.

## Workflow Strategy

These guidelines are designed for AI-assisted development where a human drives and the AI proposes. The workflow resembles XP-style pairing — the human reviews and edits every line the AI produces. The guidelines constrain the AI's output and give the human a shared vocabulary for directing corrections. Keep auto-approve off — every file edit, shell command, and commit should require explicit approval. Auto-approve defeats the review loop that makes the pairing work.

Hone the guidelines iteratively. When the AI produces an anti-pattern — a silent failure, a magic number, a speculative DOM cache — do not just correct the code. Tighten the rule so the pattern does not recur. Each rule in the doctrine traces back to a specific failure observed during development.

## Authoring and Sync

Changing the doctrine and updating a project to use that change are separate steps.

**Doctrine side.** A doctrine maintainer edits files in the `.doctrine/` working tree (or any clone of the canonical repo), commits, and pushes to the code-guidelines repository. Other clones of the canonical repo — standalone checkouts, other projects' submodules — pull to receive updates.

**Project side.** A project that includes the doctrine as a submodule records a specific doctrine commit. To adopt a new doctrine revision, pull inside `.doctrine/`, then run `git add .doctrine` in the parent repo and commit. Whether that parent commit requires review is a team and process decision — the doctrine does not prescribe it.

## Upstream / Downstream

- **Generalized improvements** to principles, patterns, or rules should be upstreamed back to this repo so all projects benefit.
- **Project-specific exceptions** stay in the project's overlay files. Do not pollute the doctrine with rules that only serve one codebase.

## Skills

Five skills in `.claude/skills/`, available to projects that include this repo as a submodule:

- **`/doctrine`** — Loads the CG as governing constraints for the current session. Uses CP for explanatory context, not as a second rules file.
- **`/doctrine-init`** — Project setup. Creates starter CLAUDE.md and pre-commit script.
- **`/doctrine-check`** — Read-only audit. Runs mechanical pre-commit checks, then reviews the current diff against doctrine patterns.
- **`/doctrine-apply`** — Interactive refactoring. Walks through findings one at a time with approval.
- **`/doctrine-review`** — Evaluate any code against the doctrine. Works on pasted snippets, file paths, or framework code.

## Pre-commit Checks

`bin/pre-commit-check.sh` enforces mechanical doctrine checks: inline event handlers, hardcoded colors, junk-drawer filenames, loose equality, long lines, etc. It covers generalized checks only — project-specific checks (asset integrity, service worker manifests, PRD references) belong in the project's own script.
