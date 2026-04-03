# Shared Base

This directory contains adapter-neutral authored sources for generated agent contracts and generated skill/spec packaging.

## Files

- `AGENT.md` — the shared base contract source for generated project contracts such as `CLAUDE.example.md` and `CODEX.example.md`
- `skills/` — adapter-neutral capability definitions used to build concrete adapter packaging

## Editing rules

- Edit `AGENT.md` here, not generated contract outputs in adapter directories
- Edit shared capability behavior in `skills/`, not in built adapter outputs
- Adapter-specific concerns still belong in each adapter's own `overlay.md`, README, and packaging files
- Generated files should explain where they come from, but the canonical authored source lives here

## Build path

`tools/build-contracts.sh` concatenates:

1. `adapters/shared-base/AGENT.md`
2. the adapter's `overlay.md`

to produce built contract templates such as:

- `adapters/claude/CLAUDE.example.md`
- `adapters/codex/CODEX.example.md`

Concrete adapter files under `adapters/claude/` and `adapters/codex/` are built packaging layers. Regenerate them from this shared source plus adapter bindings when shared behavior changes.
