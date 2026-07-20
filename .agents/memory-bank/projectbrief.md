# Project Brief

**pmcro-ai-company** is a locally-run AI Agent Company built on the PMCR-O
Colony architecture: Plan -> Make -> Check -> Reflect -> Orchestrate, one
skill per role, composed the same way for every domain-scoped cycle.

The Colony is not a company that sells AI tools -- it is a company that is
itself a federated PMCR-O agent. Ten C-Suite domains (`ceo`, `chief-of-staff`,
`cto`, `coo`, `cfo`, `cro`, `cmo`, `clo`, `chro`, `domain-specialist`) each
own a slice of the business; every one of them runs cycles through the exact
same five-role loop (`orchestrator` + `planner`/`maker`/`checker`/`reflector`
+ `dependency-resolver`), never a domain-specific reimplementation.

The sealed trail (`.pmcro/trails/<domain>/<uuid>/`) is the product itself --
not a build succeeding, not a prior session's self-report. A feature is
"working" only once an ACCEPT-disposition trail exists for it.

This file is written once and edited rarely -- `brief-session` does not
rewrite it on every run.
