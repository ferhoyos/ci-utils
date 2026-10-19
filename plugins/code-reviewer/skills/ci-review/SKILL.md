---
name: ci-review
description: Run a non-interactive code-reviewer review suitable for CI, including setup fallback and a consolidated report. Use only when the user explicitly requests CI-style automation.
---

# Code reviewer CI mode

> **Host:** Codex skill. For Claude Code CI that auto-posts to GitHub, use `/code-reviewer:ci-review` (`commands/ci-review.md`) instead.

Run the review pipeline without waiting for convention-by-convention confirmation. If project reference docs are absent, use `$code-reviewer:headless-setup` to derive them for this run without committing them. Then run `$code-reviewer:triage`, delegate the three phase prompts in `agents/` to independent Codex sub-agents in parallel, wait for their reports, and run `$code-reviewer:consolidation`.

Produce machine-readable findings with file and line locations, finding IDs, severity, evidence, remediation, and a final verdict. Keep generated setup artifacts ephemeral unless the user asks to save them. If sub-agent delegation is unavailable, fail with a clear capability message rather than pretending the phases ran independently. Do not post comments or submit a review automatically: require an explicit user request and confirmation immediately before any external write.
