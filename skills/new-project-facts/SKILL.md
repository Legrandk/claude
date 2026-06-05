---
name: new-project-facts
description: Generate executable facts for a brand-new project foundation and first vertical slice. Does not implement checks, plans, or code.
origin: user
---

# New Project Facts

Generate executable facts for a brand-new project.

Facts prove that the scaffold, foundation, and first vertical slice work.

This skill produces:

- `facts/*.md`

It must not implement tests, create plans, scaffold code, or modify production files.

## Rules

Follow:

- `rules/new-project/workflow.md`
- `rules/sdd/facts.md`
- `rules/common/output-budget.md`

## Required Inputs

Read:

- `<new-project-path>/project_brief.md`
- `<new-project-path>/requirements.md`
- `<new-project-path>/architecture.md`
- every markdown file under `<new-project-path>/delivery_artifacts/`

If delivery artifacts are missing, stop and ask the user to run `/new-project-delivery-artifacts` first.

## What Counts as a Fact

Create facts for:

- foundation commands that must pass
- first vertical slice behavior
- externally visible behavior
- API contracts
- data invariants
- authentication or authorization expectations
- configuration and secret requirements
- observability-critical behavior
- deployment or build checks

Do not create facts for:

- trivial file existence unless it proves the scaffold runs
- pure documentation
- vague quality claims
- implementation details that are not externally meaningful

## Output

Create:

- `<new-project-path>/facts/`

Group facts by natural verification area.

Examples:

- `01-foundation-facts.md`
- `02-domain-facts.md`
- `03-api-facts.md`
- `04-vertical-slice-facts.md`

## Fact Format

```md
# <Area> Facts

## FACT-001: <short name>

Status: @spec

Requirements:

- `REQ-001`

Delivery Artifacts:

- `delivery_artifacts/<file>.md` -> `<artifact heading>`

Executable Check:

- Type: <unit test | integration test | contract validation | smoke test | static analysis | build | other>
- Target: <what must be verified>
- Command: <command from architecture.md or TODO - resolve before planning>

Assertion:

- Given ...
- When ...
- Then ...

Implementation Target:

- <test file, check file, command, or validation artifact when known>

Notes:

- ...
```

## Status Rules

Generated facts should normally be `@spec`.

Never generate `@implemented`.

Use `@deferred` only when the project brief or user explicitly defers the fact.

## Output Rules

Return only:

- directory created
- facts files created
- number of facts
- requirements without facts, if any
- next recommended command
