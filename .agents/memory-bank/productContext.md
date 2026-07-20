# Product Context

**Why this Colony exists:** a session-based AI assistant has no memory
between conversations, and a human re-explaining state every session doesn't
scale as the number of domains and cycles grows. The PMCR-O architecture
solves this by making every unit of work a sealed, replayable trail -- so
"what happened" is a fact on disk, not a claim that has to be re-trusted
each time.

**The problem this solves in practice:**
- Prevents self-reported success from being mistaken for verified success
  (EC-VERIFY-FIRST-001 -- state must be read off disk, not assumed from a
  prior turn's summary).
- Prevents unbounded or silent self-evolution of the Colony's own platform
  code -- any cycle touching `catalog/`, a marketplace twin, or another
  domain's `SKILL.md` requires human sign-off (`hil-gating.md`), enforced
  the same way regardless of how clean the automated check passed.
- Gives every C-Suite domain the same reusable sequencing engine
  (`orchestrator`) instead of ten bespoke implementations that would drift
  out of sync with each other.

**Who this is for:** the human operator (Shawn) dispatching cycles via
domain commands (`/ceo:approve-initiative`, `/orchestrator:run-cycle`,
etc.), and future sessions of this same assistant that need to pick up
context fast via `brief-session` rather than re-deriving it from scratch.
