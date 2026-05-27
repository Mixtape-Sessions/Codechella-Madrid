# Abadie (2005) — Paper-Level Synthesis

**Full citation:** Abadie, A. (2005). "Semiparametric Difference-in-Differences Estimators." *Review of Economic Studies* 72(1): 1–19.

This is a synthesis of all 5 chunk-level reading notes ([Abadie-2005-reading-notes.md](Abadie-2005-reading-notes.md)).

---

## 1. What is this paper about?

The paper introduces a class of **semiparametric difference-in-differences estimators for the ATT** that replace the standard unconditional parallel-trends assumption with a **conditional** parallel-trends assumption: parallel trends hold only after conditioning on a vector of observed covariates X.

The motivating concern is straightforward: conventional DiD fails when treated and control groups differ in observable characteristics that predict outcome dynamics. The canonical example is **Ashenfelter's dip** — training participants experience a transitory earnings drop before training, so selection is driven by transitory shocks, violating the standard DiD independence condition. More generally, if covariate distributions differ between groups and those covariates predict outcome growth, unconditional DiD is biased.

Abadie's solution is a **two-step propensity-score-weighted estimator** with the following structure:

1. Estimate the propensity score `P(D=1|X)` in the first step (parametrically by logit/probit, or nonparametrically by power series).
2. Run a weighted least-squares regression of the *propensity-score-weighted outcome change* on the conditioning variables of interest.

The framework also:
- Extends to **repeated cross-sections** (via a "double weight" φ₀ combining time-period and propensity-score adjustment).
- Handles **multilevel/dose-response treatments** (different intensities).
- Estimates **heterogeneous treatment effects** (the conditional ATT as a parametric function of covariates).
- Nests **selection-on-observables** as a special case.
- Provides **valid sandwich standard errors** that account for first-step estimation error in the propensity score.

It is a pure methods paper. There is **no empirical application** and **no simulation evidence** — only theory, asymptotic distribution results, and proofs.

---

## 2. Why should I care about this?

Because Abadie (2005) is the paper that turned conditional DiD from a Heckman-Ichimura-Todd-flavored matching device into a **single weighted regression with familiar inference**. The advantages that matter in practice:

1. **One nuisance function, not four.** Naive conditional DiD requires estimating four conditional means: `E(Y_t|X,D=d)` for `t ∈ {0,1}` and `d ∈ {0,1}`. Abadie's reformulation shows you only need *one* — the propensity score — because the four-mean problem collapses into a single propensity-score-weighted average of outcome changes.

2. **Repeated cross-sections work.** Most DiD applications use CPS-style data with different individuals in each period, not panel data. Abadie's extension (Proposition 3.2) makes the same procedure valid for repeated cross-sections by using a "double weight" that adjusts for both treatment status and period membership.

3. **Heterogeneous treatment effects, parametrically summarized.** The estimator naturally returns coefficients of a *linear projection* of the true conditional ATT onto a chosen set of covariates `X_k`. The nonparametric identification is preserved; the parametric summary is just a description of how the ATT varies with covariates.

4. **Logit/probit is fine.** Theorem 4.3 establishes root-n asymptotic normality even with a parametric first stage — practitioners do not need to use nonparametric series. The influence-function correction `M_{γ₀}·ψ_{γ₀}` for first-step estimation error is what makes sandwich SEs valid.

5. **Multilevel treatments.** With minimal modification, the framework handles dose-response questions (weeks of training, dollars of subsidy) — useful in policy settings.

The paper is also a foundational reference for the **doubly-robust / IPW lineage** of modern DiD work (Sant'Anna and Zhao 2020, Callaway and Sant'Anna 2021), which builds directly on Abadie's identification and estimation results to extend them to staggered adoption settings.

---

## 3. Who is the intended audience?

**Primary:** Econometricians with a methods orientation. The paper assumes comfort with:
- Potential outcomes (Rubin 1974).
- Propensity-score theory (Rosenbaum-Rubin 1983).
- Horvitz-Thompson weighting and inverse-probability weighting.
- Semiparametric efficiency theory (Newey 1994, 1997).
- Power-series approximation and plug-in estimators.

