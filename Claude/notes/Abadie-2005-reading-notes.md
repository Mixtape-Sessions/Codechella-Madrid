# Abadie (2005) — Deep Reading Notes
## Review of Economic Studies 72(1): 1–19

**Full citation:** Alberto Abadie (2005). "Semiparametric Difference-in-Differences Estimators." *Review of Economic Studies* 72(1): 1–19.

---

## Chunk 1: Pages 1–4

### 1. What is this paper about?
The paper proposes semiparametric estimators for the average treatment effect on the treated (ATT) in a difference-in-differences (DiD) framework. The central problem: the conventional DiD estimator requires parallel trends *unconditionally*, but this fails when pre-treatment characteristics that predict outcome dynamics are unbalanced between treated and control groups — the canonical example being Ashenfelter's dip (training participants experience a transitory earnings decline before training, so selection is driven by transitory shocks, violating the independence condition). Abadie's solution is a two-step propensity-score weighting strategy that requires only *conditional* parallel trends — parallel trends hold given observed covariates X — and still recovers the ATT without requiring repeated observations on the same individuals (panel data). The framework also permits heterogeneous treatment effects, estimated as parametric approximations to the conditional ATT.

### 2. Why should I care about this?
The conventional DiD is fragile when treated and control groups differ in observable characteristics that drive outcome dynamics — a practically very common situation. Abadie's method gives a principled, semiparametric fix that:
(a) extends identification when observed covariate distributions differ between groups;
(b) allows heterogeneous treatment effects (conditional ATT as a function of covariates);
(c) works with repeated cross-sections (not just panel data) — applicable to CPS-style data;
(d) handles multilevel/continuous treatments (different treatment doses);
(e) imposes parametric restrictions only on the propensity score, not on the ATT function itself.

### 3. Who is the intended audience?
Econometricians and empirical economists with strong methods backgrounds. Prior knowledge assumed: potential outcomes framework (Rubin 1974), propensity score theory (Rosenbaum-Rubin 1983), Horvitz-Thompson weighting, semiparametric/nonparametric estimation. Familiarity with the Heckman-Ichimura-Todd (1997, 1998) matching DiD literature is assumed.

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
- **τ**: difference in mean individual fixed effects between treated and controls
- **δ**: time trend = δ(1) − δ(0)
- **X(i)**: vector of predetermined covariates (e.g., pre-treatment earnings Y(i,1−κ), demographics)
- **π(t)**: time-varying coefficient vector on covariates in expanded model (eq. 8)
- **π = π(1) − π(0)**: first-differenced covariate coefficients
- **κ**: positive integer lag (periods before training) in Ashenfelter's dip model
- **Ȳ**: threshold constant in selection model
- **u(i)**: idiosyncratic noise in selection model, independent of variance components

### 5. What do the numbers in the tables mean?
No tables in pages 1–4.

### 6. What are the econometric equations?
**Eq. (1) — Components of variance model:**
Y(i,t) = δ(t) + α·D(i,t) + η(i) + υ(i,t)
Decomposes outcome into time trend, treatment effect, individual fixed effect, transitory shock.

**Eq. (2) — Identification condition (no selection on transitory shocks):**
P(D(i,1)=1 | υ(i,t)) = P(D(i,1)=1)
Selection is independent of individual transitory shocks — the standard unconditional DiD assumption.

**Eq. (4) — Estimable regression form:**
Y(i,t) = µ + τ·D(i,1) + δ·t + α·D(i,t) + ε(i,t)
Under eq. (2), E[(1, D(i,1), t, D(i,t))·ε(i,t)] = 0, so OLS on this equation consistently estimates α.

**Eq. (5) — DiD as a difference of differences:**
α = {E[Y(i,1)|D=1] − E[Y(i,1)|D=0]} − {E[Y(i,0)|D=1] − E[Y(i,0)|D=0]}
The standard 2×2 DiD formula. The least squares estimator of α is the sample analog.

**Eq. (6) — Ashenfelter's dip selection model:**
D(i,1) = 1 if Y(i,1−κ) + u(i) < Ȳ, else 0
Those with low earnings κ periods before training are more likely to participate, violating eq. (2).

**Eq. (7) — Conditional DiD (effect conditional on X):**
{E[Y(i,1)|X(i),D=1] − E[Y(i,1)|X(i),D=0]} − {E[Y(i,0)|X(i),D=1] − E[Y(i,0)|X(i),D=0]}
The conditional analog; X(i) = Y(i,1−κ) in the Ashenfelter's dip case.

