---
name: execute-plan
description: Read plan.md and execute every unchecked task autonomously using a TDD loop: write failing tests, implement, verify using applicable project rules, update SDD tracking, and mark complete. Runs disjoint tasks in parallel.
origin: user
---

# Execute Plan

Read `plan.md` and drive every unchecked task to completion autonomously using a test-first loop.

A task is not complete when code changes are implemented.

A task is complete only when implementation, validation, and SDD tracking updates are all done.

## When to Activate

- User invokes `/execute-plan` with an optional path argument
- User says "execute plan", "run the plan", "execute all pending tasks", "implement everything in plan.md"
- A `plan.md` exists in the project and the user asks to start, continue, or resume implementation

## Workflow

### Step 0 — Locate plan.md

If `$ARGUMENTS` provides a path, use it. Otherwise search the project for `plan.md` (prefer `doc/playbook/*/plan.md`). Read the file fully before proceeding.

### Step 1 — Parallelism analysis

Scan all unchecked tasks and group them by the files they touch.

Tasks whose file scopes do not overlap are **disjoint** and may be launched in parallel via the Task tool in a **single Agent call**.

Tasks that share files must run sequentially.

### Step 2 — Execution loop

For each unchecked task, or parallel batch of disjoint tasks:

#### 2a — Write failing tests

Invoke the **tdd-guide** agent:

```txt
Write failing tests for the following task. Scope your tests strictly to these files: <files>.
Do not modify any application code.
Do not touch friendly_id slug behavior.
Task: <task description>
```

Wait for the agent to return before proceeding.

#### 2b — Implement

Invoke the **implementer** agent:

```txt
Make the following failing tests pass.
Constraints:
- Do not modify code outside the files listed below.
- Do not touch friendly_id slug behavior.
- Do not add features beyond what the tests require.
Files: <files>
Tests: <test file paths from 2a>
```

#### 2c — Verify

Run the task validation using the applicable project rules.

Use validation commands defined by:

- the task file
- `plan.md`
- repository-specific rules
- common rules
- stack-specific rules

Do not invent command conventions.

Do not run commands directly on the host if project rules require a wrapper.

Do not bypass project rules with raw tooling.

If validation fails, fix the immediate error and retry once.

If validation still fails after the second attempt, stop the entire loop and output a failure summary of ≤ 400 tokens:

- which task failed
- the error output
- what was attempted
- what help is needed

#### 2d — Completion Gate

After validation passes, immediately complete the tracking gate before moving to the next task.

Tracking updates are not optional cleanup; they are part of the task's Definition of Done.

A task is complete only when all required completion gates pass:

1. Implementation done.
2. Validation passed.
3. `plan.md` task checkbox updated.
4. Related `plan/tN.md` `Done When` checkboxes updated.
5. Related `delivery_artifacts/*.md` checkboxes updated.
6. Related `facts/*.md` statuses updated.

Do not move to the next task until all applicable completion gates are done.

Do not say `done`, `completed`, `ready for review`, or `waiting for owner review` until all applicable tracking files have been updated.

Update tracking files one by one in small chunks following `rules/common/output-budget.md`.

## Tracking Update Rules

After validation passes for a task, immediately update tracking files one by one in small chunks.

### `plan.md`

- Mark the executed task as `[x]`.
- Mark related delivery checklist items as `[x]` only if actually produced.
- Mark related facts checklist items as `[x]` only if their executable checks exist and passed.

### `plan/tN.md`

- Mark completed `Done When` items as `[x]`.
- Leave incomplete items unchecked.
- Add a short completion note only if useful.

### `delivery_artifacts/*.md`

- Mark produced or modified artifacts as `[x]`.
- Do not mark planned-only artifacts as complete.

### `facts/*.md`

Change fact status from `@spec` to `@implemented` only when:

- the implementation exists
- the executable check exists
- the executable check passed

Keep fact status as `@spec` if implementation exists but verification has not passed.

Use `@deferred` only when explicitly approved.

## Constraints

- Run validation using the applicable project, stack, and common rules.
- Do not invent command conventions.
- Do not bypass project rules with raw tooling.
- If the applicable rules cannot complete the task, stop and ask the user for help using `AskUserQuestionTool`.
- Never rewrite tests to make them pass artificially.
- Never ask the user anything unless completely blocked with no path forward.
- Update SDD tracking files immediately after each task is verified.
- Do not batch tracking updates at the end of the whole plan.
- At minimum, mark the task as `[x]` in `plan.md`.
- When applicable, also update `plan/tN.md`, `delivery_artifacts/*.md`, and `facts/*.md`.
- Do not mark delivery artifacts or facts complete unless they were actually produced and verified.
- Parallel tasks must be launched in a **single** Agent tool call.

## SDD Guardrails

Before execution, if the plan lives under `doc/playbook/<feature>/`:

- Verify `spec.md` exists
- Verify `research.md` exists
- Verify every unchecked task points to a task file or contains explicit file scope
- Refuse to execute if the plan requires architectural decisions not captured in an ADR or explicitly approved in the plan

## New Project Guardrails

Before execution, if the plan lives under `doc/new-project/<project>/`:

- Verify `project_brief.md` exists
- Verify `requirements.md` exists
- Verify `architecture.md` exists
- Verify `delivery_artifacts/` contains at least one markdown file
- Verify `facts/` contains at least one markdown file
- Verify every unchecked task points to a task file
- Verify each task file distinguishes:
  - `Files To Create`
  - `Files To Modify`
  - `Files That Must Already Exist`
- Treat missing files under `Files To Create` as expected
- Treat missing files under `Files That Must Already Exist` as drift
- Use validation commands from the task file, `architecture.md`, or applicable project rules
- Refuse to execute if unresolved architecture decisions block scaffold or first-slice work

## Done Criteria

A task is done only when:

- failing tests were written when applicable
- implementation is complete
- required validation passed
- `plan.md` is updated
- related `plan/tN.md` is updated when applicable
- related `delivery_artifacts/*.md` files are updated when applicable
- related `facts/*.md` files are updated when applicable
- no out-of-scope files were modified

## Output

Keep output short.

After each completed task or task batch, return only:

- completed task id(s)
- changed files
- validation result
- tracking files updated
- next task or blocker

Do not echo full file contents.
Do not print large diffs.
Follow `rules/common/output-budget.md`.