**Secondary:** Applied researchers running DiD who want a covariate-conditioned, weighted version of DiD with proper inference. They can read §§2–3 and Proposition 3.1/3.2 and then implement the estimator without touching the asymptotic-theory machinery in §4 or the appendix.

**Tertiary:** The lineage of econometricians extending DiD to richer settings — staggered adoption, time-varying treatment, doubly-robust estimation. This paper is a foundation, repeatedly cited by Callaway, Sant'Anna, Roth, and others.

Note: the paper is *not* written for empirical practitioners as a how-to guide. There are no tables, no figures, no simulations, no replication archive. It is a theory paper with a clearly identified empirical motivation (job training) that is left for future work.

---

## 4. What does the notation mean?

The notation builds across the paper. Synthesizing:

**Time and treatment:**
- `t ∈ {0, 1}`: pre- (0) and post-treatment (1) periods.
- `D = D(i,1)`: treatment indicator — 1 if exposed before period 1, 0 otherwise. (D(i,0) = 0 for all i.)
- `T`: time indicator for repeated cross-sections (1 if post-period, 0 if pre-period).
- `λ = n₁/(n₀ + n₁)`: fraction of pooled sample from the post-period.

**Potential outcomes:**
- `Y⁰(i,t), Y¹(i,t)`: untreated/treated potential outcomes for individual i at time t.
- `Y(i,t) = Y⁰(i,t)·(1−D(i,t)) + Y¹(i,t)·D(i,t)`: observed outcome (switching equation).
- In the pre-period: `Y(i,0) = Y⁰(i,0)` (no one treated yet).

**Covariates:**
- `X`: vector of pre-treatment covariates (e.g., pre-treatment outcome `Y(i, 1−κ)`, demographics).
- `X_k`: a *subset* of X — the conditioning variables of interest for the heterogeneous ATT (e.g., gender, age).
- `Z = (Y, D, T, X)`: full observed vector for repeated cross-sections.

**Components-of-variance model (eq. 1):**
- `δ(t)`: time-specific component (common time trend).
- `α`: scalar treatment effect.
- `η(i)`: individual fixed component (selection on permanent characteristics).
- `υ(i,t)`: transitory shock (mean zero, possibly autocorrelated).
- `ε(i,t)`: composite error term = `η(i) − E[η(i)|D(i,1)] + υ(i,t)`.
- `µ`: intercept = `E[η(i)|D(i,1)=0] + δ(0)`.
- `τ`: difference in mean individual fixed effects between treated and controls.
- `δ`: time trend = `δ(1) − δ(0)`.

**Ashenfelter's-dip selection model (eq. 6):**
- `Ȳ`: threshold constant.
- `u(i)`: idiosyncratic noise, independent of variance components.
- `κ`: lag (in periods) at which pre-treatment earnings enter the selection rule.

**Propensity score and weights:**
- `P(D=1|X)`: propensity score.
- `P(D=1)`: marginal probability of treatment.
- `π₀(X) = P(D=1|X)`: shorthand.
- `ρ₀ = (D − P(D=1|X)) / (P(D=1|X)·(1−P(D=1|X)))`: the **key reweighting function** for panel data.
  - For treated (D=1): `ρ₀ = 1/P(D=1|X)`.
  - For controls (D=0): `ρ₀ = −1/(1−P(D=1|X))`.
- `φ₀ = ((T−λ)/(λ(1−λ))) · ((D−P(D=1|X))/(P(D=1|X)·P(D=0|X)))`: the **"double weight"** for repeated cross-sections — one factor adjusts for time-period membership, the other for treatment status.

**Parametric approximation to conditional ATT:**
- `G = {g(X_k; θ): θ ∈ Θ ⊂ ℝᵏ}`: class of approximating functions (often linear: `X_k'θ`).
- `θ₀`: population least-squares projection parameter to `E[Y¹(1) − Y⁰(1) | X_k, D=1]`.
- `β₀`: the analogous population parameter for the repeated-cross-section estimator; `β̂` is its sample analog.

