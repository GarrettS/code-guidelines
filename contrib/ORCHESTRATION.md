# Orchestration

This document defines the **product-level orchestration problem**.

It does **not** describe how Claude and Codex coordinate while building Web XP. That contributor workflow belongs in a separate document.

## Scope

Orchestration means defining and running multi-step workflows with explicit order, dependency, failure behavior, and approval boundaries.

Examples:

```text
plan -> code -> review -> test -> deploy
```

```text
target A
target B depends on A
target C depends on A
target D depends on B and C
```

The core problem is not "how do two agents message each other." The core problem is "how do we define and execute a workflow correctly."

## What This System Must Do

An orchestration system must be able to answer, unambiguously:

- What tasks exist?
- What does each task require?
- What does each task produce?
- What depends on what?
- What can run in parallel?
- What happens on failure?
- Where is human approval required?
- What state is observable while the workflow is running?

If a design cannot answer those clearly, it is not an orchestration design yet.

## Design Goals

- Define workflows in a machine-readable form
- Support dependency ordering and parallelism
- Support conditional flow and failure handling
- Support human approval gates
- Support agent-backed and script-backed tasks
- Keep run state inspectable
- Avoid coupling workflow semantics to one transport or one agent platform

## Non-Goals

- Solving contributor handoff while building Web XP
- Requiring tmux as the runtime
- Treating transport as the orchestration model
- Folding Web XP core rules into the runner
- Building a full distributed-systems platform

## Core Concepts

### Task

A unit of work.

Examples:
- run a script
- ask an agent to review a diff
- apply a patch
- run tests

### Target

A named workflow node composed of one or more tasks and explicit dependencies.

### Dependency

A rule that says one target cannot start until another has completed successfully, or has produced specific required output.

### Runner

The component that evaluates the workflow definition and decides what to run next.

### Approval gate

A point in the workflow where execution pauses until a human authorizes continuation.

### Transport

The mechanism used to notify or wake an actor once work is ready.

Transport matters, but transport is not the workflow definition.

## Minimal Architecture

Any serious orchestration design will need at least these pieces:

1. **Workflow definition**
   A structured format describing tasks, targets, dependencies, and policy
2. **Runner**
   Reads the definition, executes the graph, and tracks state
3. **Task adapters**
   Invoke concrete work units such as scripts, checks, or agents
4. **Approval handling**
   Pause, surface context, and resume after human decision
5. **Run state**
   Observable status, logs, outputs, and failure reasons
6. **Transport**
   Optional wakeup/notification mechanism for interactive actors

Without the first two items, there is no orchestration system yet.

## Relationship To Web XP

Web XP is not the orchestration model.

Web XP may participate in an orchestration system as:

- a standards provider
- a task provider
- a set of agent adapters
- a source of checks and review behaviors

That means:

- Web XP core should stay focused on standards and adapter contracts
- orchestration should be designed as its own layer
- the layering decision may still be "inside this repo," "adjacent project," or "separate project"

That placement question is open. The architectural separation is not.

## Task Interface Requirements

To participate in orchestration, a task should expose a minimal contract:

- input context
- execution target
- success or failure result
- machine-readable status when possible
- human-readable findings when relevant

Different task types may expose richer interfaces, but the runner needs a stable minimum.

## Policy Requirements

A workflow definition needs to express at least:

- sequence
- parallel execution
- conditional branches
- retry or stop behavior
- approval checkpoints
- failure propagation

These are workflow semantics. They should not be inferred from tmux behavior, chat prompts, or ad hoc terminal conventions.

## Transport Position

Transport is a supporting concern.

Possible transports include:

- tmux-based pane messaging
- file watchers
- hooks
- agent-native notification mechanisms

Those may help interactive tasks wake up, but they do not replace:

- workflow definition
- dependency modeling
- execution policy
- run-state tracking

## Constraints

- Some tasks are interactive, some are not
- Some tasks are agent-backed, some are plain scripts
- Human approval must remain available where required
- Observability matters; hidden state is not acceptable
- The system should not assume one agent vendor or one terminal runtime

## Open Questions

1. What is the minimal workflow definition format worth supporting first?
2. Is the primary abstraction `task`, `target`, or both?
3. How much run state must be machine-readable in v1?
4. Which approval semantics are required in the first usable version?
5. What belongs in Web XP proper versus an adjacent orchestration layer?

## Short Version

Orchestration is the product problem of defining and executing workflows correctly.

It is about:

- workflow definition
- dependency execution
- approval gates
- failure policy
- run-state visibility

It is not just agent wakeup, pane messaging, or contributor coordination.
