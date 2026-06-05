#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
out_dir="${1:-$repo_root/codex/agents}"
timestamp="$(date +%Y%m%d%H%M%S)"

mkdir -p "$out_dir"

agent_files=(
  antagonist
  implementer
  new-project-architect
  planner
  reviewer
  tdd-guide
  tech-lead
)

extract_frontmatter_field() {
  local file="$1"
  local field="$2"

  awk -v key="$field" '
    NR == 1 && $0 == "---" { in_fm = 1; next }
    in_fm && $0 == "---" { exit }
    in_fm {
      prefix = key ":"
      if (index($0, prefix) == 1) {
        value = substr($0, length(prefix) + 1)
        sub(/^[ \t]+/, "", value)
        sub(/[ \t]+$/, "", value)
        gsub(/^"/, "", value)
        gsub(/"$/, "", value)
        print value
        exit
      }
    }
  ' "$file"
}

body_without_frontmatter() {
  local file="$1"

  awk '
    NR == 1 && $0 == "---" { in_fm = 1; next }
    in_fm && $0 == "---" { in_fm = 0; next }
    !in_fm { print }
  ' "$file"
}

first_heading() {
  local file="$1"

  awk '
    /^# / {
      sub(/^# /, "")
      print
      exit
    }
  ' "$file"
}

toml_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

install_generated_file() {
  local src="$1"
  local dst="$2"

  if [ -e "$dst" ] && [ ! -f "$dst" ]; then
    echo "Cannot replace non-file path: $dst" >&2
    exit 1
  fi

  if [ -f "$dst" ] && ! cmp -s "$src" "$dst"; then
    cp -p "$dst" "$dst.bak.$timestamp"
    echo "Backed up $dst to $dst.bak.$timestamp"
  fi

  cp -p "$src" "$dst"
}

for agent in "${agent_files[@]}"; do
  src="$repo_root/agents/$agent.md"
  [ -f "$src" ] || continue

  if grep -q "'''" "$src"; then
    echo "Cannot generate TOML for $src because it contains triple single quotes." >&2
    exit 1
  fi

  name="$(extract_frontmatter_field "$src" name || true)"
  description="$(extract_frontmatter_field "$src" description || true)"

  if [ -z "$name" ]; then
    name="$agent"
  fi

  if [ -z "$description" ]; then
    heading="$(first_heading "$src" || true)"
    if [ -n "$heading" ]; then
      description="Custom Codex subagent adapted from agents/$agent.md: $heading."
    else
      description="Custom Codex subagent adapted from agents/$agent.md."
    fi
  fi

  dst="$out_dir/$name.toml"
  tmp_file="$(mktemp "${TMPDIR:-/tmp}/codex-agent.XXXXXX")"
  {
    printf 'name = "%s"\n' "$(toml_escape "$name")"
    printf 'description = "%s"\n\n' "$(toml_escape "$description")"
    printf "developer_instructions = '''\n"
    body_without_frontmatter "$src"
    printf "\n'''\n"
  } > "$tmp_file"

  install_generated_file "$tmp_file" "$dst"
  rm -f "$tmp_file"
  echo "Generated $dst"
done
