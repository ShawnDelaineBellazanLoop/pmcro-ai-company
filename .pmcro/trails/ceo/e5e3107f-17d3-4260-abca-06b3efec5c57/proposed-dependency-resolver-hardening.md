# Proposal: Make dependency-resolver load-bearing (staged, not applied)

Trail: ceo/e5e3107f-17d3-4260-abca-06b3efec5c57
Status: needs-approval -- apply only via /ceo:approve-initiative

## Why

The orchestrator's dry-run cycle self-sealed TYPE2 without dependency-resolver
ever producing a checkable artifact. Nothing today forces a cycle to prove
resolution happened; a future orchestrator could skip step 1 silently and no
downstream role would catch it, because checker has nothing to check it
against.

## Diff 1 -- trail-schema.md (directory layout)

Add a new file, written once by orchestrator immediately after step 1,
before the trail's 00-frame.json:

```
<repo_path>/.pmcro/trails/<domain>/<uuid>/
├── 00-deps.json            # NEW: written once, by orchestrator, cycle 01 step 1
├── 00-frame.json
├── 01-plan.jsonl
...
```

New section:

```markdown
## 00-deps.json

Written once, by `orchestrator`, immediately after step 1 (Resolve
dependencies), before the trail's frame. Records dependency-resolver's
actual output so later roles -- especially checker -- can verify resolution
happened and verify what it returned, rather than trusting it happened.

\`\`\`json
{
  "requested_by": "orchestrator",
  "needs": ["planner", "maker", "checker", "reflector"],
  "resolved": [
    {"name": "planner", "version": "1.0.0", "pmcro_provides": "planner"},
    {"name": "maker", "version": "1.0.0", "pmcro_provides": "maker"},
    {"name": "checker", "version": "1.0.0", "pmcro_provides": "checker"},
    {"name": "reflector", "version": "1.0.0", "pmcro_provides": "reflector"}
  ],
  "domain_scope_path": "<path to the target domain's domain-scope/SKILL.md>",
  "resolved_at": "<ISO 8601>"
}
\`\`\`
```

## Diff 2 -- orchestrator-role/SKILL.md, step 1

Current:

> Before dispatching Planner, invoke `dependency-resolver` with this cycle's
> `domain` and `true_intent`. It returns which domain `SKILL.md` to read for
> scope, and confirms `planner`/`maker`/`checker`/`reflector` are present and
> compatible. Do not skip this even when the answer seems obvious -- a stale
> or renamed domain path fails loudly here, not silently three roles later.

Amended (appended sentence):

> ...Do not skip this even when the answer seems obvious -- a stale or
> renamed domain path fails loudly here, not silently three roles later.
> **Write dependency-resolver's returned resolution to `00-deps.json` at the
> trail root before creating `00-frame.json` -- this is what makes step 1
> checkable rather than assumed; see `../../references/trail-schema.md`.**

## Diff 3 -- checker-role/SKILL.md, new check

Insert as a new item in "What To Check, In Order", after
schema-conformance, before law-conformance (renumbering the rest):

> 3. **Dependency-resolution-recorded** -- confirm `00-deps.json` exists at
>    the trail root and its `resolved` list actually matches the role-skills
>    this cycle dispatched (`planner`/`maker`/`checker`/`reflector`, plus
>    anything the domain's evolve-colony-shaped dispatch required, e.g.
>    `cto`/`clo`/`skill-creator`). Missing file or a mismatch between
>    `resolved` and what actually ran is a finding against `orchestrator`,
>    not a pass with a note.

## What this does NOT do

- Does not touch `catalog/skills.json` or either `marketplace.json` twin.
- Does not touch any domain's own `SKILL.md`.
- Does not raise EC-009's loop cap or alter the TYPE1/TYPE2 boundary itself.
- Does not fix the two unrelated stale "sibling pmcro-skills repo" strings
  found in `cto/SKILL.md` and `ceo/commands/evolve-colony.md` -- flagged
  separately, out of this cycle's scope.
