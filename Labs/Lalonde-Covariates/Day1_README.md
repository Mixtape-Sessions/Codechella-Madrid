# LaLonde Lab — Day 1, Glasgow Workshop

**Goal:** Take everything from Day 1 — the 2×2, the three regressions, the event study, the pre-trend gut check — and run it on a real dataset by hand.

You'll work with the experimental sample from LaLonde (1986) / Dehejia & Wahba (2002): the National Supported Work Demonstration, a randomized job-training program. Outcome is real earnings (`re`). The "treatment" is randomly assigned access to the program.

Because it's experimental, the average treatment effect is identified by random assignment — which means the DiD should give a number close to the simple difference-in-means. That's the check: do your hand calculations and your regressions agree, and do they line up with what randomization predicts?

**No covariates today.** Covariates come tomorrow (Day 2). For now we test that the 2×2 / three regressions / event study machinery all reproduce the same number on real data.

---

## Data

A single Stata file with the experimental panel:

```
https://raw.github.com/Mixtape-Sessions/Causal-Inference-2/master/Lab/Lalonde/lalonde_exp_panel.dta
```

Variables:

| Variable | Description |
|---|---|
| `id` | Person identifier |
| `year` | 74, 75, 78 |
| `re` | Real earnings (constant dollars) |
| `ever_treated` | 1 if person was in the treatment group, 0 otherwise |

Treatment was assigned in mid-1976, so `74` and `75` are pre-treatment, `78` is post-treatment.

---

## Part 1 — The 2×2, by hand

Use `78` as the post period and `75` as the pre period. Ignore `74` for this part.

1. Compute the **four cell means**: `(treated, pre)`, `(treated, post)`, `(control, pre)`, `(control, post)`. Show your numbers.
2. Compute the **DiD by hand** using the formula `(Y_T_post - Y_T_pre) - (Y_C_post - Y_C_pre)`.
3. Compute the **simple post-period difference-in-means** on the `78` cross-section only. (Since this is experimental, this is also a valid estimator of the ATE.)
4. **Interpret.** Are the two numbers close? Should they be? Why?

**You should see:** DiD ≈ \$1,700 (in 1978 dollars). Sign and magnitude consistent with the simple post-period difference because random assignment makes the two estimators agree in expectation.

---

## Part 2 — The three regressions, all on the same data

Recreate the equivalence demo from Lesson 2. Restrict the sample to `year ∈ {75, 78}` and run all three of these specifications. Each should give you the same coefficient on the treatment-time interaction.

### Regression 1 — OLS with interactions

In Stata:
```stata
gen post = (year == 78)
reg re i.ever_treated##i.post, robust
```

In R:
```r
df$post <- as.integer(df$year == 78)
lm(re ~ ever_treated * post, data = df) |> summary()
```

### Regression 2 — TWFE

```stata
xtreg re c.ever_treated#c.post i.year, fe i(id) vce(robust)
```

```r
fixest::feols(re ~ ever_treated:post | id + year, data = df, vcov = "hetero")
```

### Regression 3 — Long-differences

Reshape wide and regress the change `re_78 - re_75` on `ever_treated`. (See `lalonde-did.R` or `lalonde-did-stata.do` in this folder for the reshape mechanics.)

```r
df_wide <- df |> tidyr::pivot_wider(...)
lm(re_78 - re_75 ~ ever_treated, data = df_wide) |> summary()
```

**Question.** Do all three regressions give the same coefficient on `ever_treated:post` (or its long-differences cousin)? Report the value to two decimal places.

---

## Part 3 — Event study, three years

Now include `74` in the sample. Use `t-1 = 75` as the baseline.

1. Specify an event-study regression with:
   - Unit and year fixed effects
   - Indicators for `ever_treated × year_74` and `ever_treated × year_78`
   - `ever_treated × year_75` is the omitted baseline (β = 0 by construction)

   In R:
   ```r
   fixest::feols(re ~ i(year, ever_treated, ref = 75) | id + year, data = df)
   ```

   In Stata:
   ```stata
   xtreg re i.year##i.ever_treated, fe i(id) vce(robust)
   ```

2. Report the two coefficients (74 and 78) and 95% CIs.

3. **Plot the event study.** Three points: 74, 75 (baseline at 0), 78. Add CI whiskers.

---

## Part 4 — Event study, by hand

Recover the event-study coefficients you got in Part 3 directly from cell means. Each event-study coefficient is a 2×2 DiD with `75` as the baseline.

1. **Coefficient at year 74:**
   $$\hat\beta_{74} = \big[\bar Y^T_{74} - \bar Y^T_{75}\big] - \big[\bar Y^C_{74} - \bar Y^C_{75}\big]$$
   Compute the four cell means and the DiD. Compare to your regression output.

2. **Coefficient at year 78:**
   $$\hat\beta_{78} = \big[\bar Y^T_{78} - \bar Y^T_{75}\big] - \big[\bar Y^C_{78} - \bar Y^C_{75}\big]$$
   Same exercise.

3. **Confirm** that your hand-computed event-study coefficients equal the regression coefficients from Part 3.

---

## Part 5 — Interpret + pre-trend gut check

1. Is the post-period coefficient (`β_{78}`) statistically distinguishable from zero? What does its sign and magnitude say about the NSW program?

2. Is the pre-period coefficient (`β_{74}`) close to zero? **Does the pre-trend gut check pass?**
   - If `β_{74}` is small relative to `β_{78}` and not statistically significant, you have visual evidence that parallel trends is plausible on this design.
   - If `β_{74}` is non-trivial, you'd have to either widen the pre-period or worry about anticipation / differential trends.

3. **The honest question.** This is experimental data — we know random assignment guarantees parallel trends in expectation. If you saw a worrying pre-trend here, what would it tell you? (Hint: about sampling variation, not about the design.)

---

## Deliverable

A short writeup (one or two pages) with:

- The four cell means from Part 1
- The DiD from Part 1 (hand) and the regression coefficient from Part 2 (any of the three regressions)
- The event-study plot from Part 3
- The two hand-computed coefficients from Part 4
- Your interpretation and pre-trend assessment from Part 5

---

## Reference

- LaLonde, Robert (1986). "Evaluating the Econometric Evaluations of Training Programs with Experimental Data." *American Economic Review* 76(4): 604–620.
- Dehejia, Rajeev, and Sadek Wahba (2002). "Propensity Score-Matching Methods for Nonexperimental Causal Studies." *Review of Economics and Statistics* 84(1): 151–161.
- Pre-built scripts in this folder: `lalonde-did.R`, `lalonde-did-stata.do` (covers what we did in CI-2; for Day 1, only use the experimental, no-covariates portions).
