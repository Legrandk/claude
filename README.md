# Claude Code Configuration

A set of agents, skills, and rules for disciplined AI-assisted development with [Claude Code](https://claude.ai/code).

## What's in here

### `CLAUDE.md`

The main instruction file loaded by Claude Code in every session.

It should stay small and define only the core behavioural constraints:

- Think before coding — state assumptions explicitly and surface ambiguities.
- Simplicity first — write the minimum code that solves the problem.
- Surgical changes — touch only what the task requires.
- Goal-driven execution — define success criteria and verify results.

Workflow-specific guidance should live in `rules/` and `skills/`, not directly in `CLAUDE.md`.

### `agents/`

Custom subagent definitions. Each agent has a narrow, well-defined role:

| Agent | Role |
|-------|------|
| `planner` | Converts an approved task/spec into a deterministic `plan.md` |
| `implementer` | Executes an approved `plan.md` with minimal changes |
| `reviewer` | Reviews code changes against the plan, spec, and delivery artifacts |
| `antagonist` | Adversarial pre-PR reviewer: looks for blockers, hidden risks, weak validation, unsafe rollout, and scope creep |
| `tdd-guide` | Enforces test-first workflow: red → green → refactor |
| `tech-lead` | Research and planning only — never modifies code |

### `skills/`

Slash commands that orchestrate multi-step workflows:

| Skill | Command | What it does |
|-------|---------|--------------|
| `sdd-start` | `/sdd-start` | Creates an intent-level `spec.md` v0 from a rough requirement, using `AskUserQuestionTool` to resolve blocking ambiguities |
| `sdd-research` | `/sdd-research` | Inspects the repository against `spec.md` and writes `research.md` with concrete code evidence |
| `sdd-refine` | `/sdd-refine` | Refines `spec.md` using `research.md`, producing the planning-ready version |
| `sdd-delivery-artifacts` | `/sdd-delivery-artifacts` | Creates `delivery_artifacts/*.md`, a feature-specific map of what must be produced or modified |
| `sdd-facts` | `/sdd-facts` | Creates `facts/*.md`, executable or verifiable assertions that prove important requirements |
| `execute-plan` | `/execute-plan` | Reads `plan.md` and drives every task to completion using a TDD loop, parallelizing disjoint tasks when safe |
| `deep-spec-review` | `/deep-spec-review` | Runs specialist reviewers in parallel — security, cost, compliance, ops, architecture — and conducts structured Q&A before edits |
| `architecture-decision-records` | `/architecture-decision-records` | Captures architectural decisions as structured ADR documents in `docs/adr/` |
| `spec-review` | `/spec-review` | Lightweight spec review |

### `rules/`

Domain-specific standards and workflow rules loaded on demand:

```text
rules/
├── common/       # Coding style, testing, security, patterns, hooks, devkit, jt-linter
├── rails/        # Rails-specific style, testing, security, patterns, hooks
├── terraform/    # Terraform, DynamoDB, IAM and infrastructure rules
└── sdd/          # Spec-Driven Development workflow and artifact rules
```

### `settings.json` and `keybindings.json`

Claude Code configuration files for project-specific settings:
- `settings.json` — Permissions allowlist, model selection, token limits, and status line customization
- `keybindings.json` — Custom keyboard shortcuts for Claude Code chat

## Installation & Setup

This repository contains Claude Code configuration files (agents, skills, rules, and behavioral constraints) that you install once to use across all your projects.

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Legrandk/claude.git
   cd claude
   ```

2. Copy the configuration files to your home directory where Claude Code looks for them:
   ```bash
   # macOS/Linux
   mkdir -p ~/.claude
   cp -r agents/ ~/.claude/
   cp -r skills/ ~/.claude/
   cp -r rules/ ~/.claude/
   cp CLAUDE.md ~/.claude/

   # Windows
   mkdir %USERPROFILE%\.claude
   xcopy agents\ %USERPROFILE%\.claude\agents\ /E /I
   xcopy skills\ %USERPROFILE%\.claude\skills\ /E /I
   xcopy rules\ %USERPROFILE%\.claude\rules\ /E /I
   copy CLAUDE.md %USERPROFILE%\.claude\
   ```

3. Restart Claude Code (web interface or VS Code extension) if it's already running.

### Verification

After installation, open Claude Code in ANY project and test:

1. **Check agents** — Type `@` in chat and you should see:
   - `@planner`
   - `@implementer`
   - `@reviewer`
   - `@antagonist`
   - `@tech-lead`
   - `@tdd-guide`

2. **Check slash commands** — Type `/` in chat and you should see:
   - `/sdd-start`
   - `/sdd-research`
   - `/sdd-refine`
   - `/execute-plan`
   - `/deep-spec-review`
   - And more...

3. **Check CLAUDE.md** — The core behavioral constraints should be active:
   - Think before coding
   - Simplicity first
   - Surgical changes
   - Goal-driven execution

### Usage

Once installed, these tools are available in every Claude Code session:

```bash
# Start a new feature with spec-driven development
/sdd-start doc/playbook/20260603_my_feature

# Ask the planner to create a plan
@planner Review this spec and create a plan.md

# Execute the plan
/execute-plan

# Review the changes
@reviewer Check if implementation matches the plan
```

### Updating

To update to the latest version:

```bash
cd claude
git pull
cp -r agents/ skills/ rules/ CLAUDE.md ~/.claude/
```

### Optional: Claude Code Settings

The repository also includes optional Claude Code configuration files:

- **settings.json** — Claude Code permissions, model selection, status line customization
- **keybindings.json** — Custom keyboard shortcuts for Claude Code

These are project-specific and typically stay in the repository rather than being installed globally. They configure Claude Code behavior when working on projects (e.g., allowed bash commands, output token limits).

If you want to use these settings as defaults for all projects, you can copy them to your Claude Code configuration directory (location varies by Claude Code version and platform - check Claude Code documentation).

## Using with Claude Code

### Invoking Agents

To use a specific agent, type `@agent-name` in Claude Code chat:

```
@planner Convert this requirement into a plan.md
```

Available agents:
- `@planner` — Creates a deterministic plan from a task/spec
- `@implementer` — Executes the plan with minimal changes
- `@reviewer` — Reviews code against plan, spec, and artifacts
- `@antagonist` — Adversarial pre-PR review for risks and blockers
- `@tech-lead` — Research and planning (read-only, no code changes)
- `@tdd-guide` — Enforces test-first workflow

### Using Slash Commands

Slash commands orchestrate multi-step workflows. Type `/` in Claude Code to see available commands:

```
/sdd-start                    # Start a new feature with intent-level spec
/sdd-research                 # Research the repository
/sdd-refine                   # Refine spec with research findings
/sdd-delivery-artifacts       # Map feature requirements
/sdd-facts                    # Create verifiable assertions
/execute-plan                 # Drive tasks to completion
/deep-spec-review             # Parallel specialist reviewers
/architecture-decision-records # Capture ADRs
/spec-review                  # Lightweight spec review
```

### Core Behavioral Constraints

When you use Claude Code in this workspace, `CLAUDE.md` automatically loads four core principles:

1. **Think before coding** — state assumptions, surface ambiguities
2. **Simplicity first** — minimum code that solves the problem
3. **Surgical changes** — touch only what's necessary
4. **Goal-driven execution** — define success criteria and verify

Domain-specific rules from `rules/` (Rails, Terraform, testing, security, etc.) are loaded on demand based on your project context.

## How it works

There are two main operating modes.

### Lightweight mode

Use this for trivial or mechanical work:

1. **Plan** — invoke the `planner` agent with a task description.
2. **Execute** — run `/execute-plan`.
3. **Review** — invoke the `reviewer` agent.

This mode is appropriate for:

- typo fixes
- small copy changes
- obvious one-line configuration changes
- mechanical renames with no behavioural impact

### Spec-Driven Development mode

Use SDD for non-trivial feature work, ambiguous requirements, behaviour changes, API changes, background jobs, observability changes, infrastructure changes, or anything where implementation should not start from a vague prompt.

The SDD workflow is:

```text
/sdd-start
  → spec.md v0

/sdd-research
  → research.md

/sdd-refine
  → spec.md v1

/sdd-delivery-artifacts
  → delivery_artifacts/*.md

/sdd-facts
  → facts/*.md

planner
  → plan.md + plan/tN.md

/execute-plan
  → code changes + validation + tracking updates

reviewer
  → final review against spec, research, delivery artifacts, facts, and plan

antagonist
  → adversarial pre-PR review for blockers, hidden risk, weak validation, unsafe rollout, and scope creep
```

The goal is to avoid jumping from a rough requirement directly into implementation.

## How to use SDD

Create a playbook directory for the feature:

```text
doc/playbook/<YYYYMMDD>_<feature_slug>/
```

Example:

```text
doc/playbook/20260519_provider_output_observability/
```

### 1. Start from intent

Run:

```text
/sdd-start doc/playbook/<feature>
```

This creates:

```text
spec.md
```

At this stage, `spec.md` is an intent-level spec. It should describe:

- problem
- goal
- non-goals
- users or consumers
- desired behaviour
- EARS requirements
- acceptance scenarios
- observability expectations
- compatibility concerns
- research questions

`sdd-start` must not claim facts about the current codebase unless the user explicitly provided them.

If current behaviour depends on repository inspection, the spec should say:

```text
Unknown. Must be discovered during /sdd-research.
```

### 2. Research the repository

Run:

```text
/sdd-research doc/playbook/<feature>
```

This creates:

```text
research.md
```

`research.md` is the source of truth for repository evidence. It should record:

- relevant files
- current flows
- existing tests
- contracts and external interfaces
- operational surfaces
- risks
- unknowns
- planning inputs

It must not create a plan or modify code.

### 3. Refine the spec

Run:

```text
/sdd-refine doc/playbook/<feature>
```

This updates `spec.md` using the evidence from `research.md`.

After this step, `spec.md` becomes the planning-ready version.

The refined spec should reconcile:

```text
user intent + repository evidence
```

If research conflicts with the original intent, the conflict must be surfaced explicitly. The spec must not silently change product intent just because the current code makes something easier.

### 4. Generate delivery artifacts

Run:

```text
/sdd-delivery-artifacts doc/playbook/<feature>
```

This creates:

```text
delivery_artifacts/*.md
```

`delivery_artifacts/` is a variable, feature-specific map of what must be produced or modified.

It is not a fixed category list.

Examples of valid delivery artifact files:

```text
delivery_artifacts/
├── 01-api-contracts.md
├── 02-domain-model.md
├── 03-jobs-consumers.md
└── 04-observability.md
```

or:

```text
delivery_artifacts/
├── 01-grafana-dashboard.md
├── 02-terraform-alerts.md
└── 03-runbook.md
```

The actual files must be inferred from the feature.

Tests are not delivery artifacts. Tests belong in the plan and task validation sections.

### 5. Generate facts

Run:

```text
/sdd-facts doc/playbook/<feature>
```

This creates:

```text
facts/*.md
```

Facts are executable or verifiable assertions.

They exist because specs explain intent, but facts prove behaviour.

A fact should link back to one or more `REQ-*` requirements and eventually be proven by a deterministic check, such as:

- test
- contract check
- schema validation
- smoke test
- static analysis
- infrastructure validation
- CI job

Facts help reviewers answer:

```text
Does this implementation actually prove the important behaviour, or does it merely look complete?
```

### 6. Plan from the refined inputs

Invoke the `planner` agent only after these exist:

```text
spec.md
research.md
delivery_artifacts/*.md
facts/*.md
```

The planner must read:

- `spec.md`
- `research.md`
- every markdown file under `delivery_artifacts/`
- every markdown file under `facts/`
- referenced ADRs
- relevant rules

The planner produces:

```text
plan.md
plan/t1.md
plan/t2.md
...
```

The plan must cover:

- every concrete artifact listed under `delivery_artifacts/*.md`
- every `@spec` fact listed under `facts/*.md`

Each task should include:

- `Delivers`
- `Implements Facts`
- allowed files
- implementation notes
- validation/tests
- done criteria

### 7. Execute the approved plan

Run:

```text
/execute-plan doc/playbook/<feature>
```

Execution must follow the approved plan and modify only files allowed by the relevant task.

Validation must use the applicable project, stack, and common rules.

A task is not complete when code changes are implemented. A task is complete only when implementation, validation, and SDD tracking updates are all done.

After each verified task, `/execute-plan` must update the relevant tracking files when applicable:

- `plan.md`
- `plan/tN.md`
- `delivery_artifacts/*.md`
- `facts/*.md`

### 8. Review the result

Invoke the `reviewer` agent.

The review should check the diff against:

- refined `spec.md`
- `research.md`
- `delivery_artifacts/*.md`
- `facts/*.md`
- `plan.md`
- completed `plan/tN.md` tasks

The reviewer should verify that:

- all delivery artifacts were produced or explicitly deferred
- facts marked `@implemented` have executable checks that exist and passed
- completed tasks match the actual diff

### 9. Run the antagonist before PR

Invoke the `antagonist` agent when the work is ready to become a PR.

The antagonist is not a normal reviewer.

The reviewer asks:

```text
Is this implementation correct against the plan?
```

The antagonist asks:

```text
Why should this not be merged yet?
```

Use it especially for L1+ and L2 work:

- production-impacting changes
- migrations
- observability changes
- dual-run systems
- dependency removal
- cross-service changes
- queues, jobs, or consumers
- personal data
- permissions, authentication, or authorization
- rollout or rollback risk

The antagonist should look for:

- unmet requirements
- facts that do not really prove the requirement
- delivery artifacts marked complete without evidence
- unsafe rollout
- missing rollback or reversibility
- staging/production mismatch
- hidden coupling
- premature dependency removal
- operational blind spots
- scope creep

The output should be sharp and adversarial:

```text
BLOCK | CAUTION | PASS
```

The goal is to raise red flags before GitHub review, especially when AI-assisted implementation reduced the human owner's cognitive load.

## EARS requirements in specs

Specs should use EARS for behavioural requirements.

Each important requirement should:

- have a stable id: `REQ-001`, `REQ-002`, ...
- use `shall`
- be atomic
- be testable or verifiable
- avoid vague words like "properly", "easy", "fast", or "robust" unless quantified

Preferred EARS patterns:

```text
The system shall <response>.
When <trigger>, the system shall <response>.
While <state>, the system shall <response>.
Where <feature or condition>, the system shall <response>.
If <unwanted event>, then the system shall <response>.
```

Example:

```text
REQ-001:
When a provider output attempt is made, the system shall record the attempt grouped by channel.

REQ-002:
When recording provider output metrics, the system shall not include user-level identifiers as metric labels.

REQ-003:
If the provider output attempt fails, then the system shall preserve the existing retry behaviour.
```

Acceptance scenarios may use Given/When/Then, but they do not replace EARS requirements.

## Facts

Facts turn important requirements into executable or verifiable assertions.

The short version:

```text
Specs explain intent.
Facts prove behaviour.
```

A fact should usually reference one or more `REQ-*` requirements.

Example:

```text
FACT-001:
When provider output is emitted, the system records both Datadog and OpenTelemetry signals during the dual-run phase.

Requirement:
- REQ-001

Executable check:
- resolved from project rules
```

Facts should not be marked `@implemented` unless the executable check exists and passed.

## SDD artifact responsibilities

| Artifact | Responsibility |
|----------|----------------|
| `spec.md` | Behavioural source of truth |
| `research.md` | Repository-evidence source of truth |
| `delivery_artifacts/*.md` | Production-scope source of truth |
| `facts/*.md` | Executable-verification source of truth |
| `plan.md` | Execution source of truth |
| `plan/tN.md` | Atomic task instructions |
| tests/contracts/schemas/ADRs/dashboards/alerts/code | Permanent artifacts |

## Example: using the full flow

Imagine we want to add a small feature:

```text
When a user receives a very boring notification, the system should add a tiny fun fact to make it less depressing.
```

Start with a rough prompt:

```text
Help me write the specification for adding a tiny fun fact to boring notifications.
The goal is to make low-priority notifications feel a bit more human without changing critical or legal messages.
```

Then run the flow:

```text
/sdd-start doc/playbook/20260601_fun_fact_notifications
```

Claude should ask questions if the requirement is unclear, then create `spec.md`.

Next:

```text
/sdd-research doc/playbook/20260601_fun_fact_notifications
```

This checks the repo and answers questions like:

- where notifications are built
- whether notification priority already exists
- whether legal/critical messages can be detected
- where tests already live

Then:

```text
/sdd-refine doc/playbook/20260601_fun_fact_notifications
```

This turns the original intent into a repo-aware spec.

Then:

```text
/sdd-delivery-artifacts doc/playbook/20260601_fun_fact_notifications
```

This lists what must be produced, for example:

```text
delivery_artifacts/
├── 01-notification-content.md
└── 02-safety-rules.md
```

Then:

```text
/sdd-facts doc/playbook/20260601_fun_fact_notifications
```

This defines what must be proven, for example:

```text
FACT-001: boring low-priority notifications may receive a fun fact
FACT-002: critical/legal notifications must never receive a fun fact
```

Then invoke the planner:

```text
Use the planner agent for doc/playbook/20260601_fun_fact_notifications
```

The planner creates:

```text
plan.md
plan/
├── t1.md
├── t2.md
└── t3.md
```

Then execute:

```text
/execute-plan doc/playbook/20260601_fun_fact_notifications
```

After implementation, run the normal review:

```text
Use the reviewer agent for doc/playbook/20260601_fun_fact_notifications
```

And before opening the PR, run the adversarial review:

```text
Use the antagonist agent for doc/playbook/20260601_fun_fact_notifications.
Assume this may be subtly wrong or unsafe.
Find reasons this should not be merged yet.
```

The antagonist might flag something like:

```text
BLOCK: The spec says legal notifications must never receive fun facts,
but there is no fact proving that legal messages are excluded.
```

That is the point of the workflow: not to generate more documents for fun, but to catch the thing we would otherwise miss.

## References

This workflow was influenced by these articles on Spec-Driven Development and Facts:

- [Stop Writing Specs. Start Writing Facts. The Entire SDD Movement Is Already Obsolete](https://medium.com/@wasowski.jarek/stop-writing-specs-start-writing-facts-the-entire-sdd-movement-is-already-obsolete-9045f7061e26)
- [Comparing 15 Spec-Driven Development Frameworks](https://medium.com/@wasowski.jarek/comparing-15-spec-driven-development-frameworks-sdd-c052df529274)

## Based on

Forked and adapted from:

- [Karpathy's Claude.md](https://github.com/forrestchang/andrej-karpathy-skills/blob/main/CLAUDE.md)
- [Everything-Claude-Code](https://github.com/affaan-m/everything-claude-code)

