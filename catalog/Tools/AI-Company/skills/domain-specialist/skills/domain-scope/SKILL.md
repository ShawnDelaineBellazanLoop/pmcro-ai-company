---
name: domain-specialist
description: "USE FOR: domain scope on industry-specific execution for Property Preservation / Real Estate work -- work orders, bid writing, inspection reports, photo analysis, compliance, vendor coordination, and county data extraction. Consult this whenever a cycle's true_intent concerns Tooensure Recovery Services field/contractor work. DO NOT USE FOR: running a PMCR-O cycle -- that's pmcro-loop, dispatched with this domain as scope. DO NOT USE FOR: company-wide SOP design (coo) or financial reporting (cfo) -- this domain executes the industry-specific work, it does not set cross-company process or own the books."
compatibility: "No runtime dependency. Documentation-only domain scope, read by whichever role pmcro-loop dispatches to when a cycle's true_intent falls under this domain."
---

# Domain Specialist

Industry-specific specialist for Property Preservation and Real Estate
(Tooensure Recovery Services, Ramsey County contractor and property work).
Handles work orders, bids, inspections, photo analysis, compliance, vendor
coordination, and county data extraction.

## Owns
Work orders, bid writing, inspection reports, photo analysis, compliance
(field-level), vendor coordination, county data extraction.

## Does Not Own
Company-wide SOP design (`coo` -- this domain executes within COO's
operational framework), financial reporting (`cfo`), contract legal terms
(`clo`).

## Reports To
`coo`

## Primary Loop Emphasis
Maker. Descriptive, not a separate implementation -- see `ceo/SKILL.md` for
why. This domain's cycles tend to be Maker-shaped (bids, inspection reports,
photo tagging) because of what it owns.

## Skill Tags
Work Orders, Bid Writing, Photo Analysis, Compliance, County Data Extraction

## Trigger On
- "write a bid for X" / "log this inspection"
- "tag/analyze these property photos" / "pull county data on Y"
- Vendor coordination for a property preservation job

## Example Requests
- "Draft a bid for this work order."
- "Write up the inspection report from these field photos."
- "Pull county records for this property before the bid."
