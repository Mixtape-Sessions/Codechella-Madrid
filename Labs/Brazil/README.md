# Brazil Mental-Health Reform Lab — Day 3 morning, Glasgow Workshop

**The paper.** Dias, Mateus, and Luiz Felipe Fontes (2024). "The Effects of a Large-Scale Mental Health Reform: Evidence from Brazil." *AEJ: Economic Policy* 16(3): 257–289. [DOI: 10.1257/pol.20220246](https://doi.org/10.1257/pol.20220246).

The intervention is the rollout of CAPS (*Centros de Atenção Psicossocial*) — community mental-health centers — across Brazilian municipalities, staggered from 2002 through 2016. The outcome you'll work with is the homicide rate (`sim_agressao`).

This lab walks you through a complete eight-step DiD workflow on the actual data Dias & Fontes use. The point is not to replicate their paper — it's to do the workflow yourself, step by step, using everything from this morning's lecture.

---

## The data

The cleaned dataset is on Scott's GitHub at `mixtape/brazil.dta`. Both the Stata and the R script pull it directly via URL — no separate download needed.

```stata
use "https://github.com/scunning1975/mixtape/raw/master/brazil.dta", clear
```

```r
library(haven)
br <- read_dta("https://github.com/scunning1975/mixtape/raw/master/brazil.dta")
```

Key variables:

| Variable | Meaning |
|---|---|
| `cod` | Municipality identifier |
| `ano` | Year |
| `ca` | 1 if CAPS center is operating in the municipality-year |
| `sim_agressao` | Homicide rate (the outcome) |
| `popruraltrend` | Rural population trend (used to derive `rural` covariate) |

Treatment timing variable `g` is constructed in the script as the first year `ca == 1` for each municipality (0 if never treated).

---

## The eight-step checklist

This is the same workflow we used in lecture. You'll execute every step on Brazil data.

### Step 1 — Decide on the target parameter

Before touching a regression: what causal parameter do you want? Write down the candidates (simple ATT, group ATT, event-time profile, calendar-time profile). For each, write one sentence on what economic question it answers. Pick one and defend it in 2–3 sentences.

### Step 2 — Make a table of when units are treated

Count municipalities by treatment cohort `g`. Report counts and shares. Identify the never-treated and always-treated cohorts. Explain what you do with each — and why. The 2002 cohort is special: it was "treated" before the panel starts, so it's effectively always-treated. Drop it from the analysis sample and explain why.

### Step 3 — Plot the treatment rollout

Produce a calendar grid (municipalities × years) shaded by treatment status. The point is to see the staggering. The script does this in grayscale.

### Step 4 — Plot the raw outcome by cohort

Plot mean `sim_agressao` over time, one line per treatment cohort. Look at it before you run anything. Are pre-trends visibly parallel? Are there cohorts that look like outliers? Document what you see.

### Step 5 — Covariate balance table

Pick the covariates you'll use (start with `rural` — others may be appropriate). Build a normalized-differences table at the 2002 baseline, treated cohorts vs. never-treated, dropping the 2002 always-treated cohort. Flag any covariate with normalized difference above 0.25.

### Step 6 — Run TWFE first, as a diagnostic

Run the static TWFE regression of `homicide_rate` on `treat` with municipality and year fixed effects. Report the coefficient. Run the dynamic event-study version. Save the plot. **Do not interpret causally yet.** This is the baseline you'll compare to the design-based estimator.

### Step 7 — Run the Bacon decomposition (or twowayfeweights)

Run `ddtiming` (Stata) or `bacondecomp` (R). What share of the TWFE coefficient is coming from forbidden 2×2s? Run `twowayfeweights` for the dCdH diagnostic. What share of unit-period effects gets negative weight? Report both.

### Step 8 — Estimate with Callaway-Sant'Anna

Run `csdid` (Stata) or the `did` R package with DR-DiD. Report:
- The simple ATT.
- The group-specific ATT(g) for each cohort.
- The event-time profile (a plot, with uniform confidence bands).

Compare to the TWFE headline from Step 6. Do they agree? If not, which one would you report?

### Step 9 — Honest DiD sensitivity (Rambachan-Roth)

Take your CS event-study from Step 8 and run `honestdid`. Report:
- The relative-magnitudes ($\bar M$) bounds for $\bar M \in \{0.5, 1, 2\}$.
- The breakdown value: how large does $\bar M$ have to be before zero enters your confidence set?

Interpret. If the breakdown value is large, your result is robust. If small, your result depends sensitively on PT.

---

## The reference scripts

Both files live in `code/`:

- `code/brazil.do` — full Stata workflow (Scott's worked example, 741 lines)
- `code/brazil.R` — full R workflow (parallel, 761 lines)

These are the **gold-standard answer key**. Don't paste from them — work through the steps yourself, then compare to the reference.

---

## Deliverable

A 2–3 page writeup with:

1. **Step 1.** Your target parameter + 2–3 sentence defense.
2. **Step 2.** Cohort table.
3. **Step 3.** Rollout plot.
4. **Step 4.** Raw-outcome plot + observations.
5. **Step 5.** Balance table.
6. **Step 6.** TWFE event-study plot.
7. **Step 7.** Bacon + dCdH diagnostics. Two-row summary: share of forbidden 2×2 weight; share of negative weights.
8. **Step 8.** CS results: simple ATT, group ATT, event-time plot.
9. **Step 9.** Honest DiD sensitivity bounds + breakdown value.
10. **One paragraph.** What do you conclude about the effect of CAPS on homicides? What assumption is doing the most work? Where would you push back if you were Referee 2?

---

## References

- Dias, Mateus, and Luiz Felipe Fontes (2024). "The Effects of a Large-Scale Mental Health Reform: Evidence from Brazil." *AEJ: Economic Policy* 16(3): 257–289.
- Goodman-Bacon, A. (2021). "Difference-in-differences with variation in treatment timing." *Journal of Econometrics* 225(2): 254–277.
- Callaway, B., and P. Sant'Anna (2021). "Difference-in-differences with multiple time periods." *Journal of Econometrics* 225(2): 200–230.
- Rambachan, A., and J. Roth (2023). "A More Credible Approach to Parallel Trends." *Review of Economic Studies* 90(5): 2555–2591.
- Baker, Callaway, Cunningham, Goodman-Bacon, Sant'Anna (2025). "Difference-in-Differences Designs: A Practitioner's Guide." arXiv:2503.13323.
