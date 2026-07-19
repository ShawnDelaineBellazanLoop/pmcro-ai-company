# Colony Config (Organization-Level)

This file is the PMCR-O AI Agent Company's equivalent of Claude.ai's
**organization instructions** layer: an index over rules that apply to every
domain plugin in this catalog, inherited by reference -- never copied into
an individual domain's `SKILL.md`. The laws themselves live in
`.agents/rules/` (see below); this file only points to them.

Layering mirrors both Claude.ai's project model and Claude Code's own
settings hierarchy (managed > project > user > local):

| This repo's layer | Claude.ai / Claude Code equivalent | Lives in |
|---|---|---|
| Colony config (this file) | Organization instructions | `COLONY.md` (repo root, index only) |
| Colony laws (split) | `.claude/rules/*.md` (`@import`ed) | `.agents/rules/*.md` |
| Cross-tool repo instructions | `AGENTS.md` / `CLAUDE.md` | `AGENTS.md` (repo root) |
| Domain scope | Project instructions | `skills/<domain>/skills/domain-scope/SKILL.md` |
| Domain reference material | Project knowledge | `skills/<domain>/references/` (if a domain needs it) |
| Commands | Skills (task-specific, load when relevant) | `skills/<domain>/commands/*.md` |
| Sub-agents | -- (no direct equivalent) | `skills/<domain>/agents/*.md` |
| Personal machine defaults | `.claude/settings.local.json` | `.agents/settings.local.json` (gitignored) |

If a domain's `SKILL.md` and a rule file ever conflict, the rule file wins --
same precedence Claude Code uses between project settings and anything more
local. A domain `SKILL.md` should never restate a law; it should link to the
relevant rule file instead.

## The Laws

The four Colony laws live as individual files in `.agents/rules/`, not
inlined here, so each can grow independently without this index file
becoming unmanageable:

1. [`01-declarative-params.md`](.agents/rules/01-declarative-params.md) --
   Declarative, Parameter-Driven, No Hardcoded Targets (includes the
   `repo_path` resolution order: explicit arg > `.agents/settings.local.json`
   default > ask).
2. [`02-pmcro-cycle-discipline.md`](.agents/rules/02-pmcro-cycle-discipline.md) --
   PMCR-O Cycle Discipline.
3. [`03-verification-placeholders.md`](.agents/rules/03-verification-placeholders.md) --
   Verification and Placeholders.
4. [`04-domain-boundaries.md`](.agents/rules/04-domain-boundaries.md) --
   Domain Boundaries.

## How a New or Edited Domain Should Reference This File

A domain's `SKILL.md` should contain a short pointer, not a restatement:

```
## Colony Config
This domain inherits `../../../../../COLONY.md` (organization-level laws).
Domain-specific scope below does not restate those laws.
```

Adjust the relative path to the domain's actual depth under
`catalog/Tools/AI-Company/skills/<domain>/skills/domain-scope/SKILL.md`.
