# HIT (1997) vs. Abadie (2005): What's the Same, What's Different, When to Use Which

**Papers compared:**
- [Heckman, Ichimura & Todd (1997)](Heckman-Ichimura-Todd-1997-synthesis.md), "Matching as an Econometric Evaluation Estimator," *Review of Economic Studies* 64(4): 605–654.
- [Abadie (2005)](Abadie-2005-synthesis.md), "Semiparametric Difference-in-Differences Estimators," *Review of Economic Studies* 72(1): 1–19.

Both papers live in the **conditional difference-in-differences** family — they were published 8 years apart in the same journal, and Abadie cites HIT throughout. But they answer different questions for different audiences. This note pulls them side by side.

---

## 1. The core idea both papers share

Both papers identify the **same causal parameter** (the ATT in a post-treatment period) under the **same fundamental identifying assumption**: conditional parallel trends.

In HIT's notation:
```
A-5:  E(Y_{0t} − Y_{0t'} | X, D=1) = E(Y_{0t} − Y_{0t'} | X, D=0)
```

In Abadie's notation:
```
3.1:  E[Y⁰(1) − Y⁰(0) | X, D=1] = E[Y⁰(1) − Y⁰(0) | X, D=0]
```

**These are the same assumption.** The untreated potential outcome's time change is mean-independent of treatment status, conditional on X. Both papers require an **overlap / common-support** condition (HIT's A-2; Abadie's 3.2).

Both papers also share the same **intellectual backdrop:**
- They are responses to the LaLonde (1986) critique of nonexperimental program evaluation.
- They both build directly on Rosenbaum-Rubin (1983) propensity-score theory.
- They both target the ATT (`M(S)` in HIT; `E[Y¹(1) − Y⁰(1) | D=1]` in Abadie) — not the ATE.
- They both treat heterogeneous treatment effects as a first-class object.
- Both motivate themselves with Ashenfelter's-dip selection (training participants experience transitory pre-treatment earnings drops).

In a sentence: **HIT proved that conditional DiD is the right identifying assumption for job training evaluation; Abadie built a cleaner estimator for that same assumption.**

---

## 2. The structural differences

Despite sharing identification, the two papers are very different in *kind*. The contrast matters when deciding which to cite, teach, or use.

