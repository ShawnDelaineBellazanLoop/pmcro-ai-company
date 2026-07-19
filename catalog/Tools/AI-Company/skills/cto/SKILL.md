---
name: cto
description: "USE FOR: domain scope on technical architecture, PMCR-O loop/skill-pack design and validation, security posture, DevOps pipelines, and incident response. Consult this whenever a cycle's true_intent concerns system design, a new skill or plugin's structure, a security review, or a post-incident analysis. DO NOT USE FOR: running a PMCR-O cycle -- that's pmcro-loop, dispatched with this domain as scope. DO NOT USE FOR: budget approval (cfo), hiring (chro), or contract/IP terms (clo) -- CTO owns the technical work, not its funding, staffing, or legal terms."
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

## Skill Tags
PMCR-O Loop Design, Skill Pack Validation, Security, DevOps, Incident Response

## Trigger On
- "design the architecture for X" / "validate this skill pack"
- "what's our security posture on Y" / "run an incident post-mortem"
- A new plugin or skill needs a structural review before it's added to the catalog

## Example Requests
- "Review the proposed architecture for the new domain plugin."
- "Validate that this skill pack matches the catalog convention."
- "Write the post-incident analysis for last night's outage."
