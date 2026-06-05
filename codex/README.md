# Codex Adapter Files

These files adapt the shared configuration repository to OpenAI Codex.

- `AGENTS.md` is installed to `~/.codex/AGENTS.md` and points Codex at `CORE.md`.
- `config.toml` is a minimal Codex config fragment.
- Codex custom-agent TOML is generated from `agents/*.md` by `scripts/generate-codex-agents.sh` during install. Generated agent files are not checked in, so `agents/*.md` remains the source of truth.
- `prompts/*.md` provides legacy custom prompt wrappers for command-like entrypoints.

Codex skills are installed from the repository `skills/` directory into `$HOME/.agents/skills`.
