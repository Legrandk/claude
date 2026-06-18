---
name: sdd-facts
description: Generate facts/*.md from refined spec.md, research.md, and delivery_artifacts/*.md. Facts are executable assertions that prove the feature exists. Does not implement verification, plan, or production code.
origin: user
---

# SDD Facts

Generate executable facts for a feature.

Facts convert spec intent into verifiable assertions.

Specs explain intent.
Facts verify behaviour.

This skill must not implement tests.
This skill must not modify production code.
This skill must not create `plan.md`.
This skill must not create `tasks/`.

This skill is framework-agnostic.

It must not assume Rails, Elixir, Kotlin, Terraform, devkit, Docker, CI, or any specific command runner.

## Rules

Follow:

- `rules/sdd/workflow.md`
- `rules/sdd/facts.md`

## Required Inputs

Read:

- `<playbook-path>/spec.md`
- `<playbook-path>/research.md`
- every markdown file under `<playbook-path>/delivery_artifacts/`
- referenced ADRs under `<playbook-path>/doc/adr/`, when present

If `spec.md` is missing, stop and ask the user to run `/sdd-start` first.

If `research.md` is missing, stop and ask the user to run `/sdd-research` first.

If `spec.md` is not refined, stop and ask the user to run `/sdd-refine` first.

If `delivery_artifacts/` is missing or empty, stop and ask the user to run `/sdd-delivery-artifacts` first.

## Output

Create:

- `<playbook-path>/facts/`

Inside it, create one or more numbered markdown files grouped by the natural verification areas of the feature.

Do not use a fixed category list.

Examples:

- `01-domain-facts.md`
- `02-api-facts.md`
- `03-observability-facts.md`
- `04-rollout-facts.md`
- `01-contract-facts.md`

## What Counts as a Fact

A fact is an assertion that can be verified by:

- a test
- a contract check
- a schema validation
- a lint/static check
- a dashboard/alert validation
- a smoke test
- another deterministic check with an exit code or equivalent pass/fail result

## When to Create Facts

Create facts for:

- behavioural EARS requirements
- external behaviour
- domain rules
- API contracts
- message payloads
- permissions
- idempotency
- retry behaviour
- invariants
- observability-critical behaviour
- dashboards or alerts that can be validated
- bugs that must not regress

Do not create facts for:

- trivial implementation details
- class names unless externally relevant
- refactor mechanics
- pure explanatory documentation
- things that cannot reasonably be verified

## Fact Format

Each facts file must use this structure:

```md
# <Area> Facts

## FACT-001: <short name>

Status: @spec

Requirements:

- `REQ-001`

Scenarios:

- `SCN-001`

Delivery Artifacts:

- `DA-001` - `delivery_artifacts/<file>.md` -> `<artifact heading>`

Tasks:

- `TBD until planning`

ADRs:

- `ADR-NNNN` when applicable, otherwise `None`

Traceability:

- Requirements -> Scenarios -> Delivery Artifacts -> Facts -> Tasks
- ADRs constrain this fact only when listed above.

Executable Check:

- Type: <unit test | integration test | contract validation | schema validation | static analysis | smoke test | CI job | other>
- Target: <what must be verified>
- Command: resolved from applicable project rules

Assertion:

- Given ...
- When ...
- Then ...

Implementation Target:

- <test file, contract file, schema file, CI job, or validation artifact when known>

Notes:

- ...
```

## Status Rules

Use one of:

- `@draft`: proposed but not yet accepted
- `@spec`: accepted and required
- `@implemented`: executable check exists and passes
- `@deferred`: intentionally postponed

Generated facts should normally be `@spec`.

Use `@draft` only when a fact is plausible but needs user/team confirmation.

Use `@deferred` only when the spec explicitly defers it.

Never generate `@implemented`.

## Command Rules

Executable checks must follow applicable project, stack, or repository rules.

Do not hardcode framework-specific command formats in SDD skills.

Do not mention specific runners such as Rails, RSpec, Mix, Gradle, Maven, Terraform, devkit, Docker, or CI-specific commands unless those commands come from project-specific rules.

If no applicable project rule defines how to run the check, write:

```md
Command: TODO - resolve from project rules
```

Do not guess.

## Traceability Rules

Every non-trivial behavioural requirement should map to at least one fact unless explicitly marked as:

- documentation-only
- human-only
- deferred
- not verifiable at this layer

Use lightweight traceability:

```txt
REQ -> SCN -> DA -> FACT -> TASK
```

This skill creates the `REQ/SCN/DA -> FACT` link.

The planner will create the `FACT -> TASK` link and fill task references.

## Output Rules

Return only:

- directory created
- facts files created
- number of facts
- requirements without facts, if any
- scenarios without facts, if any
- next recommended command
