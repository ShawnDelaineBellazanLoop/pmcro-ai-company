# Proposed EC-010 (staged, not appended to the live registry)

Trail: ceo/e5e3107f-17d3-4260-abca-06b3efec5c57
Status: needs-approval -- append to
catalog/Platform/PMCR-O/skills/orchestrator/references/earned-constraints.md
only via /ceo:approve-initiative.

## Proposed entry

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

## Why staged rather than appended live

earned-constraints.md documents itself as additive/append-only, and
reflector-role/SKILL.md describes appending as routine. But a new EC becomes
a standing rule every future cycle's checker enforces -- publishing that
without human sign-off is the same category of irreversible, colony-wide
change the HIL gate exists for elsewhere in this system. Staging it here
keeps that decision with /ceo:approve-initiative rather than this cycle.
