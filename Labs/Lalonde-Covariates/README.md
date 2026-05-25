# LaLonde with Covariates Lab — Day 2 afternoon, Glasgow Workshop

**Goal:** Take the four covariate-aware estimators from this morning — **TWFE-with-X**, **OR**, **IPW**, **DR-DiD** — and run them against a known benchmark on the LaLonde data.

The benchmark comes from the experimental sample: random assignment identifies the ATT, and you'll compute it first as the *truth* (≈ \$1,700 in 1978 dollars). Then we switch to a non-experimental sample built by replacing the experimental control group with a random sample of American households (CPS), where selection into the program is sharply negative — people who self-select into NSW had worse pre-program earnings than the CPS pool. Plain DiD on this sample gives the wrong sign. Your job is to find out which of the four covariate-aware estimators rescues the answer, and how close each gets to \$1,700.

This is the same exercise LaLonde (1986) ran — and the same exercise Dehejia & Wahba (2002) ran 16 years later with propensity-score methods. The point isn't that one estimator wins. The point is to see what each assumption *buys* you.

---

## Data

Two Stata panels on the Mixtape-Sessions GitHub. Same person-id structure as Day 1, but now with covariates.

**Experimental panel (the benchmark):**
```
https://raw.github.com/Mixtape-Sessions/Causal-Inference-2/master/Lab/Lalonde/lalonde_exp_panel.dta
```

**Non-experimental panel (NSW treated + CPS controls):**
```
https://raw.github.com/Mixtape-Sessions/Causal-Inference-2/master/Lab/Lalonde/lalonde_nonexp_panel.dta
```

In R:
```r
library(haven)
exp_panel    <- read_dta("https://raw.github.com/Mixtape-Sessions/Causal-Inference-2/master/Lab/Lalonde/lalonde_exp_panel.dta")
nonexp_panel <- read_dta("https://raw.github.com/Mixtape-Sessions/Causal-Inference-2/master/Lab/Lalonde/lalonde_nonexp_panel.dta")
```

In Stata:
```stata
use "https://raw.github.com/Mixtape-Sessions/Causal-Inference-2/master/Lab/Lalonde/lalonde_nonexp_panel.dta", clear
```

Variables (same in both panels):

| Variable | Description |
|---|---|
| `id` | Person identifier |
| `year` | 74, 75, 78 |
| `re` | Real earnings |
| `ever_treated` | 1 if ever in NSW treatment group, 0 otherwise |
| `age, agesq, agecube` | Age and polynomials |
| `educ, educsq` | Years of schooling and its square |
| `marr` | Married indicator |
| `nodegree` | No high-school diploma indicator |
| `black, hisp` | Race indicators |
| `re74, re75` | Pre-program earnings (74 and 75) |
| `u74, u75` | Unemployed in 74 / 75 indicators |

---

## Part 0 — Benchmark: the experimental ATT (the truth)

Use the **experimental** panel. This is what Day 1 produced. Re-do it as your benchmark.

1. Compute the **post-period difference in means** on `78` only:
   $$\widehat{\text{ATT}}^{\text{RCT}} \;=\; \bar Y^{\text{T}}_{78} - \bar Y^{\text{C}}_{78}.$$

2. Compute the **DiD** with `78` as post, `75` as pre.

3. **You should see roughly \$1,700.** This is the truth. Write it down. Mark it. Hold it.

The remaining parts try to recover this number using a non-experimental control group, where simple comparisons are biased.

---

## Part 1 — Selection bias preview

Switch to the **non-experimental** panel.

1. Compute the **post-period difference in means** on `78` only.
2. Compute the **DiD** with `78` as post, `75` as pre.
3. **Compare to \$1,700.** What sign do you get? What's the magnitude?

You should see a **negative** point estimate. That's selection: NSW participants had worse pre-program earnings than randomly sampled American households. Naive comparison attributes that *level* difference to the program.

The next four parts try to fix it.

---

## Part 2 — TWFE with covariates (interact Post × X)

The cheap fix: throw the covariates into the TWFE regression with a `post`-interaction so the covariates can have different effects pre and post.