**Multilevel treatment:**
- `W`: treatment level; `W = 0` untreated, `W⁺ = {w₁, ..., w_J}` positive levels.
- `D = 1_{W⁺}(W)`: binary indicator derived from W.
- `Y^w(t)`: potential outcome for treatment level w.
- `ρ₀^w = 1_w(W)/P(W=w|X) − 1_0(W)/P(W=0|X)`: generalized weight for level w. Reduces to `ρ₀` for binary treatment.

**First-step (propensity-score) estimation:**
- `γ̂`: parametric MLE (e.g., logit) of propensity score parameters.
- `ψ_{γ₀}(Z)`: score-based influence function for γ̂.
- `π(v)`: link function (logit or probit); `π̇`, `π̈`: first and second derivatives.
- `p^K(X)`: power-series basis (K monomials).
- `K = K(n)`: number of series terms (growing with sample size for nonparametric first step).

**Asymptotic variance components:**
- `m(Z, β, γ)`: moment function for the second step = `X_k·π(X'γ)·[φ(Z,γ)·Y − X_k'β]`.
- `M_{γ₀}`: sensitivity of the second-step moment to first-step parameter — the correction term for generated-regressor uncertainty.
- `Q = E[X_k·D·X_k']`: second-moment matrix of the WLS design.
- `ψ = m(Z, β₀, γ₀) + M_{γ₀}·ψ_{γ₀}`: full influence function (two components).
- `Σ = E_M[ψψ']`: variance of the influence function.
- `V = Q⁻¹ΣQ⁻¹`: asymptotic variance of β̂ (sandwich form).
- `δ(X)`: correction term in the asymptotic variance for nonparametric first-step error.

---

## 5. What do the numbers in the tables mean?

**There are no tables.** Abadie (2005) is a pure theory paper containing only equations, propositions, theorems, and proofs. There are no numerical examples, no simulations, no figures, no empirical results. The 19 pages comprise: introduction (§1), setup and motivation (§2), identification (§3), asymptotic theory (§4), conclusion (§5), and a substantial appendix of proofs.

---

## 6. What are the econometric equations?

**Components-of-variance setup (eq. 1):**
```
Y(i,t) = δ(t) + α·D(i,t) + η(i) + υ(i,t)
```

**Standard (unconditional) DiD identification (eq. 2):**
```
P(D(i,1)=1 | υ(i,t)) = P(D(i,1)=1)
```
Selection independent of transitory shocks ⇒ unconditional parallel trends.

**Estimable regression form (eq. 4):**
```
Y(i,t) = µ + τ·D(i,1) + δ·t + α·D(i,t) + ε(i,t)
```
OLS consistently estimates α under (2). The 2×2 DiD formula (eq. 5):
```
α = {E[Y(i,1)|D=1] − E[Y(i,1)|D=0]} − {E[Y(i,0)|D=1] − E[Y(i,0)|D=0]}
```

**Ashenfelter's-dip selection model (eq. 6):**
```
D(i,1) = 1{Y(i, 1−κ) + u(i) < Ȳ}
```
Pre-treatment earnings shocks drive selection ⇒ unconditional DiD fails.

**Conditional DiD identifying object (eq. 7):**
```
{E[Y(i,1)|X,D=1] − E[Y(i,1)|X,D=0]} − {E[Y(i,0)|X,D=1] − E[Y(i,0)|X,D=0]}
```

**Linear covariate-adjusted DiD (eq. 8):**
```
Y(i,t) = µ + X(i)'π(t) + τ·D(i,1) + δ·t + α·D(i,t) + ε(i,t)
```
Standard parametric approach; misspecified under heterogeneous treatment effects.

---

**Assumption 3.1 — Conditional parallel trends (the key identification condition):**
```
E[Y⁰(1) − Y⁰(0) | X, D=1] = E[Y⁰(1) − Y⁰(0) | X, D=0]
```

**Assumption 3.2 — Overlap:**
```
P(D=1) > 0  and  P(D=1|X) < 1 a.s.
```

