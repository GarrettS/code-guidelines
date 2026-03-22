---
name: doctrine-apply
disable-model-invocation: true
allowed-tools: Bash(bash:*), Read, Grep, Edit
---

# Doctrine Apply — Interactive Guided Fixes

Walk through doctrine-check findings and apply them one at a time with human approval.

## Procedure

### 1. Get findings

If a doctrine-check was already run in this conversation, use those findings. Otherwise, run `/doctrine-check` first to generate the finding list.

### 2. Present each finding individually

For each finding, present:
- The file and line number
- The pattern name and whether it is a violation or opportunity
- The current code (quote the relevant lines)
- The proposed change (show the replacement code)
- A one-sentence doctrine rationale

Then ask: "Apply this change? (yes / no / skip)"

### 3. Apply on approval

- On **yes**: make the edit using the Edit tool. Verify the edit was applied correctly.
- On **no** or **skip**: move to the next finding without editing.
- Never batch-apply multiple findings at once.
- Never edit without explicit approval for that specific change.

### 4. After all findings

Report a summary: how many findings were applied, skipped, and declined.

If any edits were made:
- Clean up after each edit: remove CSS selectors, IDs, classes, and variables that the refactor made unreferenced.
- Run `bin/pre-commit-check.sh` (if it exists) to verify no mechanical violations were introduced.
- Review the changed JS for correctness — confirm no broken references, missing arguments, or changed behavior.
