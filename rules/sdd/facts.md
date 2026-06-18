# SDD Facts

A fact is an executable assertion.

Specs explain intent.
Facts verify behaviour.

A fact should be true or false by running a command, checking a contract, validating a schema, executing a test, or running another deterministic verification step.

SDD facts are framework-agnostic.

They must not hardcode framework-specific commands, file conventions, test runners, build tools, local execution wrappers, or service names.

## When to Create Facts

Create facts for:

- external behaviour
- domain rules
- API contracts
- message payloads
- permissions
- idempotency
- retry behaviour
- invariants
- observability-critical behaviour
- dashboards or alerts that can be validated
- bugs that must not regress

Do not create facts for:

- trivial implementation details
- class names unless externally relevant
- refactor mechanics
- pure explanatory documentation
- things that cannot reasonably be verified

## Fact Status

Use one of:

- `@draft`: proposed but not yet accepted
- `@spec`: accepted and required
- `@implemented`: executable check exists and passes
- `@deferred`: intentionally postponed

Do not mark a fact `@implemented` unless the executable check exists and passes.

## Fact Format

Use this structure:

```md
## FACT-001: <short name>

Status: @spec

Requirements:

- `REQ-001`

Scenarios:

- `SCN-001`

Delivery Artifacts:

- `DA-001` - `delivery_artifacts/<file>.md` -> `<artifact heading>`

Tasks:

- `TBD until planning`

ADRs:

- `ADR-NNNN` when applicable, otherwise `None`

Traceability:

- Requirements -> Scenarios -> Delivery Artifacts -> Facts -> Tasks
- ADRs constrain this fact only when listed above.


Executable Check:

- Type: <unit test | integration test | contract validation | schema validation | static analysis | smoke test | CI job | other>
- Target: <what must be verified>
- Command: resolved from applicable project rules

Assertion:

- Given ...
- When ...
- Then ...

Implementation Target:

- <test file, contract file, schema file, CI job, or validation artifact when known>

Notes:

- ...
```

## Executable Check Rules

Each fact must define an executable check when possible.

The command must be chosen according to applicable project, stack, or repository rules.

Examples of executable check types include:

- unit test
- integration test
- contract test
- schema validation
- static analysis
- infrastructure validation
- smoke test
- CI job

Do not hardcode framework-specific command formats in SDD rules.

Do not mention specific runners such as Rails, RSpec, Mix, Gradle, Maven, Terraform, devkit, Docker, or CI-specific commands unless those commands come from project-specific rules.

If no applicable project rule defines how to run the check, write:

```md
Command: TODO - resolve from project rules
```

Do not guess.

## Traceability

Every non-trivial behavioural requirement should map to at least one fact unless explicitly marked as:

- documentation-only
- human-only
- deferred
- not verifiable at this layer

Use lightweight traceability:

```txt
REQ -> SCN -> DA -> FACT -> TASK
```

Use `ADR-NNNN` cross-links when an architectural decision constrains a fact.
