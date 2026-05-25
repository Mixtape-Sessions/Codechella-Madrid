# Codechella Madrid — Slides

**As of May 2026, this folder holds the Glasgow-2026 deck series**, ported in from the `the-remix-tour` repo. The original Codechella Madrid 2025 decks live in `archived_2025/` and are no longer maintained.

## Current decks (Glasgow-2026 series)

| File | Pages | Topic |
|---|---|---|
| `basics.tex` | 169 | DiD foundations, ATT, identification, the basic 2×2 |
| `covariates.tex` | 99 | Conditional PT, IPW/OR/DR, weighted-PT diagnostics |
| `bacon_cs.tex` | 74 | Staggered timing — Bacon decomp, Callaway-Sant'Anna, Sun-Abraham, BJS imputation |
| `synth.tex` | 65 | Synthetic control, convex-hull intuition, factor-model identification, synthetic DiD |
| `continuous.tex` | 58 | Continuous treatment — TWFE decomposition (four CBS weight formulas), ATT(d\|d), ACRT, `contdid` |
| `lalonde.tex` | 43 | LaLonde-DW canonical example, propensity-score methods |
| `triple-diff.tex` | 42 | DDD design, Gruber 1994 |
| `ai_agents.tex` | 39 | AI agents as experimental subjects (JEL methodology brief) |
| `brazil.tex` | 32 | Brazil mental-health reform DiD checklist (Dias & Fontes 2024) |

All built on `remix.sty` (Glasgow Beamer style — green accent, Helvetica, footer rule).

## How they compile

```bash
cd Slides/
pdflatex continuous.tex   # any deck
```

Each deck is self-contained except for `remix.sty`, the `figures/` folder, and `tables/` (for `triple-diff.tex`). All assets are in this folder.

## Companion materials

- `figures/` — all chart PDFs and PNGs the decks pull in (subfolder `figures/dxt/` holds the continuous-DiD charts)
- `scripts/` — R/Python that regenerates the figures (currently: `06_conditional_mean.R`, `acrt_fig2d.py`, `weights_07_to_10.R`)
- `code/` — R/Stata/Python source for demos and figure generation (the heavy Shiny apps live outside this folder)
- `tables/` — `.tex` table fragments included via `\input{...}` (e.g., `triple_diff_cells.tex`)
- `archived_2025/` — the original five Codechella Madrid 2025 decks (deprecated)

## Mapping from archived → current

| Archived (2025) | Current (2026) |
|---|---|
| `01-Codechella-Core` | `basics` |
| `02-Codechella-Violations` | `basics` + `covariates` + `lalonde` |
| `03-Codechella-Continuous` | `continuous` (rebuilt with CBS decomposition) |
| `04-Codechella-GxT` | `bacon_cs` |
| `05-Codechella-Imputation` | `bacon_cs` |

See `archived_2025/README.md` for details.
