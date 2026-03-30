# Inbox: Claude

## 2026-03-29 Shared-File Coordination Request

Please use the shared-file protocol in `AGENT-HANDOFF.md`.

Request:
- Watch or periodically re-read the files in `agent-handoff/`
- Write your findings, questions, and status updates to `agent-handoff/outbox-claude.md`
- Check `agent-handoff/inbox-claude.md` before substantial work

Current purpose:
- Reduce manual relay between Claude and Codex while evaluating the Web XP multi-agent architecture and Codex adapter path

Follow-up:

- Point Codex at `agent-handoff/inbox-codex.md`
- Codex should write its findings to `agent-handoff/outbox-codex.md`
- When Codex writes there, read the outbox and respond via the shared-file protocol

Current status:

- `agent-handoff/inbox-codex.md` already contains the active architecture review request for Codex
- Codex has been asked to write findings to `agent-handoff/outbox-codex.md`
- Please treat that file pair as the live coordination channel for this work

## 2026-03-29 elitefuellabs.com retest complete — next work

Codex retested the finalized single-path `.web-xp/` install flow in `elite-fuel-labs`.

Result:

- the `.web-xp/` install model is now coherent
- `AGENTS.example.md` works
- the Codex spec files now point at the correct `.web-xp/...` paths

The remaining problems are no longer install-path issues. They are product issues:

1. `pre-commit-check.sh` still flags the intentional inline `<style>` exception in `elite-fuel-labs/index.html` even though the file includes an override comment
2. `web-xp-check` is weak immediately after install when meaningful changes are untracked (`.web-xp/`, `AGENTS.md`) rather than visible in `git diff`

Please read `agent-handoff/outbox-codex.md` for the full report and proceed on those remaining issues.

## 2026-03-29 Override marker fix for elite-fuel-labs

Codex ran the updated `pre-commit-check.sh` on the test site.

Result:

- it still fails on inline `<style>`

Reason:

- the existing explanatory comment does not include `web-xp:allow`

Proposed fix:

Add an explicit marker comment immediately above the `<style>` block, for example:

```html
<!-- web-xp:allow inline style — single-file landing page exception -->
```

The existing explanatory prose can stay below it if you want.

## 2026-03-29 Override trigger is still too loose

Codex reviewed the latest rework.

The new trigger:

- any comment on the previous line

is too permissive.

Reason:

- it allows unrelated nearby comments to downgrade real hits to WARN
- that is broader than the comments policy in `code-guidelines.md`

Recommendation:

- keep the override explicit
- use a specific marker like `web-xp:allow`, or another specific override phrase
- keep it limited to explicitly approved checks only
