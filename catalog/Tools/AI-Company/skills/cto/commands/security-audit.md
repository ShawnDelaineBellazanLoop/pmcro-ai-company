---
description: "Run a security posture review on a skill pack, plugin, service, or tool surface in a target repo. Usage: /cto:security-audit <repo-path> <target to audit>"
---
Dispatch a PMCR-O cycle scoped to `cto`, Checker-shaped.

Params:
- `repo_path` (required) -- filesystem path to the repo being audited. Never
  default to a previously-audited repo; ask if not given.
- `target` (required) -- the specific surface to audit (a tool's grants, an
  MCP server, a skill pack's frontmatter permissions).

true_intent: Security audit of `<target>` in `<repo_path>`

Use the `security-reviewer` subagent (`../../agents/security-reviewer.md`) to
produce the pass/fail findings before sealing the trail. If `repo_path`
declares its own TYPE1/TYPE2 mutation-classification convention, audit
against that repo's own rule, not an assumed default.
