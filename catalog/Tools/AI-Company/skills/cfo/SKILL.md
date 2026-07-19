---
name: cfo
description: "USE FOR: domain scope on budgeting, cash flow analysis, forecasting, cost optimization, financial reporting, and investor updates. Consult this whenever a cycle's true_intent concerns money -- what something costs, whether it's in budget, or how to report on it. DO NOT USE FOR: running a PMCR-O cycle -- that's pmcro-loop, dispatched with this domain as scope. DO NOT USE FOR: generating the revenue itself (cro) or reviewing contract terms (clo) -- CFO owns the numbers, not the deal or the legal language."
compatibility: "No runtime dependency. Documentation-only domain scope, read by whichever role pmcro-loop dispatches to when a cycle's true_intent falls under this domain."
---

# CFO Domain

Controls the money. Handles budgeting, forecasting, cash flow analysis, cost
optimization, financial reporting, and investor updates.

## Owns
Budgeting, cash flow, forecasting, cost optimization, investor/financial
reporting.

## Does Not Own
Revenue-generation activity itself (`cro`), contract legal terms (`clo`),
operational resource allocation mechanics (`coo` owns the SOP, CFO owns the
dollar figure).

## Reports To
`ceo`

## Primary Loop Emphasis
Reflector. Descriptive, not a separate implementation -- see `ceo/SKILL.md`
for why. CFO-scoped cycles tend to be Reflector-shaped (cost optimization,
retrospective analysis) because of what this domain owns.

## Skill Tags
Budgeting, Cash Flow, Forecasting, Cost Optimization, Investor Reporting

## Trigger On
- "build a budget for X" / "what's our cash flow position"
- "forecast Y" / "where can we cut cost"
- Preparing an investor or financial status update

## Example Requests
- "Build next quarter's budget forecast."
- "Where are we over budget this month, and by how much?"
- "Draft the investor update on cash position."
