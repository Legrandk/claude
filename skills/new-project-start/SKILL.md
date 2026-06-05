---
name: new-project-start
description: Start a brand-new project from source Markdown documents. Creates source_inventory.md and project_brief.md under doc/new-project/<project>. Does not create architecture, plans, or code.
origin: user
---

# New Project Start

Create the initial new-project workspace from source documents.

This skill turns scattered `.md` notes into:

- `source_inventory.md`
- `project_brief.md`

It must not create requirements, architecture, delivery artifacts, facts, plans, tests, or application code.

## Rules

Follow:

- `rules/new-project/workflow.md`
- `rules/common/output-budget.md`

## When to Activate

Use this skill when:

- the user invokes `/new-project-start`
- the user says "start a new project from these docs"
- the user has many `.md` files and wants to build a project from scratch
- the user wants a source inventory and project brief before implementation

Do not use this skill for adding a feature to an existing project. Use SDD instead.

## Inputs

The user may provide:

- a directory containing source `.md` files
- a list of source files
- a rough project name
- a target new-project path

If the target path is not explicit, infer:

```text
doc/new-project/<YYYYMMDD>_<project_slug>/
```

Use a lowercase snake_case slug.

## Workflow

1. Identify the source documents.
2. Read only the source documents needed for the initial inventory and brief.
3. Classify source files by apparent purpose.
4. Identify project intent, users, goals, non-goals, and constraints.
5. Identify blocking ambiguities.
6. Ask the user if blocking ambiguities prevent a credible brief.
7. Write `source_inventory.md`.
8. Write `project_brief.md`.

## Source Boundary

Do not invent project facts.

If a source document is unclear, missing, contradictory, or incomplete, record that explicitly.

If a current-codebase fact would matter, write:

```text
Not applicable. This is a brand-new project.
```

## source_inventory.md Structure

```md
# Source Inventory: <project>

## Source Set

- Source root:
- Target path:
- Created:

## Documents

### `<path>`

Status: included | excluded | partial | missing

Purpose:

Key Topics:

Notes:

## Coverage Summary

## Gaps

## Next Source Questions
```

## project_brief.md Structure

```md
# Project Brief: <project>

## Intent

## Problem

## Goal

## Non-goals

## Users / Consumers

## Source-Backed Constraints

## Known Unknowns

## Out of Scope for Initial Foundation

## Next Step

Run `/new-project-research`.
```

## Output Rules

Return only:

- target directory
- source documents inventoried
- files created
- blocking questions, if any
- next recommended command
