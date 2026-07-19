---
name: clo
description: "USE FOR: domain scope on contract review, policy enforcement, risk analysis, regulatory compliance, privacy reviews, and IP protection. Consult this whenever a cycle's true_intent concerns legal exposure, a contract's terms, or whether something is compliant. DO NOT USE FOR: running a PMCR-O cycle -- that's pmcro-loop, dispatched with this domain as scope. DO NOT USE FOR: drafting business/pricing terms (cfo/cro own the deal economics) or operational SOPs (coo) -- CLO reviews and flags risk, it does not set business terms or run operations."
compatibility: "No runtime dependency. Documentation-only domain scope, read by whichever role pmcro-loop dispatches to when a cycle's true_intent falls under this domain."
---

# CLO Domain

Keeps the company safe. Reviews contracts, enforces policy, analyzes risk,
ensures regulatory compliance, conducts privacy reviews, and protects IP.

## Owns
Contract review, risk analysis, regulatory compliance, privacy, IP protection.

## Does Not Own
Business/pricing terms (`cfo`, `cro`), operational SOPs (`coo`), marketing
claims themselves (`cmo` -- CLO reviews them for risk, CMO writes them).

## Reports To
`ceo`

## Primary Loop Emphasis
Checker. Descriptive, not a separate implementation -- see `ceo/SKILL.md` for
why. CLO-scoped cycles tend to be Checker-shaped (compliance audits, legal
review) because of what this domain owns.

## Skill Tags
Contract Review, Risk Analysis, Regulatory Compliance, Privacy, IP Protection

## Trigger On
- "review this contract" / "what's our risk on X"
- "is this compliant with Y" / "privacy review on Z"
- Before a proposal or public claim goes out, if it carries legal exposure

## Example Requests
- "Review this vendor contract for red-flag terms."
- "Check this initiative for regulatory compliance."
- "Assess the IP risk on this new skill pack."
