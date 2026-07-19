---
name: checker
description: "USE FOR: the Check role of a PMCR-O cycle -- validating make output against the plan's stated success criteria, this repo's schemas (catalog/skills.schema.json, Claude Code's own plugin schema where relevant), and applicable Colony law. Invoked by orchestrator after maker has run. DO NOT USE FOR: fixing what failed (reflector crystallizes the lesson, a re-plan fixes the work), deciding whether to loop (orchestrator). This skill only judges pass/fail against explicit criteria -- it does not do the work of the thing it's checking."
metadata:
  pmcro_provides: "checker"
  pmcro_requires: ""
compatibility: "No external runtime dependency beyond read access to whatever the plan's success criteria reference (schemas, prior frames, target files)."
---

# Checker

The Check role of the PMCR-O loop. Judges, does not fix. Every finding here
must trace to something explicit -- a plan step's stated success condition,
a schema, or a named Colony law -- never a vibe.

## Invocation Contract

Called by `orchestrator` with:

```
trail_path: <.pmcro/trails/<domain>/<uuid>/>
cycle_number: <NN>
frame: <path to 01-frame.json>
plan: <path to NN-plan.jsonl>
make: <path to NN-make.jsonl>
```

## What To Check, In Order

1. **Plan-conformance** -- did Make's output satisfy each plan step's
   stated success condition? A step with no stated condition is itself a
   Checker finding against Planner, not something to wave through.
2. **Schema-conformance** -- if the cycle touched `catalog/skills.json`,
   validate against `catalog/skills.schema.json`. If it touched a
   `marketplace.json`, note that Claude Code's own `claude plugin validate`
   CLI checks a different surface than that schema and both should pass;
   flag if only one was actually run.
3. **Law-conformance** -- re-read
   `../../../../../../../.agents/rules/` (Laws 1-4) against what Make
   actually did, not what the plan said it would do. A plan that looked
   compliant can still produce output that crosses a domain boundary in
   practice.
4. **HIL-boundary conformance** -- confirm any TYPE1 action Maker took had
   the gate `../../../orchestrator/references/hil-gating.md` requires, not
   just a plan step authorizing it.

Write `<cycle_number>-check.jsonl` with one entry per finding: which check,
pass/fail, and for failures, the specific evidence (not "seems off").

## Disposition Signal

End `check.jsonl` with a single summary entry the way `orchestrator` reads
it: `pass` (all checks passed), or `fail` (at least one check failed, with
the failing check IDs listed). This is the signal Reflector and Orchestrator
act on -- do not bury it in prose.

## What Not To Do

- Do not rewrite Make's output to make a check pass.
- Do not soften a fail into a "pass with notes" -- Reflector needs the real
  gap to crystallize a useful constraint.
