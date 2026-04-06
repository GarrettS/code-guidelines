# E2E Testing with Clean User Isolation

E2E tests run as a separate macOS user (`webxp-test`) to avoid cross-project session state contamination ([#21](https://github.com/GarrettS/web-xp/issues/21)).

## Why a separate user

Codex persists session state (approved commands, behavioral rules) in `~/.codex/` across projects and sessions. A "fresh session" under your main user is not actually clean. A separate user has its own `$HOME` with no prior agent history.

## One-time setup

Create the test user and install Web XP:

```bash
sudo sysadminctl -addUser webxp-test -password test123
sudo -u webxp-test -H bash -c 'cd ~ && git clone https://github.com/GarrettS/web-xp.git ~/.web-xp && ~/.web-xp/bin/install.sh'
```

Copy the Codex auth token (the test user needs API access):

```bash
sudo -u webxp-test -H bash -c 'mkdir -p ~/.codex'
sudo cp ~/.codex/auth.json /Users/webxp-test/.codex/auth.json
sudo chown webxp-test:staff /Users/webxp-test/.codex/auth.json
sudo chmod 600 /Users/webxp-test/.codex/auth.json
```

## Running a test

```bash
bash test/e2e-run.sh "run web-xp-check"
```

This:
1. Cleans the test user's Codex session state
2. Creates a fresh git project with bad code fixtures
3. Runs `codex exec --full-auto` with your prompt as the test user
4. Saves results to `~/tmp/codex-test-results.txt`
5. Tears down the test project and cleans state again

## Scripts

| Script | Purpose |
|---|---|
| `e2e-run.sh` | Full setup → test → teardown runner |
| `e2e-setup.sh` | Cleans Codex state, creates test project (run as webxp-test) |
| `e2e-teardown.sh` | Removes test project, cleans Codex state (run as webxp-test) |
| `webxp-test-user-clean-settings.sh` | Removes session files from webxp-test's ~/.codex/ (run as webxp-test) |

## What this proves

- Skill discovery from `$HOME/.agents/skills/` works without prior session state
- No cross-project path leaking (no `elite-fuel-labs` or other project paths appear)
- Pre-commit check uses the correct path (`~/.web-xp/bin/pre-commit-check.sh`)
- The skill procedure is followed (diff check before mechanical check)

## What this does not prove

- Server-side session isolation (unknown — we share the auth token)
- Implicit/auto-activation behavior (requires interactive session, not `codex exec`)
- Multi-turn enforcement (requires interactive session)

For interactive behavioral tests, see `badcode-test-website/MANUAL-TEST.md`.

## Updating Web XP for the test user

When the repo changes:

```bash
sudo -u webxp-test -H bash -c 'cd ~/.web-xp && git pull && bash bin/install.sh'
```
