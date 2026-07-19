---
description: "Validate a packaged skill against both this repo's catalog schema and Claude Code's own plugin schema before it's registered. Usage: /skill-creator:validate-skill <path-to-package>"
---
```
package_path: <first argument, relative to repo_path>
```

Run both checks -- they validate different surfaces and neither implies
the other passed:

1. `claude plugin validate .` at `repo_path` -- Claude Code's own
   marketplace/plugin schema (naming, `source` paths, category values).
2. The package's prospective `catalog/skills.json` entry against
   `catalog/skills.schema.json` -- this repo's own index schema (required
   fields, `path` pattern `^catalog/.+/skills/.+/$`, `type`/`lane` enum
   values).

Report both results explicitly, even if one clearly failed and checking
the other feels redundant -- a package that's schema-valid in one system
but not the other is exactly the kind of gap this two-check rule exists to
catch.
