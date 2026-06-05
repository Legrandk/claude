# CLAUDE.md

Claude Code wrapper for the shared AI coding instructions in this repository.

## Shared Core

Read and apply `CORE.md` before doing work. It is the source of truth for tool-agnostic behavior:

- Think before coding.
- Prefer the simplest implementation that solves the request.
- Make surgical changes only.
- Define success criteria and verify results.

## Claude Code Assets

This repository also provides Claude Code agents, skills, commands, and rule documents:

- `agents/` contains Claude Code subagent definitions.
- `skills/` contains reusable workflow skills.
- `commands/` contains slash command prompts.
- `rules/` contains standards and workflow rules loaded on demand.

When installed globally, these files normally live under `~/.claude/`.