**Eq. (8) — Linear covariate adjustment in DiD:**
Y(i,t) = µ + X(i)'π(t) + τ·D(i,1) + δ·t + α·D(i,t) + ε(i,t)
Traditional approach to covariates in DiD; parametric; allows time-varying covariate effects but may be misspecified with heterogeneous treatment effects.

### 7. What are the identifying assumptions?
**Unconditional parallel trends** (implied by eq. 2): In absence of treatment, average outcomes for treated and controls follow the same time path. Sufficient: selection for treatment does not depend on transitory shocks.

**Conditional parallel trends** (motivating eq. 7): When Ashenfelter's dip is present, P(D=1|Y(i,1−κ), υ(i,t)) = P(D=1|Y(i,1−κ)), so DiD holds conditional on X(i) = Y(i,1−κ).

### 8. What is the causal target parameter?
**α = ATT** under the unconditional parametric model. More generally, E[Y¹(1) − Y⁰(1) | D=1], the average treatment effect on the treated in the post-treatment period. The conditional version E[Y¹(1) − Y⁰(1) | X(i), D=1] is the heterogeneous ATT.

### 9. What is the empirical application?
No empirical application in pages 1–4. The motivating examples are Card-Krueger (1994) minimum wage study, Meyer-Viscusi-Durbin (1995) disability benefits, Garvey-Hanka (1999) anti-takeover laws, and Ashenfelter (1978) job training. The paper's own application is absent — this is a pure methods paper.

---

## Chunk 2: Pages 5–8

### 1. What is this paper about?
This chunk introduces the formal potential outcomes framework and derives the core identification result: under conditional parallel trends (Assumption 3.1) and overlap (Assumption 3.2), the ATT can be recovered as a propensity-score-weighted average of temporal changes in the outcome. The key object is the re-weighting function ρ₀ = (D − P(D=1|X)) / (P(D=1|X)·(1−P(D=1|X))), which adjusts the outcome-change distribution to make treated and controls comparable in X-space. The chunk also shows that the conditional ATT — projected onto approximating functions via WLS — can be estimated as a weighted regression, giving a clean two-step semiparametric estimator.

### 2. Why should I care about this?
The central contribution: instead of estimating four nonparametric conditional expectations (the naive approach to eq. 9), you only need to estimate *one* function — the propensity score P(D=1|X) — then do propensity-score-weighted least squares. This reduces the first-step estimation burden by a factor of 4 (or 2 for panel data), sidesteps the curse of dimensionality more gracefully, and produces parametrically summarized results (e.g., "ATT = 200 for women, 150 for men") without restricting the true conditional ATT to be linear.

### 3. Who is the intended audience?
Same as chunk 1. This chunk is the core theoretical contribution; assumes comfort with propensity score theory, Horvitz-Thompson reweighting, and semiparametric efficiency.

### 4. What does the notation mean?
- **Y⁰(i,t)**: potential outcome for individual i at time t *without* treatment (never-treated counterfactual)
- **Y¹(i,t)**: potential outcome for individual i at time t *with* treatment
- **Y(i,t)**: observed outcome = Y⁰(i,t)·(1−D(i,t)) + Y¹(i,t)·D(i,t) (switching equation)
- **D(i)** = D(i,1): shorthand for treatment indicator (treatment only occurs after t=0)
- **Y(i,0) = Y⁰(i,0)** (all individuals untreated in pre-period)
- **Y(i,1) = Y⁰(i,1)·(1−D(i)) + Y¹(i,1)·D(i)**
- **X**: vector of pre-treatment covariates (individual argument i dropped for rest of paper)
- **P(D=1|X)**: propensity score — probability of treatment given covariates
- **ρ₀**: key re-weighting function = (D − P(D=1|X)) / (P(D=1|X)·(1−P(D=1|X)))
  - For treated (D=1): ρ₀ = 1/P(D=1|X)
  - For controls (D=0): ρ₀ = −1/(1−P(D=1|X))
