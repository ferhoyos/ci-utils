---
skill: ci-review
coverage: coordinator
---

# Eval coverage: `ci-review` (Codex coordinator)

Non-interactive variant of the review pipeline. Reuses the same phase skills and
agents as `$code-reviewer:review`, with ephemeral `headless-setup` when reference
docs are missing.

Coverage inherits from:

- `plugins/code-reviewer/skills/headless-setup/eval.md`
- `plugins/code-reviewer/skills/triage/eval.yaml`
- Phase and consolidation eval suites under `plugins/code-reviewer/skills/*/eval.yaml`

Claude Code auto-posting behavior is defined only in `commands/ci-review.md` and
is out of scope for this Codex skill (no automatic GitHub writes).
