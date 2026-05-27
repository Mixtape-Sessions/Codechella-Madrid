# CLAUDE.md — Codechella Madrid (Claude Workspace)

---

## Communication Guidelines

- Refer to the user as **Scott**
- Collaborators: [List collaborators and their roles]

---

## Estimation Philosophy

**Design before results.** During estimation and analysis:

- Do NOT express concern or excitement about point estimates
- Do NOT interpret results as "good" or "bad" until the design is intentional
- Focus entirely on whether the specification is correct
- Results are meaningless until we're confident the "experiment" is designed on purpose
- Objectivity means being attached to getting the design right, not to any particular finding

---

## Project Overview

Claude workspace inside the Codechella-Madrid 2026 workshop repo. Scratch space for Claude-driven analysis, lab walkthroughs, and exploratory work that should not pollute the top-level workshop folders (`Slides/`, `Labs/`).

Parent repo orientation lives in `../CLAUDE.md` (workshop operating manual). This file governs work done *inside* the Claude/ subfolder only.

### Research Question

[What are you trying to answer?]

### Data Sources

[What data are you using? Time periods? Geographic coverage?]

### Identification Strategy

[How are you identifying causal effects? What's the source of variation?]

---

## Key Decisions Made

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-05-26 | Scaffolded standard project structure via `/newproject` | Establish a clean workspace inside Codechella-Madrid/Claude for ad-hoc Claude work |

---

## Dropped Analyses

- **[Analysis name]**: [Why dropped]

---

## Key Files

- **Main analysis**: `code/...`
- **Data cleaning**: `code/...`
- **Paper draft**: n/a
- **Presentation**: see `../Slides/` in parent repo

---

## Variable Definitions

| Variable | Definition | Source |
|----------|------------|--------|
| `treatment` | [How defined] | [Where from] |
| `outcome` | [How defined] | [Where from] |

---

## Sample Restrictions

[Who's in your sample and why? Who's excluded?]

---

## Meeting Schedule

[Regular meetings with collaborators, advisors, etc.]

---

## Current Status

**Phase**: Setup

Workspace just initialized. No analysis yet.

---

## Referee 2 Correspondence

This project uses the Referee 2 audit protocol. Correspondence is stored at:

```
correspondence/referee2/
├── YYYY-MM-DD_round1_report.md      # Referee 2's detailed written report
├── YYYY-MM-DD_round1_deck.pdf       # Referee 2's visual presentation of findings
├── YYYY-MM-DD_round1_response.md    # Author's revision response
├── YYYY-MM-DD_round2_report.md      # Referee 2's second-round assessment
├── YYYY-MM-DD_round2_deck.pdf
└── ...
```

Replication scripts created by Referee 2 are stored at:
```
code/replication/
├── referee2_replicate_main_results.do
├── referee2_replicate_main_results.R
├── referee2_replicate_main_results.py
└── ...
```

**Current Status:** Not yet audited

**Critical Rule:** Referee 2 NEVER modifies author code. It only reads, runs, and creates its own replication scripts in `code/replication/`. Only the author (Scott) modifies your own code in response to referee concerns.

**Important:** Referee reports do NOT belong in this CLAUDE.md file. They are standalone documents in the correspondence directory. This section only tracks status.

---

## Notes for Claude

- Parent repo `CLAUDE.md` (one level up) is the workshop operating manual — read it before touching anything in `../Slides/` or `../Labs/`.
- Source-of-truth for slide content lives in `~/the-remix-tour/glasgow/decks/`. Do not edit slides here without syncing upstream.
