---
description: "Package a new command, sub-agent, domain, or PMCR-O role-skill into this repo's catalog convention. Usage: /skill-creator:create-skill <shape: command|agent|domain|role-skill> <target> <spec>"
---
```
shape: <first argument>
target_package: <second argument -- existing package for command/agent, new name for domain/role-skill>
spec: <remaining arguments>
repo_path: <resolved per Law 1>
```

Invoke the `skill-creator` skill (`../skills/skill-packaging/SKILL.md`) --
it resolves dependencies via `dependency-resolver` first, then packages
per the shape given. Produces files on disk only; does **not** update
`catalog/skills.json` or either `marketplace.json` (that's
`update-catalog.md`, deliberately separate so a package can be drafted and
reviewed before it's registered anywhere).
