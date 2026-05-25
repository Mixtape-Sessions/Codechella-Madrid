# Triple Differences Lab — Day 2 morning, Glasgow Workshop

**Goal.** Take everything from the triple-diff lecture — eight cells, two DiDs, one subtraction — and run it on the dataset behind the canonical example: Gruber (1994), the same study we opened the lecture with.

You're going to compute the DDD that appears on the right-hand panel of slide 3b. By hand. Then by regression. Then talk about what the placebo demographic actually buys you.

---

## The story (very briefly)

In 1976, three U.S. states — Illinois, New Jersey, New York — passed laws requiring health insurance plans to cover the costs of childbirth on the same terms as other medical conditions. Five demographically similar states did not pass such laws (Ohio, Indiana, Connecticut, Massachusetts, North Carolina).

Standard incidence theory says: if a benefit is **group-specific** (covers only women of childbearing age, but is paid for by the employer's premium pool), the cost should be shifted onto the wages of the group that benefits. So Gruber asked: did wages of married women 20–40 fall in the mandate states, relative to (a) the same women in non-mandate states, and (b) workers in the mandate states who *didn't* benefit from the mandate (older workers and single men 20–40)?

That's a triple-diff:

```
DDD = [DiD on married women 20–40]  −  [DiD on the placebo demographic]
```

Gruber found a DDD of **−0.054 log points** (SE 0.026) — a ~5.4% relative wage fall for the targeted group. Full shifting of the mandate's cost onto the targeted workers' wages.

---

## Data

We give you `gruber1994.dta` (CSV also available) — a teaching extract built from the **real NBER May CPS files** for 1974, 1975, 1977, and 1978. The cleaning replicates Gruber's sample restrictions:

- Age 20–65
- Not self-employed
- Real hourly wage between 1 and 100 dollars (1978 dollars; CPI-deflated)
- Keep treated demographic (married women 20–40) plus placebo demographic (workers over 40, or single males 20–40)
- Keep the 8 states Gruber uses: IL, NJ, NY (treated) and OH, IN, CT, MA, NC (placebo)

After restrictions you have **28,477 worker-year observations**. The 8-cell means in this extract reproduce Gruber's Table 3 to two decimal places. Run the DDD regression on this file and you get **−0.060** (SE 0.026) — within 0.006 of Gruber's published **−0.054**. Pedro Sant'Anna independently validated this dataset and obtained **−0.058** under a slightly tighter sample (never-married singles only); the three implementations in R, Stata, and Python all match to six decimals.

In other words: this is the real CPS data, cleaned exactly the way Gruber cleaned it.

| Variable | Meaning |
|---|---|
| `year` | 1974, 1975, 1977, 1978 |
| `state` | Two-letter state code |
| `state_law` | 1 if state passed a maternity mandate by 1976 (IL/NJ/NY); 0 otherwise |
| `age` | Age in years |
| `married_woman` | 1 if treated demographic (married women 20–40); 0 if placebo (older workers or single males 20–40) |
| `after` | 1 if year ≥ 1977 (after the laws took effect); 0 otherwise |
| `log_wage` | log of hourly wage in constant 1978 dollars — the outcome |

```stata
* Stata
use "data/gruber1994.dta", clear
```

```r
# R
library(haven)
g <- read_dta("data/gruber1994.dta")
```

---

## Part 1 — Compute the DDD by hand

**Step 1.** Compute the **eight cell means** of `log_wage`. Show them in a 2 × 2 × 2 table that looks like Gruber's Table 3.

**Step 2.** Compute the **DiD on married women** (the treated demographic):

```
DiD_treated  =  ( Ȳ_exp,post  −  Ȳ_exp,pre )_married   −   ( Ȳ_non,post  −  Ȳ_non,pre )_married
```

**Step 3.** Compute the **DiD on the placebo demographic** (older + single males 20–40):

```
DiD_placebo  =  ( Ȳ_exp,post  −  Ȳ_exp,pre )_placebo   −   ( Ȳ_non,post  −  Ȳ_non,pre )_placebo
```

**Step 4.** Compute the **DDD**:

```
δ_DDD  =  DiD_treated  −  DiD_placebo
```

You should land near **−0.060**. If your number is off by more than 0.005, you computed a cell mean wrong — go back and check.

---

## Part 2 — Run the DDD as a regression

Recover the same number using a saturated triple-interaction regression.

### Stata
```stata
use "data/gruber1994.dta", clear

* All eight cells are in the data; the three-way interaction picks out the DDD.
reg log_wage state_law##married_woman##after, robust

* The coefficient on 1.state_law#1.married_woman#1.after is your DDD.
```

### R
```r
library(haven)
library(estimatr)

g <- read_dta("data/gruber1994.dta")

ddd_fit <- lm_robust(
  log_wage ~ state_law * married_woman * after,
  data = g
)
summary(ddd_fit)

# The coefficient on state_law:married_woman:after is your DDD.
```

The coefficient on the three-way interaction is `δ_DDD`. Report it with its standard error.

---

## Part 3 — Compare

1. **Match.** Does the regression coefficient on the three-way interaction equal your hand-computed DDD from Part 1? It should — to machine precision.

2. **Standard error.** Report the heteroskedasticity-robust SE. You should land near **0.026** — Gruber's published SE.

3. **Compare the DDD to the two biased DiDs.** Each of the following is *biased* for the ATT:

   - **DiD using only married women, comparing experimental vs. non-experimental states** (no demographic placebo): this conflates the ATT with any differential wage trend between the two state groups affecting *all* workers.
   - **DiD using only experimental states, comparing married women vs. older/single workers** (no non-experimental state comparison): this conflates the ATT with any differential trend between the two demographic groups affecting *all* states.

   Run both biased DiDs and report each estimate. Which one is closer to the DDD? What does that tell you about which threat to identification — differential state trends or differential demographic trends — was bigger here?

4. **Interpret.** In your own words: what does the DDD say? Did employers shift the cost of mandated maternity coverage onto the wages of the workers who benefited from it?

---

## Part 4 — The parallel-bias assumption

The point of the placebo demographic is **not** to assume they're a clean counterfactual. It's that whatever *bias* contaminates the DiD on married women — the differential state-level wage trend between experimental and non-experimental states — should also contaminate the DiD on the placebo group. If it does, subtracting one from the other cancels the bias.

Write a short paragraph (3–5 sentences) addressing:

- What would make the DDD identification fail? (Hint: think about what would have to be true of the *placebo* group's counterfactual trend.)
- If a recession in 1977 hit Illinois manufacturing harder than Ohio's, does the DDD survive? Why or why not?
- If maternity-mandate states differentially raised the minimum wage in 1977 (affecting low-wage workers across all demographics), does the DDD survive?

---

## Deliverable

A short writeup (1–2 pages, PDF or markdown):

- The 8-cell table (means of `log_wage`).
- Your hand-computed DiD-treated, DiD-placebo, and DDD.
- Your regression output with the robust SE.
- A two-row comparison showing the regression DDD equals the hand DDD.
- A paragraph interpreting the DDD.
- A paragraph on the parallel-bias assumption.

---

## Reproducibility

The script that built this dataset is `code/build_gruber_extract.R`. It reads from a fully-cleaned NBER May CPS panel (1974, 1975, 1977, 1978) prepared in January 2026 in collaboration with Pedro Sant'Anna, applies Gruber's sample restrictions, and writes the teaching extract. Run `Rscript build_gruber_extract.R` from the `code/` directory to rebuild. The upstream cleaning pipeline (NBER CPS → cleaned panel) lives in the `Claude_DDD` project; ask Scott if you want it.

---

## References

- Gruber, Jonathan (1994). "The Incidence of Mandated Maternity Benefits." *American Economic Review* 84(3): 622–641. Table 3, page 632.
- Olden, Andreas, and Jarle Møen (2022). "The Triple Difference Estimator." *The Econometrics Journal* 25(3): 531–553. (The formal parallel-bias result.)
- Cunningham, *Causal Inference: The Mixtape*, Chapter 9, Triple Differences section.