### R
```r
library(fixest)
library(dplyr)

df <- nonexp_panel |>
  filter(year %in% c(75, 78)) |>
  mutate(post = as.integer(year == 78))

X <- c("age", "agesq", "educ", "educsq", "marr", "nodegree",
       "black", "hisp", "re74", "u74")

fml <- as.formula(paste(
  "re ~ ever_treated:post + ",
  paste(paste0(X, ":post"), collapse = " + "),
  "| id + year"
))

twfe_x <- feols(fml, data = df, vcov = "hetero")
summary(twfe_x)
```

### Stata
```stata
keep if inlist(year, 75, 78)
gen post = (year == 78)
local X age agesq educ educsq marr nodegree black hisp re74 u74

foreach v of local X {
    gen `v'_post = `v' * post
}

reghdfe re c.ever_treated#c.post `=subinstr("`X'", " ", "_post ", .)'_post, ///
        absorb(id year) vce(robust)
```

The `ever_treated × post` coefficient is your TWFE-with-X ATT estimate.

**Note:** without the `post`-interaction (i.e., a single $\theta X$ entering linearly), the FE transformation sweeps out the time-invariant components of $X$ and the estimate is *unchanged* from plain TWFE. The Post × X interactions are how covariates do anything in a panel regression.

---

## Part 3 — Outcome regression (Heckman, Ichimura & Todd 1997)

Model the **change in $Y$** on $X$ **using the control group only**, then use that model to impute the counterfactual change for the treated.

### R
```r
library(dplyr)
library(tidyr)

wide <- nonexp_panel |>
  filter(year %in% c(75, 78)) |>
  pivot_wider(
    id_cols = c(id, ever_treated, age, agesq, educ, educsq,
                marr, nodegree, black, hisp, re74, u74),
    names_from = year, values_from = re, names_prefix = "re"
  ) |>
  mutate(dY = re78 - re75)

# Fit on controls only
or_model <- lm(dY ~ age + agesq + educ + educsq + marr +
                    nodegree + black + hisp + re74 + u74,
               data = filter(wide, ever_treated == 0))

# Predict counterfactual ΔY for treated; ATT_OR = mean of (ΔY - prediction) for treated
treated <- filter(wide, ever_treated == 1)
treated$mu0_hat <- predict(or_model, newdata = treated)
att_or <- mean(treated$dY - treated$mu0_hat)
att_or
```

### Stata
```stata
use ..., clear
keep if inlist(year, 75, 78)
reshape wide re, i(id) j(year)
gen dY = re78 - re75

reg dY age agesq educ educsq marr nodegree black hisp re74 u74 ///
    if ever_treated == 0
predict mu0_hat, xb
gen orgap = dY - mu0_hat
sum orgap if ever_treated == 1   // <- this mean is your OR-DiD ATT
```

---

## Part 4 — IPW (Abadie 2005)

Estimate a propensity score $\widehat p(X) = \Pr(D{=}1 \mid X)$ using logit. Weight control changes by $\widehat p(X) / (1 - \widehat p(X))$, then take a weighted DiD.

### R
```r
ps_model <- glm(ever_treated ~ age + agesq + educ + educsq + marr +
                              nodegree + black + hisp + re74 + u74,
                data = wide, family = binomial())
wide$p_hat <- predict(ps_model, type = "response")
wide$w <- ifelse(wide$ever_treated == 1, 1, wide$p_hat / (1 - wide$p_hat))

# Abadie (2005) IPW-DiD
att_ipw <- with(wide,
  mean(dY[ever_treated == 1]) -
  weighted.mean(dY[ever_treated == 0], w = w[ever_treated == 0])
)
att_ipw
```

### Stata
```stata
logit ever_treated age agesq educ educsq marr nodegree ///
                   black hisp re74 u74
predict p_hat, pr
gen w = cond(ever_treated == 1, 1, p_hat / (1 - p_hat))

sum dY if ever_treated == 1
local mean_T = r(mean)

sum dY [aw=w] if ever_treated == 0
local mean_C = r(mean)

di "ATT_IPW = " %9.2f `mean_T' - `mean_C'
```

---

## Part 5 — Doubly-robust DiD (Sant'Anna & Zhao 2020)

Use `DRDID` (Stata) or the `DRDID` R package. DR combines OR and IPW: if either the outcome model or the propensity score is correctly specified, the estimator is consistent.

### R
```r
library(DRDID)

