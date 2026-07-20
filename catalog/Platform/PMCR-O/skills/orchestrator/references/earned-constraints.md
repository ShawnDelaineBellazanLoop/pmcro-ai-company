# Earned Constraints (EC Registry)

An EarnedConstraint is a lesson crystallized by `reflector` after the same
finding recurs 3+ times across cycles. It becomes a standing rule every
future cycle in this Colony checks against -- not a suggestion, a
constraint `checker` enforces going forward.

## Format

Each entry: an ID, a short imperative statement, and what it resolves.

```
EC-009: MaxLoops = 3 per domain-scoped cycle.
  Resolves: unbounded Plan->Make->Check->Reflect re-looping.
  Raised: seeded at Colony founding (not reflector-crystallized -- see
  "Seed Constraints" below).
```

## Seed Constraints (present from Colony founding, not crystallized)

These didn't emerge from 3+ recurrences -- they're load-bearing enough to
seed directly rather than wait for a pattern to repeat:

- **EC-009**: MaxLoops = 3 per domain-scoped cycle. `orchestrator` enforces
  this at step 5 of every cycle. Raising this ceiling deliberately (not by
  looping past it) requires a `/ceo:evolve-colony` cycle of its own,
  reviewed by `cto`, not a unilateral Orchestrator decision mid-cycle.
- **EC-VERIFY-FIRST-001**: Verify actual disk/repo state before acting on
  or claiming it. Carried forward from the earlier `pmcro-cline` project's
  operating discipline. `checker` treats a claim about state that wasn't
  verified against the actual target as a finding, not a pass.
- **EC-011**: The two marketplace twins (`.claude-plugin/marketplace.json`
  and `.agents/plugins/marketplace.json`) must be written in the same pass
  and must never drift on plugin roster, `version`, `displayName`, or the
  top-level `description`. Seeded directly rather than waiting for 3+
  recurrences -- the discovery that justified it was already the evidence:
  `.agents/plugins/marketplace.json` was found missing all 7 platform-tier
  entries, missing `displayName`/`category` on every entry, and carrying a
  stale `(in pmcro-skills)` reference the primary twin had already had
  removed, from a prior session that only ever wrote the primary file.
  `checker` enforces this at Rule 6 (Catalog-Consistency); `orchestrator`
  and `scaffold-csuite.ps1` write both twins in the same pass going
  forward, never one without the other.

## Adding a New EC (reflector's job)

1. Confirm the finding has occurred 3+ times -- across this trail's own
   cycles, or (if tracked) across other trails. Fewer than 3 is not yet a
   constraint, just a data point.
2. Assign the next sequential EC-XXX number. Never reuse a retired number.
3. Write the entry in the format above: imperative, checkable, and naming
   exactly which recurring finding it resolves.
4. Append to this file. Do not edit or renumber existing entries --
   constraints are additive, same immutability principle as a sealed
   trail.

## Crystallized Constraints

```
EC-010: A doc-staleness cleanup is not complete until grep-verified across
  the whole repo, not just the files a review pass happened to open.
  Resolves: partial cleanups that fix some instances of a stale
  cross-repo reference (e.g. "sibling pmcro-skills repo") while leaving
  others, creating repeated rediscovery of the same finding.
  Raised: reflector-crystallized, trail ceo/e5e3107f-17d3-4260-abca-06b3efec5c57,
  2026-07-20. Occurrence count: 5 (3 fixed in a prior session -- README.md,
  AGENTS.md, .agents/rules/02-pmcro-cycle-discipline.md; 2 found unfixed in
  this trail -- cto/skills/domain-scope/SKILL.md,
  ceo/commands/evolve-colony.md).
```

## How Checker Uses This Registry

Every `checker` invocation's step 3 (Law-conformance) also checks against
this registry -- an EC is enforced the same way a numbered Law is, just
scoped to a specific recurring pattern rather than a standing architectural
rule.
