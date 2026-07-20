---
name: ceo
description: "USE FOR: domain scope on strategic direction, OKR management, compute/priority allocation, and approval of major cross-agent actions in the PMCR-O Colony. Consult this whenever a cycle's true_intent concerns company direction, resourcing priority between C-Suite domains, or which initiative gets the colony's attention next -- it is the root node every other domain ultimately reports to. DO NOT USE FOR: running a PMCR-O cycle -- that's pmcro-loop, dispatched with this domain as scope. DO NOT USE FOR: domain-specific execution (budgeting is cfo, hiring is chro, contracts are clo, etc.) -- CEO sets direction and approves, it does not do the specialist work itself."
compatibility: "No runtime dependency. Documentation-only domain scope, read by whichever role pmcro-loop dispatches to when a cycle's true_intent falls under this domain."
---

# CEO Domain

Meta-planner and top-level decision authority for the Colony. Sets company
direction, allocates compute/priority across the C-Suite, approves major actions,
and is the root node every domain in this plugin pack ultimately reports to.

## Owns
Strategic planning, OKR management, compute/priority allocation across domains,
agent routing decisions, approval of cross-domain initiatives.

## Does Not Own
Budgeting/cash flow (`cfo`), technical architecture (`cto`), hiring (`chro`),
contract terms (`clo`), day-to-day workflow execution (`coo`) -- CEO sets
direction and approves, the specialist domain does the work.

## Reports To
None -- root node.

## Primary Loop Emphasis
Orchestrator. This is descriptive, not a separate implementation: every domain
in this pack runs the same five-role cycle via `pmcro-loop`. CEO-scoped cycles
most often land on Orchestrator-shaped work (routing, dispatch, priority
sequencing across other domains) because of what this domain owns, not because
it has its own orchestration code.

## Skill Tags
Strategic Planning, OKR Management, Compute Allocation, Decision Trees, Agent Routing

## How This Differs From a Runtime Agent
This is a domain-scope skill, not a compiled agent and not a duplicate PMCR-O
loop. Per this pack's `pmcro-loop` dependency: there is exactly one acting
agent per role at a time, embodying that role directly against whichever
domain's scope applies. This file exists so Planner (or whichever role is
dispatched) knows this domain's Owns/Does-Not-Own boundary before writing
`00-frame.json` -- it is read, not executed.

## Trigger On
- "what should the colony prioritize" / "set direction for X"
- "approve this initiative" / "allocate compute to Y"
- A cycle's true_intent spans multiple C-Suite domains and needs a routing call
- "evolve the colony" / a capability gap needs a new command, sub-agent, or domain

## Example Requests
- "Define this quarter's OKRs for the colony."
- "Which domain should this new initiative route to?"
- "Approve the CTO's architecture proposal before it proceeds."
