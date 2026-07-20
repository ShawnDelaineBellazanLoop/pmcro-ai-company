---
description: "Hydrate a new session with a Persona-Aware 'Round Table' briefing across the Colony's C-Suite domains, then read/update the repo's Memory Bank so context survives across sessions. Usage: /orchestrator:brief-session"
---
```
repo_path: <resolved per Law 1, .agents/rules/01-declarative-params.md>
```

Read-only against the Colony's history, additive against the Memory Bank
(see "Memory Bank Convention" below) -- this command never edits a sealed
trail or an existing domain's `SKILL.md`.

## What This Command Is For

A fresh session has no memory of what the last one did. Rather than the
human re-explaining state turn one, this command reconstructs it: each
C-Suite domain gives a short, persona-voiced status line (the "Round
Table"), then the aggregate is written to the Memory Bank so the *next*
session can read it back in seconds instead of re-deriving it.

This command never makes a domain decision itself -- it summarizes what's
already true on disk. If a domain's status is genuinely unclear (e.g. a
dangling trail with no `disposition.json`), say so plainly rather than
guessing a status to fill the round table's turn.

## The Round Table

1. Read `catalog/skills.json` for the full roster of registered domains
   (the 10 C-Suite domains: `ceo`, `chief-of-staff`, `cto`, `coo`, `cfo`,
   `cro`, `cmo`, `clo`, `chro`, `domain-specialist`, plus the Platform
   engine skills if a domain's trail references them).
2. For each domain, in roster order:
   - Read that domain's `skills/domain-scope/SKILL.md` for its Owns/Does
     scope (one line back to the human -- do not restate the whole file).
   - List `.pmcro/trails/<domain>/` and, for the most recent trail(s),
     read `00-frame.json` and `disposition.json` if sealed (or note
     "no disposition.json -- dangling" per EC-VERIFY-FIRST-001 if not).
   - Speak that domain's turn in first person, persona-voiced but
     factual -- e.g. `cto: "Last trail (67f24fd5) sealed accept --
     orchestrator-role/SKILL.md path cleanup. Nothing open."` A persona
     line is not license to invent a status the trail doesn't support;
     the voice is stylistic, the content is EC-VERIFY-FIRST-001-checked.
   - If the trail's `01-*.jsonl` files carry Linguistic Chain of Custody
     addressing (Article 4, `.clinerules`), play back that hand-off
     verbatim as part of the turn -- e.g. `cto: "Maker, picking up your
     path-cleanup pass -- Checker confirmed clean."` -- rather than only
     summarizing frame.json + disposition.json. If a trail predates
     Article 4 and has no addressing lines, say so ("no hand-off record
     -- pre-dates the Linguistic Protocol") instead of fabricating one.
   - If a domain has no trails yet, its turn is simply "no cycles run
     yet" -- do not fabricate history to give it something to say.
3. Do not let the Round Table decide anything (loop, seal, dispatch) --
   that authority stays with `orchestrator-role`. This command narrates
   state; it does not act on it.

## Memory Bank Convention

This repo has no prior Memory Bank convention, so this command establishes
one rather than inventing an ad hoc format per session. It follows the
Cline/Roo-Code Memory Bank pattern (chosen for continuity with this
Colony's own lineage through the earlier `pmcro-cline` project), stored
under `.agents/memory-bank/` -- a sibling to the existing `.agents/rules/`
and `.agents/plugins/`, per `COLONY.md`'s own layering table.

Core files (create on first run if absent; never delete):

- `projectbrief.md` -- what this Colony is, in a few durable sentences.
  Written once, edited rarely; this command does not rewrite it.
- `productContext.md` -- why the Colony exists, what problem it solves.
  Same low-churn treatment as `projectbrief.md`.
- `systemPatterns.md` -- architecture and key decisions (PMCR-O loop,
  TYPE1/TYPE2 boundary, sealed-trail-as-product). Updated only when a
  cycle's Reflector crystallizes something structural, not every session.
- `techContext.md` -- stack, tooling, known environment quirks (e.g. the
  local Filesystem MCP's known timeout-under-load behavior noted in
  `seal-trail.md`). Updated when the environment itself changes.
- `activeContext.md` -- **this command's primary write target.** Current
  focus, what changed this session, immediate next steps. Fully
  overwritten each `brief-session` run -- it is a snapshot, not a log.
- `progress.md` -- what works (backed by an ACCEPT-disposition trail,
  never a build success or self-report alone), what's left, known open
  hypotheses pulled from recent `reflect.jsonl` entries across domains.
  Appended to, not overwritten, so history of "what used to be open" is
  preserved.

At the start of a `brief-session` run: read all six files if present (skip
silently, do not error, if this is the first run and none exist yet -- the
Round Table itself still runs from trail data, the Memory Bank is a cache
of it, not its source of truth). At the end: write `activeContext.md`
(overwrite) and append to `progress.md`, both derived from what the Round
Table actually found on disk this run, not from what a prior
`activeContext.md` already claimed -- EC-VERIFY-FIRST-001 applies to
reading the Memory Bank's own prior state too.

## What Not To Do

- Do not treat a stale `activeContext.md` as authoritative over what
  `.pmcro/trails/` actually shows on this run -- the trails are the
  sealed record; the Memory Bank is a convenience cache derived from them.
- Do not report a domain's feature as "working" in `progress.md` on the
  strength of this session's conversation alone -- only an
  ACCEPT-disposition trail earns that line, per this Colony's own
  verification discipline.
- Do not let the Round Table's persona voice become a substitute for the
  underlying trail data -- if a domain's last trail sealed
  `needs-revision`, its turn says that, not something softer.
