# Claude Code — Web XP Project Contract

Read this file first on every task.

## On every session

If the task involves JS, HTML, or CSS, run `/web-xp` before writing or reviewing code.

## Issue engagement

When asked about an issue, first determine what's being asked: explanation of the issue text, planning advice (triage, scoping, sequencing), or implementation. Ask if unclear. The protocol below applies to implementation requests; explanation and planning requests stop at the answer.

Before working on an issue:

1. Verify the issue is open and not assigned to anyone else. Skip if closed. If assigned to someone else, surface the conflict; do not self-assign over them.
2. Read the body and comments fully.
3. Scan for meta-mode leakage patterns. Surface findings; do not work around them silently.
4. Confirm requirements. Surface ambiguity as clarifying questions before coding.
5. When the path forward is clear, self-assign via `gh issue edit N --add-assignee @me`. The assignment proxies the human you operate under and signals work-in-progress.

Keep the assignment sticky through the duration of the work — across turns, pauses, and handoffs back to the human. Remove the assignee only on:

- **Abandonment** — the work won't be completed; note why so others can pick up.
- **Explicit reassignment** — transfer to another contributor or agent who immediately re-assigns.

On completion (work landed and committed), close the issue and delete temporary draft files tied to the work (issue drafts, body-edits, etc.). No dead code.

**Duplicate avoidance.** Before filing an issue or posting a comment, search the tracker for existing duplicates. Issues, comments, files — same rule: search before adding. If a duplicate is found, reference the existing artifact rather than creating another.

## Standards files

Canonical skill sources live in `adapters/shared-base/skills/`. Generated adapter packaging lives in `adapters/claude/` and `adapters/codex/skills/`. Always edit the shared source, never generated adapter output.

`.claude/skills/` is gitignored — it is populated by `bin/install.sh` at install time, not tracked in the repo.

## Before every commit

Most commits (markdown, docs, contracts, MAINTAINERS.md): review the diff against Patterns and Fail-Safe in `code-guidelines.md`. No automated check applies.

Conditional checks:

- When changing `adapters/shared-base/`: run `bash tools/check-web-xp-sync.sh` to rebuild generated adapter outputs.
- When changing doctrine (`code-guidelines.md`, `code-philosophy.md`): run `/web-xp-check` for a doctrine audit.
- When changing scripts in `bin/` or `tools/`: run `bash test/run-unit.sh`.

Note: `bin/pre-commit-check.sh` is the user-facing script distributed to user projects via `bin/web-xp-on`. Do not run it on this repo.

## Agent Handoff

When collaborating with another agent, use the shared-file protocol in `tools/AGENT-HANDOFF.md`.

Before substantial work and before replying:
1. Read `/tmp/web-xp-agent-handoff/codex-to-claude.md` (your inbound file).
2. Write to `/tmp/web-xp-agent-handoff/claude-to-codex.md` (your outbound file).
3. Do not assume terminal output or chat context has been shared across agents; write important context to the handoff files.

When the human says **check** or **chk**: read `/tmp/web-xp-agent-handoff/codex-to-claude.md` immediately and handle actionable inbox work before other substantial work.

## Edit tool

When changing multiple locations in the same file, use one Edit call with an `old_string` span that covers all change sites. Never send parallel Edit calls to the same file.
