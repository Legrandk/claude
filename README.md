# AI Coding Assistant Configuration

Shared agents, skills, rules, and behavioral constraints for disciplined AI-assisted development with Claude Code and OpenAI Codex.

The repository keeps tool-agnostic behavior in `CORE.md`, then adapts it to each assistant through lightweight tool-specific files.

## What Is Included

### Shared Core

- `CORE.md` — tool-agnostic behavioral constraints:
  - Think before coding.
  - Simplicity first.
  - Surgical changes.
  - Goal-driven execution.
- `agents/` — source agent definitions.
- `skills/` — reusable workflow skills.
- `rules/` — standards and workflow rules loaded on demand.
- `commands/` — command-style prompts.

### Claude Code Files

- `CLAUDE.md` — Claude Code wrapper that points to `CORE.md`.
- `claude-code/settings.json` — Claude Code permissions, model, token, and status-line settings.
- `claude-code/keybindings.json` — Claude Code chat keybindings.

### OpenAI Codex Files

- `AGENTS.md` — repository-level Codex wrapper that points to `CORE.md`.
- `codex/AGENTS.md` — Codex wrapper that points to `CORE.md`.
- `codex/config.toml` — minimal Codex config fragment.
- `scripts/generate-codex-agents.sh` — generates Codex custom-agent TOML from `agents/*.md` during install.
- `codex/prompts/*.md` — legacy custom prompt wrappers for command-like entrypoints.

## Install For Claude Code

Run one command from the repository root:

```bash
./scripts/install-claude-code.sh
```

The installer copies files into `~/.claude` by default:

```text
~/.claude/
├── CLAUDE.md
├── CORE.md
├── agents/
├── skills/
├── rules/
├── commands/
├── settings.json
└── keybindings.json
```

Set `CLAUDE_HOME` to install somewhere else:

```bash
CLAUDE_HOME=/path/to/.claude ./scripts/install-claude-code.sh
```

### Verify Claude Code

After installation, restart Claude Code and check:

- Type `@` and confirm agents such as `@planner`, `@implementer`, `@reviewer`, `@antagonist`, `@tech-lead`, `@tdd-guide`, and `@new-project-architect` are available.
- Type `/` and confirm workflow commands such as `/new-project-start`, `/new-project-research`, `/new-project-architecture`, `/sdd-start`, `/sdd-research`, `/sdd-refine`, and `/execute-plan` are available.
- Confirm the shared constraints from `CORE.md` are active.

## Install For OpenAI Codex

Run one command from the repository root:

```bash
./scripts/install-codex.sh
```

The installer copies Codex files into `~/.codex` and shared skills/rules into `~/.agents`:

```text
~/.codex/
├── AGENTS.md
├── CORE.md
├── agents/
│   ├── planner.toml
│   ├── implementer.toml
│   └── ...
├── prompts/
└── config.toml

~/.agents/
├── agents/
├── skills/
├── rules/
└── commands/
```

If `~/.codex/config.toml` already exists, the installer leaves it unchanged and writes `~/.codex/config.claude-shared.example.toml` for review. All other Codex assets are still installed.

Set `CODEX_HOME` or `AGENTS_HOME` to install somewhere else:

```bash
CODEX_HOME=/path/to/.codex AGENTS_HOME=/path/to/.agents ./scripts/install-codex.sh
```

### Verify Codex

After installation, restart Codex and check:

- Run `/skills` or type `$` and confirm skills such as `$new-project-start`, `$new-project-research`, `$sdd-start`, `$sdd-research`, `$sdd-refine`, and `$execute-plan` are available.
- Ask Codex to spawn a custom agent, for example: `Spawn the new-project-architect agent to review these source docs`.
- Type `/` and look for prompt wrappers such as `/prompts:new-project-start` and `/prompts:sdd-start` where custom prompts are enabled.
- Confirm `~/.codex/AGENTS.md`, `~/.codex/agents/new-project-architect.toml`, `~/.codex/agents/planner.toml`, and `$HOME/.agents/skills/execute-plan/SKILL.md` exist.

## Install Both Tools

Run both installers:

```bash
./scripts/install-claude-code.sh
./scripts/install-codex.sh
```

Both tools use the same `CORE.md`, `agents/`, `skills/`, `rules/`, and `commands/` source files.

## Feature Differences

| Capability | Claude Code | OpenAI Codex |
|------------|-------------|--------------|
| Core instructions | `CLAUDE.md` references `CORE.md` | `AGENTS.md` references `CORE.md` |
| Settings | JSON files under `~/.claude` | TOML config under `~/.codex/config.toml` |
| Agents | Invoked with `@agent-name` | Custom subagents in `~/.codex/agents/*.toml`; ask Codex to spawn them explicitly |
| Skills | Installed under `~/.claude/skills` | Installed under `$HOME/.agents/skills` |
| Commands | Claude slash commands | Codex skills via `/skills` or `$skill`; prompt wrappers under `~/.codex/prompts` where supported |
| Rules in this repo | Markdown workflow rules | Markdown workflow rules installed under `$HOME/.agents/rules`; Codex `.rules` command policies are separate |