**Eq. (9) — Conditional ATT identification (Heckman-Ichimura-Todd 1997):**
```
E[Y¹(1) − Y⁰(1) | X, D=1]
   = {E[Y(1)|X,D=1] − E[Y(1)|X,D=0]} − {E[Y(0)|X,D=1] − E[Y(0)|X,D=0]}
```

**Lemma 3.1 — Reweighting identity (the central algebraic result):**
```
E[Y¹(1) − Y⁰(1) | X, D=1] = E[ρ₀·(Y(1) − Y(0)) | X]
```
where `ρ₀ = (D − P(D=1|X)) / (P(D=1|X)·(1−P(D=1|X)))`.

**Eq. (10) — ATT as a propensity-score-weighted average:**
```
E[Y¹(1) − Y⁰(1) | D=1] = E[(Y(1)−Y(0))/P(D=1) · (D−P(D=1|X))/(1−P(D=1|X))]
```

**Eq. (11) — Parametric approximation of conditional ATT:**
```
θ₀ = argmin_{θ∈Θ} E[{E[Y¹(1)−Y⁰(1)|X_k,D=1] − g(X_k;θ)}² | D=1]
```

**Proposition 3.1 — Weighted least-squares representation (the estimator):**
```
θ₀ = argmin_{θ∈Θ} E[P(D=1|X) · {ρ₀·(Y(1)−Y(0)) − g(X_k;θ)}²]
```
Estimate θ₀ by WLS of the "pseudo-outcome" `ρ₀·ΔY` on `g(X_k;θ)` with propensity-score weights `P(D=1|X)`. With `g` constant, this reduces to eq. (10).

---

**Repeated cross-sections (Lemma 3.2):**
```
E[Y¹(1) − Y⁰(1) | X, D=1] = E_M[φ₀·Y | X]
```
where `φ₀ = ((T−λ)/(λ(1−λ))) · ((D−P(D=1|X))/(P(D=1|X)·P(D=0|X)))`.

**Eq. (12) — Repeated-cross-section ATT:** `E_M[(P(D=1|X)/P(D=1))·φ₀·Y] = E[Y¹(1)−Y⁰(1)|D=1]`.

**Proposition 3.2 — Repeated-cross-section WLS:**
```
θ₀ = argmin_{θ∈Θ} E_M[P(D=1|X) · {φ₀·Y − g(X_k;θ)}²]
```

**Selection-on-observables special case (eq. 14):** `E[Y⁰(1)|X,D=1] = E[Y⁰(1)|X,D=0]`. With this, the same machinery applies using only post-period data.

**Multilevel-treatment identification (eq. 15):**
```
θ₀ = argmin_{θ} E[(E[Y^W(1)−Y⁰(1)|X_k,W] − g(W,X_k;θ))² | D=1]
     = argmin_{θ} E[Σⱼ P(W=wⱼ|X)·(ρ₀^{wⱼ}·(Y(1)−Y(0)) − g(wⱼ, X_k; θ))²]
```

---

**Estimator (the punchline):**
```
β̂ = (n⁻¹ Σᵢ X_{ki}·π̂(X_i)·X_{ki}')⁻¹ · (n⁻¹ Σᵢ X_{ki}·π̂(X_i)·φ̂_i·Y_i)
```
WLS regression of `φ̂_i·Y_i` on `X_{ki}` with propensity-score weights `π̂(X_i)`.

**Theorems 4.1–4.4 — Asymptotic normality and variance consistency:**
```
√n(β̂ − β₀) →ᵈ N(0, V),    V = Q⁻¹ΣQ⁻¹
```
where the influence function `ψ = m(Z, β₀, γ₀) + M_{γ₀}·ψ_{γ₀}` has two parts — direct second-step + first-step correction. Standard errors must use the sandwich V̂ that includes M_{γ₀}·ψ_{γ₀}; treating the propensity score as if it were known gives invalid SEs.

**Why WLS works (key algebraic identity, eq. A.1):** The cross-term in the population WLS objective vanishes by the law of iterated expectations applied to Lemma 3.1. That zero cross-term is the entire algebraic basis of the method.

---

