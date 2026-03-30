# smux Dev Workflow Spike

Experimental contributor tooling for reducing manual agent relay during Web XP development.

## Status

First spike implemented. Two complementary tools:

1. **`bin/tmux-bridge`** — active CLI for pane discovery, role registration, and handoff prompt delivery
2. **`dev-relay.sh`** — passive file watcher that monitors handoff files and notifies on changes

## What it proves

- One pane can identify another by role (`codex`, `claude`)
- A handoff can trigger a visible tmux notification
- The next prompt can be pasted into the target pane without the human retyping it
- Background polling catches changes even when neither agent actively sends

## Constraint

Codex still cannot self-invoke between turns. This spike does not auto-run Codex. It pastes the next prompt into the Codex pane so the human only has to focus that pane and press Enter.

## Files

- `bin/tmux-bridge`: tmux helper CLI — register roles, notify, paste, handoff
- `dev-relay.sh`: background watcher — polls handoff files, emits notifications on change
- `CLAUDE-PROMPT.md`: session prompt for Claude
- `CODEX-PROMPT.md`: session prompt for Codex

## Usage

### tmux-bridge (active relay)

From inside a tmux session:

```bash
contrib/smux/bin/tmux-bridge list
contrib/smux/bin/tmux-bridge register codex %1
contrib/smux/bin/tmux-bridge register claude %2
contrib/smux/bin/tmux-bridge handoff codex "Review the latest note from Claude."
contrib/smux/bin/tmux-bridge handoff claude "Codex replied in the handoff log."
```

`handoff codex` pastes:

```text
Read /absolute/path/to/agent-handoff/claude-to-codex.md and continue from there.
```

`handoff claude` pastes:

```text
Read /absolute/path/to/agent-handoff/codex-to-claude.md, act on it, and restart the poll.
```

### dev-relay (passive watcher)

Run in a separate terminal pane:

```bash
bash contrib/smux/dev-relay.sh              # default: poll every 3s
bash contrib/smux/dev-relay.sh --interval 5  # custom interval
```

Emits timestamped terminal notifications when either handoff file changes. On macOS, also attempts a system notification (best-effort).

## Commands (tmux-bridge)

- `list`: show panes across tmux sessions with IDs and current commands
- `register <role> <pane-id>`: map `codex` or `claude` to a pane
- `roles`: print the current role registry
- `notify <role|pane-id> <message>`: show a tmux status-line message in a pane
- `paste <role|pane-id> <text>`: paste text into a pane without executing it
- `handoff <codex|claude> [note]`: notify the pane and paste a standard inbox-check prompt

## State

Role mappings are stored outside the repo by default:

```text
~/.web-xp/smux/roles.tsv
```

Override with `SMUX_ROLE_FILE` if needed.

Poll state for dev-relay is stored in `.dev-relay/` at the repo root (gitignored).

## Non-goals

- General orchestration engine
- User-facing feature
- Auto-executing prompts in Codex
