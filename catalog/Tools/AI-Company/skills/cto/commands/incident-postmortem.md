---
description: "Write a post-incident analysis after an outage or failure in a target repo/service. Usage: /cto:incident-postmortem <repo-path> <what happened>"
---
Dispatch a PMCR-O cycle scoped to `cto`, Reflector-shaped.

Params:
- `repo_path` (required) -- filesystem path to the repo where the incident
  occurred. Required so findings are grounded in that repo's actual code,
  not a generic template.
- `incident` (required) -- short description of what happened.

true_intent: Post-incident analysis for `<incident>` in `<repo_path>`

Capture: what happened, root cause (cite the actual file/line/service in
`repo_path` where possible, not a paraphrase), what was verified versus
assumed during response, and any EarnedConstraint this incident should
crystallize for future cycles scoped to this repo.
