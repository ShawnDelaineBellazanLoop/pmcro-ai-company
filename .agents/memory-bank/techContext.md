# Tech Context

## Repo Location
`W:\pmcro-ai-company` (accessible via the Filesystem MCP's allowed
directories, alongside `W:\ProjectName` and `W:\`). Remote:
`https://github.com/ShawnDelaineBellazanLoop/pmcro-ai-company`, branch
`main`.

## Layering (per `COLONY.md`)
| Layer | Lives in |
|---|---|
| Colony config (index) | `COLONY.md` (repo root) |
| Colony laws | `.agents/rules/*.md` (4 files) |
| Cross-tool repo instructions | `AGENTS.md` / `CLAUDE.md` (repo root) |
| Domain scope | `catalog/Tools/AI-Company/skills/<domain>/skills/domain-scope/SKILL.md` |
| Commands | `catalog/.../skills/<domain>/commands/*.md` |
| Personal machine defaults | `.agents/settings.local.json` (gitignored) |
| **Memory Bank (this convention)** | `.agents/memory-bank/*.md` |

## Package Structure
`catalog/Platform/PMCR-O/skills/` holds the Platform-tier engine packages
(`orchestrator`, `dependency-resolver`, `planner`, `maker`, `checker`,
`reflector`, `skill-creator`), each `.claude-plugin/plugin.json` +
`manifest.json` + `skills/<name>-role/SKILL.md`, some with `commands/`,
`references/`, `scripts/`. `catalog/Tools/AI-Company/skills/` holds the
10 C-Suite domain packages, each documentation-only (`domain-scope/SKILL.md`
+ `commands/`).

## Known Environment Quirks
- Local Filesystem MCP is prone to silently timing out mid-write under
  sustained load (noted in `commands/seal-trail.md`); every write in this
  repo should be read back to confirm it landed, not trusted from a
  success response alone.
- `git` line endings: this repo warns `LF will be replaced by CRLF` on
  every touched file (Windows checkout) -- cosmetic, not a defect.
- `terminal-mcp`'s `RunCommand` always returns `TYPE1_PENDING` first; the
  actual execution happens via a separate `ExecuteRunCommand` call after
  approval is confirmed back to the human.

## Versions (as of this Memory Bank's creation)
All 15 registered `catalog/skills.json` packages at `version: "1.0.0"`.
