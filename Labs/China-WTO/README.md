# China–WTO lab: continuous DiD on Lu & Yu (2015)

Companion lab to the **continuous DiD deck** (Day 3). Replicates the TWFE decomposition and the three ATT(d|d) estimation options — linear, spline, bins — on Lu & Yu's (2015) Chinese-industry tariff data.

## What you'll do

1. **2×2 setup.** Collapse `industry_by_year.dta` to one observation per `sic3` industry. Construct the dose as `pmax(tariff_2001 - 0.10, 0)` — the bite of the 2001 pre-WTO tariff above a 10% threshold. Outcome is $\Delta \ln(\text{Theil}) = \ln Y_{2004} - \ln Y_{2001}$.

2. **Demean by the no-dose group.** Subtract $E[\Delta Y \mid D = 0]$ from every $\Delta Y$ so the regressions estimate ATT(d|d) under standard PT.

3. **Three estimators for ATT(d|d):**
   - **Linear** in dose
   - **B-spline** in dose
   - **Bins**: $D<0.1$, $0.1 \le D<0.2$, $D \ge 0.2$

4. **Pre-trends test.** Repeat the 2×2 with 1998 vs 2001 (both pre-WTO). The dose-response curve should be flat near zero.

5. **Event study (R only).** Loop over years 1998–2005 with 2001 as reference. One series per dose bin.

## Files

| File | What it does |
|---|---|
| `wto_example.R` | R version with `fixest`, splines, event study |
| `wto_example.do` | Stata version (no event study yet) |
| `data/industry_by_year.csv` | Cleaned panel, 155 industries × 9 years |
| `data/industry_by_year.dta` | Stata version of same |
| `data/AEJ_ind_DID_3-digit.dta` | Original Lu & Yu replication file |
| `data/clean_data.R` | How the cleaned panel was built |

## Setup

### R

```r
# Required packages
install.packages(c("tidyverse", "fixest", "splines", "broom"))
# Kyle's helpers (used for plotting palette)
# install via devtools if you don't have it:
# install.packages("devtools")
devtools::install_github("kylebutts/kfbmisc")
```

Run `wto_example.R` from this folder (set working directory to `glasgow/labs/China-WTO/`).

### Stata

Requires Stata 15+ (for `makespline`). Set working directory at the top of `wto_example.do`:

```stata
cd "<path-to-the-remix-tour>/glasgow/labs/China-WTO/"
```

## Connections to the deck

| Lab block | Deck slide |
|---|---|
| 2×2 setup with `pmax(tariff - 0.10, 0)` | "Lu & Yu (2015) reported $\hat\beta^{twfe} = -0.322$" |
| Three estimators on the same plot | "Option 1: Overall ATT", "Option 2: Bins", "Option 3: Non-parametric smoothing" |
| Pre-trends 1998 vs 2001 | "Pre-trends, dose by dose" |
| Event study by dose bin | Companion to "The WTO example, done properly" |

## Source

Code adapted from Kyle Butts' continuous-DiD example. The `contdid` R package itself is by Brantly Callaway.
