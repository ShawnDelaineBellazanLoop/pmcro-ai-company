# Law 2: PMCR-O Cycle Discipline

Every domain-scoped cycle runs the full Plan -> Make -> Check -> Reflect
sequence before Orchestrator decides loop-vs-seal. No domain or command skips
a role in the sequence, regardless of how obvious the fix seems. The single
loop implementation lives in `catalog/Platform/PMCR-O/skills/` in this repo
(`orchestrator`, `planner`, `maker`, `checker`, `reflector`,
`dependency-resolver`, `skill-creator`) -- no domain plugin here
reimplements plan/make/check/reflect itself. See `orchestrator`'s own
`SKILL.md` and `references/trail-schema.md` for the frame format and file
locations.
