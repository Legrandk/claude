---
name: new-project-delivery-artifacts
description: Generate delivery_artifacts/*.md for a brand-new project foundation and first vertical slice. Does not create facts, plans, tests, or code.
origin: user
---

# New Project Delivery Artifacts

Generate the production artifact map for a brand-new project.

This skill produces:

- `delivery_artifacts/*.md`

It must not create facts, create plans, scaffold code, implement tests, or run validation.

## Rules

Follow:

- `rules/new-project/workflow.md`
- `rules/common/output-budget.md`

## Required Inputs

Read:

- `<new-project-path>/project_brief.md`
- `<new-project-path>/requirements.md`
- `<new-project-path>/architecture.md`
- `<new-project-path>/contradictions.md`
- `<new-project-path>/open_questions.md`

If architecture is missing, stop and ask the user to run `/new-project-architecture` first.

If unresolved blockers affect artifact scope, stop and ask the user for a decision.

## Output

Create:

- `<new-project-path>/delivery_artifacts/`

Inside it, create numbered markdown files grouped by natural delivery area.

Examples:

- `01-project-foundation.md`
- `02-domain-model.md`
- `03-api-contracts.md`
- `04-first-vertical-slice.md`
- `05-observability.md`
- `06-deployment.md`

Use only the files that fit the project.

## Artifact Rules

- Group by delivery area, not implementation task.
- Prefer 2-6 files.
- Use checkboxes for concrete production outputs.
- Distinguish files to create from files to modify when known.
- Do not include validation commands.
- Do not include tests unless a test asset is itself a shipped artifact.
- Link artifacts to requirements, constraints, architecture sections, or ADR candidates.
- Include the first vertical slice.

## File Format

```md
# <Area Name>

## Purpose

## Artifacts

### `<path-or-component-name>`

Produce:

- [ ] Concrete output to create.

Files To Create:

- `<path>`

Files To Modify:

- `<path>`

Constraints:

- Constraint or non-change.

Source:

- `requirements.md`: `REQ-001`
- `architecture.md`: `<section>`
```

## Output Rules

Return only:

- directory created
- files created
- number of artifacts
- blocking open questions, if any
- next recommended command
