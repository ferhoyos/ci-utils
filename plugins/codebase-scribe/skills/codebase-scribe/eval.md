---
skill: codebase-scribe
coverage: coordinator
---

# Eval coverage: `codebase-scribe` (Codex coordinator)

Routes to `scribe-discover`, `scribe-draft`, `scribe-maintain`, and
`scribe-review` based on repository state. Each focused skill ships its own eval
infrastructure under `plugins/codebase-scribe/skills/scribe-*/eval.yaml`.

Add coordinator-specific `eval.yaml` cases only if this wrapper adds logic beyond
mode detection and skill dispatch described in `commands/codebase-scribe.md`.
