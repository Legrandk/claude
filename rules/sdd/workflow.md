# Spec-Driven Development Workflow

Use this workflow for non-trivial feature work.

The goal is to avoid jumping from a rough requirement directly into implementation.

## Required Sequence

For non-trivial feature work, follow this sequence:

1. `/sdd-start`
   - Produces `spec.md` v0.
   - Captures intent, scope, non-goals, EARS requirements, acceptance scenarios, SDD rigor level, and research questions.
   - Assigns stable requirement ids (`REQ-001`) and scenario ids (`SCN-001`) and links scenarios to requirements.
   - Uses `AskUserQuestionTool` to resolve blocking ambiguities before writing `spec.md`.
   - Must not inspect or claim repository facts unless provided by the user.

2. `/sdd-research`
   - Produces `research.md`.
   - Uses `spec.md` as the lens: its scope, requirements, and research questions guide what to look for.
   - Inspects the repository and records concrete evidence.
   - Must not plan or implement.

3. `/sdd-refine`
   - Updates `spec.md` into the refined version using the info found in `research.md`.
   - Reconciles user intent with repository evidence.
   - Adds or updates the Change Set: Added / Modified / Removed / Unchanged.
   - Must surface conflicts instead of silently changing the intent.
   - Detects architectural decisions and asks the user which to record as ADRs.
   - Writes confirmed ADRs to `<playbook-path>/doc/adr/` (optional at L1+, required at L2).

4. `/sdd-delivery-artifacts`
   - Produces `delivery_artifacts/*.md`.
   - Lists what must be produced or modified.
   - Must not include tests as delivery artifacts.
   - Must not create an implementation plan.

5. `/sdd-facts`
   - Produces `facts/*.md`.
   - Defines executable assertions that prove the feature exists.
   - Links facts to EARS requirements.
   - Must not implement tests or production code.

6. `planner`
   - Produces a compact `plan.md` index and detailed `tasks/TASK-001.md` task files.
   - Plans from the refined `spec.md`, `research.md`, `delivery_artifacts/*.md`, and `facts/*.md`.
   - Must not plan from `spec.md` v0 if `research.md` exists and refinement has not happened.
   - Must not create a monolithic `plan.md` with all task details inline.
   - Must follow `rules/common/output-budget.md`: create/update files one by one into small chunks.

7. `/execute-plan`
   - Executes one or more approved tasks.
   - Must modify only files allowed by the plan.
   - Must validate through project-aware commands.
   - Must update task, delivery, and facts checklists.

8. `sdd-judge`
   - Final acceptance judge. Runs after `/execute-plan` is complete.
   - Decides whether the work fully satisfies the spec, facts, delivery artifacts, and plan.
   - Read-only; does not implement.
   - Must pass before continuing.

9. `sdd-mutation-test`
   - Runs scoped mutation testing against the implemented facts.
   - Delegates surviving mutants to `tdd-guide` for test-first fixes.
   - Repeats until no mutation issues remain.
   - Must run after `sdd-judge` passes.

10. `antagonist`
    - Challenges the implementation by looking for blockers, hidden risks, unsafe assumptions, missing validation, rollout hazards, and scope creep.
    - Read-only; does not implement.
    - Must run after `sdd-mutation-test` passes and before committing to git.

## SDD Rigor Levels

Each `spec.md` must declare its SDD rigor level.

Use the lightest level that is safe.

### L0 Trivial

Use for small, obvious changes with no meaningful behavioural impact.

Examples:

- typo fixes
- copy changes
- mechanical renames
- obvious one-line config changes

Allowed shortcut:

- full SDD workflow is not required

### L1 Spec-First

Use for normal feature work.

Required:

- `spec.md`
- `research.md`
- `sdd-refine`
- `plan.md`

### L1+ Spec-First with Facts

Use for non-trivial behavioural changes, production observability, external behaviour, important domain logic, or regression-prone code.

Required:

- `spec.md`
- `research.md`
- refined `spec.md`
- `delivery_artifacts/*.md`
- `facts/*.md`
- `plan.md`

### L2 Spec-Anchored

Use for security-sensitive, compliance-sensitive, cross-team, API-contract, payment, tenant-isolation, privacy, or high-risk architectural work.

Required:

- everything from L1+
- ADRs produced by `/sdd-refine` for all architectural decisions
- stricter traceability from `REQ -> SCN -> DA -> FACT -> TASK`, with ADR cross-links when decisions exist
- explicit security/privacy/rollout review where relevant

### L3 Spec-as-Source

Do not use by default.

Only use if the project explicitly adopts code generation from specs.

## Source of Truth

- `spec.md` is the behavioural source of truth.
- `research.md` is the repository-evidence source of truth.
- `delivery_artifacts/*.md` is the production-scope source of truth.
- `facts/*.md` is the executable-verification source of truth.
- `plan.md` is the execution source of truth.
- `tasks/TASK-001.md` files are the atomic task instructions.
- Tests, contracts, schemas, ADRs, dashboards, alerts, and code are the permanent artifacts.

## Repository Knowledge Boundary

Before `/sdd-research`, do not claim facts about the current codebase unless the user explicitly provided them.

If current behaviour depends on repository inspection, write:

> Unknown. Must be discovered during `/sdd-research`.

## Requirements Syntax Rule

Specs must express behavioural requirements using EARS.

Use:

- stable requirement ids: `REQ-001`, `REQ-002`, ...
- `shall` for mandatory behaviour
- one requirement per statement
- testable/verifiable wording

Preferred EARS patterns:

- Ubiquitous: `The system shall <response>.`
- Event-driven: `When <trigger>, the system shall <response>.`
- State-driven: `While <state>, the system shall <response>.`
- Optional: `Where <feature/condition>, the system shall <response>.`
- Unwanted behaviour: `If <unwanted event>, then the system shall <response>.`

Acceptance scenarios may use Given/When/Then, but they do not replace EARS requirements.

Acceptance scenarios must use stable scenario ids: `SCN-001`, `SCN-002`, ...

Each scenario must list the requirement ids it covers.

## Refinement Rule

After `research.md` exists, the spec must be refined before planning.

The planner must not use an unrefined `spec.md` if repository research has produced new evidence.

`/sdd-refine` must add or update:

```md
## Change Set

### Added

### Modified

### Removed

### Unchanged
```

Use the Change Set to make the feature delta explicit in brownfield repositories.

## Delivery Artifacts Rule

`delivery_artifacts/` is a variable, feature-specific map of what must be produced.

Do not assume fixed filenames.

Examples of valid delivery artifact files:

- `01-api-contracts.md`
- `02-domain-model.md`
- `03-jobs-consumers.md`
- `04-observability.md`
- `01-grafana-dashboard.md`
- `02-terraform-alerts.md`
- `01-cli-command.md`

The actual files must be inferred from the feature.

Delivery artifacts must use checkboxes for concrete outputs so completion can be tracked.

Each concrete delivery artifact must have a stable id: `DA-001`, `DA-002`, ...

Each delivery artifact must link to relevant requirements, scenarios, facts when known, tasks when planned, and ADRs when applicable.

Tests are not delivery artifacts.

## Facts Rule

Facts are executable assertions.

Specs explain intent.
Facts verify behaviour.

Every non-trivial behavioural requirement should map to at least one fact unless explicitly marked as documentation-only, human-only, or deferred.

Facts must define:

- stable id: `FACT-001`, `FACT-002`, ...
- status: `@draft`, `@spec`, `@implemented`, or `@deferred`
- linked requirement ids
- linked scenario ids
- linked delivery artifact ids
- linked ADR ids when applicable
- linked task ids once planned, or `TBD until planning`
- executable check command, when known
- assertion
- implementation target, when known

## Traceability Rule

For L1+ and L2 work, use lightweight traceability across generated artifacts:

```txt
REQ -> SCN -> DA -> FACT -> TASK
```

Use `ADR-NNNN` cross-links wherever an architectural decision constrains a requirement, scenario, delivery artifact, fact, or task.

Do not create heavy enterprise matrices unless explicitly requested. Prefer short `Traceability` sections in each artifact.

The planner must ensure that:

- every `@spec` fact is implemented or explicitly deferred
- every implementation task references requirements, scenarios, delivery artifacts, facts, and ADRs when applicable
- every non-trivial requirement is covered by at least one fact or explicit deferral

## Tests Rule

Tests are not delivery artifacts.

Tests belong in:

- `facts/*.md`
- `plan.md`
- `tasks/*.md`
- validation sections
- implementation requirements

Every implementation task must define how the delivered artifact will be validated.

## Output Budget Rule

When creating or updating SDD artifacts, follow:

- `rules/common/output-budget.md`

In particular:

- create/update files one by one
- use small chunks
- avoid large `Write` or `Edit` operations
- do not echo generated file contents in chat
- do not generate multiple large files in the same response

## Planning Rule

When planning under `doc/playbook/<feature>/`, the planner must read:

- `spec.md`
- `research.md`
- every markdown file under `delivery_artifacts/`
- every markdown file under `facts/`
- referenced ADRs under `doc/adr/`
- relevant rules
- `rules/common/output-budget.md`

Every concrete artifact listed under `delivery_artifacts/*.md` must be covered by at least one task in `plan.md`.

`plan.md` must be a compact index/checklist, not a monolithic task document.

`plan.md` must contain:

- Task Checklist
- Delivery Checklist
- Facts Checklist
- Traceability summary
- Validation summary
- Task index pointing to `tasks/TASK-001.md`

Detailed task instructions must live in separate task files:

```txt
tasks/
  TASK-001.md
  TASK-002.md
  TASK-003.md
```

Each `tasks/TASK-001.md` task file must include:

- `Traceability`
- `Requirements`
- `Scenarios`
- `Delivers`
- `Implements Facts`
- `ADRs`
- `Allowed Files`
- `Validation`
- `Done When`

Create or update plan files one by one into small chunks.

Do not create a monolithic `plan.md` containing all task details inline.

Tasks that can safely run in parallel must be marked with `[P]` in the task title/id.

Do not create a separate parallelization section.

## No Shortcut Rule

Do not skip directly from rough requirement to implementation.

Allowed shortcut only for explicitly trivial L0 changes.

If in doubt, use the SDD workflow.
