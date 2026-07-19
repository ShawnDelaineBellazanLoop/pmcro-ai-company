---
description: "Kick a PMCR-O cycle scoped to CEO to approve or reject a cross-domain initiative. Usage: /ceo:approve-initiative <initiative to review>"
---
Dispatch a PMCR-O cycle scoped to the `ceo` domain.

true_intent: Approve or reject the following cross-domain initiative:
``

Before approving, confirm which domains are affected and whether their
Owns/Does-Not-Own boundaries are respected. Invoke `pmcro-loop` with
domain=ceo and this true_intent; the cycle should produce an explicit
approve/reject/needs-revision disposition.