- **P(D=1)**: marginal probability of treatment (unconditional)
- **Xk**: a deterministic function of X — a subset of covariates of interest for the conditional ATT
- **G = {g(Xk; θ): θ ∈ Θ ⊂ ℝᵏ}**: class of approximating functions for conditional ATT (e.g., linear functions Xk'θ)
- **θ₀**: population least squares approximation parameter to E[Y¹(1)−Y⁰(1)|Xk,D=1] from class G

### 5. What do the numbers in the tables mean?
No tables in pages 5–8.

### 6. What are the econometric equations?
**Assumption 3.1 — Conditional parallel trends (the key identifying restriction):**
E[Y⁰(1) − Y⁰(0) | X, D=1] = E[Y⁰(1) − Y⁰(0) | X, D=0]
In absence of treatment, conditional on X, treated and controls have the same average counterfactual time trend.

**Eq. (9) — Conditional ATT identification (Heckman et al. 1997):**
E[Y¹(1) − Y⁰(1) | X, D=1] = {E[Y(1)|X,D=1] − E[Y(1)|X,D=0]} − {E[Y(0)|X,D=1] − E[Y(0)|X,D=0]}
The conditional DiD formula — four expectations to estimate nonparametrically.

**Assumption 3.2 — Overlap (common support):**
P(D=1) > 0 and P(D=1|X) < 1 with probability one.
Some are treated; for every value of X, some remain untreated. Implies support of propensity score for treated is contained in support for untreated.

**Lemma 3.1 — Key reweighting result:**
E[Y¹(1) − Y⁰(1) | X, D=1] = E[ρ₀·(Y(1)−Y(0)) | X]
where ρ₀ = (D − P(D=1|X)) / (P(D=1|X)·(1−P(D=1|X)))
This converts the four-conditional-mean problem into a single propensity-score-weighted average of outcome changes.

**Eq. (10) — ATT as a propensity-score-weighted average:**
E[Y¹(1) − Y⁰(1) | D=1] = E[(Y(1)−Y(0))/P(D=1) · (D−P(D=1|X))/(1−P(D=1|X))]
Under Assumptions 3.1 and 3.2, a simple weighted average of temporal outcome differences recovers the ATT. Weights depend only on the propensity score. The scheme down-weights controls that are over-represented relative to treated (low P(D=1|X)/P(D=0|X)) and up-weights those that are under-represented, imposing the same covariate distribution for both groups.

**Eq. (11) — Parametric approximation to conditional ATT:**
θ₀ = argmin_{θ∈Θ} E[{E[Y¹(1)−Y⁰(1)|Xk,D=1] − g(Xk;θ)}² | D=1]
Least squares projection of the true conditional ATT function onto approximating class G.

**Proposition 3.1 — WLS representation (the estimable form):**
θ₀ = argmin_{θ∈Θ} E[P(D=1|X) · {ρ₀·(Y(1)−Y(0)) − g(Xk;θ)}²]
Estimate θ₀ by weighted least squares of the "pseudo-outcome" ρ₀·ΔY on g(Xk;θ), with propensity score P(D=1|X) as weights. Reduces to eq. (10) when g is constant.

### 7. What are the identifying assumptions?
**Assumption 3.1** (Conditional parallel trends): E[Y⁰(1)−Y⁰(0)|X,D=1] = E[Y⁰(1)−Y⁰(0)|X,D=0]. The counterfactual time trend for treated equals that of controls, conditional on X.

**Assumption 3.2** (Overlap): P(D=1) > 0 and P(D=1|X) < 1 a.s.

These are weaker than "selection on observables" (cross-sectional CIA), because they allow time-invariant unobserved heterogeneity to differ between treated and controls — as long as its effect on outcomes doesn't change over time.

### 8. What is the causal target parameter?
**ATT** = E[Y¹(1) − Y⁰(1) | D=1]: the average effect of treatment on those who received it, in the post-treatment period.

**Conditional ATT** = E[Y¹(1) − Y⁰(1) | Xk, D=1]: how the ATT varies with a subset Xk of covariates. Approximated parametrically by g(Xk; θ₀).

### 9. What is the empirical application?
No empirical application in pages 5–8. Still theoretical development.

---

## Chunk 3: Pages 9–12

### 1. What is this paper about?
This chunk extends the identification and estimation strategy in three directions: (1) from repeated outcomes (panel) to **repeated cross-sections** (the more common empirical setting); (2) a special case of **selection on observables** (cross-sectional CIA); (3) **multilevel/dose-response treatments** (different treatment intensities). It then begins the asymptotic distribution theory (§4), covering both nonparametric (power series) and parametric (probit/logit) first-step estimation of the propensity score, establishing the explicit estimator β̂ and Theorems 4.1–4.2.

### 2. Why should I care about this?
Most DiD applications use repeated cross-sections (CPS, household surveys), not panels. Lemma 3.2 and Proposition 3.2 prove the identification result still holds in that setting, with the only modification being a "double weight" φ₀ that accounts for both time-period membership and treatment status. The multilevel extension covers dose-response questions (weeks of training, amount of subsidy). The asymptotic theory gives practitioners valid inference formulas for the two-step estimator.

### 3. Who is the intended audience?
Same as above. The asymptotic theory in §4 requires familiarity with semiparametric efficiency, power series approximation, and plug-in estimators. Practitioners may skip §4 and implement using Propositions 3.1/3.2 directly.

### 4. What does the notation mean?
**Repeated cross-sections:**
- **Z = (Y, D, T, X)**: observed vector for each individual in the pooled (pre+post) sample
- **T**: time indicator = 1 if observation is from post-treatment sample, 0 if pre-treatment
- **λ**: fraction of observations from the post-treatment period = n₁/(n₀+n₁)
- **Pₘ(·)**: mixture distribution of the pooled sample
- **Eₘ[·]**: expectation with respect to Pₘ
- **φ₀**: extended weight for repeated cross-sections = ((T−λ)/(λ(1−λ))) · ((D−P(D=1|X))/(P(D=1|X)·P(D=0|X)))
  This is a "double weight": one factor adjusts for time-period (pre vs. post), one for treatment assignment.

**Multilevel treatment:**
- **W**: treatment level (W=0 untreated; W⁺ = {w₁,...,wJ} are positive treatment levels)
- **D = 1_{W⁺}(W)**: binary treatment indicator derived from W (1 if any treatment)
- **Yʷ(t)**: potential outcome for treatment level w at time t
- **ρ₀ʷ**: generalized weight for level w = (1_{w}(W)/P(W=w|X)) − (1_{0}(W)/P(W=0|X))
  For binary treatment: ρ₀¹ = ρ₀ from Lemma 3.1.

**Estimation:**
- **β₀**: population parameter from WLS objective = argmin_β Eₘ[π₀·{φ₀Y − Xk'β}²]
- **π₀(X) = P(D=1|X)**: propensity score
- **β̂**: sample estimator of β₀ (the main estimator)
- **π̂(Xᵢ)**: estimated propensity score for observation i
- **φ̂ᵢ**: φ₀ evaluated at π̂(Xᵢ)
- **ζ = (ζ₁,...,ζᵣ)'**: vector of non-negative integers for power series terms
- **pᴷ(X)**: K-vector of power series basis functions (monomials up to order s)
- **K = K(n)**: number of series terms, growing with sample size
- **δ(X)**: correction term in asymptotic variance for first-step estimation error in π₀
- **ψ**: influence function = Xk·π₀(X)·(φ₀Y − Xk'β₀) + δ(X)·(D−π₀(X))
- **Q = E[Xk·D·Xk']**: second moment matrix of the WLS design
- **Σ = Eₘ[ψψ']**: variance of the influence function
- **V = Q⁻¹ΣQ⁻¹**: asymptotic variance of β̂

### 5. What do the numbers in the tables mean?
No tables in pages 9–12.

### 6. What are the econometric equations?
**Assumption 3.3 — Repeated cross-sections sampling:**
Conditional on T=0, data i.i.d. from distribution of (Y(0),D,X); conditional on T=1, data i.i.d. from distribution of (Y(1),D,X).

**Lemma 3.2 — Repeated cross-sections identification:**
E[Y¹(1)−Y⁰(1)|X,D=1] = Eₘ[φ₀·Y|X]
where φ₀ = ((T−λ)/(λ(1−λ))) · ((D−P(D=1|X))/(P(D=1|X)·P(D=0|X)))
The "double weight" combines time-period adjustment with propensity-score reweighting.

**Eq. (12) — ATT for repeated cross-sections:**
Eₘ[(P(D=1|X)/P(D=1))·φ₀·Y] = E[Y¹(1)−Y⁰(1)|D=1]

**Proposition 3.2 — WLS for repeated cross-sections:**
θ₀ = argmin_{θ∈Θ} Eₘ[P(D=1|X)·{φ₀·Y − g(Xk;θ)}²]
Analogous to Proposition 3.1 but using φ₀ instead of ρ₀·(Y(1)−Y(0)).

**Selection on observables special case (eq. 14):**
E[Y⁰(1)|X,D=1] = E[Y⁰(1)|X,D=0]
In this case (which nests standard cross-sectional matching), the same formula applies with Y = Y(1) only and no pre-treatment period required.

**Multilevel, eq. (15):**
θ₀ = argmin_{θ} E[(E[Yᵂ(1)−Y⁰(1)|Xk,W]−g(W,Xk;θ))²|D=1]
Identified by: θ₀ = argmin_{θ} E[Σⱼ P(W=wⱼ|X)·(ρ₀^{wⱼ}·(Y(1)−Y(0))−g(wⱼ,Xk;θ))²]

**Estimator β̂ (explicit form in §4):**
β̂ = (1/n Σᵢ Xkᵢ·π̂(Xᵢ)·Xkᵢ')⁻¹ · (1/n Σᵢ Xkᵢ·π̂(Xᵢ)·φ̂ᵢ·Yᵢ)
Propensity-score-weighted least squares (WLS) regression of φ̂ᵢ·Yᵢ on Xkᵢ.

**Power series propensity score (eq. 16):**
π̂(X) = pᴷ(X)'γ̂, where γ̂ = (Σᵢ pᴷ(Xᵢ)pᴷ(Xᵢ)')⁻(Σᵢ pᴷ(Xᵢ)Dᵢ)

**Theorem 4.1 — Asymptotic normality (nonparametric first step):**
n^{1/2}(β̂−β₀) →ᵈ N(0, V), V = Q⁻¹ΣQ⁻¹
Requires K⁶/n → 0, plus smoothness of π₀ and usual regularity conditions.

**Theorem 4.2:** V̂ →ᵖ V (requires K⁷/n → 0).

### 7. What are the identifying assumptions?
**Assumption 3.3** (Repeated cross-sections): Independence between time periods; each cross-section is i.i.d. from the relevant period distribution.

**Extended Assumption 3.1 for multilevel**: E[Y⁰(1)−Y⁰(0)|X,W=w] = E[Y⁰(1)−Y⁰(0)|X,W=0] for all w ∈ W⁺. In absence of treatment, all treatment-level groups have the same conditional counterfactual time trend.

**Assumption 4.1 (nonparametric first step)**: π₀ is s-times continuously differentiable; X has compact support with density bounded away from zero; π₀ bounded away from 0 and 1; β₀ interior of compact Θ; E_M Y² < ∞; Xk bounded; E[XkXk'|D=1] non-singular.

### 8. What is the causal target parameter?
Same as chunk 2. For multilevel: E[Yʷ(1)−Y⁰(1)|Xk, W=w] — average effect of treatment level w relative to no treatment for those receiving level w, conditional on Xk.

### 9. What is the empirical application?
No empirical application. Section 5 (conclusion) will confirm the paper is purely theoretical.

---

## Chunk 4: Pages 13–16

### 1. What is this paper about?
This chunk concludes §4.2 on parametric (MLE) first-step propensity score estimation — Theorems 4.3 and 4.4 establish asymptotic normality and variance consistency when using probit/logit for the first step. The remainder is the Appendix, containing full mathematical proofs of all Lemmas, Propositions, and Theorems. The proofs confirm the key algebraic fact: the cross-term in the WLS objective (eq. A.1) equals zero, which is what makes the propensity-score-weighted WLS representation (Propositions 3.1/3.2) work.

### 2. Why should I care about this?
Practitioners almost always use logit or probit for the first-step propensity score, not nonparametric series. Theorem 4.3 legitimizes that choice: β̂ is root-n asymptotically normal even with parametric first step, and V̂ is consistent. The influence function for β̂ has two components: a direct second-step term and a correction M_{γ₀}ψ_{γ₀} for first-step estimation error — meaning standard errors must account for the fact that the propensity score was estimated, not known. The proofs of Proposition 3.1 show exactly why the WLS trick works.

### 3. Who is the intended audience?
Theoretical econometricians comfortable with semiparametric efficiency theory. Proofs invoke Newey (1994), Newey (1997), van der Vaart (1998), and Newey-McFadden (1994).

### 4. What does the notation mean?
- **γ̂**: MLE of propensity score parameters = argmax_γ (1/n)Σᵢ[Dᵢ log π(Xᵢ'γ) + (1−Dᵢ)log(1−π(Xᵢ'γ))]
- **π̇ = ∂π(v)/∂v**: derivative of link function w.r.t. index; **π̇₀ = π̇(X'γ₀)**: at true parameters
- **ψ_{γ₀}(Z)**: influence function for MLE = [E(π̇₀²/(π₀(1−π₀))·XX')]⁻¹ · X·(π̇₀/(π₀(1−π₀)))·(D−π₀)
  (This is the standard score-based influence function for maximum likelihood.)
- **M_{γ₀}**: sensitivity of the second-step moment condition to first-step parameter variation = Eₘ[Xk·((T−λ)/(λ(1−λ)))·((D−1)/(1−π₀)²)·(Y−Xk'β₀)·π̇₀X']
- **m(Z,β,γ)**: moment function for the second step = Xk·π(X'γ)·[φ(Z,γ)·Y − Xk'β]
- **| · |∞**: supremum norm
- **Λ(Z,π,β,π̃)**: Gateaux derivative of m with respect to propensity score = [∂m(Z,β,π)/∂π|_{π=π̃}]·π

### 5. What do the numbers in the tables mean?
No tables in pages 13–16.

### 6. What are the econometric equations?
**MLE of propensity score:**
γ̂ = argmax_{γ∈Γ} (1/n)Σᵢ[Dᵢ log π(Xᵢ'γ) + (1−Dᵢ)log(1−π(Xᵢ'γ))]

**Score function/influence function for MLE (eq. 17):**
ψ_{γ₀}(Z) = [E(π̇₀²/(π₀(1−π₀))·XX')]⁻¹ · X·(π̇₀/(π₀(1−π₀)))·(D−π₀)

**Theorem 4.3 — Asymptotic normality (parametric first step):**
√n(β̂−β₀) →ᵈ N(0,V), V = Q⁻¹ΣQ⁻¹
where ψ = m(Z,β₀,γ₀) + M_{γ₀}·ψ_{γ₀} (two-component influence function)

**Theorem 4.4:** V̂ →ᵖ V (requires π(v) twice differentiable with bounded second derivative).

**Key proof step for Proposition 3.1 (eq. A.1) — why WLS works:**
G(θ) = E[P(D=1|X)·{ρ₀·ΔY − E[ATT|Xk,D=1]}²]   [constant in θ]
      + E[P(D=1|X)·{E[ATT|Xk,D=1] − g(Xk;θ)}²]   [minimized at θ₀]
      + 0                                            [cross-term = zero by LIE + Lemma 3.1]
The cross-term vanishing is the algebraic key that makes the whole approach valid.

### 7. What are the identifying assumptions?
**Assumption 4.2** (parametric propensity score): γ₀ interior of compact Γ; X compact support with E[XX'] non-singular; known link function π(·) such that π₀(X) = π(X'γ₀); π(v) bounded away from 0 and 1, strictly increasing, continuously differentiable; β₀ interior of compact Θ; E_M Y² < ∞; Xk bounded; E[XkXk'|D=1] non-singular.

### 8. What is the causal target parameter?
Same throughout: ATT = E[Y¹(1)−Y⁰(1)|D=1] and its conditional approximation β₀ (vector of coefficients in the linear projection of conditional ATT on Xk).

### 9. What is the empirical application?
The conclusions section (§5, beginning on p.13) confirms no separate empirical application is presented in the paper. The paper is a pure methodological contribution. The motivating applications — job training programs and minimum wage studies — appear only in the introduction.

---

## Chunk 5: Pages 17–19

### 1. What is this paper about?
This chunk completes the proof of Theorems 4.3 and 4.4 (parametric first-step case), ending the technical appendix. Pages 18–19 contain the acknowledgements and the full reference list. No new substantive content — this is the tail end of the mathematical proofs (establishment of consistency and asymptotic linearity via the Donsker property and Lipschitz arguments) and the bibliography.

### 2. Why should I care about this?
The completion of Theorem 4.3's proof shows that asymptotic linearity of γ̂ (MLE) feeds cleanly into β̂ via the delta method. The reference list is essential for tracing the intellectual lineage: the key foundational papers are Heckman-Ichimura-Todd (1997, 1998) for conditional DiD identification, Rosenbaum-Rubin (1983) for propensity scores, Rubin (1974) for potential outcomes, Imbens-Hirano-Ridder (2003) for efficient propensity-score weighting, and Newey (1994, 1997) for semiparametric asymptotic theory.

### 3. Who is the intended audience?
Theoretical econometricians completing the proofs; empirical researchers studying the reference list.

### 4. What does the notation mean?
- **p_γ = π(X'γ)^D · (1−π(X'γ))^{1−D}**: likelihood contribution for a single observation
- **l̇_{γ}**: score direction in quadratic mean differentiability = X·(π̇(X'γ)/(π(X'γ)(1−π(X'γ))))·(D−π(X'γ))
- **N_{γ₀}**: convex open neighbourhood of γ₀ in Γ (used to establish Lipschitz property)
- **M_{γ₀}**: derivative of Eₘ[m(Z,β₀,γ)] with respect to γ at γ₀
- **ψ̂_{γ̂}(Zᵢ)**: estimated influence function for γ̂ (used to construct V̂)
- **M̂_{γ̂}**: sample estimator of M_{γ₀}
- **π̈**: second derivative of link function π(v); bounded in Theorem 4.4

### 5. What do the numbers in the tables mean?
No tables in pages 17–19.

### 6. What are the econometric equations?
**Score function:**
l̇_{γ} = X·(π̇(X'γ)/(π(X'γ)(1−π(X'γ))))·(D−π(X'γ))

**Delta method:**
n^{1/2} Eₘ[m(Z,β₀,γ̂)] = n^{1/2} M_{γ₀}(γ̂−γ₀) + o_p(1)

**Asymptotic expansion (proof of Theorem 4.3):**
n^{1/2}(β̂−β₀) = Q⁻¹ · (1/√n) Σᵢ [m(Zᵢ,β₀,γ₀) + M_{γ₀}ψ_{γ₀}(Zᵢ)] + o_p(1)
This is the influence function representation; asymptotic variance is Var(m + M_{γ₀}ψ_{γ₀}).

**Eq. (A.8):** (1/n) Σᵢ ‖m(Zᵢ,β̂,γ̂) − m(Zᵢ,β₀,γ₀)‖² = o_p(1)
Consistency of sample objective to population — needed for V̂ →ᵖ V.

### 7. What are the identifying assumptions?
No new assumptions in this chunk. Proof of Theorem 4.3 additionally uses:
- Donsker property of function class {m(Z,β,γ): ‖β−β₀‖<c, ‖γ−γ₀‖<c} (established via Lipschitz argument using boundedness of X, finite second moments of Y, and smoothness of π)
- Non-singularity of ∂Eₘ[m(Z,β,γ)]/∂β = −E[Xk·π(X'γ)·Xk'] in a neighbourhood of γ₀

### 8. What is the causal target parameter?
Same as all prior chunks: ATT = E[Y¹(1)−Y⁰(1)|D=1] and its conditional/parametric approximation β₀. No new parameters introduced.

### 9. What is the empirical application?
No empirical application in this paper. It is a pure methodological contribution. The final acknowledgements and references confirm the paper's theoretical nature — the empirical motivation cited is job training program evaluation (Ashenfelter 1978, Heckman et al. 1997/1998) but no original empirical analysis is conducted.

---

## Summary: The Abadie (2005) Contribution in Brief

**The problem:** Conventional DiD requires unconditional parallel trends — the same counterfactual time trend for treated and controls, without conditioning on anything. This fails when (a) Ashenfelter's dip is present (selection on transitory shocks), or (b) observed covariates predict outcome dynamics and are unbalanced between groups.

**The solution:** Replace unconditional parallel trends with conditional parallel trends (Assumption 3.1): E[Y⁰(1)−Y⁰(0)|X,D=1] = E[Y⁰(1)−Y⁰(0)|X,D=0]. Under this assumption plus overlap (Assumption 3.2):

ATT = E[(Y(1)−Y(0))/P(D=1) · (D−P(D=1|X))/(1−P(D=1|X))]

**The estimator (two steps):**
1. Estimate the propensity score P(D=1|X) via logit/probit or nonparametric series.
2. Run propensity-score-weighted OLS of φ̂ᵢ·Yᵢ on Xkᵢ (the desired conditioning variables), using π̂(Xᵢ) as weights.

**Key advantages:**
- Works with repeated cross-sections (not just panel data)
- Identifies heterogeneous ATT: how the effect varies with covariates Xk
- Only one function to estimate nonparametrically (propensity score), not four
- Handles multilevel treatments
- Asymptotically normal with valid sandwich standard errors (accounting for first-step estimation)
- Nonparametric identification + parametric approximation (the "White 1981 spirit")
