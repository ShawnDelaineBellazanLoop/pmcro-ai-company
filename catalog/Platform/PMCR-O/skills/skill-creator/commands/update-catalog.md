---
description: "Register a validated package into catalog/skills.json and both marketplace.json twins, together, in one operation. Usage: /skill-creator:update-catalog <package-name>"
---
```
package_name: <first argument>
repo_path: <resolved per Law 1>
```

Run `validate-skill.md` first. Do not proceed if either check failed.

Then update all three files in the same pass -- never just one or two of
them:

1. `catalog/skills.json` -- add the entry (schema-valid, matches the
   package's actual `path`, correct `type`/`lane`/`category`)
2. `.claude-plugin/marketplace.json` -- add the Claude Code-native plugin
   entry
3. `.agents/plugins/marketplace.json` -- add the same entry, Codex-native
   twin format

If any one of the three can't be updated (e.g. a name collision), stop and
report it rather than partially updating -- a catalog where these three
files disagree is worse than one that hasn't been updated yet, per the
carried-forward discipline that these always change together.

**This command performs the TYPE1 action itself** -- per
`../../orchestrator/references/hil-gating.md`, writing a live entry into
`catalog/skills.json` or either `marketplace.json` twin is exactly what
makes something TYPE1. That means this command only runs *after*
`/ceo:approve-initiative` has approved the package, never before. A
package sitting on disk but not yet run through this command is the
correct `needs-approval` staging state -- files exist, nothing points at
them yet. Do not invoke this command speculatively "to see if it fits";
that speculative check belongs entirely to `validate-skill.md`, which is
TYPE2 and safe to run anytime.
