# Law 1: Declarative, Parameter-Driven, No Hardcoded Targets

No domain plugin, command, or agent in this catalog names a specific target
repository, project, or file path as a fact baked into its instructions.
Every command that operates against an external target takes that target as
an explicit parameter (`repo_path`, `scope`, etc. -- named per domain, see
each domain's `commands/`), resolved at invocation time, not assumed at
authoring time.

Why: a hardcoded path makes a command a single-project script instead of a
reusable catalog skill, and it goes stale the instant that project's layout
changes without anyone touching this repo. The catalog stays reusable across
any target the requester names.

## Resolving a Target Path

When a command declares a `repo_path`-style parameter, resolve it in this
order, and never silently skip a step:

1. **Explicit argument** -- if the requester names a path in the command
   invocation, use it. Always wins.
2. **Local machine default** -- if `.agents/settings.local.json` exists and
   declares `default_repo_path`, use it. This file is gitignored and
   personal (see `.agents/settings.example.json` for the shape); it is
   never assumed to exist, and it is never committed to this repo.
3. **Ask** -- if neither is present, ask which repo/project the cycle
   targets. Never guess a project from a previous cycle's context.

This mirrors Claude Code's own settings precedence (managed > project >
user > local): the most specific, most explicitly-given value always wins,
and personal defaults live outside version control.

Corollary: if a cycle needs standing context about a *specific* recurring
target (e.g. a particular project), that context belongs in that target's
own convention files (its own `.clinerules/`, `CLAUDE.md`, `AGENTS.md`), or
in `.agents/settings.local.json` as a default path -- never inlined into a
domain's `SKILL.md` as a hardcoded example.