Codex custom prompts are a compatibility bridge. Prefer Codex skills for reusable workflows when possible.

## Updating

Pull the latest repository changes and rerun the installer for the tool you use:

```bash
git pull
./scripts/install-claude-code.sh
# or
./scripts/install-codex.sh
```

Existing files are never silently overwritten. When an installer replaces a changed file, it first creates a timestamped backup next to the original, such as `settings.json.bak.20260605123045`. Directory installs use the same per-file backup behavior.

## Usage

### Claude Code

```text
/new-project-start doc/new-project/20260603_my_project
@new-project-architect Review the source docs and identify architecture decisions.

/sdd-start doc/playbook/20260603_my_feature
@planner Review this spec and create a plan.md
/execute-plan
@reviewer Check if implementation matches the plan
```

### OpenAI Codex

```text
$new-project-start doc/new-project/20260603_my_project
Spawn the new-project-architect agent to review these source docs.

$sdd-start doc/playbook/20260603_my_feature
Spawn the planner agent to review this spec and create a plan.md.
$execute-plan doc/playbook/20260603_my_feature
Spawn the reviewer agent to check if implementation matches the plan.
```

If custom prompts are enabled in your Codex surface, the prompt wrappers are also available as `/prompts:<name>`.

## New Project Workflow

Use this workflow when starting a brand-new software project from source documents such as product notes, domain notes, requirements, meeting notes, ADR drafts, or other `.md` files.

Do not use this workflow for adding a feature to an existing codebase. Use SDD for existing-project feature work.

The workflow is:

```text
new-project-start
  -> source_inventory.md + project_brief.md

new-project-research
  -> requirements.md + contradictions.md + open_questions.md

new-project-architecture
  -> architecture.md + ADR candidates

new-project-delivery-artifacts
  -> delivery_artifacts/*.md

new-project-facts
  -> facts/*.md

planner
  -> plan.md + plan/tN.md

execute-plan
  -> scaffold + project foundation + first vertical slice

reviewer
  -> final review against project brief, requirements, architecture, artifacts, facts, and plan

antagonist
  -> adversarial review before treating the scaffold as ready for normal feature work
```

Create a new-project directory:

```text
doc/new-project/<YYYYMMDD>_<project_slug>/
```

The new-project planner must distinguish files to create from files that must already exist:

```md
## Files To Create

## Files To Modify

## Files That Must Already Exist
```

After the scaffold and first vertical slice are implemented and reviewed, use normal SDD under `doc/playbook/<feature>/` for future feature work.

## Spec-Driven Development Workflow

Use SDD for non-trivial feature work, ambiguous requirements, behavior changes, API changes, background jobs, observability changes, infrastructure changes, or anything where implementation should not start from a vague prompt.

The workflow is:

```text
sdd-start
  -> spec.md v0

sdd-research
  -> research.md

sdd-refine
  -> spec.md v1

sdd-delivery-artifacts
  -> delivery_artifacts/*.md

sdd-facts
  -> facts/*.md

planner
  -> plan.md + plan/tN.md

execute-plan
  -> code changes + validation + tracking updates

reviewer
  -> final review against spec, research, delivery artifacts, facts, and plan

antagonist
  -> adversarial pre-PR review for blockers, hidden risk, weak validation, unsafe rollout, and scope creep
```

### 1. Start From Intent

Create a playbook directory for the feature:

```text
doc/playbook/<YYYYMMDD>_<feature_slug>/
```

Run `sdd-start` with the playbook path. This creates `spec.md`, an intent-level spec describing the problem, goal, non-goals, desired behavior, requirements, acceptance scenarios, observability expectations, compatibility concerns, and research questions.

At this stage, the spec must not claim facts about the current codebase unless the user explicitly provided them. Unknown current behavior should be marked for discovery during `sdd-research`.

### 2. Research The Repository

Run `sdd-research` with the playbook path. This creates `research.md`, the source of truth for repository evidence: relevant files, current flows, existing tests, contracts, operational surfaces, risks, unknowns, and planning inputs.

Research must not create a plan or modify code.

### 3. Refine The Spec

Run `sdd-refine` with the playbook path. This updates `spec.md` using evidence from `research.md`.

The refined spec reconciles user intent with repository evidence. If research conflicts with the original intent, the conflict must be surfaced explicitly.

### 4. Generate Delivery Artifacts

Run `sdd-delivery-artifacts` with the playbook path. This creates `delivery_artifacts/*.md`, a feature-specific map of what must be produced or modified.

