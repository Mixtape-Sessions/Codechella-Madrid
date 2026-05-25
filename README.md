<img src="https://github.com/Mixtape-Sessions/Codechella-Madrid/blob/main/Slides/codechella_2026.jpg?raw=true" alt="Codechella Madrid 2026" width="100%">

# Codechella Madrid 2026

Welcome to **Codechella Madrid 2026** — Mixtape Sessions' third in-person Spanish workshop.

**When:** May 25–28, 2026 (Monday–Thursday)
**Where:** CUNEF Auditorium, Madrid
**Instructors:** Scott Cunningham (Baylor University) + Dan Rees & Mark Anderson (Hidden Curriculum)

---

## Schedule

| Time | Mon May 25 | Tue May 26 | Wed May 27 | Thu May 28 |
|---|---|---|---|---|
| 8:30 – 9:00 am | **Registration** | | | |
| **9:00 – 10:30 am** | Core DiD | Covariates | Continuous | Staggered |
| 10:30 – 11:00 am | *Coffee* | *Coffee* | *Coffee* | *Coffee* |
| **11:00 am – 1:00 pm** | Covariates | Covariates | Continuous | Staggered |
| 1:00 – 2:30 pm | *Lunch (by research field)* | *Lunch* | *Lunch* | *Lunch* |
| **2:30 – 3:30 pm** | Dan Rees & Mark Anderson — Hidden Curriculum | Continuous | Staggered | Claude Code |
| **3:30 – 5:00 pm** | Dan Rees & Mark Anderson — Hidden Curriculum | Continuous | Dan Rees & Mark Anderson — Hidden Curriculum | Claude Code |

---

## Slide decks (in `Slides/`)

| File | Topic | Workshop slot |
|---|---|---|
| **`01-basics.tex`** | Core DiD: the 2×2, parallel trends, event studies | Mon 9:00–10:30 (90 min) |
| `02-covariates.tex` | DiD with covariates: PSM, IPW, doubly-robust, weighted-PT diagnostics | Mon 11–1, Tue 9–1 (~5.5 hrs) |
| `02b-lalonde.tex` | LaLonde companion: 5 specs against the DW experimental benchmark on the NSW data | Used alongside Covariates |
| `03-continuous.tex` | Continuous-treatment DiD: CBS decomposition, ATT(d\|d), ACRT, `contdid` | Tue 2:30–5, Wed 9–1 (~6 hrs) |
| `04-staggered.tex` | Staggered DiD: Goodman-Bacon decomposition, Callaway–Sant'Anna, Sun-Abraham, BJS | Wed 2:30–3:30, Thu 9–1 (~4.5 hrs) |
| `05-claude.tex` | AI agents for empirical research | Thu 2:30–5 (Claude Code session) |
| `06-checklist.tex` | A DiD checklist — Brazil mental-health reform walkthrough (Dias & Fontes 2024) | Reference |

All decks compile with `pdflatex <file>.tex` and use **`remix.sty`** and **`madrid_theme.sty`** (both in the same folder).

The earlier (2025-era) Codechella decks are preserved in `Slides/archived_2025/` for reference.

---

## Labs (in `Labs/`)

| Lab | Companion to | Notes |
|---|---|---|
| `basic/` | Mon Core DiD | Five equivalent paths to the 2×2 (`equivalence.R`, `.do`, `.py`); event-study by hand |
| `Lalonde/` | Mon Core DiD + Tue Covariates | LaLonde re-evaluation |
| `Lalonde-Covariates/` | Tue Covariates | PSM / IPW / DR with LaLonde |
| `Castle/` | Mon Core DiD | Cheng & Hoekstra castle doctrine — used in §3 of `01-basics` |
| `China-WTO/` | Wed Continuous | Lu & Yu (2015) WTO tariff data — 5 estimators of ATT(d\|d) + event study |
| `Baker/` | Thu Staggered | Staggered DiD bench data |
| `Brazil/` | Reference | Brazil CAPS mental-health reform |
| `Texas/` | Reference | Texas prison construction — synth + augsynth + synthdid |
| `Triple-Diff/` | Reference | DDD simulation |
| `DDD/`, `Example-Code/`, `Kline-Moretti/`, `Medicaid-Expansion/` | Inherited 2025 labs | Kept as reference |

---

## Shiny apps

- **`baconplus`** — interactive continuous-DiD weight decomposer
  https://scunning1975.github.io/baconplus/
  Use on Wed when introducing the four CBS weight formulas
- **Bacon decomposition explorer**: https://mixtape.shinyapps.io/Bacon-Decomposition/ (Wed PM)
- **Event-study explorer**: https://mixtape.shinyapps.io/Event-Study/ (Mon)

---

## Compiling

```bash
cd Slides
pdflatex 01-basics.tex
pdflatex 01-basics.tex   # second pass: Madrid title banner uses tikz remember-picture
```

The second pass is required for the Gran Vía banner on the title slide to position correctly (any deck that uses `\codechellatitle` from `madrid_theme.sty`).

All figures referenced by the decks are in `Slides/figures/`. Code that regenerates figures lives in `Slides/scripts/` (R, Python) and `Slides/code/` (data simulations).

---

## Image credits

The top banner and the title slide of every deck use `Slides/codechella_2026.jpg` — Gran Vía at sunset, Madrid (Metropolis building visible left of center).

---

*For agents or collaborators picking up this repo, see `CLAUDE.md` in the project root for design notes, the `madrid_theme.sty` palette spec, and the workflow conventions.*
