---
name: sdd-delivery-artifacts
description: Generate delivery_artifacts/*.md from refined spec.md and research.md. Lists concrete files/modules/configuration/docs that must be produced or modified before planning. Does not include tests, create facts, plan, or implement.
origin: user
---

# SDD Delivery Artifacts

Generate the delivery artifact map for a feature.

`delivery_artifacts/` is a variable, feature-specific map of what must be produced.

It must not include verification artifacts unless they are themselves the production artifact being delivered.
It must not include validation commands.
It must not create `facts/`.
It must not create `plan.md`.
It must not create `tasks/`.
It must not modify application code.

This skill is framework-agnostic.

It must not assume Rails, Elixir, Kotlin, Terraform, devkit, Docker, CI, or any specific command runner.

## Rules

Follow:

- `rules/sdd/workflow.md`

## Required Inputs

Read:

- `<playbook-path>/spec.md`
- `<playbook-path>/research.md`

If `spec.md` is missing, stop and ask the user to run `/sdd-start` first.

If `research.md` is missing, stop and ask the user to run `/sdd-research` first.

If `spec.md` is not refined, stop and ask the user to run `/sdd-refine` first.

## Output

Create:

- `<playbook-path>/delivery_artifacts/`

Inside it, create one or more numbered markdown files grouped by the natural delivery areas of this feature.

Do not use a fixed category list.

Infer area names from:

- `spec.md`
- `research.md`
- impacted files
- impacted runtime components
- impacted external contracts
- impacted operational surfaces
- SDD rigor level

Examples of possible area names:

- `01-domain-model.md`
- `02-api-contracts.md`
- `03-jobs-consumers.md`
- `04-observability.md`
- `05-rollout.md`
- `01-dashboard.md`
- `02-infrastructure.md`
- `01-cli-command.md`
- `02-configuration.md`

Use only the files that make sense for the current feature.

## Grouping Rules

- Group by delivery area, not by task.
- Prefer 2–6 files.
- Avoid creating one file per source file.
- Avoid generic buckets like `misc.md`.
- Avoid forcing categories that do not apply.
- Use stable numbering only to define reading order, not implementation order.

## File Format

Each delivery artifact file must use this structure:

```md
# <Area Name>

## Purpose

Why this delivery area exists for this feature.

## Artifacts

### DA-001: `<path-or-component-name>`

Traceability:

- Requirements: `REQ-001`
- Scenarios: `SCN-001`
- Facts: `TBD until /sdd-facts`
- Tasks: `TBD until planning`
- ADRs: `ADR-NNNN` when applicable, otherwise `None`

Produce:

- [ ] Concrete output/change to produce.
- [ ] Concrete output/change to produce.

Constraints:

- Constraint or non-change.
- Constraint or non-change.

Source:

- `spec.md`: `REQ-001`, `REQ-002`, scenario, or section
- `research.md`: file, flow, risk, or finding
```

## Artifact Rules

- Use checkboxes for concrete production outputs.
- Prefer concrete file paths when known.
- Use component names when exact files are unknown.
- Do not include validation commands.
- Do not include test/linter execution.
- Do not include framework-specific command details.
- Mark expected non-changes explicitly when they prevent unnecessary work.
- Avoid vague items like "update service" or "improve logic".
- Give each concrete artifact a stable `DA-*` id.
- Link each artifact to requirements and scenarios.
- Link each artifact to ADRs when an architectural decision constrains it.
- Leave facts and tasks as `TBD` until those artifacts are generated.

## Output Rules

Return only:

- directory created
- files created
- number of artifacts
- blocking open questions, if any
- next recommended command