| Dimension | HIT (1997) | Abadie (2005) |
|---|---|---|
| **Paper type** | Applied + methodological hybrid. Builds theory in service of an empirical question. | Pure methods. No empirical application or simulation. |
| **Empirical content** | Massive: 8 tables, 2 figures, 4 sites, 4 demographic groups, 4 comparison groups, 7 estimators × 4 conditioning sets. | None. |
| **Central question** | *When can matching replicate a randomized experiment?* | *How do we estimate the ATT cleanly under conditional parallel trends?* |
| **Estimator** | Matching with kernel / local-linear weights on the propensity score; conditional DiD as a special case. | Two-step propensity-score-weighted least squares. One regression after a logit/probit. |
| **What you have to compute nonparametrically** | Four conditional means: `E(Y_{dt}|X,D=d)` for d, t ∈ {0,1}. | One — the propensity score. The reweighting collapses the four-mean problem to a single weighted regression. |
| **Inference** | Bootstrap (50 replications, 100% resampling). | Analytic sandwich SEs with influence-function correction for first-step uncertainty. Root-n asymptotic normality (Theorems 4.1–4.4). |
| **Data structure** | Panel (36-month JTPA panel). | Either panel **or repeated cross-sections** (Proposition 3.2). Latter is the more useful contribution for applied work. |
| **Treatment level** | Binary. | Binary OR **multilevel/dose-response** (Section 3 extension). |
| **Heterogeneous effects** | Reports M(S) over subsets of support; tables tabulate by demographic group separately. | Parameterizes the conditional ATT as `g(X_k; θ)` (typically linear) and recovers θ from one WLS regression. Heterogeneity is built into the estimator. |
| **Testing the assumption** | Formally tests A-5 (and A-3, A-4, A-5') against the experimental benchmark. Provides nonparametric χ² tests with local linear regression. **Reports actual p-values.** | Does not test the assumption — assumes it. No empirical evidence about when it holds. |
| **Bias accounting** | Decomposes B into B₁ (non-overlap) + B₂ (density-weighting) + B₃ (selection on unobservables). Shows B₁ + B₂ dominate; B₃ ≈ 0 for well-chosen comparison groups. | Does not decompose bias. The propensity-score weighting handles B₁/B₂ implicitly (by reweighting on overlap); B₃ is what conditional parallel trends rules out by assumption. |
| **Common support** | Operational trimming rule (Appendix C): drop observations below density threshold `c_q`, with q = 2% (adults) or 5% (youth). Visualized in Figure 1. | Treated as a regularity condition (Assumption 3.2). No operational trimming rule given. |
| **Practical packaging** | A workflow: estimate P(X), trim, run kernel/local-linear matching, optionally DiD. Multiple knobs. | A single regression. Minimal knobs after the propensity-score model is chosen. |
| **Audience** | Labor economists + applied econometricians + propensity-score practitioners. | Theoretical econometricians + methodologists writing follow-on papers. |
| **Citation pattern (downstream)** | Cited in every empirical paper using matching with DiD; the *empirical* benchmark for evaluating matching. | Cited as the *methodological* foundation for IPW DiD; the starting point for Sant'Anna-Zhao (2020), Callaway-Sant'Anna (2021), and the doubly-robust DiD literature. |

A useful way to remember the contrast:

> **HIT is the paper that proved the assumption.** It exhausted the data showing that conditional DiD survives testing where conventional matching fails, and that data quality (location + survey instrument) matters more than econometric sophistication. The estimator is incidental to the empirical finding.
>
> **Abadie is the paper that simplified the estimator.** It took the same identifying assumption and turned it into a propensity-score-weighted WLS regression with closed-form standard errors. The empirical application is incidental to the methodological cleanness.

---

## 3. Where their answers actually differ

A few specific differences worth understanding:

**(a) Number of nuisance functions.** HIT-style conditional DiD (using local linear matching on pre-/post-differences) requires nonparametrically estimating four conditional means — `E(Y_{dt} | X, D=d)` for d, t ∈ {0,1}. Abadie's reformulation collapses this to **one** nuisance function, the propensity score. Algebraically this works because of Lemma 3.1's reweighting identity: `E[Y¹(1) − Y⁰(1) | X, D=1] = E[ρ₀·(Y(1) − Y(0)) | X]`, where `ρ₀` depends only on the propensity score. Practically, this means Abadie's estimator is **less prone to the curse of dimensionality** in the conditional-expectation step.

**(b) Inference machinery.** HIT relies on the bootstrap. Abadie derives **analytic sandwich standard errors with an explicit first-step correction** (the `M_{γ₀}·ψ_{γ₀}` term). The HIT bootstrap is robust but expensive and offers less insight into where the variance comes from. Abadie's analytic SEs make clear that ignoring first-step estimation error in the propensity score leads to invalid inference — a fact often missed by practitioners using "off the shelf" IPW DiD.

**(c) Repeated cross-sections.** This is **the most consequential applied difference.** HIT requires panel data (matching pre-/post-differences within individuals). Abadie's Proposition 3.2 and the "double weight" `φ₀` extend the same identification result to **repeated cross-sections** — CPS-style data where different individuals are sampled in each period. Almost every modern DiD application uses repeated cross-sections. Without Abadie, conditional DiD would be a panel-only method.

**(d) Heterogeneity treatment.** HIT reports separate ATT estimates by demographic group (adult males, adult females, male youth, female youth) and bias decompositions within each group. Heterogeneity is "by hand." Abadie treats heterogeneity as a **first-class parameter**: the conditional ATT function `E[Y¹(1) − Y⁰(1) | X_k, D=1]` is projected onto a linear (or other) approximating class, and the WLS regression returns coefficients that summarize how the ATT varies with covariates X_k. This is much closer to how applied researchers actually want to report results ("the effect is X for women and Y for men, controlling for Z").

**(e) Multilevel treatments.** HIT is binary (training / no training). Abadie's framework extends naturally to **continuous or multi-valued treatments** — weeks of training, dollars of subsidy. This is a strict expansion of what conditional DiD can target.

**(f) Where conditional DiD breaks.** HIT's empirical findings expose a specific failure mode of A-5: **geographic mismatch.** When treated and control groups are from different labour markets (SIPP comparison, site-mismatch experiment), A-5 fails — pre-treatment trends differ across cities even after conditioning on X. Abadie does not address this — under his framework you would simply note that "X" must include whatever drives the heterogeneous trends, and if it doesn't, the assumption fails. HIT teaches you *what features of the data* (same labour market, same survey instrument) matter; Abadie tells you *what to do* once you have the right data.

---

## 4. Why should you care about the difference?

Three reasons:

**(i) Inference.** If you're running conditional DiD on a CPS-style repeated cross-section, you should be using Abadie's estimator, not HIT-style matching. The repeated-cross-section extension is the single most important practical difference. HIT cannot be applied directly to repeated cross-sections without further machinery.

**(ii) Reporting heterogeneity.** If your audience wants to see how the effect varies with covariates — and they almost always do — Abadie's projection onto `g(X_k; θ)` gives you a clean way to report this. HIT's group-by-group tables are valid but less compact, and the standard errors are harder to interpret across groups.

**(iii) Evidence about the assumption.** HIT is the only paper that gives you **direct empirical evidence about when conditional parallel trends holds**. It holds in the JTPA setting *only when* the comparison group is from the same labour market with the same questionnaire. It fails when those features differ. Abadie assumes the assumption and gives you a clean estimator; HIT tells you whether to believe the assumption in the first place.

If you only read one for *methodology*, read Abadie.
If you only read one for *evidence about when the methodology works*, read HIT.
You almost certainly need both.

---

## 5. When to use which

A simple decision tree:

**Use the Abadie (2005) estimator when:**
- You have **repeated cross-sections** (CPS, household surveys, county-year panels with shifting sample frames).
- You want **closed-form inference** that accounts for first-step propensity-score estimation.
- You want to **estimate heterogeneous treatment effects** as functions of covariates in a single regression.
- You have **continuous or multilevel treatments** (different doses).
- You are writing a methods paper or extending the framework (the algebra is cleaner).
- You want to use one of the **modern DiD packages** (Callaway-Sant'Anna 2021's `did` in R; Sant'Anna-Zhao 2020's `DRDID`) — these descend directly from Abadie's formulation.

**Use HIT (1997)'s matching-with-DiD workflow when:**
- You have **rich panel data** with multiple pre-treatment outcome periods (so DiD can be combined with matching on pre-trends).
- You're working with a **small-to-medium sample** where local-linear nonparametric estimation is feasible and you don't want to commit to a parametric propensity-score functional form.
- You want to **visualize and diagnose common support** before committing to a method (HIT's Figure 1 + Appendix C trimming rules).
- You want to **decompose bias** into B₁ (support) + B₂ (density-weighting) + B₃ (selection) for your audience.
- You're explicitly comparing **multiple matching estimators** (Section 11 and Tables 5(a)-(b) of HIT give you the framework).

**Use both papers together when:**
- You are *evaluating the assumption* — HIT tells you what to check in the data (same location, same survey, pre-trends comparable) before committing to conditional DiD. Then Abadie gives you the estimator.
- You are *teaching* conditional DiD — HIT motivates *why* the assumption is reasonable and what fails when it fails; Abadie shows you the cleanest way to estimate under the assumption.
- You are *writing an empirical paper* that uses conditional DiD — cite HIT for the identifying assumption and the empirical case that it can hold; cite Abadie for the estimator and inference.

A practical workflow:

1. **Diagnostics (HIT):** Estimate propensity scores; visualize overlap (HIT Figure 1); trim by density (HIT Appendix C); compare pre-treatment trends across treated and control groups.
2. **Choice (HIT-style reasoning):** Is your comparison group from the same labour market and the same survey instrument? If not, A-5 is in trouble even before you start.
3. **Estimation (Abadie):** Estimate the propensity score by logit/probit on X. Construct the weight `ρ₀` (panel) or `φ₀` (repeated cross-sections). Run propensity-score-weighted WLS of `ρ₀·ΔY` (or `φ₀·Y`) on `X_k`.
4. **Inference (Abadie):** Use sandwich SEs with the `M_{γ₀}·ψ_{γ₀}` first-step correction. Don't pretend the propensity score is known.
5. **Heterogeneity (Abadie):** Report θ̂ as the heterogeneous-ATT projection coefficients.
6. **Robustness (HIT-style):** Re-do the analysis with coarser propensity-score specifications (HIT Tables 6(a)-(b) style) to check sensitivity to the conditioning set.

---

## 6. One-paragraph elevator summary

> Both papers identify the ATT under conditional parallel trends — the assumption that, after conditioning on X, the untreated potential outcome would have followed the same time path for treated and controls. **HIT (1997) is the paper that proved this assumption holds in practice** (specifically: it survived formal nonparametric testing in JTPA when conventional matching's stronger assumptions did not, *as long as* the comparison group is from the same labour market and the same survey instrument). **Abadie (2005) is the paper that gave us the cleanest estimator** for that assumption — a single propensity-score-weighted WLS regression that handles repeated cross-sections, multilevel treatments, and heterogeneous effects with closed-form sandwich standard errors. HIT is the *empirical foundation*; Abadie is the *methodological tool.* You teach with both, you cite both, you use HIT's reasoning to design your study and Abadie's estimator to run the regression.
