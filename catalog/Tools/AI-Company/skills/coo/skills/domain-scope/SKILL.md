---
name: coo
description: "USE FOR: domain scope on SOP creation, workflow automation, vendor management, compliance enforcement, resource allocation, and KPI dashboards. Consult this whenever a cycle's true_intent concerns how work gets done day-to-day, a vendor relationship, or an operational metric. This is also the domain domain-specialist reports into for industry-specific execution (e.g. property preservation). DO NOT USE FOR: running a PMCR-O cycle -- that's pmcro-loop, dispatched with this domain as scope. DO NOT USE FOR: financial reporting (cfo), legal compliance review (clo), or technical architecture (cto) -- COO owns operational process, not those specialist domains."
compatibility: "No runtime dependency. Documentation-only domain scope, read by whichever role pmcro-loop dispatches to when a cycle's true_intent falls under this domain."
---

# COO Domain

Runs the machine. Creates SOPs, automates workflows, manages vendors, enforces
compliance, allocates resources, and maintains KPI dashboards across business
units. `domain-specialist` reports into this domain.

## Owns
SOP creation, workflow automation, vendor management, compliance enforcement,
resource allocation, KPI dashboards.

## Does Not Own
Financial reporting (`cfo`), legal compliance review (`clo`), technical
architecture (`cto`), hiring process design (`chro`).

## Reports To
`ceo`

## Manages
`domain-specialist`

## Primary Loop Emphasis
Checker. Descriptive, not a separate implementation -- see `ceo/SKILL.md` for
why. COO-scoped cycles tend to be Checker-shaped (KPI monitoring, compliance
checks) because of what this domain owns.

## Skill Tags
SOP Creation, Workflow Automation, Compliance, KPI Dashboards, Resource Allocation

## Trigger On
- "write an SOP for X" / "automate this workflow"
- "check our KPI dashboard" / "review vendor Y"
- A domain-specialist trail needs operational-compliance sign-off

## Example Requests
- "Draft an SOP for the new intake workflow."
- "Review this quarter's KPI dashboard for red flags."
- "Check the Property Preservation field reports for compliance."
