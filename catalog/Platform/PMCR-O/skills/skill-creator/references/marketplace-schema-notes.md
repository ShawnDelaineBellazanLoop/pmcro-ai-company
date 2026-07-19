# Claude Code marketplace.json Schema Notes

Current fields worth setting on new plugin entries (this repo's existing
10 domain entries predate these and don't use them yet -- new entries
should):

- **`version`** -- per-plugin version pinning. Without it, every commit is
  effectively treated as a new version for every plugin in the
  marketplace. Set this on every new entry from the start.
- **`renames`** -- maps an old plugin name to its new name (or `null` to
  retire it outright). Relevant the moment any plugin here is ever
  renamed -- without it, anyone with the old name still referenced gets a
  plugin-not-found error instead of a clean redirect.
- **`hooks`**, **`mcpServers`**, **`lspServers`** -- first-class fields on
  a marketplace entry now, not just plugin-internal config. Only relevant
  if a package actually needs one of these; none of the current PMCR-O
  engine packages do (they're pure Agent Skills, no MCP server or LSP of
  their own).

## The Real Validator

`claude plugin validate .` is the authoritative CLI check for this
repo's `marketplace.json` shape. It checks a genuinely different surface
than `catalog/skills.schema.json` -- run both, always; passing one does
not imply the other passed. See `../commands/validate-skill.md`.

## Two Twins, Kept In Sync By Hand

`.claude-plugin/marketplace.json` (Claude Code native) and
`.agents/plugins/marketplace.json` (Codex-native) describe the same
catalog in two formats. There is no tooling in this repo yet that
generates one from the other -- `/skill-creator:update-catalog` updates
both by hand, in the same pass, every time. If a future cycle wants to
eliminate this duplication (e.g. generate the Codex twin from the Claude
Code one), that's itself an `/ceo:evolve-colony` cycle, not something to
quietly start doing differently in this command.
