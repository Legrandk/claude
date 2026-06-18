---
name: sdd-research
description: Inspect the repository against an existing spec.md and produce research.md with concrete code evidence. Never plans or implements.
origin: user
---

# SDD Research

Research existing implementation before planning.

This skill answers repository questions raised by `spec.md`.

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

- The user invokes `/sdd-research <playbook-path>`
- A `spec.md` exists and the user wants implementation context
- The user says "research this spec"
- The user says "inspect the repo for this feature"

## Required Inputs

Read:

- `<playbook-path>/spec.md`

If `spec.md` is missing, stop and ask the user to run `/sdd-start` first.

## Workflow

1. Read `spec.md`
2. Inspect relevant code, tests, config, schemas, dashboards, jobs, consumers, docs, and infrastructure
3. Answer the `Research Questions` from `spec.md`
4. Record concrete evidence
5. Write `<playbook-path>/research.md`
6. Do not create `plan.md`
7. Do not create `tasks/`
8. Do not modify code

## research.md Structure

```md
# Research: <feature>

## Spec Input

- Spec path: `<path>`
- SDD rigor: `<level>`
- Refined spec required before planning: yes

## Research Questions Answered

### Question

Linked Requirements:

- `REQ-001`

Linked Scenarios:

- `SCN-001`

Answer:

Evidence:

- `path/to/file`: reason

## Relevant Files

- `path`: why it matters; links: `REQ-001`, `SCN-001`

## Current Flow

Describe what happens today based on repository evidence.

## Existing Verification

Existing tests, contracts, schemas, checks, or CI validations.

- `path`: what behaviour is already covered

## Contracts / External Interfaces

HTTP, messages, database, storage, external providers, dashboards, alerts, APIs, CLIs, or other boundaries.

## Observability

Existing metrics, logs, dashboards, alerts, instrumentation points.

## Constraints

Technical constraints discovered in the repo.

## Risks

Implementation risks, compatibility risks, operational risks, rollout risks.

## Unknowns

Questions that remain unresolved after repository inspection.

## Planning Inputs

Concrete facts the planner must use.

Include traceability inputs:

- `REQ-001` / `SCN-001`: repository evidence, constraints, risks, and referenced `ADR-NNNN` ids when applicable
```

## Evidence Rules

Research claims must cite concrete repository evidence.

Prefer:

- file paths
- module/component names
- existing verification artifacts
- schema files
- dashboard files
- infrastructure files
- config files
- ADRs

Every research finding that materially affects the feature should list the relevant `REQ-*` and `SCN-*` ids.

Do not invent current behaviour.

If the repository does not contain evidence, say so.

## Output Rules

Return only:

- files inspected
- `research.md` path
- blocking unknowns, if any
- next recommended command
