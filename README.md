<img src="https://github.com/Mixtape-Sessions/Codechella-Madrid/blob/main/img/banner.png?raw=true" alt="Mixtape Sessions Banner" width="100%">

# Codechella Madrid 2026

Welcome to **Codechella Madrid 2026** — Mixtape Sessions' third in-person Spanish workshop.

**When:** May 25–28, 2026 (Monday–Thursday)
**Where:** CUNEF Auditorium, Madrid
**Instructor:** Scott Cunningham (Baylor University) + Dan Rees & Mark Anderson (Hidden Curriculum)

---

## Schedule

| Time | Mon May 25 | Tue May 26 | Wed May 27 | Thu May 28 |
|---|---|---|---|---|
| **9:00–10:30** | Core DiD | Covariates | Continuous | Staggered |
| 10:30–11:00 | *Coffee* | *Coffee* | *Coffee* | *Coffee* |
| **11:00–13:00** | Covariates | Covariates | Continuous | Staggered |
| 13:00–14:30 | *Lunch (by research field)* | *Lunch* | *Lunch* | *Lunch* |
| **14:30–15:30** | Dan Rees & Mark Anderson — Hidden Curriculum | Continuous | Staggered | Claude Code |
| **15:30–17:00** | Dan Rees & Mark Anderson — Hidden Curriculum | Continuous | Dan Rees & Mark Anderson — Hidden Curriculum | Claude Code |

---

## Slide decks (in `Slides/`)

| File | Topic | Workshop slot |
|---|---|---|
| **`01-basics.tex`** | Core DiD: the 2×2, parallel trends, event studies | Day 1, 9:00–10:30 (90 min) |
| `02-covariates.tex` | DiD with covariates: PSM, IPW, doubly-robust, weighted-PT diagnostics | Day 1 PM + Day 2 mornings (~5 hrs) |
| `03-continuous.tex` | Continuous-treatment DiD: CBS decomposition, ATT(d\|d), ACRT, `contdid` | Day 2 PM + Day 3 mornings (~6 hrs) |
| `04-staggered.tex` | Staggered DiD: Goodman-Bacon decomposition, Callaway–Sant'Anna, Sun-Abraham, BJS | Day 3 PM + Day 4 mornings (~4.5 hrs) |
| `synth.tex` | Synthetic control + synthetic DiD | Reference |
| `02b-lalonde.tex` | LaLonde re-evaluation: PSM, IPW, doubly-robust on the canonical NSW dataset | Reference |
| `06-checklist.tex` | Brazil mental-health reform — DiD checklist walkthrough on Dias & Fontes (2024) | Reference |
| `triple-diff.tex` | DDD (triple-difference) | Reference |
| `05-claude.tex` | AI agents for empirical research | Day 4 PM (Claude Code session) |

All decks compile with `pdflatex <file>.tex` and use **`remix.sty`** (in the same folder).

> **Note on theming:** `01-basics.tex` uses a custom Madrid palette (terracotta + twilight navy + sunset peach). All other decks render in the default Glasgow green. See `CLAUDE.md` for the override pattern.

The earlier (2025-era) Codechella decks are preserved in `Slides/archived_2025/` for reference.

---

## Labs (in `Labs/`)

| Lab | Companion to | Notes |
|---|---|---|
| `basic/` | Day 1 Core DiD | Five equivalent paths to the 2×2 (`equivalence.R`, `.do`, `.py`); event-study by hand |
| `Lalonde/` | Day 1 PM / Day 2 | LaLonde re-evaluation |
| `Lalonde-Covariates/` | Day 2 Covariates | PSM / IPW / DR with LaLonde |
| `China-WTO/` | Day 3 Continuous | Lu & Yu (2015) WTO tariff data — 5 estimators of ATT(d\|d) + event study |
| `Texas/` | Day 3 (Synth reference) | Texas prison construction — synth + augsynth + synthdid |
| `Brazil/` | Reference | Brazil CAPS mental-health reform |
| `Castle/` | Reference | Cheng & Hoekstra castle doctrine — used in §3 of 01-basics |
| `Baker/` | Reference | Staggered DiD bench data |
| `Triple-Diff/` | Reference | DDD simulation |
| `DDD/`, `Example-Code/`, `Kline-Moretti/`, `Medicaid-Expansion/` | Inherited 2025 labs | Kept as reference |

---

## Shiny apps

- **`baconplus`** — interactive continuous-DiD weight decomposer
  https://scunning1975.github.io/baconplus/
  Use on Day 3 when introducing the four CBS weight formulas
- **Bacon decomposition explorer**: https://mixtape.shinyapps.io/Bacon-Decomposition/ (Day 3 PM)
- **Event-study explorer**: https://mixtape.shinyapps.io/Event-Study/ (Day 1)

---

## Compiling

```bash
cd Slides
pdflatex 01-basics.tex
# or any other deck
```

All figures referenced by the decks are in `Slides/figures/`. Code that regenerates figures lives in `Slides/scripts/` (R, Python) and `Slides/code/` (data simulations).

---

## Image credits

Title slide of `01-basics.tex` uses `codechella_2026.jpg` — Gran Vía at sunset, Madrid (Metropolis building visible left of center).

---

*For agents / collaborators picking up this repo, see `CLAUDE.md` in the project root for design notes, the source-of-truth relationship with the `the-remix-tour` repo, and the Madrid palette override pattern.*