# DRDID expects long-form panel; nonexp_panel is already long
drdid_fit <- drdid(
  yname = "re",
  tname = "year",
  idname = "id",
  dname = "ever_treated",
  xformla = ~ age + agesq + educ + educsq + marr + nodegree +
              black + hisp + re74 + u74,
  data = nonexp_panel |> filter(year %in% c(75, 78)),
  panel = TRUE,
  estMethod = "imp"   # improved DR estimator
)
summary(drdid_fit)
```

### Stata
```stata
ssc install drdid, replace

use "https://raw.github.com/Mixtape-Sessions/Causal-Inference-2/master/Lab/Lalonde/lalonde_nonexp_panel.dta", clear
keep if inlist(year, 75, 78)

drdid re age agesq educ educsq marr nodegree black hisp re74 u74, ///
      ivar(id) time(year) tr(ever_treated) all
```

The `all` option reports OR, IPW, and DR side-by-side — useful for the comparison in Part 6.

---

## Part 6 — Compare and interpret

Build a small table:

| Estimator | ATT | SE | Distance from \$1,700 |
|---|---|---|---|
| Naive DiD (Part 1) |   |   |   |
| TWFE with Post × X (Part 2) |   |   |   |
| OR (Part 3) |   |   |   |
| IPW (Part 4) |   |   |   |
| DR (Part 5) |   |   |   |
| **RCT benchmark (Part 0)** | **≈ \$1,700** | — | 0 |

### Questions

1. **Direction.** Which estimators move the ATT in the right direction? Which don't?

2. **Magnitude.** Of those that move it right, which get closest to \$1,700? Within \$200? Within \$500?

3. **TWFE with Post × X.** If you ran TWFE-with-X *without* the Post × X interactions (i.e., one $\theta$ for each covariate, no time interaction), what would happen — and why?

4. **OR vs IPW.** OR depends on $\widehat\mu_0(X)$ being correctly specified. IPW depends on $\widehat p(X)$ being correctly specified. When are these the same? When are they different? On this dataset, which assumption do you find more credible — and why?

5. **DR.** Doubly-robust says: if *either* of the two models is correctly specified, DR is consistent. Why doesn't that mean DR is always closer to the RCT benchmark than OR or IPW alone?

6. **Overlap.** Look at the distribution of $\widehat p(X)$ for treated vs. controls. Is there a region of $X$ where the propensity score is near 0 or 1? What does that imply for IPW and DR? (Hint: this is the "overlap violation" Sant'Anna-Zhao 2024 talk about.)

7. **The honest question.** Even the best of these estimators may not exactly reproduce \$1,700. What does that gap mean? Is it sampling variation? Misspecification? Hidden confounding the controls don't capture?

---

## Deliverable

A short writeup (one or two pages):

- The 6-row comparison table from Part 6.
- The propensity score overlap plot (histogram of $\widehat p(X)$ for $D{=}1$ vs. $D{=}0$).
- Your answers to questions 1–7.
- One paragraph: what does the LaLonde lab teach you about the *generalizability* of any of these estimators?

---

## References

- LaLonde, Robert (1986). "Evaluating the Econometric Evaluations of Training Programs with Experimental Data." *American Economic Review* 76(4): 604–620.
- Dehejia, Rajeev, and Sadek Wahba (2002). "Propensity Score-Matching Methods for Nonexperimental Causal Studies." *Review of Economics and Statistics* 84(1): 151–161.
- Heckman, J., H. Ichimura, and P. Todd (1997). "Matching as an Econometric Evaluation Estimator." *Review of Economic Studies* 64(4): 605–654.
- Abadie, Alberto (2005). "Semiparametric Difference-in-Differences Estimators." *Review of Economic Studies* 72(1): 1–19.
- Sant'Anna, P., and J. Zhao (2020). "Doubly Robust Difference-in-Differences Estimators." *Journal of Econometrics* 219(1): 101–122.
- Pre-built scripts in `Causal-Inference-2/Lab/Lalonde/`: `covariates.R`, `covariates.do`, `lalonde_covariates.do`.
