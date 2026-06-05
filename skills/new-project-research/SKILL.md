---
name: new-project-research
description: Extract source-backed requirements, contradictions, and open questions from new-project source documents. Does not create architecture, plans, or code.
origin: user
---

# New Project Research

Extract requirements from source documents for a brand-new project.

This skill produces:

- `requirements.md`
- `contradictions.md`
- `open_questions.md`

It must not choose architecture, create delivery artifacts, create facts, create plans, scaffold files, or implement code.

## Rules

Follow:

- `rules/new-project/workflow.md`
- `rules/common/output-budget.md`

## Required Inputs

Read:

- `<new-project-path>/source_inventory.md`
- `<new-project-path>/project_brief.md`

Then read the source documents identified by `source_inventory.md`, one by one.

If the start artifacts are missing, stop and ask the user to run `/new-project-start` first.

## Workflow

1. Read `source_inventory.md`.
2. Read `project_brief.md`.
3. Read source documents incrementally.
4. Extract source-backed behavioral requirements.
5. Extract constraints and non-functional requirements.
6. Identify contradictions.
7. Identify open questions.
8. Ask the user only for questions that block requirements.
9. Write `requirements.md`.
10. Write `contradictions.md`.
11. Write `open_questions.md`.

## Requirement Rules

Use stable ids:

- `REQ-001`, `REQ-002`, ... for behavior
- `CON-001`, `CON-002`, ... for constraints
- `NFR-001`, `NFR-002`, ... for non-functional requirements

Every requirement must cite source evidence.

Use EARS for behavioral requirements where practical.

Avoid implementation details unless the source documents explicitly require them.

## requirements.md Structure

```md
# Requirements: <project>

## Source Inputs

## Behavioral Requirements

### REQ-001: <name>

Requirement:

Source Evidence:

- `<path>`: <section or note>

Notes:

## Constraints

## Non-Functional Requirements

## Out of Scope

## Requirements Needing Decisions
```

## contradictions.md Structure

```md
# Contradictions: <project>

## Active Contradictions

### CONTRADICTION-001: <name>

Conflict:

Sources:

- `<path>`: <evidence>
- `<path>`: <evidence>

Impact:

Decision Needed:

Status: open | resolved

## Resolved Contradictions
```

## open_questions.md Structure

```md
# Open Questions: <project>

## Blocking

## Non-Blocking

## Decisions Received
```

## Output Rules

Return only:

- files created
- number of requirements
- number of contradictions
- blocking questions, if any
- next recommended command
