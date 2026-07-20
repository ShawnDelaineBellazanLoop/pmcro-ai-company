# Proposal 3 of 3 -- Mandatory Startup Protocol

Trail: ceo/4cf2171d-4600-46a8-84bf-93939bc26aaa
Status: needs-approval -- apply only via /ceo:approve-initiative

## What was asked

A mandatory Startup Protocol requiring the agent to read
`.agents/plugins/marketplace.json` before proposing any code change.

## Where it should live

Already folded into Proposal 2's `CLAUDE.md` draft above (its own
"Startup Protocol" section). For twin parity with `AGENTS.md` -- same
principle as EC-011 -- the identical requirement should also be added to
`AGENTS.md`, referencing both marketplace twins rather than just the one
named in the request, since Codex CLI reads the Claude-native
`.claude-plugin/marketplace.json` never but Claude Code reads
`.agents/plugins/marketplace.json` never either; each tool should be told
to check *its own* twin, not the other one.

## Proposed diff -- AGENTS.md, new section after "Validating"

```markdown
## Startup Protocol

Before proposing any code change in this repo, read
`.agents/plugins/marketplace.json` to confirm the current plugin roster
and versions. Do not assume the roster from memory or a prior session --
this file is the live source of truth and may have changed since you last
read it. (Claude Code sessions: read `CLAUDE.md`'s Startup Protocol
instead, which points at the Claude-native twin,
`.claude-plugin/marketplace.json`.)
```

## Why phrased as "read your own tool's twin," not literally as asked

The request named `.agents/plugins/marketplace.json` specifically, but
that's the Codex-native file; a Claude Code session following this
protocol from `AGENTS.md` alone would be checking the wrong twin. Since
Proposal 2 already puts a matching protocol in `CLAUDE.md` pointed at the
Claude-native file, `AGENTS.md`'s version should point Codex at its own
twin rather than repeat the Claude-native path verbatim -- otherwise this
protocol immediately becomes a second thing that can drift out of sync
with reality, which is exactly what it exists to prevent.
