# Codex Adapter

Web XP adapter for Codex. Implements the adapter interface as flat spec files and a built contract.

## Status

Initial implementation. Prompt/spec files define each Web XP operation for Codex. They are built artifacts, not the canonical authored skill source.

## How it works

1. `adapters/shared-base/AGENT.md` is the shared base contract — version pin, session directives, pre-commit sequence.
2. `overlay.md` (in this adapter) adds Codex-specific config such as the spec directory.
3. The install builds `CODEX.md` from `adapters/shared-base/AGENT.md` + `overlay.md`. Projects get one file.
4. `tools/build-adapter-skills.sh` builds the concrete Codex spec files in this adapter from `adapters/shared-base/skills/` + Codex bindings.
5. One built spec file per Web XP operation defines what each operation does.

These flat `.md` spec files are the Codex equivalents of the Claude skill
directories in `adapters/claude/`. Both are built from `adapters/shared-base/skills/`.

## Spec Files

| Spec file | Role | Purpose |
|-----------|------|---------|
| `web-xp.md` | both | Load constraints |
| `web-xp-check.md` | auditor | Audit diff |
| `web-xp-review.md` | auditor | Review any code |
| `web-xp-apply.md` | coder | Apply fixes with approval |
| `web-xp-init.md` | setup | Bootstrap project |
| `web-xp-on.md` | setup | Enable always-on enforcement |
| `web-xp-off.md` | setup | Disable enforcement |
| `web-xp-remove` | setup | Remove Web XP from project |

## Install

Web XP is installed once per user, not per project.

```bash
git clone https://github.com/GarrettS/web-xp.git ~/.web-xp
```

Install also copies the Codex bootstrap skill to `~/.codex/skills/web-xp-init/`.

Then in each project, inside Codex:

```text
web-xp-init
```

Shell fallback:

```bash
~/.web-xp/bin/web-xp-init codex
```

To remove Web XP from the current project inside Codex:

```text
web-xp-remove
```

Shell fallback:

```bash
~/.web-xp/bin/web-xp-remove codex
```

To update:

```bash
cd ~/.web-xp && git pull
```

### Usage

Point Codex to `CODEX.md` when starting a session. Invoke Web XP by spec file name (e.g. "follow `web-xp-check.md`").
