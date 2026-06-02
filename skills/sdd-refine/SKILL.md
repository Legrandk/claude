---
name: sdd-refine
description: Refine spec.md using research.md. Reconciles intent with repository evidence, adds Change Set, updates EARS requirements, and marks the spec as refined. Does not plan or implement.
origin: user
---

# SDD Refine

Refine the intent-level `spec.md` using repository evidence from `research.md`.

This skill turns `spec.md` v0 into `spec.md` v1.

It must not plan implementation.
It must not modify application code.
It must not create `delivery_artifacts/`, `facts/`, or `plan.md`.

This skill is framework-agnostic.

It must not assume Rails, Elixir, Kotlin, Terraform, devkit, Docker, CI, or any specific command runner.

## Rules

Follow:

- `rules/sdd/workflow.md`

## When to Activate

Use this skill when:

- The user invokes `/sdd-refine <playbook-path>`
- `spec.md` and `research.md` exist
- The user says "refine the spec with research"
- The user wants to reconcile intent with repository findings

## Required Inputs

Read:

- `<playbook-path>/spec.md`
- `<playbook-path>/research.md`

If `spec.md` is missing, stop and ask the user to run `/sdd-start` first.

If `research.md` is missing, stop and ask the user to run `/sdd-research` first.

## Workflow

1. Read `spec.md`
2. Read `research.md`
3. Replace unknown current behaviour with researched current behaviour
4. Update or clarify EARS requirements
5. Add or update the Change Set
6. Surface conflicts between intent and repo reality
7. Detect architectural decisions (see ADR Detection below)
8. Ask the user which decisions to record as ADRs
9. Write confirmed ADRs to `docs/adr/`
10. Keep unresolved questions as checkboxes
11. Mark the spec as refined

## Refinement Rules

You may clarify requirements using repository evidence.

You must not silently change user intent.

If research contradicts the original intent, add a `Research Conflicts` section.

Use this format:

```md
## Research Conflicts

- Conflict: <what conflicts>
  - Spec intent: <original intent>
  - Research finding: <repo evidence>
  - Resolution: <resolved / open question / requires user decision>
```

If the conflict requires user input, use `AskUserQuestionTool`.

## ADR Detection

After surfacing conflicts, scan for architectural decisions that emerged during reconciliation.

A decision is ADR-worthy if it involves a meaningful tradeoff between alternatives — not a trivial implementation detail.

Signals:

- A conflict required choosing between two approaches
- A constraint eliminated one option in favour of another
- A design choice has long-term consequences on the codebase structure
- A requirement was changed or removed because of repository reality

### Detection Step

List each candidate decision in chat using this format:

```md
### Candidate ADRs

1. [Short title] — chose X over Y because [brief reason] (linked: REQ-001)
2. [Short title] — ...
```

Then use `AskUserQuestionTool` to ask which ones to record. Do not write any ADR file before the user confirms.

If no architectural decisions were detected, skip this step entirely and do not mention it.

### Writing ADRs

For each confirmed decision, write one ADR file to `docs/adr/NNNN-decision-title.md`.

Scan existing files in `docs/adr/` to assign the next sequential number.

If `docs/adr/` does not exist, create it before writing.

Use this format:

```md
# ADR-NNNN: [Decision Title]

**Date**: YYYY-MM-DD
**Status**: accepted
**Requirements**: REQ-XXX, REQ-YYY

## Context

[2-4 sentences: the situation and constraints that forced a decision]

## Decision

[1-2 sentences: what was decided]

## Alternatives Considered

### [Alternative 1]
- **Why not**: [specific reason rejected]

### [Alternative 2]
- **Why not**: [specific reason rejected]

## Consequences

### Positive
- [benefit]

### Negative
- [trade-off]
```

After writing each ADR, append a row to `docs/adr/README.md` (create it if missing):

```md
| [NNNN](NNNN-decision-title.md) | [Title] | accepted | YYYY-MM-DD |
```

Write one ADR file at a time. Do not batch multiple ADRs in one response.

## Required Changes to spec.md

After refinement, `spec.md` must include:

```md
<!-- sdd: refined=true -->
<!-- refined_from: research.md -->
```

It must also include:

```md
## Change Set

### Added

### Modified

### Removed

### Unchanged
```

## Change Set Rules

Use the Change Set to describe the feature delta for a brownfield repository.

### Added

New behaviours, artifacts, contracts, metrics, jobs, endpoints, docs, dashboards, alerts.

### Modified

Existing behaviours, files, flows, interfaces, contracts, dashboards, alerts.

### Removed

Behaviours, files, configs, flags, contracts, or docs that should disappear.

### Unchanged

Important behaviours or interfaces that must remain untouched.

Use `Unchanged` aggressively to prevent scope creep.

## EARS Rules

Maintain stable requirement ids where possible.

If a requirement is split, preserve traceability:

```md
Split from: `REQ-002`
```

If a requirement is removed, explain why.

Requirements must remain:

- atomic
- verifiable
- behaviour-focused
- expressed with `shall`

## Output Rules

After updating `spec.md`, return only:

- path updated
- whether conflicts remain
- number of requirements
- number of open questions
- ADRs written (paths), or "no ADRs recorded"
- next recommended command
