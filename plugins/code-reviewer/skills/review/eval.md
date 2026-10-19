---
skill: review
coverage: coordinator
---

# Eval coverage: `review` (Codex coordinator)

This skill orchestrates `$code-reviewer:triage`, delegates to `agents/*.md`
sub-agents, and runs `$code-reviewer:consolidation`. It does not add new review
logic beyond routing.

Behavioral coverage is provided by existing eval suites:

- `plugins/code-reviewer/skills/triage/eval.yaml`
- `plugins/code-reviewer/skills/adversarial-review/eval.yaml`
- `plugins/code-reviewer/skills/style-review/eval.yaml`
- `plugins/code-reviewer/skills/testing-review/eval.yaml`
- `plugins/code-reviewer/skills/consolidation/eval.yaml`

Add dedicated `eval.yaml` cases here if the coordinator workflow diverges from
`commands/review.md`.
