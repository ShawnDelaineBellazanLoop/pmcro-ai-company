# Ralph-Loop Mechanics (Re-Implemented via Native /goal)

Some cycles genuinely need more sustained multi-turn iteration than one
Plan->Make->Check->Reflect pass comfortably holds -- e.g. scaffolding a
full new domain plugin end to end during `/ceo:evolve-colony`. This
document is the Colony's re-implementation of that persistent-iteration
pattern (the technique the community calls "Ralph" / "Ralph Wiggum"),
built on Claude Code's **native `/goal` command** rather than the
community `ralph-loop`/`ralph-wiggum` plugin.

## Why Not the `ralph-loop` Plugin

The plugin (`anthropics/claude-plugins-official`, also shipped as
`ralph-wiggum` in `anthropics/claude-code`) works by a Stop hook that
intercepts session exit and re-feeds the same prompt until an exact
`<promise>TEXT</promise>` string match, capped by `--max-iterations`.
Confirmed, current mechanism -- but two things make it the wrong fit here:

- **Fragile exact-string completion signal.** The completion promise is
  static, set once, matched by exact string. A typo or slight rephrasing
  by the model and the loop never terminates on its own -- `--max-iterations`
  becomes the only real safety net, not a genuine "done" signal.
- **Platform dependency.** The plugin has a documented `jq` dependency that
  breaks under Windows/Git Bash. This is a Windows machine with no `pwsh`
  installed (all scripts invoke via `powershell -NoProfile -File`) -- an
  unmet `jq` dependency is exactly the kind of silent failure mode this
  Colony's EC-VERIFY-FIRST-001 discipline exists to catch before it causes
  a stuck loop.

## The Native `/goal` Mechanism (what this Colony uses instead)

Claude Code v2.1.139+ ships `/goal` as a first-party command
(`code.claude.com/docs/en/goal`): you set a completion **condition**, and
after every turn a small, fast model checks whether that condition holds
against the transcript. If not, Claude starts another turn instead of
returning control. The goal clears automatically once the condition is
met.

```
/goal <verifiable completion condition for this evolve-colony cycle>
```

Key differences from the plugin, all favorable here:

- No Stop-hook script to write or maintain, no `jq` or any other shell
  dependency -- the evaluator is a model call, not a shell pattern-match.
- The condition is a *judgment*, not a brittle exact string -- closer to
  what `checker` already does for a single cycle, just running after every
  turn instead of once at cycle-end.
- `/goal` is unavailable (and says why, rather than silently no-opping)
  when hooks are disabled at any settings level -- a clean failure mode
  instead of a loop that quietly never exits.

## How This Composes With the PMCR-O Roles

`/goal` is a session-level mechanism; it doesn't replace `checker` or
`reflector`, it holds the session open long enough for a full
Plan->Make->Check->Reflect sequence (possibly several looped cycles) to
complete without the human re-prompting between turns. Concretely, for a
large `evolve-colony` cycle:

1. `orchestrator` sets a `/goal` condition matching this cycle's intended
   `disposition.json` outcome -- e.g. "the new domain package under
   `catalog/Tools/AI-Company/skills/<name>/` passes both
   `claude plugin validate .` and `catalog/skills.schema.json`, and
   `disposition.json` is written as `needs-approval`."
2. Each turn within that `/goal` still runs a full Plan->Make->Check->Reflect
   pass, sequenced exactly as `../skills/orchestrator-role/SKILL.md`
   describes -- `/goal` does not change cycle discipline, it just avoids a
   human having to manually restart the session between cycles.
3. **EC-009 still applies inside a `/goal` session.** Cap cycles at 3 the
   same way as any other trail. A `/goal` condition that hasn't been met
   after 3 cycles seals `needs-revision` and stops -- do not let `/goal`'s
   own turn budget substitute for this cap; the two are independent
   ceilings and both apply.
4. A `/goal` clearing (condition met) is equivalent to a cycle's Checker
   returning `pass` -- it is **not** equivalent to `disposition: accept`.
   Anything this cycle touched under `catalog/` or a `marketplace.json`
   still seals `needs-approval`, gated by `/ceo:approve-initiative`,
   regardless of how cleanly `/goal` resolved.

## Writing a Good Condition

Same discipline `checker` already applies to plan steps: the condition
must be something Claude's own output can demonstrate, not something that
requires external verification Claude can't run. Prefer conditions phrased
as "X passes Y check" over "X is good" -- the small evaluator model can
judge the former, not the latter.
