# AGENTS.md

OpenAI Codex wrapper for the shared AI coding instructions in this repository.

## Shared Core

Read and apply `CORE.md` from this Codex home directory before doing work. It is the source of truth for tool-agnostic behavior:

- Think before coding.
- Prefer the simplest implementation that solves the request.
- Make surgical changes only.
- Define success criteria and verify results.

If `CORE.md` is not present, ask the user to reinstall this configuration.

## Installed Assets

The installer places shared assets in these locations:

- Custom Codex subagents: `~/.codex/agents/*.toml`
- Codex global guidance: `~/.codex/AGENTS.md`
- Reusable Codex skills: `$HOME/.agents/skills/*/SKILL.md`
- Shared rule documents: `$HOME/.agents/rules/`
- Legacy prompt wrappers: `~/.codex/prompts/*.md`

When a skill or agent references `rules/...`, resolve that path from the active project first. If the active project does not contain the referenced rule, resolve it from `$HOME/.agents/rules/`.

## Codex Differences

- Use Codex skills through `/skills`, explicit `$skill-name` mentions, or implicit skill matching.
- Use custom agents by explicitly asking Codex to spawn the named agent.
- Prompt wrappers under `~/.codex/prompts/` provide slash-command entrypoints where Codex supports custom prompts, but Codex skills are the preferred reusable workflow surface.
