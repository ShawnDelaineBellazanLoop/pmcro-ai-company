---
description: "Hydrate a new session with a Persona-Aware 'Round Table' briefing across the Colony's C-Suite domains, then generate SESSION-BRIEF.md from that pass so context survives across sessions. Usage: /orchestrator:brief-session"
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

## Session Brief Convention

An earlier version of this command used a Cline/Roo-Code-style Memory Bank
(`.agents/memory-bank/`, six hand-maintained files). That was unwound --
see `.pmcro/trails/cto/6cc3b341-73ef-40be-bdb7-4270912e1d8e` -- because
cto/clo had already flagged the pattern not-recommended in
`ceo/4cf2171d-4600-46a8-84bf-93939bc26aaa/proposal-1-clinerules.md` before
it was ever built: this repo has no Cline footprint, and running a second,
freeform persistence store alongside `.pmcro/trails/` is an architectural
fork that can drift out of sync with the sealed record it's supposedly
summarizing.

This command now generates a single `SESSION-BRIEF.md` at `repo_path`
root instead -- the alternative that same proposal already specified.
Fully overwritten every run, never hand-edited, nothing to keep in sync
manually:

- Derived entirely from this run's Round Table pass (Step "The Round
  Table" above) -- each domain's Owns/Does-Not-Own one-liner, its most
  recent trail's disposition, and any hand-off addressing found per
  Article 4 of `.clinerules`.
- No separate read step: the Round Table's own findings *are* the
  source, written out once at the end rather than accumulated in a
  parallel file across sessions.
- A domain with no trails yet writes "no cycles run yet"; a domain with a
  dangling trail (no `disposition.json`) writes "dangling" -- same
  EC-VERIFY-FIRST-001 discipline as the Round Table itself, not a softer
  summary version of it.

A fresh session reads `SESSION-BRIEF.md` for a fast catch-up, but it is a
cache of `.pmcro/trails/`, never a substitute source of truth for it --
if the file and the trails ever disagree, the trails win and the file is
stale until the next `brief-session` run regenerates it.

## What Not To Do

- Do not treat a stale `SESSION-BRIEF.md` as authoritative over what
  `.pmcro/trails/` actually shows on this run -- regenerate, don't trust
  the last run's snapshot.
- Do not report a domain's feature as "working" in `SESSION-BRIEF.md` on
  the strength of this session's conversation alone -- only an
  ACCEPT-disposition trail earns that line, per this Colony's own
  verification discipline.
- Do not let the Round Table's persona voice become a substitute for the
  underlying trail data -- if a domain's last trail sealed
  `needs-revision`, its turn says that, not something softer.
- Do not resurrect a hand-maintained `memory-bank/`-style convention for
  this command without a new `/ceo:approve-initiative` cycle -- it was
  unwound once already for a documented architectural reason, not
  removed by accident.
