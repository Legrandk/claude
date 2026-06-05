# New Project Workflow

Use this workflow when starting a brand-new software project from source documents such as product notes, domain notes, requirements, meeting notes, ADR drafts, diagrams described in Markdown, or other `.md` files.

Do not use this workflow for adding features to an existing codebase. Use SDD for existing-project feature work.

The goal is to move from scattered source material to a scaffold-ready implementation plan without inventing requirements, skipping architecture decisions, or treating a blank repository like an existing system.

## Required Sequence

For non-trivial new projects, follow this sequence:

1. `/new-project-start`
   - Produces `source_inventory.md` and `project_brief.md`.
   - Reads only the user-provided source document set.
   - Captures source files, project intent, users, goals, non-goals, constraints, and blocking ambiguities.
   - Must not choose architecture, create a plan, scaffold code, or claim missing source facts.

2. `/new-project-research`
   - Produces `requirements.md`, `contradictions.md`, and `open_questions.md`.
   - Extracts requirements and constraints from the source documents.
   - Records source-backed evidence using file paths and section names when available.
   - Must not create architecture, plan, or implementation files.

3. `/new-project-architecture`
   - Produces `architecture.md`.
   - Defines the proposed stack, system boundaries, data model direction, validation strategy, commands, environments, and initial risk controls.
   - Identifies ADRs that should be recorded before implementation.
   - Must not scaffold code or silently resolve major tradeoffs.

4. `/new-project-delivery-artifacts`
   - Produces `delivery_artifacts/*.md`.
   - Lists concrete production artifacts to create for the project foundation and first vertical slice.
   - Must not include tests as delivery artifacts unless the test or validation asset is itself a shipped artifact.

5. `/new-project-facts`
   - Produces `facts/*.md`.
   - Defines executable assertions that prove the foundation and first vertical slice work.
   - Links facts to requirements and delivery artifacts.
   - Must not implement tests or production code.

6. `planner`
   - Produces a compact `plan.md` index and detailed `plan/tN.md` task files.
   - Plans from `project_brief.md`, `requirements.md`, `architecture.md`, `delivery_artifacts/*.md`, and `facts/*.md`.
   - Must distinguish files to create from files expected to already exist.
   - Must not create a monolithic `plan.md`.

7. `/execute-plan`
   - Executes the approved plan.
   - Creates the scaffold, project foundation, and first vertical slice only as allowed by the task files.
   - Validates using commands defined by `architecture.md`, project rules, or task files.
   - Updates task, delivery, and fact tracking after validation.

8. `reviewer`
   - Reviews the diff against the new-project artifacts and plan.

9. `antagonist`
   - Challenges the scaffold and first slice before the project is treated as ready for normal feature work.

## Directory Structure

Use this structure:

```text
doc/new-project/<YYYYMMDD>_<project_slug>/
  source_inventory.md
  project_brief.md
  requirements.md
  contradictions.md
  open_questions.md
  architecture.md
  delivery_artifacts/
    01-foundation.md
    02-first-vertical-slice.md
  facts/
    01-foundation-facts.md
    02-vertical-slice-facts.md
  plan.md
  plan/
    t1.md
    t2.md
```

Use the actual delivery and facts filenames that fit the project.

## Source of Truth

- Source `.md` files are the source-material truth.
- `source_inventory.md` is the source coverage truth.
- `project_brief.md` is the intent and scope truth.
- `requirements.md` is the behavior and constraint truth.
- `contradictions.md` is the conflict truth.
- `open_questions.md` is the unresolved-decision truth.
- `architecture.md` is the foundation decision truth.
- ADRs are the durable architectural decision record.
- `delivery_artifacts/*.md` is the production-scope truth.
- `facts/*.md` is the executable-verification truth.
- `plan.md` and `plan/tN.md` are the execution truth.

## Source Material Boundary

Do not invent facts that are not present in the source documents or explicitly provided by the user.

If a requirement, business rule, user role, integration, non-goal, platform choice, or constraint is not supported by the source material, mark it as:

```text
Unknown. Requires user decision.
```

Do not resolve contradictions silently. Record them in `contradictions.md` and ask the user when they block architecture or planning.

## Requirements Rules

Requirements must be source-backed.

Use stable ids:

- `REQ-001`, `REQ-002`, ... for behavior
- `CON-001`, `CON-002`, ... for constraints
- `NFR-001`, `NFR-002`, ... for non-functional requirements

Behavioral requirements should use EARS where practical:

- `The system shall <response>.`
- `When <trigger>, the system shall <response>.`
- `While <state>, the system shall <response>.`
- `Where <feature/condition>, the system shall <response>.`
- `If <unwanted event>, then the system shall <response>.`

## Architecture Rules

Architecture must be explicit before scaffold planning.

`architecture.md` must define:

- selected stack and rationale
- rejected alternatives when material
- system boundaries
- data storage choice
- external interfaces
- authentication and authorization stance
- configuration and secret-management stance
- validation commands
- development and deployment assumptions
- risks and mitigations
- ADRs to create before implementation

Major architecture choices require ADRs before implementation when they affect framework, language, database, deployment model, API style, authentication, tenancy, data model, or testing strategy.

## New Project Planning Rules

Every implementation task must distinguish:

```md
## Files To Create

## Files To Modify

## Files That Must Already Exist
```

A missing file listed under `Files To Create` is expected.

A missing file listed under `Files That Must Already Exist` is drift and must be reported instead of improvised around.

## First Slice Rule

The initial plan should produce a working first vertical slice, not only an empty scaffold.

A valid first slice proves:

- the selected stack runs
- the main domain path has at least one executable behavior
- the validation commands work
- the project structure can support future SDD feature work

## Handoff to SDD

After the scaffold and first vertical slice are implemented and reviewed, future feature work should use the normal SDD workflow under `doc/playbook/<feature>/`.
