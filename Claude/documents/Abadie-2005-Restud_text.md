# Abadie (2005) — Condensed Synthesis for Reuse
## "Semiparametric Difference-in-Differences Estimators"
## Review of Economic Studies 72(1): 1–19

---

## The Core Problem

Conventional DiD requires unconditional parallel trends:
**E[Y⁰(1)−Y⁰(0)|D=1] = E[Y⁰(1)−Y⁰(0)|D=0]**

This fails when:
- Selection on transitory shocks (Ashenfelter's dip): training participants have pre-training earnings dip, so selection depends on υ(i,t)
- Observed covariates X predict outcome dynamics and are unbalanced between treated and controls

## The Identifying Assumption

**Assumption 3.1 (Conditional Parallel Trends):**
E[Y⁰(1)−Y⁰(0) | X, D=1] = E[Y⁰(1)−Y⁰(0) | X, D=0]

In absence of treatment, conditional on covariates X, treated and controls have the same average counterfactual time trend. Weaker than selection on observables: allows time-invariant unobserved heterogeneity to differ between groups.

**Assumption 3.2 (Overlap):**
P(D=1) > 0 and P(D=1|X) < 1 with probability one.

## The Key Result (Lemma 3.1 + Eq. 10)

Under Assumptions 3.1 and 3.2, for repeated outcomes:

**ATT = E[(Y(1)−Y(0))/P(D=1) · (D−P(D=1|X))/(1−P(D=1|X))]**

where the weight ρ₀ = (D − P(D=1|X)) / (P(D=1|X)·(1−P(D=1|X))).

For repeated cross-sections (Lemma 3.2 + Eq. 12), the equivalent weight is:
φ₀ = ((T−λ)/(λ(1−λ))) · ((D−P(D=1|X))/(P(D=1|X)·P(D=0|X)))

## The Estimator (Two Steps)

**Step 1:** Estimate propensity score π̂(X) = P(D=1|X) using:
- Parametric: logit or probit MLE: γ̂ = argmax (1/n)Σᵢ [Dᵢ log π(Xᵢ'γ) + (1−Dᵢ)log(1−π(Xᵢ'γ))]
- Nonparametric: power series regression

**Step 2:** Estimate ATT via propensity-score-weighted OLS (Proposition 3.1/3.2):
β̂ = (1/n Σᵢ Xkᵢ·π̂(Xᵢ)·Xkᵢ')⁻¹ · (1/n Σᵢ Xkᵢ·π̂(Xᵢ)·φ̂ᵢ·Yᵢ)

When Xk = 1 (constant), β̂ = sample ATT. When Xk includes covariates, β̂ = parametric approximation to conditional ATT.

## Asymptotic Theory

Under either parametric (Theorem 4.3) or nonparametric (Theorem 4.1) first step:
√n(β̂−β₀) →ᵈ N(0, V), V = Q⁻¹ΣQ⁻¹

Influence function (parametric first step):
ψ = m(Z,β₀,γ₀) + M_{γ₀}·ψ_{γ₀}
- First term: direct second-step contribution
- Second term: correction for first-step estimation error in propensity score

V̂ = Q̂⁻¹Σ̂Q̂⁻¹ is consistent (Theorems 4.2, 4.4).

## Key Parameters and Notation Reference

| Symbol | Meaning |
|--------|---------|
| Y⁰(t), Y¹(t) | Potential outcomes without/with treatment at time t |
| D = D(i,1) | Binary treatment indicator |
| X | Pre-treatment covariates |
| Xk | Subset of X for conditional ATT heterogeneity |
| P(D=1\|X) = π₀(X) | Propensity score |
| ρ₀ | Reweighting function for panel data |
| φ₀ | Reweighting function for repeated cross-sections |
| λ = n₁/(n₀+n₁) | Fraction of post-treatment observations |
| T | Time indicator (1=post, 0=pre) in pooled cross-section |
| β₀ | True coefficients in linear approx to conditional ATT |
| θ₀ | More general: argmin in WLS objective |
| g(Xk;θ) | Approximating function class for conditional ATT |
| ψ | Influence function for β̂ |
| V = Q⁻¹ΣQ⁻¹ | Asymptotic variance matrix |
| M_{γ₀} | First-step correction matrix (parametric case) |

## Extensions

**Selection on observables** (special case): E[Y⁰(1)|X,D=1] = E[Y⁰(1)|X,D=0] — same formulas apply using only post-treatment Y(1).

**Multilevel treatments**: W ∈ {0,w₁,...,wJ}. Replace ρ₀ with ρ₀ʷ = (1_{w}(W)/P(W=w|X)) − (1_{0}(W)/P(W=0|X)). ATT at dose w is E[Yʷ(1)−Y⁰(1)|Xk,W=w].

## What This Paper Does NOT Do

- No empirical application
- No Monte Carlo simulations
- Does not discuss bandwidth selection (that's Ichimura-Linton 2002)
- Does not consider staggered adoption or multiple treatment periods
- Does not propose a test for the conditional parallel trends assumption
- Treatment effect heterogeneity is estimated by parametric approximation, not nonparametrically

## Relation to Other Methods

- **vs. Heckman et al. (1997, 1998)**: Same identification. Different estimation — HIT use nonparametric matching on propensity score; Abadie uses direct weighting. Abadie works for repeated cross-sections (HIT requires panel/matched samples). Abadie directly estimates conditional ATT by WLS.
- **vs. Blundell et al. (2001)**: Related combination of DiD and matching, but HIT/Abadie approach is more direct.
- **vs. Horvitz-Thompson (1952)**: Abadie's weights are a DiD generalization of HT weighting for cross-sectional data.
- **vs. Imbens-Hirano-Ridder (2003)**: IHR estimate ATE under selection on observables; Abadie estimates ATT under conditional parallel trends (weaker assumption allowing unobserved heterogeneity).
