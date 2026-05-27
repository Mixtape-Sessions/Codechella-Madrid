# Abadie (2005) — Working Notes (updated after each batch)

**Paper:** "Semiparametric Difference-in-Differences Estimators"
**Journal:** Review of Economic Studies (2005) 72, 1–19
**Author:** Alberto Abadie, Harvard University and NBER

---

## BATCH 1 COMPLETE: Chunks 1–3 (Pages 1–12)

---

## Chunk 1: Pages 1–4

### 1. What is this paper about?
The paper proposes semiparametric estimators for the average treatment effect on the treated (ATT) in a difference-in-differences (DiD) framework. The key problem it addresses: the conventional DiD estimator requires parallel trends *unconditionally*, but this fails when pre-treatment characteristics that predict outcome dynamics are unbalanced between treated and control groups (e.g., Ashenfelter's dip). Abadie's solution is a two-step propensity-score weighting strategy that allows conditional parallel trends — parallel trends hold *conditional on observed covariates X* — and still recovers the ATT without requiring repeated observations on the same individuals.

### 2. Why should I care about this?
The conventional DiD is fragile when treated and control groups differ in observable characteristics that drive outcome dynamics. This is practically common: training programs select on low earners (Ashenfelter's dip), Medicaid expansions reach sicker populations, etc. Abadie's method gives a principled, semiparametric fix. It also allows heterogeneous treatment effects — the effect of the treatment is allowed to vary with covariates, so you get conditional ATT estimates, not just a single scalar. Importantly, it works with repeated cross-sections (not just panel data), making it broadly applicable.

### 3. Who is the intended audience?
Econometricians and empirical economists with strong methods backgrounds. Prior knowledge assumed: potential outcomes framework (Rubin 1974), propensity score (Rosenbaum-Rubin 1983), Horvitz-Thompson weighting, semiparametric/nonparametric estimation. The paper cites Heckman-Ichimura-Todd (1997, 1998) extensively — familiarity with that literature is assumed.

### 4. What does the notation mean?
- **Y(i,t)**: outcome for individual i at time t
- **t = 0**: pre-treatment period; **t = 1**: post-treatment period
- **D(i,t)**: treatment indicator = 1 if individual i was exposed to treatment before period t, 0 otherwise
- **D(i,1) = 1**: individual i is "treated"; D(i,1) = 0: "control/untreated"
- **D(i,0) = 0** for all i (no one treated before the first period)
- **δ(t)**: time-specific component of outcome (common time trend)
- **α**: scalar treatment effect (the "impact of the treatment") in the parametric model
- **η(i)**: individual-specific fixed component (allows selection on permanent characteristics)
- **υ(i,t)**: individual-transitory shock, mean zero, possibly autocorrelated
- **ε(i,t)**: composite error = η(i) − E[η(i)|D(i,1)] + υ(i,t)
- **µ**: intercept = E[η(i)|D(i,1)=0] + δ(0)
- **τ**: difference in individual fixed effects between treated and controls
- **δ**: time trend = δ(1) − δ(0)
- **X(i)**: vector of predetermined covariates (e.g., pre-treatment earnings Y(i, 1−κ), demographics)
- **π(t)**: time-varying coefficient vector on covariates in expanded model (eq. 8)
- **π = π(1) − π(0)**: first-differenced covariate coefficients
- **κ**: positive integer lag (number of periods before training) in Ashenfelter's dip model
- **Ȳ**: threshold constant in selection model (eq. 6)
- **u(i)**: idiosyncratic noise in selection model, independent of variance components

### 5. What do the numbers in the tables mean?
No tables in pages 1–4.

### 6. What are the econometric equations?
**Eq. (1) — Components of variance model:**
Y(i,t) = δ(t) + α·D(i,t) + η(i) + υ(i,t)
- Decomposes outcome into time trend, treatment effect, individual fixed effect, transitory shock.

**Eq. (2) — Identification condition (no selection on transitory shocks):**
P(D(i,1)=1 | υ(i,t)) = P(D(i,1)=1)
- Selection is independent of individual transitory shocks.

**Eq. (3) — Rearranged model:**
Y(i,t) = δ(t) + α·D(i,t) + E[η(i)|D(i,1)] + ε(i,t)

**Eq. (4) — Estimable form:**
Y(i,t) = µ + τ·D(i,1) + δ·t + α·D(i,t) + ε(i,t)
- Under eq. (2), E[(1, D(i,1), t, D(i,t))·ε(i,t)] = 0, so OLS is consistent.

**Eq. (5) — DiD as a difference of differences:**
α = {E[Y(i,1)|D=1] − E[Y(i,1)|D=0]} − {E[Y(i,0)|D=1] − E[Y(i,0)|D=0]}
- The standard 2×2 DiD formula.

**Eq. (6) — Ashenfelter's dip selection model:**
D(i,1) = 1 if Y(i,1−κ) + u(i) < Ȳ, else 0
- Those with low earnings κ periods before training are more likely to participate.

**Eq. (7) — Conditional DiD (treatment effect conditional on X):**
{E[Y(i,1)|X(i),D=1] − E[Y(i,1)|X(i),D=0]} − {E[Y(i,0)|X(i),D=1] − E[Y(i,0)|X(i),D=0]}
- The conditional analog of the DiD formula; X(i) = Y(i,1−κ) in Ashenfelter's dip case.

**Eq. (8) — Linear covariate adjustment in DiD:**
Y(i,t) = µ + X(i)'π(t) + τ·D(i,1) + δ·t + α·D(i,t) + ε(i,t)
- Traditional approach to covariates; allows time-varying covariate effects but is parametric.

### 7. What are the identifying assumptions?
**Unconditional parallel trends** (implied by eq. 2): In absence of treatment, average outcomes for treated and controls follow the same time path. Sufficient condition: selection for treatment does not depend on transitory shocks.

**Conditional parallel trends** (anticipated; eq. 7 motivation): When Ashenfelter's dip is present, P(D=1 | Y(i,1−κ), υ(i,t)) = P(D=1 | Y(i,1−κ)), so DiD holds conditional on X(i) = Y(i,1−κ).

### 8. What is the causal target parameter?
α = ATT under the unconditional model. More generally, the paper motivates estimating E[Y¹(1) − Y⁰(1) | D=1], the average treatment effect on the treated (ATT), and its conditional version E[Y¹(1) − Y⁰(1) | X(i), D=1].

### 9. What is the empirical application?
No empirical application in pages 1–4. The motivating examples are: Card-Krueger (1994) minimum wage study, and job training programs (Ashenfelter's dip). The paper's own empirical application appears later.

---

## Chunk 2: Pages 5–8

### 1. What is this paper about?
This chunk introduces the formal potential outcomes framework and states the core identification result: under conditional parallel trends (Assumption 3.1) and overlap (Assumption 3.2), the ATT can be identified by a propensity-score-weighted average of temporal changes in the outcome. The key object is the weight ρ₀ = (D − P(D=1|X)) / (P(D=1|X)·(1−P(D=1|X))), which re-weights the outcome-change distribution to make treated and controls comparable in X-space. The chunk also shows that conditional ATT — projected onto approximating functions via WLS — can be estimated by a weighted least squares regression with propensity score weights, giving a clean two-step estimator.

### 2. Why should I care about this?
The main punchline of the paper: instead of estimating four nonparametric conditional mean functions (the naive approach to eq. 9), you only need to estimate one function — the propensity score P(D=1|X) — and then do weighted least squares. This is computationally and statistically more efficient, avoids the curse of dimensionality more gracefully, and produces estimates that can be parametrically summarized (e.g., "the ATT is 200 for women, 150 for men") without restricting the true conditional ATT to be linear.

### 3. Who is the intended audience?
Same as chunk 1. This chunk is the core theoretical contribution; it assumes comfort with propensity score theory, Horvitz-Thompson reweighting, and the semiparametric efficiency literature.

### 4. What does the notation mean?
- **Y⁰(i,t)**: potential outcome for individual i at time t *without* treatment
- **Y¹(i,t)**: potential outcome for individual i at time t *with* treatment
- **Y(i,t)**: observed outcome = Y⁰(i,t)·(1−D(i,t)) + Y¹(i,t)·D(i,t)
- **D(i)** = D(i,1): shorthand for treatment indicator (since treatment only happens after t=0)
- **Y(i,0) = Y⁰(i,0)** (everyone untreated in pre-period)
- **Y(i,1) = Y⁰(i,1)·(1−D(i)) + Y¹(i,1)·D(i)**
- **X**: vector of pre-treatment covariates (individual argument dropped for rest of paper)
- **P(D=1|X)**: propensity score — probability of treatment given covariates
- **ρ₀**: the key re-weighting function = (D − P(D=1|X)) / (P(D=1|X)·(1−P(D=1|X)))
  - For treated (D=1): ρ₀ = (1−p(X)) / (p(X)·(1−p(X))) = 1/p(X)
  - For controls (D=0): ρ₀ = (0−p(X)) / (p(X)·(1−p(X))) = −1/(1−p(X))
- **P(D=1)**: marginal probability of treatment (unconditional)
- **Xk**: a deterministic function of X (a subset of covariates of interest for the conditional ATT)
- **G = {g(Xk; θ): θ ∈ Θ ⊂ ℝᵏ}**: class of approximating functions for conditional ATT
- **θ₀**: least squares approximation parameter = argmin_{θ} E[{E[Y¹(1)−Y⁰(1)|Xk,D=1] − g(Xk;θ)}² | D=1]

### 5. What do the numbers in the tables mean?
No tables in pages 5–8.

### 6. What are the econometric equations?
**Assumption 3.1 — Conditional parallel trends:**
E[Y⁰(1) − Y⁰(0) | X, D=1] = E[Y⁰(1) − Y⁰(0) | X, D=0]
- In absence of treatment, conditional on X, treated and controls have the same average counterfactual time trend.

**Eq. (9) — Conditional ATT identification:**
E[Y¹(1) − Y⁰(1) | X, D=1] = {E[Y(1)|X,D=1] − E[Y(1)|X,D=0]} − {E[Y(0)|X,D=1] − E[Y(0)|X,D=0]}
- The conditional DiD formula (Heckman et al. 1997).

**Assumption 3.2 — Overlap:**
P(D=1) > 0 and P(D=1|X) < 1 with probability one.
- Some are treated; for every value of X, some are untreated (common support for treated).

**Lemma 3.1 — Key reweighting result:**
E[Y¹(1) − Y⁰(1) | X, D=1] = E[ρ₀·(Y(1)−Y(0)) | X]
where ρ₀ = (D − P(D=1|X)) / (P(D=1|X)·(1−P(D=1|X)))

**Eq. (10) — ATT as a propensity-score-weighted average:**
E[Y¹(1) − Y⁰(1) | D=1] = E[(Y(1)−Y(0))/P(D=1) · (D−P(D=1|X))/(1−P(D=1|X))]
- ATT = weighted mean of temporal outcome changes; weights are a function of propensity score only.

**Eq. (11) — Parametric approximation to conditional ATT:**
θ₀ = argmin_{θ∈Θ} E[{E[Y¹(1)−Y⁰(1)|Xk,D=1] − g(Xk;θ)}² | D=1]
- Least squares projection of true conditional ATT onto approximating class G.

**Proposition 3.1 — WLS representation:**
θ₀ = argmin_{θ∈Θ} E[P(D=1|X) · {ρ₀·(Y(1)−Y(0)) − g(Xk;θ)}²]
- Estimate θ₀ by weighted least squares of ρ₀·ΔY on g(Xk;θ), using propensity score as weights.
- This collapses to eq. (10) when g is a constant.

### 7. What are the identifying assumptions?
**Assumption 3.1** (Conditional parallel trends): E[Y⁰(1)−Y⁰(0)|X,D=1] = E[Y⁰(1)−Y⁰(0)|X,D=0]. The counterfactual time trend for treated equals that of controls, conditional on X.

**Assumption 3.2** (Overlap/common support): P(D=1) > 0 and P(D=1|X) < 1 a.s. Implies the support of the propensity score for the treated is contained in the support for untreated.

Note: These together are weaker than "selection on observables" (cross-sectional CIA), because they allow unobserved time-invariant heterogeneity to differ between treated and controls — as long as its effect on outcomes doesn't change over time.

### 8. What is the causal target parameter?
**ATT** = E[Y¹(1) − Y⁰(1) | D=1]: the average effect of the treatment on those who were treated, in the post-treatment period.

**Conditional ATT** = E[Y¹(1) − Y⁰(1) | Xk, D=1]: how the ATT varies with a subset of covariates Xk. Approximated parametrically by g(Xk; θ₀).

### 9. What is the empirical application?
No empirical application in pages 5–8. Still theoretical development.

---

## Chunk 3: Pages 9–12

### 1. What is this paper about?
This chunk: (1) extends the identification strategy from repeated outcomes (panel) to **repeated cross-sections** — a more common data situation; (2) shows the same approach applies under **selection on observables** (a special case); (3) extends to **multilevel treatments** (different treatment doses); and (4) begins the asymptotic distribution theory for the estimator, covering both nonparametric (power series) and parametric (probit/logit) first-step estimation of the propensity score.

### 2. Why should I care about this?
Most DiD applications in economics use repeated cross-sections (e.g., CPS before/after a policy), not true panel data. This chunk proves the identification result still holds. The multilevel treatment extension is important for dose-response settings (e.g., length of training, amount of aid). The asymptotic theory gives practitioners the tools to do valid inference after the two-step procedure.

### 3. Who is the intended audience?
Same as above. The asymptotic theory in §4 requires familiarity with semiparametric efficiency, power series approximation, and plug-in estimators. Practitioners may skip §4 and implement the estimator using Propositions 3.1/3.2 directly.

### 4. What does the notation mean?
**Repeated cross-sections setup:**
- **Z = (Y, D, T, X)**: observed vector for each individual in the pooled sample
- **T**: time indicator = 1 if observation is from post-treatment sample, 0 if pre-treatment
- **λ**: fraction of observations from the post-treatment period = n₁/(n₀+n₁)
- **Pₘ(·)**: mixture distribution of the pooled sample
- **Eₘ[·]**: expectation with respect to Pₘ
- **φ₀**: extended weight for repeated cross-sections = ((T−λ)/(λ(1−λ))) · ((D−P(D=1|X))/(P(D=1|X)·P(D=0|X)))

**Multilevel treatment:**
- **W**: treatment level (0 = untreated; W⁺ = {w₁,...,wJ} positive treatment levels)
- **D = 1_{W⁺}(W)**: binary treatment indicator derived from W
- **Yʷ(t)**: potential outcome for treatment level w at time t
- **ρ₀ʷ**: generalized weight for level w = (1_{w}(W)/P(W=w|X)) − (1_{0}(W)/P(W=0|X))
- Note: for binary treatment, ρ₀¹ = ρ₀ from Lemma 3.1

**Estimation (§4):**
- **β₀**: population parameter from WLS objective = argmin_β Eₘ[π₀·{φ₀Y − Xk'β}²]
- **π₀(X) = P(D=1|X)**: propensity score (now also called π₀ in the estimation section)
- **β̂**: sample estimator of β₀
- **π̂(Xᵢ)**: estimated propensity score for observation i
- **φ̂ᵢ**: estimated φ₀ using π̂(Xᵢ)
- **ζ = (ζ₁,...,ζᵣ)'**: vector of non-negative integers for power series construction
- **Xᶻ = ∏ⱼ Xⱼᶻʲ**: monomial (power series term)
- **|ζ| = Σⱼ ζⱼ**: total degree of monomial
- **pᴷ(X)**: K-vector of power series basis functions
- **γ̂**: OLS coefficient in power series regression of D on pᴷ(X)
- **K = K(n)**: number of series terms, growing with n
- **δ(X)**: correction term for asymptotic variance accounting for first-step estimation error
- **ψ**: influence function = Xk·π₀(X)·(φ₀Y − Xk'β₀) + δ(X)·(D−π₀(X))
- **Q = E[Xk·D·Xk']**: second moment matrix
- **Σ = Eₘ[ψψ']**: variance matrix of influence function
- **V = Q⁻¹ΣQ⁻¹**: asymptotic variance of β̂

**Parametric first step (§4.2):**
- **γ₀**: true parameter in parametric propensity score model
- **π(·)**: known link function (e.g., Φ for probit, logistic for logit)
- **V**: set of index values {x'γ : x ∈ S, γ ∈ Γ}

### 5. What do the numbers in the tables mean?
No tables in pages 9–12.

### 6. What are the econometric equations?
**Lemma 3.2 — Repeated cross-sections identification:**
E[Y¹(1)−Y⁰(1)|X,D=1] = Eₘ[φ₀·Y|X]
where φ₀ = ((T−λ)/(λ(1−λ))) · ((D−P(D=1|X))/(P(D=1|X)·P(D=0|X)))
- The "double weight": one weight for time (pre vs. post), one for treatment.

**Eq. (12) — ATT for repeated cross-sections:**
Eₘ[(P(D=1|X)/P(D=1))·φ₀·Y] = E[Y¹(1)−Y⁰(1)|D=1]

**Proposition 3.2 — WLS for repeated cross-sections:**
θ₀ = argmin_{θ∈Θ} Eₘ[P(D=1|X)·{φ₀·Y − g(Xk;θ)}²]
- Analogous to Proposition 3.1 but using the mixture-sample weight φ₀.

**Selection on observables special case (eq. 14):**
E[Y⁰(1)|X,D=1] = E[Y⁰(1)|X,D=0]
→ θ₀ = argmin_θ E[P(D=1|X)·{ρ₀·Y − g(Xk;θ)}²], using Y = Y(1) only.

**Multilevel: eq. (15):**
θ₀ = argmin_{θ} E[(E[Yᵂ(1)−Y⁰(1)|Xk,W]−g(W,Xk;θ))²|D=1]
→ θ₀ = argmin_{θ} E[Σⱼ P(W=wⱼ|X)·(ρ₀^{wⱼ}·(Y(1)−Y(0))−g(wⱼ,Xk;θ))²]

**Estimator β̂ (§4, explicit form):**
β̂ = (1/n Σᵢ Xkᵢ·π̂(Xᵢ)·Xkᵢ')⁻¹ · (1/n Σᵢ Xkᵢ·π̂(Xᵢ)·φ̂ᵢ·Yᵢ)
- Propensity-score-weighted least squares (WLS) regression of φ̂ᵢ·Yᵢ on Xkᵢ.

**Power series estimator (eq. 16):**
π̂(X) = pᴷ(X)'γ̂, where γ̂ = (Σᵢ pᴷ(Xᵢ)pᴷ(Xᵢ)')⁻(Σᵢ pᴷ(Xᵢ)Dᵢ)

**Theorem 4.1 — Asymptotic normality:**
n^{1/2}(β̂−β₀) →ᵈ N(0, V), where V = Q⁻¹ΣQ⁻¹
- Requires K⁶/n → 0 and usual smoothness conditions.

**Theorem 4.2 — Consistency of variance estimator:**
V̂ →ᵖ V (under K⁷/n → 0)

### 7. What are the identifying assumptions?
For repeated cross-sections, adds:
**Assumption 3.3**: Pre-treatment sample is i.i.d. from distribution of (Y(0),D,X); post-treatment sample is i.i.d. from distribution of (Y(1),D,X).

For multilevel: **Extended Assumption 3.1**: E[Y⁰(1)−Y⁰(0)|X,W=w] = E[Y⁰(1)−Y⁰(0)|X,W=0] for all w ∈ W⁺.

For nonparametric first step (Assumption 4.1): π₀ is s-times continuously differentiable; X has compact support with density bounded away from zero; π₀ bounded away from 0 and 1; β₀ is interior point of compact Θ; Y has finite second moment; Xk is bounded; E[XkXk'|D=1] is nonsingular.

### 8. What is the causal target parameter?
Same as chunk 2: ATT = E[Y¹(1)−Y⁰(1)|D=1], and its conditional version.

For multilevel: E[Yʷ(1)−Y⁰(1)|Xk, W=w] — the average effect of treatment level w (relative to no treatment) for those receiving level w, conditional on Xk.

### 9. What is the empirical application?
No empirical application yet. Section 5 (not yet read) likely contains it.

---

---

## BATCH 2 COMPLETE: Chunks 4–5 (Pages 13–19)

---

## Chunk 4: Pages 13–16

### 1. What is this paper about?
This chunk contains: (1) the conclusion of §4.2 on parametric (MLE) first-step propensity score estimation — giving Theorems 4.3 and 4.4 for asymptotic normality and variance consistency under probit/logit first step; and (2) the full mathematical proofs of all four Lemmas, Propositions, and Theorems (Appendix). This is the technical backbone of the entire paper.

### 2. Why should I care about this?
Practitioners typically use logit or probit for the propensity score (not nonparametric series). Theorems 4.3/4.4 legitimize that choice: β̂ is still root-n normal and the sandwich variance estimator V̂ is consistent even when you use MLE for the first step. The influence function adjusts for the first-step estimation error via the Mγ₀ term. The proofs confirm that Propositions 3.1/3.2 work because the cross-term in the WLS objective is exactly zero (the key algebraic step that makes the whole approach work).

### 3. Who is the intended audience?
Theoretical econometricians. The proofs invoke Newey (1994, 1997), van der Vaart (1998), and Newey-McFadden (1994) — the standard toolkit for semiparametric asymptotics with generated regressors.

### 4. What does the notation mean?
**Parametric MLE:**
- **γ̂**: MLE of propensity score parameters = argmax_γ (1/n) Σᵢ [Dᵢ log π(Xᵢ'γ) + (1−Dᵢ) log(1−π(Xᵢ'γ))]
- **π̇ = ∂π(v)/∂v**: derivative of link function with respect to index
- **π̇₀ = π̇(X'γ₀)**: evaluated at true parameters
- **ψ_{γ₀}(Z)**: influence function for MLE of propensity score = [E(π̇₀²/(π₀(1−π₀))·XX')]⁻¹ · X·(π̇₀/(π₀(1−π₀)))·(D−π₀)
- **M_{γ₀}**: derivative of E_M[m(Z,β₀,γ)] with respect to γ at γ₀; the "sensitivity" of the second-step moment condition to first-step parameter changes
- **m(Z,β,γ)**: moment function = Xk·π(X'γ)·[φ(Z,γ)·Y − Xk'β]

**Proof-specific:**
- **| · |∞**: supremum norm
- **|ζ|**: order of the power series term
- **ξK**: best L₂ approximation to δ(X) from the K-term power series
- **Λ(Z,π,β,π̃)**: linearization term = [∂m(Z,β,π)/∂π|_{π=π̃}]·π (Gateaux derivative of m w.r.t. propensity score)
- **o_p(1)**: converges to zero in probability
- **O_p(K·[(K/n)^{1/2} + K^{-s/r}])**: convergence rate of nonparametric propensity score estimator

### 5. What do the numbers in the tables mean?
No tables in pages 13–16.

### 6. What are the econometric equations?
**MLE of propensity score:**
γ̂ = argmax_{γ∈Γ} (1/n) Σᵢ [Dᵢ log π(Xᵢ'γ) + (1−Dᵢ) log(1−π(Xᵢ'γ))]

**Influence function for MLE (eq. 17):**
ψ_{γ₀}(Z) = [E(π̇₀²/(π₀(1−π₀))·XX')]⁻¹ · X·(π̇₀/(π₀(1−π₀)))·(D−π₀)
- This is the standard logit/probit score influence function.

**Theorem 4.3 — Asymptotic normality (parametric first step):**
√n(β̂−β₀) →ᵈ N(0,V), V = Q⁻¹ΣQ⁻¹
where ψ = m(Z,β₀,γ₀) + M_{γ₀}·ψ_{γ₀}
- The influence function has two parts: the direct second-step contribution m(·) and the indirect first-step correction M_{γ₀}·ψ_{γ₀}.

**Theorem 4.4 — Variance consistency:**
V̂ →ᵖ V (requiring π(v) twice differentiable with bounded second derivative)

**Key proof step for Proposition 3.1 (Appendix, eq. A.1):**
G(θ) = E[P(D=1|X)·{ρ₀·(Y(1)−Y(0)) − E[Y¹(1)−Y⁰(1)|Xk,D=1]}²] (doesn't depend on θ)
     + E[P(D=1|X)·{E[Y¹(1)−Y⁰(1)|Xk,D=1] − g(Xk;θ)}²] (minimized at θ₀)
     + 0 (cross-term = zero by Lemma 3.1 and LIE)
- The cross-term vanishing is the key step that enables the WLS representation.

### 7. What are the identifying assumptions?
Assumption 4.2 (parametric propensity score): γ₀ ∈ interior of compact Γ; X has compact support with E[XX'] non-singular; there exists known link function π(·) such that π₀(X) = π(X'γ₀); π(v) is bounded away from 0 and 1, strictly increasing, continuously differentiable with bounded derivative; β₀ interior of compact Θ; E_M Y² < ∞, Xk bounded, E[XkXk'|D=1] non-singular.

### 8. What is the causal target parameter?
Same as previous chunks: β₀, the vector of coefficients in the linear approximation to the conditional ATT. When g(Xk;β) is a constant, β₀ = E[Y¹(1)−Y⁰(1)|D=1] = ATT.

### 9. What is the empirical application?
The conclusions section (§5) confirms no separate empirical application is presented in this paper. The paper is entirely theoretical. The motivating applications cited are job training programs (Ashenfelter's dip) and the canonical Card-Krueger minimum wage study.

---

## Chunk 5: Pages 17–19

### 1. What is this paper about?
This chunk completes the proof of Theorems 4.3 and 4.4 (the parametric first-step case), ending the technical appendix. Pages 18–19 contain the acknowledgements and the full reference list. There is no new substantive content — this is the tail end of the mathematical proofs and bibliography.

### 2. Why should I care about this?
The completion of Theorem 4.3's proof shows that the consistency and asymptotic linearity of γ̂ (MLE) feed cleanly into the second-step β̂ via the delta method, confirming that standard errors from V̂ are valid even after two-step estimation. The reference list is valuable for tracing the intellectual lineage of the paper.

### 3. Who is the intended audience?
Theoretical econometricians reading the proofs; empirical researchers looking at the reference list to understand the prior literature this paper builds on.

### 4. What does the notation mean?
- **p_γ = π(X'γ)^D · (1−π(X'γ))^{1−D}**: likelihood contribution for observation with covariates X and treatment D
- **ṗ_{γ}^{1/2}**: score direction in quadratic mean differentiability of the parametric model
- **l̇_{γ}**: score function = X·(π̇(X'γ)/(π(X'γ)(1−π(X'γ))))·(D−π(X'γ))
- **N_{γ₀}**: convex open neighbourhood of γ₀ in Γ
- **M_{γ₀}**: equals derivative of E_M[m(Z,β₀,γ)] at γ=γ₀; connects first-step variation to second-step moment condition
- **ψ̂_{γ̂}(Zᵢ)**: estimated influence function for γ̂ (used to construct V̂)
- **M̂_{γ̂}**: sample estimator of M_{γ₀}
- **π̈**: second derivative of link function π(v); bounded by assumption in Theorem 4.4

### 5. What do the numbers in the tables mean?
No tables in pages 17–19.

### 6. What are the econometric equations?
**Score function (differentiability in quadratic mean):**
l̇_{γ} = X·(π̇(X'γ)/(π(X'γ)(1−π(X'γ))))·(D−π(X'γ))

**Delta method application:**
n^{1/2} E_M[m(Z,β₀,γ̂)] = n^{1/2} M_{γ₀}(γ̂−γ₀) + o_p(1)

**Asymptotic expansion (proof of Theorem 4.3):**
n^{1/2}(β̂−β₀) = Q⁻¹ · (1/√n) Σᵢ [m(Zᵢ,β₀,γ₀) + M_{γ₀}ψ_{γ₀}(Zᵢ)] + o_p(1)
- This is the influence function representation; variance is Var(m + M_{γ₀}ψ_{γ₀}).

**Eq. (A.8):** (1/n) Σᵢ ‖m(Zᵢ,β̂,γ̂) − m(Zᵢ,β₀,γ₀)‖² = o_p(1)
- Consistency of sample objective to population, needed for V̂ →ᵖ V.

### 7. What are the identifying assumptions?
No new assumptions. The proof of Theorem 4.3 additionally uses:
- Donsker property of the function class {m(Z,β,γ): ‖β−β₀‖<c, ‖γ−γ₀‖<c} (established via Lipschitz argument)
- Non-singularity of ∂E_M[m(Z,β,γ)]/∂β = −E[Xk π(X'γ)Xk'] in a neighbourhood of γ₀

### 8. What is the causal target parameter?
Same as all prior chunks: ATT = E[Y¹(1)−Y⁰(1)|D=1], and its conditional/parametric approximation β₀.

### 9. What is the empirical application?
No empirical application. The paper has no empirical section — it is a pure methodological contribution. The reference list cites training program and labor market studies as motivating applications, but the paper itself provides only identification and estimation theory.

---

*All 5 chunks complete.*

