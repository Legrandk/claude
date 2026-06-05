---
name: new-project-architecture
description: Define architecture for a brand-new project after source-backed requirements exist. Creates architecture.md and ADR candidates. Does not scaffold code or create plans.
origin: user
---

# New Project Architecture

Define the initial architecture for a brand-new project.

This skill produces:

- `architecture.md`

It may identify ADR candidates, but it must not create ADR files unless the user explicitly invokes or approves the ADR workflow.

It must not scaffold code, create delivery artifacts, create facts, create plans, or implement anything.

## Rules

Follow:

- `rules/new-project/workflow.md`
- `rules/common/output-budget.md`

## Required Inputs

Read:

- `<new-project-path>/source_inventory.md`
- `<new-project-path>/project_brief.md`
- `<new-project-path>/requirements.md`
- `<new-project-path>/contradictions.md`
- `<new-project-path>/open_questions.md`

If requirements are missing, stop and ask the user to run `/new-project-research` first.

If blocking contradictions or questions remain, stop and ask the user for the required decision before writing architecture.

## Workflow

1. Read the new-project artifacts.
2. Identify architecture drivers from requirements and constraints.
3. Identify viable stack and architecture options.
4. Compare material alternatives.
5. Ask the user before resolving major tradeoffs that are not source-backed.
6. Write `architecture.md`.
7. List ADR candidates.
8. Define validation commands or mark them unresolved.

## Architecture Decision Rules

Record material choices, including:

- application framework
- language/runtime
- package manager
- database/storage
- API style
- authentication and authorization
- deployment target
- test framework
- observability baseline

If a choice has significant long-term consequences, mark it as an ADR candidate.

## architecture.md Structure

```md
# Architecture: <project>

## Summary

## Architecture Drivers

## Selected Stack

## Alternatives Considered

## System Boundaries

## Domain Model Direction

## Data Storage

## External Interfaces

## Authentication / Authorization

## Configuration and Secrets

## Validation Commands

## Development Environment

## Deployment Assumptions

## Observability Baseline

## Risks and Mitigations

## ADR Candidates

## Planning Notes
```

## Validation Command Rules

Commands must be concrete when the architecture decision makes them knowable.

If commands are not knowable yet, write:

```text
TODO - resolve before planning.
```

Do not guess project commands.

## Output Rules

Return only:

- file created or updated
- selected stack summary
- ADR candidates
- unresolved blockers, if any
- next recommended command
