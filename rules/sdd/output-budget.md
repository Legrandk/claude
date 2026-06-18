---
paths:
  - "doc/playbook/**/*"
  - "rules/sdd/**/*"
---
# SDD Output Budget

This rule extends `rules/common/output-budget.md` for SDD work.

It exists to keep SDD artifacts executable, reviewable, deterministic, and safe under low `CLAUDE_CODE_MAX_OUTPUT_TOKENS` values.

The common output-budget rule always applies. This SDD-specific rule adds stricter requirements for specs, research, design, plans, task files, fact files, antagonist reports, rollout docs, and rollback docs.

## Core SDD Rule

SDD artifacts must be split into compact index files and detailed child files.

Do not collapse detailed execution instructions into a single large `plan.md`.

A valid SDD plan is not just a checklist. It must include separate executable task files with enough detail to constrain implementation.

## Mandatory SDD Structure

For a normal implementation plan, create this structure:

```text
doc/playbook/<feature>/
  specs.md
  research.md
  design.md
  plan.md
  tasks/
    TASK-001.md
    TASK-002.md
    TASK-003.md
    ...
```

`plan.md` is the index and execution contract.

`tasks/TASK-001.md` files are the executable task contracts.

If the plan is PR-based, task file names may use PR IDs only when the project already uses that convention, for example:

```text
tasks/
  PR-1.md
  PR-2.md
```

Do not create only `plan.md` when the plan contains implementation tasks.

## `plan.md` Budget and Scope

`plan.md` must stay compact.

It may include:

- title
- objective
- global execution rules
- validation commands
- rollback summary
- human gates
- task index
- links to `tasks/TASK-001.md` files

It must not include detailed implementation instructions for each task.

It must not be the only executable source of truth for implementation.

If `plan.md` includes detailed per-file instructions, expected behavior, tests, and validation for each task, it is too large and must be split into child task files.

## Required Task Files

Every implementation task listed in `plan.md` must have a corresponding child file under `tasks/`.

Examples:

```text
plan.md checklist item: TASK-001 - Foundation dependencies and test helper
required child file: tasks/TASK-001.md
```

or:

```text
plan.md checklist item: PR-1 - Foundation dependencies and test helper
required child file: tasks/PR-1.md
```

The child file is mandatory even if the task seems simple.

## Task File Contract

Each `tasks/TASK-001.md` file must be specific enough that an implementer can execute it without inventing scope.

Each task file must include:

1. **Traceability** - linked `REQ-*`, `SCN-*`, `DA-*`, `FACT-*`, and `ADR-*` ids where applicable.
2. **Goal** - what this task delivers.
3. **Scope** - exact files expected to be modified, created, or deleted.
4. **Out of scope** - explicit things not to touch.
5. **Implementation steps** - small ordered steps.
6. **Expected behavior** - observable behavior after the task.
7. **Tests** - exact tests to add/update or exact reason no tests are needed.
8. **Validation commands** - commands to run for this task.
9. **Rollback notes** - how to revert this task safely.
10. **Completion checklist** - small checkbox list.

If a task file does not define exact files and expected behavior, it is not executable.

If a task file only says "implement X" or repeats the task title, it is invalid.

## Anti-Hallucination Requirements

Task files must constrain implementation.

Each task file must explicitly answer:

- Which files may be touched?
- Which files must not be touched?
- What existing behavior must be preserved?
- What tests prove the behavior?
- What would count as drift?
- What should the implementer do if reality differs from the plan?

If the implementer discovers that a planned file, API, class, method, event, dependency, or assumption does not exist, they must stop and report the mismatch. They must not invent a replacement silently.

## Required Drift Guard

Each task file must include this section:

```md
## Drift Guard

Stop and report instead of improvising if:

- a planned file does not exist
- a planned method/class/API does not exist
- an expected test helper is missing
- the implementation requires touching files outside scope
- the behavior differs from `design.md`
- the task cannot be completed without broad refactoring
```

This section is mandatory.

## SDD Document Creation Budget

For SDD artifacts such as:

- `specs.md`
- `research.md`
- `design.md`
- `plan.md`
- `tasks/TASK-001.md`
- `facts/*.md`
- rollout docs
- rollback docs
- antagonist reports

use section-by-section creation.

### `plan.md`

Create `plan.md` in small sections:

1. title and objective
2. execution rules
3. validation commands
4. rollback summary if required
5. task index only
6. human gates if required

Do not include task details in `plan.md`.

### `tasks/TASK-001.md`

Create each task file independently.

Rules:

- create only one task file per assistant turn unless the user explicitly requests batching
- keep each task file compact but complete
- do not generate all task files together
- do not print task file contents in chat
- after creating one task file, stop and summarize

## Forbidden SDD Pattern

Do not do this:

1. read many files
2. synthesize a full plan
3. write a large `plan.md`
4. put all implementation details inside `plan.md`
5. skip `tasks/*.md` files
6. summarize everything

This pattern is both output-budget unsafe and execution unsafe.

## Required SDD Pattern

Do this instead:

1. read the minimum needed context
2. write compact `plan.md` as index only
3. create one detailed child task file
4. stop and summarize
5. continue with the next child task only when instructed

## Plan Split Enforcement

Before considering planning complete, verify:

- [ ] `plan.md` exists
- [ ] `plan.md` contains a task index
- [ ] every task in the index points to a child file
- [ ] every child file exists
- [ ] every child file has Goal, Scope, Out of scope, Implementation steps, Expected behavior, Tests, Validation commands, Rollback notes, Completion checklist, and Drift Guard
- [ ] `plan.md` does not contain detailed implementation instructions that belong in child files

If any item is missing, the planning task is incomplete.

## Antagonist Check Requirement

The antagonist must check for this specific blocker:

> Plan tasks are not split into executable child task files, leaving too much implementation freedom.

The antagonist must also check:

- missing or vague task files
- task files without exact file scope
- task files without tests
- task files without drift guards
- task files that allow broad refactors
- `plan.md` containing too much task detail
- task index entries with no corresponding child file

## Recovery Mode for SDD

If an output-limit error happens during SDD planning, the next assistant turn must not retry the whole plan.

Recovery sequence:

1. create or fix only the `tasks/` directory
2. ensure `plan.md` is compact and index-only
3. create only one missing task file
4. stop

Do not use subagents in SDD recovery unless explicitly instructed.

Do not continue with all remaining task files automatically.

## SDD Response Format

After changing SDD files, respond with at most 20 words and only include:

- file changed
- what small unit was completed
- next suggested unit

Example:

```md
Updated `tasks/TASK-001.md`: task contract added. Next: create `tasks/TASK-002.md`.
```

Never print generated SDD file contents unless explicitly requested.
