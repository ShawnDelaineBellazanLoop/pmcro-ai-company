# Repository Instructions

This repository is the PMCR-O AI Agent Company C-Suite directory, published
as a plugin marketplace for Claude Code and (via `.agents/plugins/marketplace.json`)
Codex CLI, following the `dotnet-agent-skills` catalog convention
(see `W:\dotnet-skills` for the reference implementation this repo tracks).

## Layout

- `catalog/Tools/AI-Company/skills/<domain>/` -- one plugin per C-Suite seat.
  Each is documentation-only: a `SKILL.md` stating that domain's Owns / Does
  Not Own boundary, plus `commands/` and `agents/`. No domain reimplements
  the PMCR-O loop -- that lives once, in the sibling `pmcro-skills` repo's
  `pmcro-loop` plugin.
- `.agents/rules/*.md` -- the Colony's organization-wide laws, indexed from
  `COLONY.md`. Read these before adding or editing any domain.
- `.agents/settings.local.json` (gitignored, not present by default) -- your
  personal machine defaults, e.g. `default_repo_path`. Copy
  `.agents/settings.example.json` to create it. Never commit it.
- `.claude-plugin/marketplace.json` -- Claude Code's marketplace manifest.
- `.agents/plugins/marketplace.json` -- the same catalog, Codex-native
  format, kept in sync by hand whenever a plugin is added, removed, or
  renamed in the Claude manifest.

## The One Rule That Matters Most

No domain, command, or agent in this catalog ever hardcodes a target
repository or file path. Every command that touches an external target takes
that target as an explicit parameter, resolved per
`.agents/rules/01-declarative-params.md`. If you're about to write a real
path into a `SKILL.md` or a command as a "just for now" example, don't --
put it in your own `.agents/settings.local.json` instead.

## Validating

`catalog/skills.json` and `catalog/skills.schema.json` are copies of the
`pmcro-skills` convention, so `pmcro-skills`' `catalog-check` skill can
validate this repo's index unmodified.
