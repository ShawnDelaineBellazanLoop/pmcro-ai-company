---
name: chief-of-staff
description: "USE FOR: domain scope on priority triage of the CEO's decision queue, cross-agent coordination between C-Suite domains, weekly brief writing, and filtering agent output before it reaches CEO review. Consult this whenever a cycle's true_intent concerns coordinating multiple domains, compiling a status brief, or deciding what does/doesn't need CEO attention. DO NOT USE FOR: running a PMCR-O cycle -- that's pmcro-loop, dispatched with this domain as scope. DO NOT USE FOR: setting company direction itself (ceo) or doing any specialist domain's actual work -- Chief of Staff coordinates and triages, it does not execute domain work."
compatibility: "No runtime dependency. Documentation-only domain scope, read by whichever role pmcro-loop dispatches to when a cycle's true_intent falls under this domain."
---

# Chief of Staff Domain

The CEO's coordination brain. Enforces priority, triages decisions, manages
cross-agent coordination, and keeps the CEO's focus aligned across the Colony.
Sits between CEO and every other domain in this pack.

## Owns
Priority triage of the CEO's decision queue, cross-agent coordination, weekly
brief writing, decision filtering, context management across domains.

## Does Not Own
Setting company direction (`ceo`); any specialist domain's actual work
(engineering, budgeting, legal, etc.) -- Chief of Staff routes and summarizes,
it does not do the underlying work itself.

## Reports To
`ceo`

## Primary Loop Emphasis
Planner. Descriptive, not a separate implementation -- see `ceo/SKILL.md` for
why. Chief-of-Staff-scoped cycles tend to be Planner-shaped (triage, sequencing,
brief structure) because of what this domain owns.

## Skill Tags
Priority Triage, Cross-Agent Coordination, Brief Writing, Decision Filtering,
Context Management

## Trigger On
- "compile the weekly brief" / "what's pending for the CEO"
- "triage these decisions" / "does this need CEO attention"
- Coordinating a task that spans two or more C-Suite domains

## Example Requests
- "Compile this week's CEO brief from the domain outputs."
- "Triage the pending decision queue by urgency."
- "Sync CTO and COO on the infra rollout before it reaches the CEO."
