# System Patterns

## The PMCR-O Loop
One `orchestrator` skill owns all sequencing (the only skill allowed to).
`planner`/`maker`/`checker`/`reflector` are passive and stateless -- reusable
outside this exact sequence, composed only by `orchestrator`. Every
domain-scoped cycle: resolve deps -> create trail -> Plan -> Make -> Check
-> Reflect -> loop-or-seal, capped at 3 loops (EC-009).

## Sealed Trail As Product
`.pmcro/trails/<domain>/<uuid>/`: `00-deps.json`, `00-frame.json`, then
per-cycle `NN-plan/make/check/reflect.jsonl`, sealed by `disposition.json`
(`accept`|`needs-approval`|`reject`|`needs-revision`). Immutable once
sealed -- a defect found later becomes an open hypothesis in a *new* trail,
never an edit to a sealed one.

## TYPE1 / TYPE2 Boundary (`hil-gating.md`)
TYPE2 (auto-approved): reads, builds, unregistered-package creation under
`catalog/`. TYPE1 (requires HIL): writing a live `skills.json`/marketplace
entry, git commit/push, editing another domain's `SKILL.md`, renaming or
removing an existing catalog entry. `orchestrator` step 4 is the
enforcement point -- it cannot self-seal `accept` if the cycle touched a
TYPE1 surface, full stop, regardless of check outcome.

Precedent (trails `cto/67f24fd5`, `cto/6df5bc78`, `ceo/e5a18a66`,
`ceo/b9164546`): a self-seal of `accept` on a `catalog/`-touching cycle is
valid specifically when the human's dispatch was concrete/explicit enough
to count as pre-authorization -- named file, named edit, named outcome --
as opposed to a vague proposal awaiting review.

## Domain Boundaries (Law 4)
Ten C-Suite domains, each with an Owns/Does-Not-Own section in its own
`domain-scope/SKILL.md`. A cycle scoped to one domain editing another
domain's `SKILL.md` crosses Law 4 regardless of intent. `cto` explicitly
owns "PMCR-O loop/skill-pack design and validation" -- editing the
Platform-tier `orchestrator` package is in-scope for `cto`, not a boundary
violation.

## Earned Constraints (EC Registry)
`reflector` crystallizes a recurring (3+) finding into a standing EC;
`checker` enforces it like a numbered Law thereafter. Some ECs are seeded
directly (EC-009, EC-VERIFY-FIRST-001, EC-011, EC-012) rather than waiting
for 3 recurrences, when the founding evidence is itself sufficient.

## Terminal-MCP's Own HIL Gate
Separate from the Colony's own hil-gating.md: the `terminal-mcp` server
treats *every* `RunCommand` call (including read-only ones like `git
status`) as TYPE1_PENDING, requiring an explicit `ExecuteRunCommand` call
after human approval. Stricter than the Colony's own TYPE1/TYPE2 split,
but its own law anchors (EC-002, MAAI-001, ARCH-TERM-HIL-001) are
authoritative for that server specifically.
