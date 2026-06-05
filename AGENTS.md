# AGENTS.md

OpenAI Codex wrapper for this configuration repository.

## Shared Core

Read and apply `CORE.md` before doing work. It is the source of truth for tool-agnostic behavior:

- Think before coding.
- Prefer the simplest implementation that solves the request.
- Make surgical changes only.
- Define success criteria and verify results.

## Repository Assets

This repository provides reusable assets for Claude Code and OpenAI Codex:

- `agents/` contains the canonical agent definitions.
- `skills/` contains reusable workflow skills.
- `commands/` contains command-style prompts.
- `rules/` contains standards and workflow rules loaded on demand.
- `claude-code/` contains Claude Code-specific configuration files.
- `codex/` contains OpenAI Codex-specific adapter files.

When a skill or agent references `rules/...`, resolve that path from this repository unless the active project has its own closer `rules/...`.
