# Proposal 1 of 3 -- .clinerules / "Memory Bank" pattern

Trail: ceo/4cf2171d-4600-46a8-84bf-93939bc26aaa
Status: NOT RECOMMENDED AS SPECIFIED -- flagged by cto/clo review, needs
your explicit call before this gets built.

## What was asked

Create `.clinerules` at repo root using the 2026 Cline "Memory Bank"
pattern (a set of persistent markdown files -- typically
`memory-bank/projectbrief.md`, `activeContext.md`, `progress.md`, etc. --
that Cline re-reads at the start of every session since it has no
native memory across sessions).

## Why cto/clo are flagging this rather than just building it

1. **No Cline footprint exists in this repo.** `AGENTS.md` states this
   repo is a plugin marketplace for exactly two tools: Claude Code and
   Codex CLI (via the two `marketplace.json` twins). Nothing here targets
   Cline. Adding `.clinerules` would be the first Cline-specific artifact
   in a repo that has otherwise been deliberately scoped to two tools.
2. **This Colony already has a persistence mechanism, and it's not this.**
   `.pmcro/trails/<domain>/<uuid>/` is this repo's own session-persistence
   layer -- sealed, replayable, immutable execution history. A Cline
   Memory Bank solves the same underlying problem (an agent forgetting
   context between sessions) a different way (freeform markdown notes
   re-read at session start vs. structured, checkable trail files). Running
   both is a real architectural fork, not free redundancy -- two
   persistence stories that can drift out of sync, the same shape of
   problem EC-011 just fixed for the marketplace twins.
3. **Retired-project precedent.** Shawn's earlier `B:\pmcro-cline` project
   used the Cline `.cline/skills/` convention and has since been retired
   to reference-only status in favor of Claude Code / MAF-native tooling
   elsewhere. Building a fresh `.clinerules` here would be introducing that
   pattern into a repo that was built after that retirement, in a
   different toolchain.

## What I'd build instead, if the actual goal is "session persistence for
whichever agent picks this repo up cold"

This Colony's real gap isn't memory -- it's a **cold-start summary**: a
short, generated-not-hand-maintained file that tells a fresh agent session
"here's the current state" by reading the trail system that already exists,
rather than a second place to write context notes that can go stale. If
that's the actual need, I'd propose a `pmcro-loop`-adjacent script or
`orchestrator` step that generates a `SESSION-BRIEF.md` from the most
recent sealed trails' dispositions, refreshed each cycle -- same data,
zero duplication, nothing to keep in sync by hand.

## If you do want literal Cline compatibility

Say so explicitly and I'll build `.clinerules` + a `memory-bank/` directory
to the actual current Cline convention (I'd verify the exact file set via
web search rather than assume, since "2026 Memory Bank pattern" implies
this has moved since my training data). But that's a real toolchain
addition to this repo's documented scope in `AGENTS.md`, not a drop-in --
`AGENTS.md`'s toolchain line would need updating too, or the two docs go
stale relative to each other on day one.