Tests are not delivery artifacts. Tests belong in the plan and task validation sections.

### 5. Generate Facts

Run `sdd-facts` with the playbook path. This creates `facts/*.md`, executable or verifiable assertions that prove the feature exists.

Facts should link back to requirements and eventually be proven by deterministic checks such as tests, contract checks, schema validation, smoke tests, static analysis, infrastructure validation, or CI jobs.

### 6. Plan From Refined Inputs

Invoke the planner only after these exist:

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

The plan must cover every concrete artifact and every `@spec` fact.

Each task should include:

- `Delivers`
- `Implements Facts`
- allowed files
- implementation notes
- validation/tests
- done criteria

### 7. Execute The Approved Plan

Run `execute-plan` with the playbook path. Execution must follow the approved plan and modify only files allowed by the relevant task.

Validation must use the applicable project, stack, and common rules.

A task is complete only when implementation, validation, and SDD tracking updates are all done.

After each verified task, `execute-plan` must update the relevant tracking files when applicable:

- `plan.md`
- `plan/tN.md`
- `delivery_artifacts/*.md`
- `facts/*.md`

### 8. Review The Result

Invoke the reviewer agent. The review should check the diff against the refined spec, research, delivery artifacts, facts, plan, and completed task files.

The reviewer should verify that:

- all delivery artifacts were produced or explicitly deferred
- facts marked `@implemented` have executable checks that exist and passed
- completed tasks match the actual diff

### 9. Run The Antagonist Before PR

Invoke the antagonist agent when the work is ready to become a PR. It looks for blockers, hidden risks, weak validation, unsafe rollout, and scope creep.

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

## EARS Requirements In Specs

Specs should use EARS for behavioral requirements.

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
If the provider output attempt fails, then the system shall preserve the existing retry behavior.
```

Acceptance scenarios may use Given/When/Then, but they do not replace EARS requirements.

## Facts

Facts turn important requirements into executable or verifiable assertions.

The short version:

```text
Specs explain intent.
Facts prove behavior.
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

## SDD Artifact Responsibilities

| Artifact | Responsibility |
|----------|----------------|
| `spec.md` | Behavioral source of truth |
| `research.md` | Repository-evidence source of truth |
| `delivery_artifacts/*.md` | Production-scope source of truth |
| `facts/*.md` | Executable-verification source of truth |
| `plan.md` | Execution source of truth |
| `plan/tN.md` | Atomic task instructions |
| tests/contracts/schemas/ADRs/dashboards/alerts/code | Permanent artifacts |

## Example: Using The Full Flow

Imagine we want to add a small feature:

```text
When a user receives a low-priority notification, the system should add a tiny fun fact to make it less depressing.
```

Start with a rough prompt:

```text
Help me write the specification for adding a tiny fun fact to low-priority notifications.
The goal is to make low-priority notifications feel a bit more human without changing critical or legal messages.
```

Then run the flow:

```text
sdd-start doc/playbook/20260601_fun_fact_notifications
```

The assistant should ask questions if the requirement is unclear, then create `spec.md`.

Next:

```text
sdd-research doc/playbook/20260601_fun_fact_notifications
```

This checks the repo and answers questions like:

- where notifications are built
- whether notification priority already exists
- whether legal or critical messages can be detected
- where tests already live

Then:

```text
sdd-refine doc/playbook/20260601_fun_fact_notifications
```

This turns the original intent into a repo-aware spec.

Then:

```text
sdd-delivery-artifacts doc/playbook/20260601_fun_fact_notifications
```

This lists what must be produced, for example:

```text
delivery_artifacts/
├── 01-notification-content.md
└── 02-safety-rules.md
```

Then:

```text
sdd-facts doc/playbook/20260601_fun_fact_notifications
```

This defines what must be proven, for example:

```text
FACT-001: low-priority notifications may receive a fun fact
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
execute-plan doc/playbook/20260601_fun_fact_notifications
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

That is the point of the workflow: not to generate more documents for its own sake, but to catch the thing we would otherwise miss.

## References

This workflow was influenced by these articles on Spec-Driven Development and Facts:

- [Stop Writing Specs. Start Writing Facts. The Entire SDD Movement Is Already Obsolete](https://medium.com/@wasowski.jarek/stop-writing-specs-start-writing-facts-the-entire-sdd-movement-is-already-obsolete-9045f7061e26)
- [Comparing 15 Spec-Driven Development Frameworks](https://medium.com/@wasowski.jarek/comparing-15-spec-driven-development-frameworks-sdd-c052df529274)

## Based On

Forked and adapted from:

- [Karpathy's Claude.md](https://github.com/forrestchang/andrej-karpathy-skills/blob/main/CLAUDE.md)
- [Everything-Claude-Code](https://github.com/affaan-m/everything-claude-code)
