---
name: doctrine-review
description: "Evaluate any code — pasted snippets, file paths, or framework code — against the code standards. Reports pattern violations and doctrine-aligned alternatives."
allowed-tools: Read, Grep
---

# Doctrine Review — Evaluate Any Code Against the Doctrine

Review code the user provides — pasted snippets, file paths, or URLs — against code-guidelines.md. Unlike doctrine-check (which audits git diffs), this works on any code from any source.

## Procedure

### 1. Load the doctrine

Read `.doctrine/code-guidelines.md`. If not found, report: "No doctrine submodule found. Add it with: git submodule add https://github.com/GarrettS/code-guidelines.git .doctrine"

### 2. Receive code to review

The user provides code in one of these forms:
- Pasted directly in the conversation
- A file path to read
- A description of a pattern to evaluate

If the user provides a React component or framework code, evaluate both the original and what the doctrine-aligned vanilla equivalent would look like.

### 3. Analyze against doctrine patterns

For each concern in the code, assess against the doctrine patterns defined in the Patterns and Fail-Safe sections of code-guidelines.md. Use the same pattern recognition list as doctrine-check: Event Delegation, Active Object, Shared Key, Ancestor Class, Dispatch Table, Fail-Safe, CSS over JS, hidden attribute, Extract Shared Logic, Template and cloneNode.

Also assess against Language Rules: naming conventions, module cohesion, identifier accuracy, guard clauses, DOM content, string concatenation.

### 4. Report findings

For each finding, report the pattern name, whether the code violates or could benefit from it, and the doctrine-aligned alternative.

When reviewing framework code, show the vanilla equivalent side by side. Do not just criticize the framework code — demonstrate what replaces it and why.

### 5. Offer next steps

After the report, prompt the user with actionable options based on what was found. Examples:

- "Want me to fix the hardcoded colors and add tokens to `:root`?"
- "Want me to move the inline `<style>` block to an external stylesheet?"
- "Want me to generate the doctrine-compliant version of this component?"
- "Want me to tackle these one at a time, or apply all fixes at once?"

Tailor the prompts to the specific findings. Do not offer generic options — reference the actual violations and opportunities from the report. If the review found nothing, say so and skip this step.
