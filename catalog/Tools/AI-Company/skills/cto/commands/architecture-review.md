---
description: "Review a proposed architecture, plugin structure, or skill pack in a target repo before it's added to the catalog. Usage: /cto:architecture-review <repo-path> <what to review, e.g. a service, a new skill pack, a plugin structure>"
---
Dispatch a PMCR-O cycle scoped to `cto`.

Params:
- `repo_path` (required) -- filesystem path to the repo being reviewed. Do not
  assume a default; if omitted, ask for it rather than guessing a project.
- `target` (required) -- what within that repo to review (a service, a
  proposed change, a plugin structure).

true_intent: Review the architecture at `<repo_path>`: `<target>`

Read `../../SKILL.md` first, then read `<repo_path>`'s own convention files
(if any) before forming an opinion -- do not assume this repo follows the
same layout as any other repo previously reviewed. Use `software-engineer`
and, if the proposal touches tool permissions or new mutation paths,
`security-reviewer` (`../../agents/`) before sealing the cycle's disposition.
