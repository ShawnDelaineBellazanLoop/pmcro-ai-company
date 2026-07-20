# Proposal 2 of 3 -- CLAUDE.md (Claude Code router)

Trail: ceo/4cf2171d-4600-46a8-84bf-93939bc26aaa
Status: needs-approval -- apply only via /ceo:approve-initiative

## Why this one fits cleanly

`AGENTS.md` already exists as Codex CLI's root convention file. Claude
Code reads `CLAUDE.md` the same way. This repo publishes to both tools
(`.claude-plugin/marketplace.json` + `.agents/plugins/marketplace.json`)
but only has a root doc for one of them -- `CLAUDE.md` closes that gap,
same twin relationship EC-011 already formalized for the two
`marketplace.json` files. Content points at the same sources of truth
`AGENTS.md` uses rather than re-describing the catalog independently, so
the two can't drift the way the marketplace twins did.

## Proposed file: CLAUDE.md (new, repo root)

```markdown
# Claude Code Instructions

This is the PMCR-O AI Agent Company repo -- see AGENTS.md for the full
layout and conventions (this file and AGENTS.md are twins for two tools,
Claude Code and Codex CLI respectively; keep them in sync, same rule
EC-011 applies to the two marketplace.json files).

## Startup Protocol

Before proposing any code change in this repo, read
`.agents/plugins/marketplace.json` (or its Claude-native twin,
`.claude-plugin/marketplace.json`) to confirm the current plugin roster
and versions. Do not assume the roster from memory or from a prior
session -- both files are the live source of truth and either can have
changed since you last read them.

## Routing: slash-command -> domain plugin

Every plugin's full command list lives in its own `commands/` directory
and is indexed in `catalog/skills.json` / `.claude-plugin/marketplace.json`
-- read those directly rather than trusting a hand-copied table here, to
avoid the exact doc-drift EC-010 already had to fix once. At a glance:

| Domain | Plugin | Seat |
|---|---|---|
| `/ceo:*` | ceo | Chief Executive -- direction, OKRs, routing, approvals |
| `/chief-of-staff:*` | chief-of-staff | Priority triage, cross-agent coordination |
| `/cto:*` | cto | Architecture, skill-pack validation, security, DevOps |
| `/coo:*` | coo | SOPs, workflow automation, vendor/compliance, KPIs |
| `/cfo:*` | cfo | Budgeting, cash flow, forecasting, investor reporting |
| `/cro:*` | cro | Lead gen, CRM, proposals, pipeline, deal closing |
| `/cmo:*` | cmo | Content, SEO, social, campaigns, brand voice |
| `/clo:*` | clo | Contracts, risk, compliance, privacy, IP |
| `/chro:*` | chro | Hiring, onboarding, reviews, culture, training |
| `/domain-specialist:*` | domain-specialist | Property Preservation (reports to coo) |
| `/orchestrator:*` | orchestrator | Run/replay/seal a PMCR-O cycle (the engine every domain command calls through) |

Every domain command ultimately dispatches through
`/orchestrator:run-cycle` -- see
`catalog/Platform/PMCR-O/skills/orchestrator/skills/orchestrator-role/SKILL.md`
for the full Plan -> Make -> Check -> Reflect -> seal sequence, and
`.agents/rules/` for the Colony's standing laws (declarative params, cycle
discipline, domain boundaries, TYPE1/TYPE2 HIL gating).
```

## What this does NOT do

- Does not touch `AGENTS.md` (separate file, not superseded).
- Does not add anything to `catalog/skills.json` or either
  `marketplace.json` twin -- this is a root doc, not a plugin.
- Does not hardcode individual command names, to avoid the doc-staleness
  pattern EC-010 named.
