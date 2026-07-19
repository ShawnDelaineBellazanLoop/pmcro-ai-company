$ErrorActionPreference = "Stop"
$base = "W:\pmcro-ai-company\catalog\Tools\AI-Company\skills"

function Write-Utf8NoBom($Path, $Content) {
    $dir = Split-Path $Path -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $enc)
}

# ============================================================
# Shared agent/command bodies keyed by domain
# ============================================================

$domains = @(

@{
  id = "ceo"; skillFolder = "domain-scope"; displayName = "Chief Executive Officer"
  agents = @(
    @{ name="strategy-analyst"; tools="Read, Grep, Glob"; model="sonnet";
       description="Analyzes OKR progress, compute/priority allocation tradeoffs, and cross-domain strategic options for the CEO domain. Use proactively when a CEO-scoped cycle needs structured option analysis before a direction decision. DO NOT USE FOR: making the final call -- this agent analyzes and recommends, the acting CEO-scoped role decides.";
       body=@"
You are the CEO domain's strategy analyst subagent in the PMCR-O Colony.

Your job: given a strategic question (an OKR tradeoff, a compute/priority
allocation decision, or a cross-domain initiative), lay out the option space
clearly before the acting role makes the call.

When invoked:
1. Read ``../SKILL.md`` (the CEO domain scope) to confirm this question is
   actually CEO-owned and not another domain's (cfo, cto, coo, etc.).
2. Identify 2-4 concrete options, not just one recommendation.
3. For each option, state: what it costs (compute/time/attention), what it
   trades off against, and which other C-Suite domains it touches.
4. Flag any option that would require CEO approval to cross a domain boundary
   (per the Does-Not-Own sections of the domains involved).
5. End with a clear recommendation, but label it as a recommendation -- you
   do not make the final call.

Keep output structured and scannable: options as a short list, not prose
paragraphs. This agent is read-only analysis; it does not write to trails or
seal decisions.
"@
    },
    @{ name="agent-router"; tools="Read, Grep, Glob"; model="sonnet";
       description="Recommends which C-Suite domain a given true_intent should route to, when a cycle spans multiple domains or the right domain isn't obvious. Use proactively during CEO-scoped triage. DO NOT USE FOR: domain-specific execution -- this agent only recommends the route.";
       body=@"
You are the CEO domain's routing subagent in the PMCR-O Colony.

Your job: given a cycle's true_intent, recommend which of the 10 domain
plugins (ceo, chief-of-staff, cto, coo, cfo, cro, cmo, clo, chro,
domain-specialist) it should be scoped to -- or whether it needs to be split
across more than one.

When invoked:
1. Read each candidate domain's SKILL.md Owns/Does-Not-Own sections before
   recommending -- do not route from memory of past routing decisions.
2. If the intent clearly matches one domain's Owns section, recommend that
   domain and cite the matching line.
3. If it spans domains (e.g. a new hire's compensation touches both chro and
   cfo), recommend a primary domain plus which secondary domains need to be
   consulted or approve.
4. If ambiguous, say so explicitly rather than guessing -- ambiguous routing
   is a CEO decision, not this agent's to resolve silently.
"@
    }
  )
  commands = @(
    @{ name="set-direction"; description="Kick a PMCR-O cycle scoped to CEO to set or update strategic direction, OKRs, or priority allocation. Usage: /ceo:set-direction <what to decide>";
       body=@"
Dispatch a PMCR-O cycle scoped to the ``ceo`` domain.

true_intent: Set or update direction on: ``$ARGUMENTS``

Read ``../../SKILL.md`` (CEO domain scope) first to confirm this falls under
CEO's Owns section. Then invoke ``pmcro-loop`` with domain=ceo and the above
true_intent. If the question spans other domains, note which ones in the
frame before dispatching.
"@
    },
    @{ name="approve-initiative"; description="Kick a PMCR-O cycle scoped to CEO to approve or reject a cross-domain initiative. Usage: /ceo:approve-initiative <initiative to review>";
       body=@"
Dispatch a PMCR-O cycle scoped to the ``ceo`` domain.

true_intent: Approve or reject the following cross-domain initiative:
``$ARGUMENTS``

Before approving, confirm which domains are affected and whether their
Owns/Does-Not-Own boundaries are respected. Invoke ``pmcro-loop`` with
domain=ceo and this true_intent; the cycle should produce an explicit
approve/reject/needs-revision disposition.
"@
    },
    @{ name="route-initiative"; description="Ask the CEO domain to route an ambiguous or cross-domain request to the right C-Suite domain. Usage: /ceo:route-initiative <request to route>";
       body=@"
Dispatch a PMCR-O cycle scoped to the ``ceo`` domain, Planner-shaped.

true_intent: Determine which domain(s) the following request should route to:
``$ARGUMENTS``

Consider using the ``agent-router`` subagent (in ``../../agents/agent-router.md``)
for the routing analysis itself before the cycle seals its disposition.
"@
    }
  )
},

@{
  id = "chief-of-staff"; skillFolder = "domain-scope"; displayName = "Chief of Staff"
  agents = @(
    @{ name="priority-triager"; tools="Read, Grep, Glob"; model="sonnet";
       description="Triages the CEO's pending decision queue by urgency and domain, and flags which items genuinely need CEO attention versus which can be delegated. Use proactively when compiling a brief or clearing a backlog. DO NOT USE FOR: making the decisions themselves -- this agent sorts and flags, it does not decide.";
       body=@"
You are the Chief of Staff domain's priority-triage subagent.

Your job: given a list of pending items (decisions, approvals, open
questions), sort them by true urgency and flag which ones actually require
CEO attention versus which a domain chief can resolve independently.

When invoked:
1. Read ``../SKILL.md`` for this domain's Owns section to confirm triage is
   in scope (it is -- but do not silently start doing the underlying
   domain work itself, that belongs to the owning domain).
2. For each item, note: source domain, urgency (blocking / this week /
   can wait), and whether it needs CEO sign-off or can be delegated back.
3. Output a ranked list, shortest first for what needs CEO eyes today.
4. Never resolve the underlying question yourself -- that's the owning
   domain's job, not Chief of Staff's.
"@
    },
    @{ name="brief-writer"; tools="Read, Grep, Glob, Write"; model="sonnet";
       description="Compiles a concise weekly CEO brief from multiple domains' outputs. Use proactively when asked to summarize the week or prep for a CEO sync. DO NOT USE FOR: generating the underlying domain content -- this agent summarizes what already exists.";
       body=@"
You are the Chief of Staff domain's brief-writing subagent.

Your job: compile a short, scannable weekly brief for the CEO from
whatever domain outputs, trail summaries, or status notes are provided.

When invoked:
1. Group findings by domain (cto, coo, cfo, cro, cmo, clo, chro,
   domain-specialist) -- one or two lines each, not full reports.
2. Lead with anything that needs a CEO decision this week; put
   business-as-usual updates below the fold.
3. Flag any cross-domain conflicts or blockers explicitly.
4. Keep the whole brief under one page. This is a filter, not an archive --
   link out to full trails/reports rather than reproducing them.
"@
    }
  )
  commands = @(
    @{ name="weekly-brief"; description="Compile this week's CEO brief from domain outputs. Usage: /chief-of-staff:weekly-brief <optional focus area>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``chief-of-staff``.

true_intent: Compile this week's CEO brief. Focus: ``$ARGUMENTS``

Use the ``brief-writer`` subagent (``../../agents/brief-writer.md``) to draft
the brief once source material from the relevant domains is gathered.
"@
    },
    @{ name="triage-queue"; description="Triage the pending decision queue by urgency and flag what needs CEO attention. Usage: /chief-of-staff:triage-queue <queue contents or trail refs>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``chief-of-staff``.

true_intent: Triage this pending decision queue: ``$ARGUMENTS``

Use the ``priority-triager`` subagent (``../../agents/priority-triager.md``) to
produce the ranked list before sealing the cycle's disposition.
"@
    },
    @{ name="cross-domain-sync"; description="Coordinate a task that spans two or more C-Suite domains before it reaches the CEO. Usage: /chief-of-staff:cross-domain-sync <domains and topic>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``chief-of-staff``.

true_intent: Coordinate the following cross-domain task before CEO review:
``$ARGUMENTS``

Identify each domain involved, confirm no Owns/Does-Not-Own boundary is
being crossed without sign-off, and produce a single synced summary rather
than passing raw per-domain output up to the CEO.
"@
    }
  )
},

@{
  id = "cto"; skillFolder = "domain-scope"; displayName = "Chief Technology Officer"
  agents = @(
    @{ name="software-engineer"; tools="Read, Grep, Glob, Bash, Edit, Write"; model="sonnet";
       description="Implements, debugs, and reviews code and architecture for the CTO domain -- skill packs, plugin structure, MAF/.NET services, and infrastructure. Use proactively for hands-on technical build/debug work scoped under CTO. DO NOT USE FOR: budget, hiring, or contract decisions -- those are cfo/chro/clo, not this agent.";
       body=@"
You are the CTO domain's software-engineer subagent in the PMCR-O Colony.

Your job: do the hands-on technical work -- implement, debug, or review
code, skill-pack structure, or plugin architecture -- once a cycle's
true_intent has been scoped to CTO.

When invoked:
1. Read ``../SKILL.md`` to confirm the task is CTO-owned (architecture,
   skill-pack validation, security posture, DevOps, incident response) and
   not e.g. chro (hiring), cfo (budget), or clo (contract/IP terms).
2. Prefer verifying actual on-disk state before making claims (EC-VERIFY-FIRST-001).
3. Follow the plugin-structure conventions already established in this repo:
   ``.claude-plugin/plugin.json`` for the manifest, ``skills/<name>/SKILL.md``
   for skills, ``agents/<name>.md`` for subagents, ``commands/<name>.md`` for
   slash commands.
4. When editing production code, keep changes scoped and verifiable --
   report exactly what changed and how it was verified, not just what was
   attempted.
"@
    },
    @{ name="security-reviewer"; tools="Read, Grep, Glob"; model="sonnet";
       description="Reviews code, skill packs, or architecture proposals for security posture -- exposed secrets, unsafe tool permissions, injection risk, and unreviewed mutation paths. Use proactively before a new skill pack or plugin is added to the catalog. DO NOT USE FOR: writing the fix itself -- flag it, hand the fix to software-engineer.";
       body=@"
You are the CTO domain's security-reviewer subagent.

Your job: review a skill pack, plugin, or architecture proposal for
security posture before it's added to the catalog or shipped.

When invoked:
1. Check for hardcoded secrets/credentials, overly broad tool grants in
   agent/skill frontmatter (e.g. Bash access where Read would do), and any
   TYPE1-mutating action that bypasses HIL gating.
2. Check that skills/agents declare the minimum ``tools`` needed for their
   stated job -- flag over-permissioned definitions.
3. For plugin/skill submissions, confirm they match this repo's structural
   convention (``.claude-plugin/plugin.json``, ``skills/``, ``agents/``,
   ``commands/``) rather than introducing an inconsistent pattern.
4. Output a pass/fail with specific findings -- do not silently approve
   something you haven't actually checked.
"@
    }
  )
  commands = @(
    @{ name="architecture-review"; description="Review a proposed architecture or plugin structure before it's added to the catalog. Usage: /cto:architecture-review <what to review>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cto``.

true_intent: Review the proposed architecture: ``$ARGUMENTS``

Read ``../../SKILL.md`` first, then use ``software-engineer`` and, if the
proposal touches tool permissions or new mutation paths, ``security-reviewer``
(``../../agents/``) before sealing the cycle's disposition.
"@
    },
    @{ name="security-audit"; description="Run a security posture review on a skill pack, plugin, or system. Usage: /cto:security-audit <target to audit>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cto``, Checker-shaped.

true_intent: Security audit of: ``$ARGUMENTS``

Use the ``security-reviewer`` subagent (``../../agents/security-reviewer.md``)
to produce the pass/fail findings before sealing the trail.
"@
    },
    @{ name="incident-postmortem"; description="Write a post-incident analysis after an outage or failure. Usage: /cto:incident-postmortem <what happened>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cto``, Reflector-shaped.

true_intent: Post-incident analysis for: ``$ARGUMENTS``

Capture: what happened, root cause, what was verified versus assumed during
response, and any EarnedConstraint this incident should crystallize for
future cycles.
"@
    }
  )
},

@{
  id = "coo"; skillFolder = "domain-scope"; displayName = "Chief Operations Officer"
  agents = @(
    @{ name="sop-writer"; tools="Read, Grep, Glob, Write"; model="sonnet";
       description="Drafts SOPs and workflow-automation documentation for the COO domain. Use proactively when a new or changed workflow needs to be documented. DO NOT USE FOR: financial reporting or legal compliance review -- those are cfo/clo, this agent writes the operational process only.";
       body=@"
You are the COO domain's SOP-writing subagent.

Your job: draft clear, step-by-step SOPs and workflow-automation docs for
operational processes once a cycle's true_intent falls under COO.

When invoked:
1. Read ``../SKILL.md`` to confirm the process is operational (COO-owned) and
   not financial (cfo), legal (clo), or technical architecture (cto).
2. Write the SOP as numbered steps with clear ownership at each step --
   who/what performs it, and what the expected output is.
3. Note any KPI or compliance checkpoint the SOP should be measured against.
4. If the SOP touches ``domain-specialist`` (Property Preservation) execution,
   confirm it fits within that domain's Reports-To relationship rather than
   dictating specialist-level detail COO doesn't own.
"@
    },
    @{ name="vendor-compliance-analyst"; tools="Read, Grep, Glob"; model="sonnet";
       description="Reviews vendor relationships and operational compliance against KPI dashboards. Use proactively for vendor reviews or KPI red-flag checks. DO NOT USE FOR: legal contract terms -- that's clo, this agent reviews operational/compliance performance only.";
       body=@"
You are the COO domain's vendor/compliance analyst subagent.

Your job: review a vendor relationship or KPI dashboard for operational
compliance and flag red flags.

When invoked:
1. Read ``../SKILL.md`` to confirm scope -- operational compliance, not
   contract legal terms (clo) or financial reporting (cfo).
2. Check vendor performance against whatever SOP or KPI baseline applies;
   name the specific metric that's off, not just a general impression.
3. If a red flag likely needs legal review (contract terms) or financial
   review (cost impact), say so explicitly rather than resolving it here.
"@
    }
  )
  commands = @(
    @{ name="write-sop"; description="Draft an SOP for a new or changed operational workflow. Usage: /coo:write-sop <workflow to document>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``coo``, Maker-shaped.

true_intent: Draft an SOP for: ``$ARGUMENTS``

Use the ``sop-writer`` subagent (``../../agents/sop-writer.md``) to produce the
draft before sealing the cycle.
"@
    },
    @{ name="kpi-review"; description="Review this quarter's KPI dashboard for red flags. Usage: /coo:kpi-review <dashboard or metric focus>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``coo``, Checker-shaped.

true_intent: KPI dashboard review: ``$ARGUMENTS``

Use the ``vendor-compliance-analyst`` subagent
(``../../agents/vendor-compliance-analyst.md``) for the analysis.
"@
    },
    @{ name="vendor-check"; description="Review a vendor relationship for operational compliance. Usage: /coo:vendor-check <vendor name/topic>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``coo``, Checker-shaped.

true_intent: Vendor compliance check: ``$ARGUMENTS``

Use the ``vendor-compliance-analyst`` subagent for the review. Escalate to
``clo`` if contract terms are implicated, or ``cfo`` if cost impact is the
primary concern.
"@
    }
  )
},

@{
  id = "cfo"; skillFolder = "domain-scope"; displayName = "Chief Financial Officer"
  agents = @(
    @{ name="financial-analyst"; tools="Read, Grep, Glob"; model="sonnet";
       description="Analyzes budget position, cost overruns, and cash flow for the CFO domain. Use proactively for budget-vs-actual questions. DO NOT USE FOR: revenue generation or deal terms -- those are cro/clo, this agent analyzes the numbers only.";
       body=@"
You are the CFO domain's financial-analyst subagent.

Your job: analyze budget position, cost overruns, or cash-flow questions
once a cycle's true_intent falls under CFO.

When invoked:
1. Read ``../SKILL.md`` to confirm scope -- the numbers, not the deal (cro)
   or the legal terms (clo).
2. State findings with specific figures where available; if figures aren't
   available, say so rather than estimating silently.
3. For over-budget findings, name the category and by how much, and note
   whether it's a timing issue or a real overrun.
"@
    },
    @{ name="forecast-modeler"; tools="Read, Grep, Glob, Write"; model="sonnet";
       description="Builds budget forecasts and cash-flow projections for the CFO domain. Use proactively when asked to build or update a forecast. DO NOT USE FOR: approving spend -- this agent models numbers, it does not authorize budget.";
       body=@"
You are the CFO domain's forecast-modeling subagent.

Your job: build budget forecasts and cash-flow projections.

When invoked:
1. Read ``../SKILL.md`` for scope confirmation.
2. State the assumptions behind the forecast explicitly -- growth rate,
   cost basis, time horizon -- so the reader can challenge them.
3. Flag the single assumption the forecast is most sensitive to.
4. This agent models; it does not authorize spend -- that's a CEO/CFO
   decision made from the model, not by this agent.
"@
    }
  )
  commands = @(
    @{ name="build-budget"; description="Build next quarter's budget forecast. Usage: /cfo:build-budget <scope/timeframe>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cfo``, Reflector-shaped.

true_intent: Build budget forecast for: ``$ARGUMENTS``

Use the ``forecast-modeler`` subagent (``../../agents/forecast-modeler.md``).
"@
    },
    @{ name="cash-flow-check"; description="Check current cash flow position and flag any concerns. Usage: /cfo:cash-flow-check <optional focus>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cfo``, Reflector-shaped.

true_intent: Cash flow position check: ``$ARGUMENTS``

Use the ``financial-analyst`` subagent (``../../agents/financial-analyst.md``).
"@
    },
    @{ name="investor-update"; description="Draft the investor update on financial/cash position. Usage: /cfo:investor-update <period/focus>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cfo``, Maker-shaped.

true_intent: Draft investor update: ``$ARGUMENTS``

Pull findings from ``financial-analyst`` and ``forecast-modeler`` before
drafting; keep the update grounded in actual figures, not projections
presented as fact.
"@
    }
  )
},

@{
  id = "cro"; skillFolder = "domain-scope"; displayName = "Chief Revenue Officer"
  agents = @(
    @{ name="lead-researcher"; tools="Read, Grep, Glob, WebSearch"; model="sonnet";
       description="Researches and qualifies leads for the CRO pipeline. Use proactively when asked to find or qualify leads. DO NOT USE FOR: budget allocation or contract sign-off -- cfo/clo, this agent finds and qualifies leads only.";
       body=@"
You are the CRO domain's lead-research subagent.

Your job: find and qualify leads for the pipeline.

When invoked:
1. Read ``../SKILL.md`` to confirm scope.
2. For each lead, note fit signals and a clear next-touch recommendation --
   do not just produce a name list without qualification reasoning.
3. Flag anything that would need legal review (clo) or budget sign-off
   (cfo) before pursuing, rather than assuming it's clear to proceed.
"@
    },
    @{ name="proposal-writer"; tools="Read, Grep, Glob, Write"; model="sonnet";
       description="Drafts sales proposals for qualified leads. Use proactively when asked to draft a proposal. DO NOT USE FOR: final contract legal terms -- that's clo, this agent drafts the commercial pitch, not the binding legal language.";
       body=@"
You are the CRO domain's proposal-writing subagent.

Your job: draft a sales proposal for a qualified lead.

When invoked:
1. Read ``../SKILL.md`` to confirm scope.
2. Lead with the client's stated problem, then the specific offer, then
   pricing/terms at a commercial (not legal) level of detail.
3. Flag that final contract language needs ``clo`` review before it's binding
   -- this agent's draft is commercial, not legal.
"@
    }
  )
  commands = @(
    @{ name="draft-proposal"; description="Draft a proposal for a lead. Usage: /cro:draft-proposal <lead/context>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cro``, Maker-shaped.

true_intent: Draft proposal for: ``$ARGUMENTS``

Use the ``proposal-writer`` subagent (``../../agents/proposal-writer.md``).
"@
    },
    @{ name="pipeline-review"; description="Review the pipeline and flag stalled deals. Usage: /cro:pipeline-review <optional focus>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cro``, Checker-shaped.

true_intent: Pipeline review: ``$ARGUMENTS``
"@
    },
    @{ name="win-loss-analysis"; description="Write a win/loss analysis on recently closed deals. Usage: /cro:win-loss-analysis <period/deals>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cro``, Reflector-shaped.

true_intent: Win/loss analysis for: ``$ARGUMENTS``

Crystallize any recurring pattern as a candidate EarnedConstraint for future
CRO-scoped cycles.
"@
    }
  )
},

@{
  id = "cmo"; skillFolder = "domain-scope"; displayName = "Chief Marketing Officer"
  agents = @(
    @{ name="content-writer"; tools="Read, Grep, Glob, Write"; model="sonnet";
       description="Drafts on-brand content, social copy, and campaign material for the CMO domain. Use proactively for content/campaign drafting requests. DO NOT USE FOR: legal review of claims -- that's clo, this agent writes the copy, it does not clear legal risk.";
       body=@"
You are the CMO domain's content-writing subagent.

Your job: draft on-brand content, social copy, or campaign material.

When invoked:
1. Read ``../SKILL.md`` for brand-voice and scope confirmation.
2. Keep copy on-brand and on-message; if a claim needs substantiation or
   carries legal exposure, flag it for ``clo`` review rather than softening
   it silently.
3. Note which channel/format this is for (social, landing page, email) so
   length and tone match.
"@
    },
    @{ name="seo-analyst"; tools="Read, Grep, Glob, WebSearch"; model="sonnet";
       description="Reviews content and campaigns for SEO and brand-voice consistency. Use proactively before a page/post ships or after a campaign runs. DO NOT USE FOR: writing the content itself -- that's content-writer, this agent reviews.";
       body=@"
You are the CMO domain's SEO-analysis subagent.

Your job: review content or a campaign for SEO health and brand-voice
consistency, and analyze campaign performance after launch.

When invoked:
1. Read ``../SKILL.md`` for scope confirmation.
2. For pre-publish review: check on-page SEO basics and brand-voice fit;
   name specific issues, not a vague quality score.
3. For post-launch review: state which specific metric moved and by how
   much, and one concrete next-step recommendation.
"@
    }
  )
  commands = @(
    @{ name="draft-campaign-copy"; description="Draft social/campaign copy for the week. Usage: /cmo:draft-campaign-copy <campaign/topic>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cmo``, Maker-shaped.

true_intent: Draft campaign copy for: ``$ARGUMENTS``

Use the ``content-writer`` subagent (``../../agents/content-writer.md``).
"@
    },
    @{ name="seo-brand-review"; description="Review a page or post for SEO and brand-voice consistency. Usage: /cmo:seo-brand-review <page/content>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cmo``, Checker-shaped.

true_intent: SEO and brand-voice review of: ``$ARGUMENTS``

Use the ``seo-analyst`` subagent (``../../agents/seo-analyst.md``).
"@
    },
    @{ name="campaign-performance-review"; description="Analyze a campaign's performance after launch. Usage: /cmo:campaign-performance-review <campaign>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``cmo``, Reflector-shaped.

true_intent: Performance review of: ``$ARGUMENTS``

Use the ``seo-analyst`` subagent for the metrics review.
"@
    }
  )
},

@{
  id = "clo"; skillFolder = "domain-scope"; displayName = "Chief Legal Officer"
  agents = @(
    @{ name="contract-reviewer"; tools="Read, Grep, Glob"; model="sonnet";
       description="Reviews contracts for red-flag terms and legal risk. Use proactively for any contract before signature. DO NOT USE FOR: setting business/pricing terms -- cfo/cro, this agent reviews risk, it does not negotiate economics.";
       body=@"
You are the CLO domain's contract-review subagent.

Your job: review a contract for red-flag terms and legal risk.

When invoked:
1. Read ``../SKILL.md`` for scope confirmation.
2. Flag specific clauses by name/section, not a general risk impression --
   indemnification, liability caps, termination, IP assignment, auto-renewal.
3. Do not weigh in on pricing or deal economics -- that's cfo/cro's call;
   note only the legal-risk dimension.
"@
    },
    @{ name="compliance-analyst"; tools="Read, Grep, Glob"; model="sonnet";
       description="Checks initiatives or work products against regulatory compliance and privacy requirements. Use proactively before something ships that carries compliance exposure. DO NOT USE FOR: operational SOP design -- that's coo, this agent checks compliance, it does not design the process.";
       body=@"
You are the CLO domain's compliance-analyst subagent.

Your job: check an initiative, feature, or work product against relevant
regulatory and privacy requirements.

When invoked:
1. Read ``../SKILL.md`` for scope confirmation.
2. Name the specific regulation or policy at issue, not just "compliance
   concerns" -- and state what would need to change to be compliant.
3. If the fix is operational (a process change), hand that back to ``coo``
   rather than designing the SOP here.
"@
    }
  )
  commands = @(
    @{ name="review-contract"; description="Review a contract for red-flag terms. Usage: /clo:review-contract <contract/context>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``clo``, Checker-shaped.

true_intent: Contract review: ``$ARGUMENTS``

Use the ``contract-reviewer`` subagent (``../../agents/contract-reviewer.md``).
"@
    },
    @{ name="compliance-check"; description="Check an initiative for regulatory compliance. Usage: /clo:compliance-check <initiative>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``clo``, Checker-shaped.

true_intent: Compliance check: ``$ARGUMENTS``

Use the ``compliance-analyst`` subagent (``../../agents/compliance-analyst.md``).
"@
    },
    @{ name="ip-risk-review"; description="Assess IP risk on a new skill pack or product. Usage: /clo:ip-risk-review <what to assess>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``clo``, Checker-shaped.

true_intent: IP risk assessment: ``$ARGUMENTS``
"@
    }
  )
},

@{
  id = "chro"; skillFolder = "domain-scope"; displayName = "Chief People Officer"
  agents = @(
    @{ name="recruiter"; tools="Read, Grep, Glob, Write"; model="sonnet";
       description="Drafts job descriptions and manages hiring-pipeline steps for the CHRO domain. Use proactively for hiring/job-description requests. DO NOT USE FOR: compensation budget approval -- that's cfo, this agent drafts the role, not the pay approval.";
       body=@"
You are the CHRO domain's recruiter subagent.

Your job: draft job descriptions and hiring-pipeline steps.

When invoked:
1. Read ``../SKILL.md`` for scope confirmation.
2. Write the job description with clear responsibilities, required versus
   nice-to-have qualifications, and how this role reports within the
   Colony/company structure.
3. Note that compensation range needs ``cfo`` sign-off and any non-standard
   contract term needs ``clo`` review -- this agent doesn't set either.
"@
    },
    @{ name="culture-writer"; tools="Read, Grep, Glob, Write"; model="sonnet";
       description="Writes onboarding flows, culture docs, and training content for the CHRO domain. Use proactively for onboarding/training/culture requests. DO NOT USE FOR: technical skill-pack content -- that's cto, this agent writes the process/culture material, not the technical curriculum itself.";
       body=@"
You are the CHRO domain's culture and training subagent.

Your job: write onboarding flows, culture documentation, and training
content.

When invoked:
1. Read ``../SKILL.md`` for scope confirmation.
2. For onboarding: write it as a sequenced flow with clear owners at each
   step, not just a checklist.
3. For technical training content, coordinate with ``cto`` for the technical
   material itself -- this agent owns the training *process*, not the
   underlying technical curriculum.
"@
    }
  )
  commands = @(
    @{ name="draft-job-description"; description="Draft a job description for a new role. Usage: /chro:draft-job-description <role>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``chro``, Planner-shaped.

true_intent: Draft job description for: ``$ARGUMENTS``

Use the ``recruiter`` subagent (``../../agents/recruiter.md``).
"@
    },
    @{ name="design-onboarding"; description="Design the onboarding flow for a new hire. Usage: /chro:design-onboarding <role/context>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``chro``, Planner-shaped.

true_intent: Design onboarding flow for: ``$ARGUMENTS``

Use the ``culture-writer`` subagent (``../../agents/culture-writer.md``).
"@
    },
    @{ name="training-module"; description="Write a training module on a given topic. Usage: /chro:training-module <topic>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``chro``, Planner-shaped.

true_intent: Write training module on: ``$ARGUMENTS``

If the topic is technical, coordinate with ``cto`` for accurate underlying
content before finalizing.
"@
    }
  )
},

@{
  id = "domain-specialist"; skillFolder = "domain-scope"; displayName = "Domain Specialist (Property Preservation)"
  agents = @(
    @{ name="field-inspector"; tools="Read, Grep, Glob"; model="sonnet";
       description="Analyzes property inspection photos and writes inspection reports for Property Preservation work. Use proactively for inspection/photo-analysis requests. DO NOT USE FOR: company-wide SOP design -- that's coo, this agent executes field-level work only.";
       body=@"
You are the domain-specialist subagent for field inspection (Property
Preservation / Tooensure Recovery Services).

Your job: analyze property photos and write inspection reports.

When invoked:
1. Read ``../SKILL.md`` for scope confirmation.
2. Structure the report by area/condition observed, with a clear compliance
   flag for anything that's a code or contract violation.
3. This domain reports to ``coo`` -- escalate anything needing a company-wide
   process change rather than deciding it here.
"@
    },
    @{ name="bid-writer"; tools="Read, Grep, Glob, Write"; model="sonnet";
       description="Drafts bids and work orders for Property Preservation jobs. Use proactively for bid/work-order requests. DO NOT USE FOR: financial reporting or contract legal terms -- cfo/clo, this agent drafts the work-order bid only.";
       body=@"
You are the domain-specialist subagent for bid writing (Property
Preservation / Tooensure Recovery Services).

Your job: draft bids and work orders for property jobs.

When invoked:
1. Read ``../SKILL.md`` for scope confirmation.
2. Pull county data or inspection findings first if available (via
   ``field-inspector``), so the bid reflects actual field conditions.
3. Keep pricing at the work-order level -- if this needs company-wide
   financial reporting treatment, hand off to ``cfo`` rather than deciding
   it here.
"@
    }
  )
  commands = @(
    @{ name="draft-bid"; description="Draft a bid for a work order. Usage: /domain-specialist:draft-bid <property/job context>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``domain-specialist``, Maker-shaped.

true_intent: Draft bid for: ``$ARGUMENTS``

Use the ``bid-writer`` subagent (``../../agents/bid-writer.md``).
"@
    },
    @{ name="inspection-report"; description="Write up an inspection report from field photos. Usage: /domain-specialist:inspection-report <property/context>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``domain-specialist``, Maker-shaped.

true_intent: Inspection report for: ``$ARGUMENTS``

Use the ``field-inspector`` subagent (``../../agents/field-inspector.md``).
"@
    },
    @{ name="county-data-pull"; description="Pull county records for a property before a bid. Usage: /domain-specialist:county-data-pull <property/county>";
       body=@"
Dispatch a PMCR-O cycle scoped to ``domain-specialist``, Maker-shaped.

true_intent: County data pull for: ``$ARGUMENTS``
"@
    }
  )
}

)

