---
name: dependency-resolver
description: "USE FOR: resolving which domain SKILL.md and which PMCR-O role-skills a cycle needs, by walking metadata.pmcro_provides/pmcro_requires across this repo's catalog before a cycle dispatches. Invoked by orchestrator at the start of every cycle, and by skill-creator before packaging a new skill. DO NOT USE FOR: making the routing judgment call between ambiguous domains -- that's ceo's agent-router. This skill resolves declared dependencies; it doesn't guess intent."
metadata:
  pmcro_provides: "dependency-resolver"
  pmcro_requires: ""
compatibility: "Read access to catalog/skills.json and every package's .claude-plugin/plugin.json under this repo."
---

# Dependency Resolver

Walks this repo's `provides`/`requires` graph so nothing gets dispatched
against a skill that isn't actually present, compatible, or up to date.

## Why This Exists As Its Own Skill

Both `orchestrator` (resolving role-skills before a cycle) and
`skill-creator` (resolving what a new skill would need before packaging it)
need the exact same graph-walk. Putting it in either of those would
duplicate the logic in the other, or couple one to the other unnecessarily.
One resolver, two callers -- same non-duplication principle as the loop
itself having exactly one implementation.

## Invocation Contract

```
requesting_skill: <name of the skill/domain asking>
needs: <comma-separated list of pmcro_provides values required, or "auto" to read requesting_skill's own pmcro_requires>
```

## What To Do

1. Read `catalog/skills.json` for the full index, then each candidate
   package's `.claude-plugin/plugin.json` for its `description`-embedded
   `Provides:`/`Requires:` line (this repo doesn't have a first-class
   dependency field in the marketplace schema -- see
   `../../../skill-creator/references/marketplace-schema-notes.md` -- so
   the declared contract lives in the plugin description text and this
   skill's own `metadata.pmcro_provides`/`pmcro_requires` frontmatter,
   which is the authoritative source; treat the plugin description as
   human-readable restatement, not the source of truth if they ever
   disagree).
2. For each `needs` entry, find exactly one package whose
   `metadata.pmcro_provides` matches. Zero matches or more than one match
   is a resolution failure -- report it rather than picking one silently.
3. Recursively resolve each matched package's own `pmcro_requires`, same
   rule, until the full dependency set bottoms out at leaf skills
   (`pmcro_requires: ""`).
4. Return the resolved set as an ordered list (dependencies before
   dependents) plus each package's version, so the caller can confirm
   nothing stale is being dispatched against.

## What Not To Do

- Do not resolve a dependency by name-guessing when `pmcro_provides` values
  don't match exactly -- a near-miss is a packaging defect to surface, not
  something to paper over.
- Do not cache a prior resolution across cycles -- `catalog/skills.json`
  and plugin manifests can change between cycles (that's the whole point
  of `skill-creator` existing), so resolve fresh each time.
