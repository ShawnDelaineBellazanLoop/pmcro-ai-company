---
description: "Kick a PMCR-O cycle scoped to CEO to evolve the Colony itself -- add a command, sub-agent, or domain in response to a capability gap. Usage: /ceo:evolve-colony <capability gap or missing command, e.g. 'coo needs an incident-severity classifier'>"
---
Dispatch a PMCR-O cycle scoped to the `ceo` domain, Orchestrator-Workers shaped.

true_intent: Evolve the Colony to close the following capability gap: ``

This command is the one place self-evolution enters the Colony. It follows
Anthropic's own agent-pattern boundary (see `../../../../../COLONY.md` ->
Law 2 for cycle discipline, Law 4 for domain boundaries): deciding what's
missing can be agentic; writing it to the catalog and publishing it to
`marketplace.json` cannot be. Nothing this command does bypasses
`/ceo:approve-initiative`.

## 1. Route (classify, don't hardcode the path)

Before anything else, determine which shape the gap is:

- a new **command** on an existing domain's `commands/`
- a new **sub-agent** under an existing domain's `agents/`
- an entirely new **domain** plugin

Use the `agent-router` subagent (`../../agents/agent-router.md`) for this
classification, same as `/ceo:route-initiative` does. Do not proceed to
step 2 until the shape is decided -- this is the deterministic part and
should not be left to downstream steps to infer.

## 2. Dispatch (orchestrator-workers -- subtasks can't be predetermined)

This is the step that can't be a fixed pipeline, because which domains need
to weigh in depends on what the gap actually is:

- **`cto`** -- architecture review: does the proposed shape fit the existing
  `dotnet-agent-skills` / agentskills.io convention (SKILL.md frontmatter,
  `commands/` vs `agents/` split, `provides`/`requires` metadata)?
- **`clo`** -- domain-boundary check per Law 4: does this cross an existing
  domain's Owns/Does-Not-Own line, or invent authority nobody granted it?
- **`skill-creator`** (sibling `pmcro-skills` repo) -- actual package
  generation. This command never reimplements packaging here, same
  non-duplication rule that keeps `pmcro-loop` a single implementation.

If the gap is large enough to need sustained multi-turn iteration (e.g.
scaffolding a full new domain plugin end to end), use Claude Code's native
`/goal` command to hold the completion condition across turns rather than
re-prompting manually or reaching for the `ralph-loop` plugin -- `/goal` is
the current supported mechanism (Claude Code v2.1.139+): a small fast model
checks your stated condition after each turn and only starts another turn
if it isn't met yet, with no separate Stop-hook script to maintain and no
platform-specific dependency (the `ralph-loop`/`ralph-wiggum` plugin has a
known `jq` dependency that breaks under Windows/Git Bash, relevant since
this machine has no `pwsh`). Whatever the mechanism, cap iterations the
same way EC-009 already caps Checker/Reflector loops -- do not default to
unlimited.

A `/goal` condition or completion promise means "ready for review." It
never means "published." That distinction is load-bearing -- see step 4.

## 3. Validate (evaluator-optimizer, bounded)

Checker validates the proposed package against `catalog/skills.schema.json`,
Law 4, and Claude Code's own plugin schema (`claude plugin validate .` is
the authoritative CLI check for `marketplace.json` shape -- it checks a
different surface than `skills.schema.json` and both should pass). Reflector
fixes what fails. Bound the loop the same way every other cycle in this
Colony is bound -- do not let this be the one cycle that runs unbounded
because "self-evolution" sounds like it should.

## 4. Seal -- and stop (hard, non-agentic checkpoint)

The cycle seals with `disposition: needs-approval`, never `accept`. Nothing
written by this command reaches `catalog/` on disk as a live entry, and
nothing is added to `marketplace.json`'s `plugins` array, until a human runs
`/ceo:approve-initiative` against this proposal. This mirrors the same HIL
gate already used for any other irreversible, structural write in this
Colony -- publishing a change to the Colony's own governance is exactly the
kind of checkpoint Anthropic's agent guidance calls out as needing a human,
not a looser one because the requester is the CEO domain itself.
