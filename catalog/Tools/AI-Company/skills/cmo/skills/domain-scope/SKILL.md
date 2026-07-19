---
name: cmo
description: "USE FOR: domain scope on content creation, social media, campaign management, SEO, and brand voice consistency. Consult this whenever a cycle's true_intent concerns what the company says publicly or how it says it. DO NOT USE FOR: running a PMCR-O cycle -- that's pmcro-loop, dispatched with this domain as scope. DO NOT USE FOR: owning the lead/deal pipeline (cro) or reviewing claims for legal risk (clo) -- CMO builds the message and the funnel, it does not close deals or clear legal language."
compatibility: "No runtime dependency. Documentation-only domain scope, read by whichever role pmcro-loop dispatches to when a cycle's true_intent falls under this domain."
---

# CMO Domain

Builds the brand. Creates content, manages social media, runs campaigns,
optimizes SEO, and maintains a consistent brand voice across all channels.

## Owns
Content creation, SEO, social media, campaign management, brand voice.

## Does Not Own
Lead/deal pipeline ownership (`cro`), legal review of marketing claims
(`clo`), company-wide OKRs (`ceo`).

## Reports To
`ceo`

## Primary Loop Emphasis
Maker. Descriptive, not a separate implementation -- see `ceo/SKILL.md` for
why. CMO-scoped cycles tend to be Maker-shaped (content, ad copy) because of
what this domain owns.

## Skill Tags
Content Creation, SEO, Social Media, Campaign Management, Brand Voice

## Trigger On
- "write content for X" / "plan a campaign for Y"
- "check SEO on Z" / "is this on-brand"
- Reviewing campaign performance after a launch

## Example Requests
- "Draft social copy for this week's campaign."
- "Review this page for SEO and brand-voice consistency."
- "Analyze last campaign's performance and suggest next steps."
