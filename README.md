# Code Guidelines

Canonical vanilla-JS RIA doctrine for AI tools and human programmers. No frameworks, no build tools. Maximum readability and performance.
## What's Here

- **`code-guidelines.md`** — Governing standards: principles, patterns, language rules, formatting.
- **`code-philosophy.md`** — Explanatory context: how and why the doctrine works, historical framing, and supporting examples.

## How to Use

Two paths, depending on how far you want to go.

**Use a skill** to get doctrine guidance in an AI coding session without adopting the full submodule. Copy the skill folder from `.claude/skills/` in this repo into your project's `.claude/skills/` directory, then invoke it in Claude Code:

- `/doctrine` — Loads the CG as governing constraints for the session. Good for trying the doctrine out, or for repos you don't own.
- `/doctrine-review` — Evaluates code you paste or point to against the doctrine. Shows vanilla equivalents for framework code. Good for learning or comparing approaches.
- `/doctrine-check` — Audits your current diff against doctrine patterns. Good for pre-commit review.

No other files needed. Nothing persists between sessions.

**Use the submodule** to adopt the doctrine in a project. The files live in your repo, versioned and pinned. Skills, pre-commit script, and both doctrine documents come bundled. The AI reads the actual files — rules are enforceable across sessions and contributors.

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

## Claude Code Skills

Five skills in `.claude/skills/`:

- **`/doctrine-init`** — Project setup. Copies doctrine files, creates pre-commit script and starter CLAUDE.md.
- **`/doctrine`** — Inline reference. Loads the CG as governing constraints for the current session. Uses CP for explanatory context, not as a second rules file.
- **`/doctrine-check`** — Read-only audit. Runs mechanical pre-commit checks, then reviews the current diff against doctrine patterns. Reports violations and opportunities without editing.
- **`/doctrine-apply`** — Interactive refactoring. Walks through doctrine-check findings one at a time, presenting each proposed change for approval before editing.
- **`/doctrine-review`** — Evaluate any code against the doctrine. Works on pasted snippets, file paths, or framework code. Shows vanilla equivalents side by side.

Projects with the `.doctrine` submodule get these automatically.

## Pre-commit Checks

`bin/pre-commit-check.sh` enforces mechanical doctrine checks: inline event handlers, hardcoded colors, junk-drawer filenames, loose equality, long lines, etc. It covers generalized checks only — project-specific checks (asset integrity, service worker manifests, PRD references) belong in the project's own script.
