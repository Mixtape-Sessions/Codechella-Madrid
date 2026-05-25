# `decks/code/` — Figure and table generators for the Glasgow deck

This folder holds the **scripts that generate every figure and table** that appears in (or alongside) `basics.tex` and the other Glasgow decks. The point is reproducibility: anyone with the source can recompile the deck and regenerate the visuals from scratch.

This is **separate from `../labs/`**, which contains student-facing exercises adapted from `Causal-Inference-2`. The split:

| Folder | Purpose |
|---|---|
| `decks/code/` | Code that produces the figures and tables shown in the deck. |
| `../labs/` | Exercises the students work through themselves. |

## What's here

| File / folder | Generates | Used on |
|---|---|---|
| `semmelweis_chart.R` | `../figures/semmelweis_remix.pdf` — annual maternal mortality at Vienna General Hospital, 1841–1849, with handwashing intervention marker | Day 1, Lesson 1 (Semmelweis) |
| `sampling_distribution_chart.R` | `../figures/sampling_distribution.pdf` — two-panel sampling distribution showing shape (statistics) vs. center (identification) | Day 1, Lesson 3 (PO → identification) |
| `Tiebout-Roy/` | Solon-Haider-Wooldridge simulation: person-weighted vs. county-weighted ATE under random vs. δ-sorted assignment | Day 1, Lesson 3 (weighting subsection) |
| `equivalence/` | Stata / R / Python scripts showing three regressions on castle.dta all return the same DiD | Day 1, Lesson 2 (three regressions) |
| `IPW-Demo/ipw_simulation.R` | `IPW-Demo/figures/ipw_comparison.pdf` — Monte Carlo comparing IPW-reweighting vs. additive-PS regression vs. naive OLS | Day 2, Covariates lesson (live demo) |
| `SE-Demo/se_simulation.R` + `app.R` | Static + Shiny version of the BDM placebo simulation: vanilla / robust / cluster-robust sampling distributions of the t-statistic | Day 1, Lesson 4 (Standard Errors) |

## Visual identity

Every figure in this folder sources the shared theme at `../../../_themes/remix_theme.R`. This guarantees that the figures match the deck's palette and typography. **Do not redefine colors locally** — always use `theme_remix()` + the `scale_*_remix_*()` scales.

## To regenerate any figure

```sh
cd decks/code           # or into IPW-Demo / SE-Demo
Rscript <name>.R
```

Each script writes its output PDF to a `figures/` subdirectory (or `../figures/` if the figure is referenced from `basics.tex`'s figures path).

## Adding a new figure for the deck

1. Write the generator as a standalone R script in this folder
2. Source `../../../_themes/remix_theme.R` (or `../../../../_themes/...` if in a subfolder)
3. Use `theme_remix()` and the Remix color scales
4. Save with `remix_save("path/to/output.pdf")`
5. Reference the output from `basics.tex` via `\includegraphics{figures/output.pdf}`
6. Add a row to the table above
