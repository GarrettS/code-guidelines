# Web XP Init — Project Setup

Set up a project to use Web XP with Codex.

## Procedure

### 1. Verify Web XP is available

Check that `.web-xp/` exists in the project (either as a submodule or a local clone). If it does not exist, report: "Clone or add Web XP first: `git clone https://github.com/GarrettS/web-xp.git .web-xp`" and stop.

### 2. Create project contract

If no `AGENTS.md` exists, copy the contract template:

```bash
cp .web-xp/adapters/codex/AGENTS.example.md AGENTS.md
```

If `AGENTS.md` already exists: "AGENTS.md already exists — skipping."

### 3. Report

Summarize what was created or skipped.
