# Archived: Codechella Madrid 2025 slides

These are the **original five Codechella Madrid 2025 slide decks** plus their shared `lecture_includes/`, `math.sty` (renamed to `math_old.sty`), and `preamble.tex` (renamed to `preamble_old.tex`). They were used at the May 2025 workshop.

## Status

**Deprecated as of May 2026.** Superseded by the Glasgow-2026 deck series in the parent `Slides/` folder (built on the `remix` Beamer style, with the Rhetoric-of-Decks structure and per-deck audit fixes).

## Mapping to current decks

| Archived deck | Current replacement |
|---|---|
| `01-Codechella-Core.tex` — DiD intro, pedagogy, day outlines | `basics.tex` |
| `02-Codechella-Violations.tex` — PT violations, event studies | `basics.tex` + `covariates.tex` + `lalonde.tex` |
| `03-Codechella-Continuous.tex` — discrete dose, DiD by dose | **`continuous.tex`** (CBS decomposition, four weight formulas, `contdid`) |
| `04-Codechella-GxT.tex` — staggered timing (CS, Sun-Abraham, etc.) | `bacon_cs.tex` |
| `05-Codechella-Imputation.tex` — Borusyak-Jaravel-Spiess | covered in `bacon_cs.tex` |

## Why archived in-place

Git history preserves the originals either way. Keeping them in `archived_2025/` gives anyone hitting the repo a visible trail — "these existed, here's the current version" — without burying the breadcrumb in commit log.
