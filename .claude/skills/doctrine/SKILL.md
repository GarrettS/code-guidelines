---
name: doctrine
disable-model-invocation: true
allowed-tools: Read, Grep
---

# Doctrine — Inline Reference

Load the doctrine into the current session with the correct split between governing rules and explanatory context.

## Procedure

### 1. Locate and read doctrine files

Read both files from `.doctrine/`:
- `.doctrine/code-guidelines.md` — governing standards: principles, patterns, language rules, formatting
- `.doctrine/code-philosophy.md` — explanatory context: how and why the doctrine works, historical framing, and supporting examples

If `.doctrine/` does not exist, report: "No doctrine submodule found. Add it with: git submodule add https://github.com/GarrettS/code-guidelines.git .doctrine"

### 2. Summarize active constraints

After reading, list the key constraints now governing the session. Draw the governing constraints from the CG, not the CP. Include at minimum: Fail-Safe, Module Cohesion, Shared Key, Event Delegation, Active Object, Ancestor Class, Design Tokens, Ubiquitous Language, and DOM-Light. State each with a one-line description drawn from the CG.

### 3. Apply for the session

For the remainder of this conversation:
- Evaluate all code written or reviewed against these constraints
- Flag violations by pattern name
- When proposing code, follow the doctrine's patterns
- Use `code-philosophy.md` to explain the reasoning behind the rules, not to invent new rules
- When the doctrine conflicts with a request, state the tension and ask
- On commit, remind to run pre-commit checks and re-read the CG
