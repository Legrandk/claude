# Execute Plan SDD Addition

Add this to `skills/execute-plan/SKILL.md`.

## SDD Execution

When executing work under `doc/playbook/<feature>/`, follow:

- `rules/sdd/workflow.md`
- `rules/sdd/facts.md`

SDD is framework-agnostic.

Do not derive framework-specific commands, runners, wrappers, or build tools from SDD rules.

Use applicable project, stack, or repository rules for command execution.

Before executing, read:

- `spec.md`
- `research.md`
- `delivery_artifacts/*.md`
- `facts/*.md`
- `doc/adr/*.md`, when referenced
- `plan.md`
- the relevant `tasks/TASK-001.md` task file, if present

## SDD Guardrails

Before execution, verify:

- `spec.md` exists
- `research.md` exists
- `spec.md` is refined if `research.md` exists
- `delivery_artifacts/` exists and contains markdown files
- `facts/` exists for L1+ or L2 work
- `plan.md` exists
- the selected task is unchecked
- the selected task has `Allowed Files`
- the selected task has traceability links for applicable `REQ-*`, `SCN-*`, `DA-*`, `FACT-*`, and `ADR-*` ids

Do not execute if the task requires architectural decisions not captured in an ADR or explicitly approved in the plan.

## Parallel Task Execution

Tasks marked `[P]` may be executed in parallel only when their dependencies are already complete.

Do not parallelize unmarked tasks.

If two `[P]` tasks touch the same file, execute them sequentially.

Do not infer new parallelization during execution unless the user explicitly asks for replanning.

## Command Execution

Before running validation commands:

1. Prefer commands listed in the task or plan.
2. If the command says `TODO - resolve from project rules`, read the applicable project, stack, or repository rules.
3. Do not invent stack-specific commands from SDD rules.
4. Do not add wrappers or runners unless required by applicable project rules.

## Checklist Updates

After completing a task:

1. Mark the task as `[x]` in `Task Checklist`.
2. Mark delivered artifacts as `[x]` in `Delivery Checklist`.
3. Mark implemented facts as `[x]` in `Facts Checklist`.
4. Mark detailed artifact checkboxes inside `delivery_artifacts/*.md` when applicable.
5. Fill `Tasks:` links in related `facts/*.md` entries when the task implements them.
6. Mark facts as `@implemented` only when their executable check exists and passes.
7. Do not mark a fact complete if it is merely planned.
8. Do not mark a delivery artifact complete unless the corresponding output exists.

## Done Criteria

A task is done only when:

- all intended files are modified
- no unplanned files are modified
- required facts are implemented or explicitly deferred
- targeted validation passes
- checklist state is updated
- the summary is brief and concrete
