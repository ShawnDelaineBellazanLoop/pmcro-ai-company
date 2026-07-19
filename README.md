# pmcro-ai-company

PMCR‑O AI Agent Company — the C‑Suite directory for the PMCR‑O Colony, published as an Anthropic (Claude Code) plugin marketplace.

This repo does **not** reimplement the PMCR‑O loop. The loop already exists, once, in [`pmcro-skills`](../pmcro-skills) as the `pmcro-loop` plugin — the single skill that gives whichever role (Planner/Maker/Checker/Reflector) the Orchestrator dispatches to its exact frame format and trail location. This repo adds the layer on top of that: **domain scope**.

## What's here

Ten domain-scope plugins, one per seat in the C‑Suite directory (the same 10 cards the CopilotKit UI shows):

| Plugin | Role | Reports To |
|---|---|---|
| `ceo` | Root node — strategic direction, OKRs, compute allocation | — |
| `chief-of-staff` | Priority triage, cross-agent coordination, briefs | `ceo` |
| `cto` | Architecture, skill-pack validation, security, DevOps | `ceo` |
| `coo` | SOPs, workflow automation, compliance, KPIs | `ceo` |
| `cfo` | Budgeting, cash flow, forecasting, cost optimization | `ceo` |
| `cro` | Lead gen, CRM, pipeline, deal closing | `ceo` |
| `cmo` | Content, SEO, social, campaigns, brand voice | `ceo` |
| `clo` | Contract review, risk, regulatory compliance, IP | `ceo` |
| `chro` | Hiring, onboarding, performance, culture, training | `ceo` |
| `domain-specialist` | Property Preservation / Real Estate (Tooensure Recovery Services) | `coo` |

Each plugin is **documentation-only** — a `SKILL.md` stating that domain's Owns/Does-Not-Own boundary, consulted by whichever role `pmcro-loop` dispatches to when a cycle's `true_intent` falls under that domain. No domain has its own `plan.ts`/`make.ts`/`check.ts`/`reflect.ts` — that would fork the loop 10 ways. There is exactly one PMCR-O loop; these plugins scope it.

## Structure

Follows the same convention as `pmcro-skills` (itself built to the `dotnet-agent-skills` catalog convention):

```
pmcro-ai-company/
├── AGENTS.md                      # cross-tool root contract (Claude Code, Codex, etc.) -- start here
├── COLONY.md                      # index into .agents/rules/ -- the laws themselves live there now
├── .claude-plugin/
│   └── marketplace.json          # root catalog Claude Code reads to discover plugins
├── .agents/
│   ├── plugins/
│   │   └── marketplace.json      # same catalog, Codex-native twin of .claude-plugin/marketplace.json
│   ├── rules/                    # Colony laws, one file per law (numbered, see COLONY.md for the index)
│   ├── settings.example.json     # checked in -- shows the shape, no real paths
│   └── settings.local.json       # gitignored -- your personal machine defaults (e.g. default_repo_path)
├── catalog/
│   ├── skills.json                # index (schema-validated by pmcro-skills' catalog-check)
│   ├── skills.schema.json
│   └── Tools/AI-Company/skills/
│       ├── ceo/
│       │   ├── manifest.json                # catalog metadata (version, category, packages)
│       │   ├── .claude-plugin/plugin.json    # Marketplace packaging
│       │   ├── agents/                       # this domain's sub-agents (e.g. software-engineer.md)
│       │   ├── commands/                     # this domain's parameterized commands
│       │   └── skills/domain-scope/SKILL.md  # domain scope: Owns / Does Not Own / triggers
│       ├── chief-of-staff/
│       ├── cto/
│       ├── coo/
│       ├── cfo/
│       ├── cro/
│       ├── cmo/
│       ├── clo/
│       ├── chro/
│       └── domain-specialist/
└── README.md
```

See `AGENTS.md` for the short version of this layout aimed at any agent (Claude, Codex, etc.) starting cold in this repo.

## Relationship to the CopilotKit directory UI

The UI's 10 agent cards should read from this catalog rather than hardcoded mock data — each card's description, skill tags, and reports-to chain map 1:1 to a domain's `SKILL.md` frontmatter and Owns section. A card's `loopState` should reflect whichever role most recently wrote a frame in that domain's trail folder under `.pmcro/trails/`, not a hardcoded value.

## Validating

This repo's `catalog/skills.json` and `skills.schema.json` are copies of the `pmcro-skills` convention, so `pmcro-skills`' `catalog-check` skill (`scripts/validate_catalog.py`) can validate this repo's index unmodified by pointing it at this repo root.