## 7. What are the identifying assumptions?

**Assumption 3.1 — Conditional parallel trends:**
```
E[Y⁰(1) − Y⁰(0) | X, D=1] = E[Y⁰(1) − Y⁰(0) | X, D=0]
```
In the absence of treatment, treated and control groups have the **same average counterfactual time trend, after conditioning on X.** This is weaker than:
- *Unconditional* parallel trends (which fails when covariates differ between groups), and
- Cross-sectional selection-on-observables (which requires conditional independence of *levels*, not just changes).

It is *stronger* than allowing arbitrary covariate-driven heterogeneity in trends — it requires that whatever covariate-dependent trends exist are common to treated and controls.

**Assumption 3.2 — Overlap:**
```
P(D=1) > 0  and  P(D=1|X) < 1 a.s.
```
Some are treated; for every X, some remain untreated. Implies the propensity-score support for treated is contained in the support for untreated.

**Assumption 3.3 — Repeated cross-sections sampling (when applicable):** Each cross-section is i.i.d. from the relevant period distribution; independence between periods.

**Extended Assumption 3.1 for multilevel treatments:** `E[Y⁰(1) − Y⁰(0) | X, W=w] = E[Y⁰(1) − Y⁰(0) | X, W=0]` for all positive treatment levels w. Common counterfactual trends across all treatment doses.

**Regularity (Assumption 4.1 nonparametric, 4.2 parametric):** Standard smoothness of π₀; compact X support; π₀ bounded away from 0 and 1; β₀ in interior of compact Θ; finite second moment of Y; bounded X_k.

**What is NOT assumed:**
- The conditional ATT function `E[Y¹(1) − Y⁰(1) | X_k, D=1]` is not restricted to be linear or any specific functional form. The parametric approximation `g(X_k; θ)` is a *projection*, not a model.
- Standard cross-sectional selection-on-observables is not required (Y⁰ levels can differ between groups conditional on X — only the *change* in Y⁰ must be balanced).
- No homogeneity in treatment effects (heterogeneity is the whole point of the conditional ATT).

---

## 8. What is the causal target parameter?

**Primary:** ATT in the post-treatment period — `E[Y¹(1) − Y⁰(1) | D=1]`. The average effect of treatment on those who received it.

**Secondary (heterogeneous):** Conditional ATT — `E[Y¹(1) − Y⁰(1) | X_k, D=1]` — the ATT as a function of a chosen subset of covariates X_k. The estimator returns a *parametric projection* of this function onto a chosen approximating class G (typically linear: `X_k'θ`). The projection coefficients θ₀ describe how the ATT varies with covariates, even if the underlying conditional ATT function is not linear.

**Multilevel generalization:** `E[Y^w(1) − Y⁰(1) | X_k, W=w]` — the ATT of treatment level w (relative to no treatment) for those receiving level w, conditional on X_k.

There is no ATE in this paper. The propensity-score weighting scheme naturally identifies the ATT (the treated population's covariate distribution is the reference), not the ATE.

---

## 9. What is the empirical application?

**There is none.** Abadie (2005) is a pure methodological contribution with no empirical analysis and no simulation evidence. The empirical motivations cited in the introduction are:

- **Job training programmes** (Ashenfelter 1978; Heckman-Ichimura-Todd 1997, 1998). The Ashenfelter's-dip pattern is the running example of why conditional DiD is needed.
- **Card and Krueger (1994)** on the minimum wage and fast-food employment.
- **Meyer, Viscusi and Durbin (1995)** on the effect of disability insurance.
- **Garvey and Hanka (1999)** on anti-takeover laws and corporate financing.

These are mentioned to motivate the framework; none is analyzed in the paper. The paper essentially says: *"Here is a clean estimator. Apply it to your own problem."*

This is a significant constraint for evaluating the method's performance. The reader cannot see how the estimator behaves in finite samples, how sensitive it is to propensity-score misspecification, or how it compares to alternatives in any specific setting. Those questions were left to subsequent work (Sant'Anna and Zhao 2020 is the canonical follow-up showing that the doubly-robust extension improves robustness).
