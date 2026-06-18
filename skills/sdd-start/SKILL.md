---
name: sdd-start
description: Convert a rough feature idea into an intent-level spec.md under doc/playbook/<feature>. Uses AskUserQuestionTool to resolve blocking ambiguities before writing the spec. Does not inspect code, plan, or implement.
origin: user
---

# SDD Start

Create the initial intent-level spec for a feature from a rough requirement.

This skill turns an unclear idea into a clear `spec.md` v0.

It must not plan implementation.
It must not inspect repository code.
It must not modify application code.
It must not create `research.md`, `delivery_artifacts/`, `facts/`, `plan.md`, or `tasks/`.

This skill is framework-agnostic.

It must not assume Rails, Elixir, Kotlin, Terraform, devkit, Docker, CI, or any specific command runner.

## Rules

Follow:

- `rules/sdd/workflow.md`

## When to Activate

Use this skill when:

- The user invokes `/sdd-start <feature-name>`
- The user says "create a spec"
- The user says "start SDD"
- The user says "turn this into a spec"
- The user provides a rough feature requirement and wants to begin feature work

## Inputs

The user may provide:

- a rough idea
- a product requirement
- a technical requirement
- a bug/change request
- a feature name
- a target playbook path

If the playbook path is not explicit, infer a reasonable path:

`doc/playbook/<YYYYMMDD>_<feature_slug>/`

Use a lowercase snake_case slug.

## Repository Knowledge Boundary

This skill must not claim facts about the current codebase unless they are provided by the user.

If current behaviour depends on repository inspection, write:

> Unknown. Must be discovered during `/sdd-research`.

Add concrete research questions that `/sdd-research` must answer.

## Workflow

### 1. Understand the rough requirement

Extract:

- problem
- goal
- SDD rigor level
- users/consumers
- desired behaviour
- non-goals
- EARS requirements
- acceptance scenarios
- requirement-to-scenario traceability
- edge cases
- observability impact
- compatibility impact
- security/privacy/compliance impact
- research questions
- open questions

### 2. Identify ambiguities

Classify ambiguities as:

#### Blocking

Questions that materially affect:

- scope
- behaviour
- acceptance scenarios
- requirements
- data model
- external contracts
- compatibility
- rollout
- observability
- security/privacy/compliance
- operational risk
- SDD rigor level

#### Non-blocking

Questions that can safely remain as open questions in `spec.md`.

### 3. Ask the user before writing the spec

If blocking ambiguities exist, use `AskUserQuestionTool`.

Do not write `spec.md` until blocking ambiguities are resolved.

Ask grouped, concrete questions.

Prefer multiple-choice questions when possible.

Avoid asking more than 7 questions in one round unless the requirement is highly ambiguous.

Do not ask questions whose answer can be safely discovered later during `/sdd-research`.

Do not ask questions that only affect implementation details.

### 4. Incorporate answers

After receiving answers:

- update your understanding
- resolve the relevant ambiguities
- keep unresolved non-blocking questions in the `Open Questions` section
- do not silently discard user constraints

### 5. Write `spec.md`

Create:

`<playbook-path>/spec.md`

Do not create:

- `research.md`
- `delivery_artifacts/`
- `facts/`
- `plan.md`
- `tasks/`
- application code
- tests
- infrastructure files

## AskUserQuestionTool Rules

Use `AskUserQuestionTool` when:

- the requested behaviour is ambiguous
- the target users/consumers are unclear
- there are conflicting interpretations
- acceptance criteria cannot be written confidently
- there is a risk of over-scoping
- there is a possible compatibility/security/operational concern
- the user has not specified what is explicitly out of scope
- the SDD rigor level is unclear and materially affects the workflow

Do not use `AskUserQuestionTool` for:

- implementation details that `/sdd-research` should discover
- codebase facts that can be inspected later
- minor naming preferences
- questions that do not affect the spec

## Requirements Syntax

Use EARS for all behavioural requirements.

Each requirement must:

- have a stable id: `REQ-001`, `REQ-002`, ...
- use `shall`
- be atomic
- be testable or verifiable
- be linked to at least one `SCN-*` acceptance scenario unless explicitly scenario-free
- avoid implementation details unless explicitly required
- avoid vague words like "properly", "fast", "easy", "robust", unless quantified

Allowed EARS patterns:

- Ubiquitous: `The system shall <response>.`
- Event-driven: `When <trigger>, the system shall <response>.`
- State-driven: `While <state>, the system shall <response>.`
- Optional: `Where <feature/condition>, the system shall <response>.`
- Unwanted behaviour: `If <unwanted event>, then the system shall <response>.`

## spec.md Structure

Write the spec using this structure:

```md
# Spec: <feature>

<!-- sdd: refined=false -->
<!-- sdd_rigor: L1 | L1+ | L2 -->

## SDD Rigor

Level: <L0 | L1 | L1+ | L2>

Reason:

- ...

## Problem

## Goal

## Non-goals

## Users / Consumers

## Current Behaviour

Unknown. Must be discovered during `/sdd-research`.

## Desired Behaviour

## Requirements

### REQ-001

When <trigger>, the system shall <response>.

Scenarios:

- `SCN-001`

### REQ-002

The system shall <response>.

Scenarios:

- `SCN-002`

## Acceptance Scenarios

### SCN-001: <name>

Covers:

- `REQ-001`

Given ...
When ...
Then ...

### SCN-002: <name>

Covers:

- `REQ-002`

Given ...
When ...
Then ...

## Edge Cases

## Observability

## Compatibility

## Security / Privacy / Compliance

## Research Questions

- [ ] ...

## Open Questions

- [ ] ...
```

## Quality Bar

The generated spec must be:

- behaviour-focused
- implementation-light
- explicit about non-goals
- clear enough for `/sdd-research`
- clear enough to derive `delivery_artifacts/`
- clear enough to derive `facts/`
- not dependent on hidden assumptions

## Output Rules

After writing `spec.md`, return only:

- path created
- short summary of the spec
- selected SDD rigor level
- number of open questions
- next recommended command
