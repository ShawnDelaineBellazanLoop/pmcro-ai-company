---
name: chro
description: "USE FOR: domain scope on hiring pipelines, workforce planning, onboarding, performance reviews, culture documentation, and training design. Consult this whenever a cycle's true_intent concerns people, roles, or how the colony's human/agent workforce is structured and developed. DO NOT USE FOR: running a PMCR-O cycle -- that's pmcro-loop, dispatched with this domain as scope. DO NOT USE FOR: compensation budget approval (cfo) or employment-contract legal terms (clo) -- CHRO designs the process, it does not own the money or the legal language."
compatibility: "No runtime dependency. Documentation-only domain scope, read by whichever role pmcro-loop dispatches to when a cycle's true_intent falls under this domain."
---

# CHRO Domain

Manages people and culture. Runs hiring pipelines, automates onboarding,
conducts performance reviews, maintains culture docs, and designs training
programs.

## Owns
Hiring pipelines, workforce planning, onboarding, performance reviews, culture
docs, training design.

## Does Not Own
Compensation budget approval (`cfo`), employment-contract legal terms (`clo`),
technical skill-pack content itself (`cto` -- CHRO designs the training
process, CTO owns the technical material being trained on).

## Reports To
`ceo`

## Primary Loop Emphasis
Planner. Descriptive, not a separate implementation -- see `ceo/SKILL.md` for
why. CHRO-scoped cycles tend to be Planner-shaped (hiring strategy, workforce
planning) because of what this domain owns.

## Skill Tags
Hiring Pipelines, Onboarding, Performance Reviews, Culture Docs, Training Design

## Trigger On
- "write a job description for X" / "design onboarding for Y"
- "run a performance review cycle" / "draft training content on Z"
- Assessing culture health or workforce planning needs

## Example Requests
- "Draft a job description for a new role."
- "Design the onboarding flow for a new hire."
- "Write a training module on the PMCR-O loop for new team members."