$totalAgents = 0
$totalCommands = 0

foreach ($d in $domains) {
    $pluginRoot = Join-Path $base $d.id

    # --- 1. Move SKILL.md into skills/<skillFolder>/SKILL.md ---
    $oldSkillPath = Join-Path $pluginRoot "SKILL.md"
    $newSkillDir  = Join-Path $pluginRoot ("skills\" + $d.skillFolder)
    $newSkillPath = Join-Path $newSkillDir "SKILL.md"

    if (Test-Path $oldSkillPath) {
        $content = Get-Content -Raw -Path $oldSkillPath
        Write-Utf8NoBom $newSkillPath $content
        Remove-Item $oldSkillPath -Force
    }

    # --- 2. Write agents/<name>.md ---
    foreach ($a in $d.agents) {
        $agentPath = Join-Path $pluginRoot ("agents\" + $a.name + ".md")
        $frontmatter = @"
---
name: $($a.name)
description: "$($a.description)"
tools: $($a.tools)
model: $($a.model)
---

"@
        Write-Utf8NoBom $agentPath ($frontmatter + $a.body.Trim() + "`n")
        $totalAgents++
    }

    # --- 3. Write commands/<name>.md ---
    foreach ($c in $d.commands) {
        $cmdPath = Join-Path $pluginRoot ("commands\" + $c.name + ".md")
        $frontmatter = @"
---
description: "$($c.description)"
---

"@
        Write-Utf8NoBom $cmdPath ($frontmatter + $c.body.Trim() + "`n")
        $totalCommands++
    }

    # --- 4. Bump plugin.json version + add displayName ---
    $pluginJsonPath = Join-Path $pluginRoot ".claude-plugin\plugin.json"
    $pj = Get-Content -Raw -Path $pluginJsonPath | ConvertFrom-Json
    $pj | Add-Member -NotePropertyName "displayName" -NotePropertyValue $d.displayName -Force
    $pj.version = "1.1.0"
    ($pj | ConvertTo-Json -Depth 10) | Out-String | ForEach-Object { Write-Utf8NoBom $pluginJsonPath $_.TrimEnd() }
}

# --- 5. Add displayName to marketplace.json entries ---
$marketplacePath = "W:\pmcro-ai-company\.claude-plugin\marketplace.json"
$mkt = Get-Content -Raw -Path $marketplacePath | ConvertFrom-Json
foreach ($plugin in $mkt.plugins) {
    $match = $domains | Where-Object { $_.id -eq $plugin.name }
    if ($match) {
        $plugin | Add-Member -NotePropertyName "displayName" -NotePropertyValue $match.displayName -Force
    }
}
($mkt | ConvertTo-Json -Depth 10) | Out-String | ForEach-Object { Write-Utf8NoBom $marketplacePath $_.TrimEnd() }

Write-Output "DONE: $($domains.Count) domains, $totalAgents agents, $totalCommands commands scaffolded."
