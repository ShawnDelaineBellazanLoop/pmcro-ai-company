---
name: cto
description: "USE FOR: domain scope on technical architecture, PMCR-O loop/skill-pack design and validation, security posture, DevOps pipelines, and incident response, for whatever target repo a cycle names. Consult this whenever a cycle's true_intent concerns a service architecture, a new skill/plugin's structure, a tool's permission surface, or a post-incident analysis. DO NOT USE FOR: running a PMCR-O cycle -- that's pmcro-loop, dispatched with this domain as scope. DO NOT USE FOR: budget approval (cfo), hiring (chro), or contract/IP terms (clo) -- CTO owns the technical work, not its funding, staffing, or legal terms."
compatibility: "No runtime dependency. Documentation-only domain scope, read by whichever role pmcro-loop dispatches to when a cycle's true_intent falls under this domain."
---

# CTO Domain

Runs the technical backbone. Designs PMCR-O loops and skill packs, validates
them, enforces security posture, manages DevOps pipelines, and handles
incident response.

## Owns
Architecture design, PMCR-O loop/skill-pack design and validation, security
posture, DevOps pipelines, incident response.

## Does Not Own
Budget approval (`cfo`), hiring (`chro`), contract/IP terms (`clo`), day-to-day
non-technical SOPs (`coo`).

## Reports To
`ceo`

## Primary Loop Emphasis
Maker. Descriptive, not a separate implementation -- see `ceo/SKILL.md` for
why. CTO-scoped cycles tend to be Maker-shaped (building/deploying) because of
what this domain owns.

## Target Repo Is a Parameter, Not a Fact

This domain does not name a specific repository. Every CTO command takes a
`repo_path` argument (see `../../commands/`), resolved per
`.agents/rules/01-declarative-params.md` (explicit arg > local machine
default in `.agents/settings.local.json` > ask). The acting role then reads
that path's own convention files (a `.clinerules/`, `CONTRIBUTING.md`,
`AGENTS.md`, whatever that repo declares) rather than assuming any fixed
layout.

This keeps the domain declarative and reusable: the same `architecture-review`
command works against any repo the requester points it at, not just one
hardcoded project. If a cycle needs standing context about a *specific*
recurring target repo, that context belongs in that repo's own conventions
or in your own `.agents/settings.local.json` default -- never inlined into
this SKILL.md as a hardcoded example that goes stale the moment the
project's layout changes.

## Skill Tags
PMCR-O Loop Design, Skill Pack Validation, Security, DevOps, Incident Response

## Trigger On
- "design the architecture for X" / "validate this skill pack"
- "what's our security posture on Y" / "run an incident post-mortem"
- A new plugin or skill needs a structural review before it's added to the catalog
- Any request that names a target repo path and asks for technical review of it

## Example Requests
- "Review the architecture at <repo-path>/src/services/OrchestratorService against its own stated loop contract."
- "Audit <repo-path>/mcp/<server>'s tool grants against that repo's TYPE1/TYPE2 classification, if it declares one."
- "Write the post-incident analysis for last night's failure in <repo-path>."
