#!/bin/bash
# Validate portable plugin.json, .codex-plugin overlays, and the Codex marketplace.
set -u

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

python_bin=""
for cand in python3 python; do
  command -v "$cand" >/dev/null 2>&1 || continue
  if "$cand" -c 'import json' >/dev/null 2>&1; then python_bin="$cand"; break; fi
done
if [ -z "$python_bin" ]; then
  echo "FAIL: python3 required"
  exit 1
fi

status=0

validate_json() {
  local label="$1" path="$2"
  if [ ! -f "$path" ]; then
    echo "MISSING: $label ($path)"
    status=1
    return
  fi
  if ! $python_bin -c "
import json, sys
path = sys.argv[1]
with open(path, encoding='utf-8') as f:
    json.load(f)
" "$path" 2>/dev/null; then
    echo "INVALID JSON: $label ($path)"
    status=1
  fi
}

check_skills_dir() {
  local plugin_dir="$1" manifest="$2"
  local skills
  skills="$($python_bin -c "
import json, sys
with open(sys.argv[1], encoding='utf-8') as f:
    data = json.load(f)
print(data.get('skills', ''))
" "$manifest" 2>/dev/null || true)"
  if [ -z "$skills" ]; then
    return
  fi
  local resolved="${plugin_dir}/${skills#./}"
  if [ ! -d "$resolved" ]; then
    echo "MISSING skills dir: $resolved (from $manifest)"
    status=1
  fi
}

check_onboarding() {
  local plugin_dir="$1" manifest="$2"
  local rel
  rel="$($python_bin -c "
import json, sys
with open(sys.argv[1], encoding='utf-8') as f:
    data = json.load(f)
ext = data.get('extensions') or {}
openai = ext.get('com.openai') or {}
print(openai.get('onboardingSkill', ''))
" "$manifest" 2>/dev/null || true)"
  if [ -z "$rel" ]; then
    return
  fi
  local target="${plugin_dir}/${rel#./}"
  if [ ! -f "$target" ]; then
    echo "MISSING onboardingSkill: $target (from $manifest)"
    status=1
  fi
}

for plugin in code-reviewer codebase-scribe ossm-ci; do
  base="$repo_root/plugins/$plugin"
  for manifest in "$base/plugin.json" "$base/.codex-plugin/plugin.json"; do
    validate_json "$plugin $(basename "$(dirname "$manifest")")/$(basename "$manifest")" "$manifest"
    if [ -f "$manifest" ]; then
      check_skills_dir "$base" "$manifest"
      check_onboarding "$base" "$manifest"
    fi
  done
done

marketplace="$repo_root/.agents/plugins/marketplace.json"
validate_json "Codex marketplace" "$marketplace"

if [ -f "$marketplace" ]; then
  while IFS= read -r rel_path; do
    [ -z "$rel_path" ] && continue
    full="$repo_root/${rel_path#./}"
    if [ ! -d "$full" ]; then
      echo "MISSING marketplace plugin path: $full"
      status=1
    fi
  done < <($python_bin -c "
import json, sys
with open(sys.argv[1], encoding='utf-8') as f:
    data = json.load(f)
for entry in data.get('plugins', []):
    src = entry.get('source') or {}
    path = src.get('path', '')
    if path:
        print(path)
" "$marketplace")
fi

if [ "$status" -eq 0 ]; then
  echo "OK: plugin manifests and Codex marketplace validated"
fi
exit "$status"
