# Heckman, Ichimura & Todd (1997) — Deep Reading Notes
## "Matching as an Econometric Evaluation Estimator: Evidence from Evaluating a Job Training Programme"
## Review of Economic Studies, 64(4): 605–654

---

## Chunk 1: Pages 1–4

### 1. What is this paper about?
The paper asks whether nonexperimental methods can replicate experimental estimates of job training programme impacts. It proposes a two-stage matching methodology: (a) estimate propensity scores and (b) use them in classical and extended matching estimators including a new conditional difference-in-differences extension. The paper decomposes evaluation bias into its components, tests the identifying assumptions, and finds that data quality features (same labour market, same questionnaire) matter more than selection-on-unobservables bias.

### 2. Why should I care about this?
This is the foundational applied paper that evaluates when matching "works" as a substitute for randomized experiments. Its key finding — that the LaLonde (1986) critique of nonexperimental methods is largely attributable to questionnaire mismatch and geographic mismatch, not econometric failure — reshapes how researchers think about comparison group construction. It also introduces the nonparametric conditional DiD estimator as a weaker-assumption alternative to matching.

### 3. Who is the intended audience?
Labor economists and econometricians familiar with program evaluation, potential outcomes notation, the Rosenbaum-Rubin (1983) propensity score literature, and Heckman-Robb (1985/1986) selection correction methods. Prior knowledge of JTPA and LaLonde (1986) assumed.

### 4. What does the notation mean?
- Y₁, Y₀: potential outcomes under treatment (1) and no-treatment (0)
- D: treatment indicator (D=1 if treated, D=0 otherwise)
- Y = DY₁ + (1-D)Y₀: observed outcome (switching equation)
- Δ = Y₁ - Y₀: individual-level treatment gain
- X: vector of observed covariates
- U₁, U₀: unobservable error terms in treated and untreated outcome equations
- g₁(X), g₀(X): systematic (observable) components of Y₁, Y₀
- β₁, β₀: linear coefficient vectors in the parametric special case g_j(X)=Xβ_j
- R: randomization indicator (R=1 if randomized into programme, R=0 if randomized out)
- M(S): mean treatment effect on the treated, averaged over subset S of X-support conditional on D=1
- F(·): CDF notation; F₀(y₀|D=1,X) = conditional CDF of Y₀ for the treated
- S: subset of support of X given D=1 over which M(S) is defined

### 5. What do the numbers in the tables mean?
Table 1 is described but its content is in chunk 2 (pages 5–8). This chunk only describes it: it tabulates features of nonexperimental comparison groups used in prior evaluations of U.S. job training programs, showing how many studies used same-labour-market controls and same questionnaires.

### 6. What are the econometric equations?
**Eq. (1a):** Y₁ = g₁(X) + U₁  — treated potential outcome as systematic + stochastic component  
**Eq. (1b):** Y₀ = g₀(X) + U₀  — untreated potential outcome  
**Switching equation:** Y = DY₁ + (1-D)Y₀  — observed outcome  
**Eq. (2):** E(Y₁-Y₀|X,D=1) = g₁(X) - g₀(X) + E(U₁-U₀|X,D=1) — conditional ATT  
**Eq. (3):** M(S) = [∫_S E(Δ|X,D=1)dF(X|D=1)] / [∫_S dF(X|D=1)] — averaged ATT over region S

### 7. What are the identifying assumptions?
Not yet formally introduced in this chunk; identification discussion begins in Section 3 (chunk 2). This chunk introduces the fundamental identification problem: Y₀ is unobserved for treated units, making E(Y₀|D=1,X) the missing counterfactual.

### 8. What is the causal target parameter?
**ATT (Average Treatment Effect on the Treated):** M(S) = ∫_S E(Δ|X,D=1)dF(X|D=1) / ∫_S dF(X|D=1)  
This is the mean gain to programme participants from the programme, averaged over the distribution of X among participants (D=1), restricted to a region S of the support.

### 9. What is the empirical application?
The JTPA (Job Training Partnership Act) programme for disadvantaged U.S. workers. The programme provides on-the-job training, job search assistance, and classroom training. The dataset includes treatment, randomized-out controls, and eligible nonparticipants (ENPs). The outcome is earnings. Time period: mid-1980s to early 1990s. Four demographic groups are examined. Full data description deferred to Section 7.

---

## Chunk 2: Pages 5–8

### 1. What is this paper about?
This chunk formalizes how randomization identifies the ATT, introduces matching (assumption A-1: strong ignorability) as the nonexperimental substitute, discusses the propensity score dimension-reduction result (Rosenbaum-Rubin), and identifies three additional features of experimental data that matching cannot replicate automatically: common support, common questionnaire, and common labour market. It also introduces the weaker mean independence assumptions (A-3, A-4) that suffice for matching and begins discussing extensions including exclusion restrictions.

### 2. Why should I care about this?
This chunk is the conceptual core of the paper's matching framework. It establishes that (a) the propensity score P(X) can reduce the dimensionality problem, (b) strong ignorability (A-1 + A-2) is sufficient but not necessary — A-3 suffices — and (c) three non-statistical features of comparison group data drive much of the bias in evaluation studies. The practical implication: get the comparison group in the same city with the same survey before worrying about selection bias.

### 3. Who is the intended audience?
Same as Chunk 1: labor/applied econometricians. Knowledge of Rosenbaum-Rubin (1983) propensity score theory expected.

### 4. What does the notation mean?
- R: randomization indicator (R=1 randomized in, R=0 randomized out), introduced more fully here
- P(X) = Pr(D=1|X): propensity score — probability of treatment given observables
- "⊥⊥" (double perpendicular): statistical independence symbol
- A-1: (Y₁,Y₀) ⊥⊥ D|X — "strong ignorability" (full conditional independence of both potential outcomes and treatment)
- A-2: 0 < Pr(D=1|X) < 1 — common support / overlap condition
- A-3: Y₀ ⊥⊥ D|X — weaker one-sided conditional independence (only Y₀ need be independent of D)
- A-4: E(Y₀|P(X),D=1) = E(Y₀|P(X),D=0) — mean independence version via propensity score
- X = (T,Z): partition of covariates where T appear in outcome equations, Z appear in participation equation (exclusion restriction partition)
- F₀(y₀|D=1,X): conditional CDF of untreated outcome for the treated population
- "Support": the set of X values with positive probability density

### 5. What do the numbers in the tables mean?
**Table 1** (described in this chunk): A catalogue of nonexperimental comparison groups from previous U.S. job training programme evaluations. Rows 1 and 2 record whether studies used (1) same-labour-market comparison groups and (2) same questionnaire for both treatment and comparison groups. Key finding: most studies, including LaLonde (1986), fail on both dimensions. The table motivates the paper's conclusion that questionnaire and geographic mismatch — not selection on unobservables — is the dominant source of evaluation bias.

### 6. What are the econometric equations?
**Eq. (4a):** E(Y|X,D=1,R=1) = E(Y₁|X,D=1) = g₁(X) + E(U₁|X,D=1) — mean outcome for randomized-in  
**Eq. (4b):** E(Y|X,D=1,R=0) = E(Y₀|X,D=1) = g₀(X) + E(U₀|X,D=1) — counterfactual mean from randomized-out  
**Eq. (5):** E(Y|X,D=1,R=1) - E(Y|X,D=1,R=0) = g₁(X) - g₀(X) + E(U₁-U₀|X,D=1) = E(Δ|X,D=1) — experimental ATT estimand  
**Eq. (6):** E(Y₀|X,D=1) = E(Y₀|X,D=0) = E(Y₀|X) — matching assumption: nonparticipants' outcomes proxy treated counterfactual  
**A-4:** E(Y₀|P(X),D=1) = E(Y₀|P(X),D=0) — weaker mean independence via propensity score

### 7. What are the identifying assumptions?
- **(A-1)** (Y₁,Y₀) ⊥⊥ D|X — "strong ignorability": both potential outcomes are independent of treatment status given X. Rules out selection on unobservable outcomes.
- **(A-2)** 0 < Pr(D=1|X) < 1 — common support/overlap: every value of X must have positive probability of both treatment and control.
- **(A-3)** Y₀ ⊥⊥ D|X — weaker than A-1; only the untreated potential outcome need be independent of D given X. Sufficient for ATT identification.
- **(A-4)** E(Y₀|P(X),D=1) = E(Y₀|P(X),D=0) — weakest version: mean independence via propensity score only. Derived from A-1+A-2 but can be maintained separately.

Together A-1 and A-2 = "strong ignorability" (Rosenbaum-Rubin). The paper argues A-3 or A-4 suffice for estimating M(S).

### 8. What is the causal target parameter?
ATT: M(S) as defined in Chunk 1. Randomization identifies E(Δ|X,D=1) as shown in Eq. (5). Matching attempts to reproduce this identification nonexperimentally using A-1/A-3/A-4.

### 9. What is the empirical application?
Same JTPA application. Table 1 reviews LaLonde (1986) and related evaluations to motivate the paper's critique of how comparison groups are chosen.

---

## Chunk 3: Pages 9–12

### 1. What is this paper about?
This chunk presents: (1) the exclusion restriction partition X=(T,Z) and its residual independence extensions (A-3', A-4'); (2) the new nonparametric conditional difference-in-differences estimator D_{t,t'}(X) and its identifying assumption A-5/A-5'; (3) the bias function B(X) and its index property (P-1) established in prior work; (4) Section 6 on determinants of JTPA participation (unemployment dynamics matter more than earnings histories); and (5) the start of Section 7 describing the JTPA experimental data — the National JTPA Experiment, eligible nonparticipants (ENPs), and the four study sites.

### 2. Why should I care about this?
The conditional DiD estimator D_{t,t'}(X) is the paper's key innovation over conventional matching. Assumption A-5 — that pre-programme trends in Y₀ are the same for participants and nonparticipants conditional on X — is substantially weaker than A-3/A-4 and is consistent with Roy-model self-selection on unobservables. The index property of bias (P-1) is the empirical regularity motivating the whole propensity-score approach. The participation analysis (Section 6) shows why unemployment history matters more than earnings history as a matching variable.

### 3. Who is the intended audience?
Same. The DiD extension requires understanding of panel data and selection models. Knowledge of Ashenfelter's dip and JTPA eligibility rules assumed.

### 4. What does the notation mean?
- T: variables appearing in outcome equations (subset of X)
- Z: variables appearing in participation equation (subset of X); T and Z may overlap
- Pr(D=1|Z): propensity score using only participation-equation variables Z
- U₀: untreated potential outcome residual (same as before)
- A-3': Pr(U₀≤u₀|T,Z,D) = Pr(U₀≤u₀|Z,D) — distributional independence of U₀ from T given Z,D
- A-4': E(U₀|T,Z,D) = E(U₀|Z,D) — mean independence of U₀ from T given Z,D
- t: time period after programme start
- t': time period before programme start
- Y_{1t}: treated potential outcome at post-period t
- Y_{0t}, Y_{0t'}: untreated potential outcomes at post-period t and pre-period t'
- D_{t,t'}(X) = E(Y_{1t}-Y_{0t'}|X,D=1) - E(Y_{0t}-Y_{0t'}|X,D=0) — conditional DiD moment
- B(X) = E(Y₀|X,D=1) - E(Y₀|X,D=0) — selection bias function
- B̃(P(X)): bias as a function of the single index P(X) — index-sufficient representation
- (P-1): index property: B(X) = B̃(P(X))
- (P-2): B(X) = B̃(P(X)) = 0 — the matching condition (bias is zero for all X)
- B_t(X): bias at time t; B_{t'}(X): bias at time t'
- ENPs: Eligible NonParticipants — the nonexperimental comparison group

### 5. What do the numbers in the tables mean?
No new tables appear in this chunk. The empirical content is narrative (Section 6: participation determinants from Heckman and Smith (1994)).

### 6. What are the econometric equations?
**Eq. (7a):** Y₁ = g₁(T) + U₁ — treated outcome using T (outcome-relevant covariates only)  
**Eq. (7b):** Y₀ = g₀(T) + U₀ — untreated outcome using T only  
**A-3':** Pr(U₀≤u₀|T,Z,D) = Pr(U₀≤u₀|Z,D) — distributional exclusion restriction on U₀  
**A-4':** E(U₀|T,Z,D) = E(U₀|Z,D) — mean exclusion restriction on U₀  
**Conditional DiD moment:** D_{t,t'}(X) = E(Y_{1t}-Y_{0t'}|X,D=1) - E(Y_{0t}-Y_{0t'}|X,D=0)  
**A-5 (DiD identifying assumption):** E(Y_{0t}-Y_{0t'}|X,D=1) = E(Y_{0t}-Y_{0t'}|X,D=0)  
Equivalently under additive separability: E(U_{0t}-U_{0t'}|X,D=1) = E(U_{0t}-U_{0t'}|X,D=0), i.e. B_t(X) = B_{t'}(X)  
**A-5' (index-sufficient version):** E(U_{0t}-U_{0t'}|P(Z),D=1) = E(U_{0t}-U_{0t'}|P(Z),D=0)  
**Eq. (8):** B(X) = E(Y₀|X,D=1) - E(Y₀|X,D=0) — definition of bias function  
**Eq. (9):** B(X) = E(U₀|X,D=1) - E(U₀|X,D=0) — bias in terms of residuals under additive separability  
**Index property (P-1):** B(X) = B̃(P(X)) — bias depends on X only through propensity score  
**Matching condition (P-2):** B(X) = B̃(P(X)) = 0 — zero bias everywhere (the assumption matching requires, which the paper rejects)

### 7. What are the identifying assumptions?
- **(A-3')** Distributional exclusion: conditional distribution of U₀ does not depend on T once Z and D are conditioned on. Stronger than A-4' but weaker than A-3.
- **(A-4')** Mean exclusion: E(U₀|T,Z,D) = E(U₀|Z,D). Enables regression-adjusted matching.
- **(A-5)** Pre-programme trends in Y₀ are the same for D=1 and D=0 conditional on X. This is the DiD identifying assumption. It does NOT require Y₀ levels to be equal; only that changes from t' to t are equal in expectation.
- **(A-5')** Index-sufficient version of A-5 using P(Z) instead of X.
- **A-5 is strictly weaker than A-3/A-4**: it permits selection based on unobservable levels of Y₀, as long as the time trend in Y₀ is common.

### 8. What is the causal target parameter?
Still ATT. D_{t,t'}(X) converges to E(Δ|X,D=1) under A-5. The averaged ATT M(S) is the ultimate estimand.

### 9. What is the empirical application?
**JTPA — National Job Training Partnership Act Experiment:**
- Programme: on-the-job training, job search assistance, classroom training for disadvantaged workers
- Eligibility: family income near/below poverty line for 6 months prior, or welfare/food stamp recipient
- Experimental design: 2/3 of accepted applicants treated, 1/3 randomized out for 18 months
- Four sites: Fort Wayne (Indiana), Corpus Christi (Texas), Jersey City (New Jersey), Providence (Rhode Island)
- Comparison group: ENPs (Eligible NonParticipants) — same geography, same questionnaire as controls
- Data: 36-month panel (18 months pre, 18 months post) from baseline + 2 follow-up surveys
- Response rate: ~84%
- Four demographic groups studied (adult men, adult women, male youth, female youth implied)
- Outcome: earnings

---

## Chunk 4: Pages 13–16

### 1. What is this paper about?
This chunk completes the description of the JTPA data (Section 7), presents the full Table 1 comparing nonexperimental comparison groups across major evaluations, introduces Section 8 on estimating P(X) via logit, and presents Figure 1 showing propensity score histograms for adult males and male youth. The key finding: the propensity score distributions for ENPs (D=0) and controls (D=1) have very limited common support.

### 2. Why should I care about this?
Figure 1 is the visual proof that common support fails dramatically in practice. The propensity score mass for ENPs (controls) is heavily concentrated at low P values (near zero), while programme participants are spread across the P distribution. This means M(S) is only identified over a narrow overlap region, and the experimental and nonexperimental estimates implicitly target different populations. This motivates the trimming rules and the support-restriction approach used throughout the paper.

### 3. Who is the intended audience?
Same applied econometricians. Knowledge of logit models for participation equations assumed.

### 4. What does the notation mean?
- P̂(X): estimated propensity score from a logit model
- P̂: sample proportion of eligible persons taking training (classification threshold)
- Hit-or-miss method: classification rule that assigns observation to D=1 if P̂(X) > P̂, maximizing overall correct classification rate
- S_P: region of overlapping P support between D=1 and D=0 (the "overlap region")
- Trimming rules: 2% trimming for adults, 5% for youth — boundary observations excluded from overlap region (Appendix C)

### 5. What do the numbers in the tables mean?
**Table 1 (full):** Rows are features of comparison group design; columns are studies (Ashenfelter 1978, Ashenfelter & Card 1985, Dickinson-Johnson-West 1987, Westat 1986, LaLonde 1986, Fraker & Maynard 1987, JTPA data).
- Row 1 (same labour market): All studies before the JTPA data = "No." The JTPA ENP data = "Yes."
- Row 2 (same questionnaire): Most = "No." LaLonde = "No." JTPA ENP = "Yes."
- Row 4 (programme eligibility known): All prior studies = "No." JTPA ENP = "Yes."
- Variables available: prior studies generally lack unemployment histories; JTPA has 5 years of pre-programme monthly earnings and labour force histories.
The pattern establishes that LaLonde's comparison groups are deficient on all dimensions the paper identifies as critical.

**Figure 1:** Histograms of estimated P for adult males and male youth. ENPs have very high density at P ≈ 0–0.025 and almost no mass above 0.225. Controls have mass spread across the full range including high P values. The overlap is very thin.

### 6. What are the econometric equations?
**Logit model for participation:** Pr(D=1|X) = Λ(Xγ) where Λ is the logistic CDF, γ estimated to maximize in-sample hit-or-miss classification rate.  
**Classification rule:** Assign to D=1 if P̂(X) > P̂ (sample training rate).

### 7. What are the identifying assumptions?
No new identifying assumptions introduced. This chunk is empirical/descriptive. The key empirical finding is that common support (assumption A-2) approximately fails: propensity score supports of participants and ENPs barely overlap.

### 8. What is the causal target parameter?
M(S) over S = S₁₀ (common support region). The chunk emphasizes that when support differs, M(S)_experimental ≠ M(S)_nonexperimental because they implicitly define M over different subsets S.

### 9. What is the empirical application?
JTPA. Four demographic groups: adult males, adult females, male youth, female youth. Four sites: Fort Wayne, Corpus Christi, Jersey City, Providence. Logit model estimated separately for each group. Key predictors: site, age, race, education, marital status, children under 6, labour force transition histories, earnings at month of random assignment.

---

## Chunk 5: Pages 17–20

### 1. What is this paper about?
This chunk completes Figure 1 (adult females and female youth propensity score histograms), then presents Section 9 on decomposing the conventional measure of evaluation bias B into three components: B₁ (non-overlapping support), B₂ (density weighting), and B₃ (selection on unobservables). It derives the decomposition analytically and empirically, and presents Table 2 (upper two panels: ENP comparison and SIPP comparison group) showing the magnitude of each component.

### 2. Why should I care about this?
Table 2 is the quantitative heart of the paper's central claim. For the ENP comparison group, B₃ (selection bias, rigorously defined) is small and statistically insignificant — only −7% to +94% of the simple mean difference, while B₁ and B₂ dominate. This definitively reframes the evaluation bias problem: the "econometric problem" (selection on unobservables) is empirically secondary. The SIPP comparison group shows much larger B₃ (up to 676% of treatment impact), confirming that questionnaire and geographic mismatch amplify all components.

### 3. Who is the intended audience?
Applied econometricians and program evaluators. Requires understanding of distributional support, density weighting, and local linear regression.

### 4. What does the notation mean?
- B: overall conventional bias = E(Y₀|D=1) - E(Y₀|D=0) (unconditional on X)
- S₁: support of X for D=1 (treated/controls)
- S₀: support of X for D=0 (comparison group)
- S₁₀: overlapping support region S₁ ∩ S₀
- S₁\S₁₀: part of treated support with no comparable controls
- S₀\S₁₀: part of control support with no comparable treated
- B₁: non-overlap bias component — mismatched support
- B₂: density weighting bias — different distribution of X over common support
- B₃: selection on unobservables — bias remaining after controlling for X and reweighting
- B̄_Sx: average selection bias over the common support, weighted by f(X|D=1)
- Y⁰₀ᵢ: outcome of randomized-out control i (D=1, R=0)
- Y⁰₀ⱼ: outcome of comparison group member j (D=0)
- N₁*: sample size of randomized-out controls
- N₀: sample size of comparison group
- Ŷ⁰₀(P): value of Y₀ for D=1 member with propensity score P
- Ŷ⁰₀(P): value of Y₀ for D=0 member with propensity score P
- Ê(Y₀|P,D=0): local linear regression estimate of E(Y₀|P,D=0)
- V₁, V₀: residuals from projecting E(Y₀|X,D) onto P(X) — orthogonal to P

### 5. What do the numbers in the tables mean?
**Table 2 (ENP comparison, upper panel):** Monthly earnings units, bootstrapped SEs (50 replications).
- Adult males: B = −342; B₁ = +218 (−64%), B₂ = −584 (+170%), B₃ = +23 (−7%); average bias B_Sp = 38; this is 87% of experimental treatment impact.
- Adult females: B = +33; B₁ = +80 (+242%), B₂ = −78 (−235%), B₃ = +31 (+94%); B_Sp = 38; 129% of impact.
- Male youth: B = +20; B₁ = +142 (+704%), B₂ = −131 (−650%), B₃ = +9 (+46%); B_Sp = 14; 23% of impact.
- Female youth: B = +42; B₁ = +74 (+177%), B₂ = −67 (−161%), B₃ = +35 (+84%); B_Sp = 49; 7239% of impact (very small experimental impact in denominator).
Conclusion: B₁ and B₂ are large and roughly offsetting; B₃ is small and statistically insignificant for all groups with ENPs. But even small B_Sp is large relative to the treatment impact.

**Table 2 (SIPP comparison, lower panel):** Larger and mostly statistically significant B₃ values (up to +122 for adult males and females). B_Sp = 192 for adult males (440% of impact), 198 for adult females (676% of impact). SIPP comparison groups are from different geographic areas with different questionnaires, producing much larger residual selection bias.

**Table 2 (No-shows, third panel):** Near-zero B₁ (good overlap — no-shows are in same site), larger B₃ particularly for youth. No-shows have selection bias component of 97–171% of treatment impact for males.

### 6. What are the econometric equations?
**Bias decomposition:**  
B = ∫_{S₁} E(Y₀|X,D=1)f(X|D=1)dX − ∫_{S₀} E(Y₀|X,D=0)f(X|D=0)dX  
= B₁ + B₂ + B₃  

**B₁** (non-overlap) = ∫_{S₁\S₁₀} E(Y₀|X,D=1)f(X|D=1)dX − ∫_{S₀\S₁₀} E(Y₀|X,D=0)f(X|D=0)dX  

**B₂** (density weighting) = ∫_{S₁₀} E(Y₀|X,D=0){f(X|D=1)−f(X|D=0)}dX  

**B₃** (selection on unobservables) = ∫_{S₁₀} {E(Y₀|X,D=1)−E(Y₀|X,D=0)}f(X|D=1)dX  

**B̄_Sx** = ∫_{S₁₀} {E(Y₀|X,D=1)−E(Y₀|X,D=0)}f(X|D=1)dX / ∫_{S₁₀} f(X|D=1)dX  

**Sample estimator of B:** B̂ = (1/N₁*) Σᵢ Y¹₀ᵢ − (1/N₀) Σⱼ Y⁰₀ⱼ  

**Sample bias decomposition (in P):**  
B̂ = [non-overlap term] + [density weighting term using Ê(Y₀|Pᵢ,D=0)] + [residual selection term Y¹₀(Pᵢ)−Ê(Y₀|Pᵢ,D=0)]

### 7. What are the identifying assumptions?
No new assumptions. This section tests whether B₃ = 0 (which is what A-3/A-4 require). The empirical finding for ENPs: B₃ ≈ 0 (not statistically different from zero), suggesting A-3/A-4 cannot be firmly rejected on mean grounds alone — but the average masks point-wise variation in B(P).

### 8. What is the causal target parameter?
ATT: M(S₁₀) over the common support. The paper emphasizes that M(S) differs depending on whether S = S₁ (experimental support) or S = S₁₀ (common support), which is another source of discrepancy between experimental and nonexperimental estimates.

### 9. What is the empirical application?
JTPA, same four groups, ENPs and SIPP comparison groups. Y₀ = average monthly earnings over 18 months post-random assignment. Bias B measured in monthly dollar terms. Local linear regression with biweight kernel, bandwidth 0.06 used for Ê(Y₀|P,D=0). Bootstrap SEs from 50 replications (100% sampling).

---

## Chunk 6: Pages 21–24

### 1. What is this paper about?
This chunk presents: (1) the remainder of Table 2 (no-shows panel); (2) discussion of what matching eliminates (B₁ and B₂) and what it doesn't (B₃); (3) Section 10 — formal testing of identifying assumptions A-3, A-3', A-4, A-4', A-5, A-5' using pre-programme and post-programme data; (4) the test statistics for conditional independence and mean independence using local linear regression; and (5) Table 3(a) (p-values for H(A-4) and H(A-4')) and Table 3(b) (p-values for H(A-5) and H(A-5')).

### 2. Why should I care about this?
Tables 3(a) and 3(b) are the key specification tests. The results confirm: (a) A-3 and A-3' are decisively rejected — conventional matching is not justified; (b) A-4 and A-4' are also generally rejected, especially in pre-programme periods — mean independence fails; (c) A-5 and A-5' (the DiD identifying assumptions) are NOT rejected for any group. This provides the formal empirical basis for preferring the conditional DiD estimator over conventional matching. The testing methodology (local linear regression chi-squared tests) is itself a contribution.

### 3. Who is the intended audience?
Econometricians comfortable with nonparametric testing, chi-squared test statistics, local linear regression, and panel data. This is the most technical chunk so far.

### 4. What does the notation mean?
- F̂_d(p) = F̂(y₀|P=p, D=d): estimated conditional CDF at point P=p, D=d using local linear regression
- m̂_d(p) = Ê(Y₀|P=p, D=d): estimated conditional mean via local linear regression
- B_d, V_d: bias and variance of local linear regression estimator for group d (defined in Appendix A)
- B̃_d, Ṽ_d: bias and variance terms for the mean estimator
- V̂₁, V̂₀: consistent variance estimators for conditional CDF estimators
- Ṽ₁, Ṽ₀: feasible covariance estimators for conditional mean estimators
- χ²(1): chi-squared distribution with 1 degree of freedom — test statistic distribution under null
- χ²_T: T-dimensional chi-squared — for vector tests
- H(A-3): null of conditional distributional independence F(Y₀|P,D=1) = F(Y₀|P,D=0)
- H(A-3'): same for U₀ residuals
- H(A-4): null of conditional mean independence E(Y₀|P,D=1) = E(Y₀|P,D=0)
- H(A-4'): same for U₀ residuals
- H(A-5): null of DiD mean independence E(Y₀t-Y₀t'|P,D=1) = E(Y₀t-Y₀t'|P,D=0)
- H(A-5'): same for U₀ residuals
- "Overall" p-value: test statistic pooled across all P-points and quarters
- Bandwidth 0.06, biweight kernel: nonparametric smoothing parameters used throughout

### 5. What do the numbers in the tables mean?
**Table 3(a) — p-values for H(A-4) and H(A-4'):**  
Rows = values of P (0.0025 to 0.10) and "Overall"; Columns = four demographic groups × pre/post × earnings/residuals.  
Reading: a small p-value = rejection of mean independence (= matching assumption fails).

Key findings:
- Adult males: "Overall" pre-programme p = 0.0159 (reject A-4); post = 0.0000 (strong rejection)
- Adult females: "Overall" pre = 0.0006 (reject); post = 0.0000 (strong rejection)
- Male youth: "Overall" pre = 0.0147 (reject); post = 0.0251 (borderline reject); residuals post = 0.3561 (fail to reject A-4')
- Female youth: "Overall" pre = 0.0009 (reject); post = 0.0000 (reject)
Conclusion: A-4 is rejected for all groups in pre-programme period. The regression-adjusted version (A-4') passes for male youth only.

**Table 3(b) — p-values for H(A-5) and H(A-5'):**  
Test is joint across post-programme quarters t=1 to 6, for symmetric pre-post differences.  
"Overall" p-values: Adult males earnings = 0.5260, residuals = 0.4403; Adult females earnings = 0.3364, residuals = 0.0506; Male youth earnings = 0.9832, residuals = 0.9910; Female youth earnings = 0.0533, residuals = 0.2119.  
Conclusion: No group rejects A-5 or A-5' at conventional significance levels (all overall p-values ≥ 0.05 except adult females residuals at borderline 0.051). The DiD assumption is supported.

### 6. What are the econometric equations?
**Test statistic for H(A-3) at point p:**  
(F̂₁(p) − F̂₀(p))′(V̂₁ + V̂₀)⁻¹(F̂₁(p) − F̂₀(p)) ~ χ²(1) under the null  

**Test statistic for H(A-4) at point p:**  
(m̂₁(p) − m̂₀(p))′(Ṽ₁ + Ṽ₀)⁻¹(m̂₁(p) − m̂₀(p)) ~ χ²_T under the null  

Note: local linear regression is used so bias terms B_d cancel in the difference when using the same kernel/bandwidth — this is a key technical advantage over ordinary kernel regression.

**Tests of H(A-5):** Same structure as H(A-4) test, using Y₀t − Y₀t' differences in place of Y₀ levels. Tests H(A-5') use U₀ residuals similarly.

### 7. What are the identifying assumptions?
All six assumptions are formally tested here. Results:
- **(A-3), (A-3')**: Rejected (distributional independence fails)
- **(A-4), (A-4')**: Generally rejected (mean independence fails); exception is A-4' for male youth post-programme
- **(A-5), (A-5')**: Not rejected for any demographic group — the DiD assumption stands

### 8. What is the causal target parameter?
ATT, M(S). The tests use pre-programme data to evaluate whether identifying conditions that must hold in pre-programme periods (as a falsification check) actually hold. Pre-programme rejection of A-4 means the matching assumption is violated.

### 9. What is the empirical application?
JTPA, same four groups. Tests run over P-points from 0.0025 to 0.10 and "Overall." Pre-programme = quarters t=−1 to t=−6; post-programme = quarters t=1 to t=6. Bandwidth 0.06, biweight kernel.

---

## Chunk 7: Pages 25–28

### 1. What is this paper about?
This chunk concludes Section 10 (confirmation that A-5/A-5' are not rejected), then presents Section 11 — a unified framework for all matching estimators — and begins Section 12 on evaluating performance. It defines nearest-neighbour, caliper, kernel-based, and local linear matching estimators within the general Eq. (10) framework. It also introduces the regression-adjusted and conditional DiD versions. Section 12.1 formalizes the support problem and defines M(S_E) vs M(S_P).

### 2. Why should I care about this?
This is the taxonomy that every practitioner needs. The unified Eq. (10) nests all matching estimators as special cases differing only in the weights W(i,j). The formalization of M(S_E) vs M(S_P) (experimental vs overlap support) explains why experimental and nonexperimental estimates differ even when there is no selection bias — they estimate different parameters over different populations.

### 3. Who is the intended audience?
Applied econometricians who implement matching. The kernel/local linear weight formulas require knowledge of nonparametric estimation. References to Fan (1992) on local linear regression assumed known.

### 4. What does the notation mean?
- M̂(S): general matching estimator, Eq. (10)
- Q_{1i}: treated (participant) outcome possibly regression-adjusted
- Q_{0j}: comparison group outcome possibly regression-adjusted
- ω_{N₀,N₁}(i): weight for participant i accounting for heteroscedasticity/scale
- W_{N₀,N₁}(i,j): weight for comparison group member j in match for i; sums to 1 over j
- I₁: index set for programme participants (D=1)
- I₀: index set for comparison group members (D=0)
- C(X_i): neighbourhood of X_i within which matches are found
- A_i: set of matched comparators for participant i
- ε: caliper tolerance (maximum distance for a valid caliper match)
- ||X_i − X_j||: distance metric (e.g. Euclidean or Mahalanobis)
- Σ: covariance matrix of X from D=1 sample (for Mahalanobis metric)
- G_{ik} = G((X_i−X_k)/a_{N₀}): kernel function evaluated at (X_i−X_k)/bandwidth
- a_{N₀}: bandwidth parameter → 0 as N₀ → ∞
- W_{N₀,N₁}(i,j) local linear formula (Eq. 11): the local linear regression weights
- S_E: support of X in experimental data
- S_P = S₁₀: region of common P-support (overlap) between participants and comparison group
- M(S_E): experimental ATT over full experimental support
- M(S_P) = M(S₁₀): ATT restricted to common support (what nonexperimental estimators can identify)
- D̂_{t,t'}(S): conditional DiD estimator = M̂_t(S) − M̂_{t'}(S)
- D̃_{t,t'}(S): regression-adjusted conditional DiD estimator
- β̂₀_t: estimated outcome equation coefficient at time t

### 5. What do the numbers in the tables mean?
No new tables in this chunk. Section 12.1 is narrative.

### 6. What are the econometric equations?
**General matching estimator (Eq. 10):**  
M̂(S) = Σ_{i∈I₁} ω_{N₀,N₁}(i) [Q_{1i} − Σ_{j∈I₀} W_{N₀,N₁}(i,j) Q_{0j}], for X ∈ S

**Nearest-neighbour:** W(i,j) = 1 if j∈A_i (singleton); 0 otherwise  
**Caliper condition:** ||X_i−X_j|| < ε  
**Kernel matching weight:** W_{N₀,N₁}(i,j) = G_{ij} / Σ_{k∈I₀} G_{ik}  
**Local linear weight (Eq. 11):** See paper for full formula — numerically adjusts kernel weight by local curvature  
**Regression-adjusted:** Q_{1i} = Y_{1i} − X_i β̂₀; Q_{0j} = Y_{0j} − X_j β̂₀  
**DiD matching:** Q_{1i} = Y_{1it} − Y_{0it'}, Q_{0j} = Y_{0jt} − Y_{0jt'} in Eq. (10)  
Equivalently: D̂_{t,t'}(S) = M̂_t(S) − M̂_{t'}(S)

### 7. What are the identifying assumptions?
No new assumptions. The regression-adjusted matching estimator requires A-4'; the DiD estimator requires A-5/A-5'. Both are special cases of the general Eq. (10) framework.

### 8. What is the causal target parameter?
ATT over S. When S = S_E this gives the experimental parameter; when S = S_P this gives the nonexperimental estimand. The paper emphasizes these are different when S_E ≠ S_P — which is always the case in their data.

### 9. What is the empirical application?
JTPA, same four groups. The "measure of bias" used throughout Section 12 is: compare experimental controls (D=1, R=0) outcomes to matched ENP outcomes, because both groups received no treatment — any difference is pure bias.

---

## Chunk 8: Pages 29–32

### 1. What is this paper about?
This chunk presents Table 4 (experimental impact estimates over full support vs overlap region), then Table 5(a) and 5(b) — the main bias comparisons across seven matching estimators for all four demographic groups, by quarter. The chunk also begins Section 13 on the importance of conditioning variables (what happens when coarser P(X) models are used).

### 2. Why should I care about this?
Tables 5(a)-(b) are the horse race. They compare seven estimators (difference in means, nearest-neighbour without/with common support, local linear P score matching, regression-adjusted local linear matching, conditional DiD, regression-adjusted conditional DiD) for adult males, adult females, male youth, female youth. The key finding: no single estimator dominates, but the conditional DiD generally performs well. Raw difference in means is extremely biased (775% of impact for adult males). Imposing common support matters enormously.

### 3. Who is the intended audience?
Applied researchers implementing matching. Table footnotes give full details of conditioning variables used.

### 4. What does the notation mean?
- B̃_{Sp}: estimated bias over the common support S_P (what Tables 5(a)-(b) report)
- β̂: difference in raw means — the simple unadjusted bias estimator
- t = 1 to 6: post-programme quarters (18 months, 6 quarters)
- "Ave. 1 to 6": average monthly bias over 6 post-programme quarters
- "As a % of impact**": bias as % of M(S_E) (full experimental support impact)
- "As a % of adjusted impact": bias as % of M(S_P) (impact over common support)
- Standard errors in parentheses (bootstrapped, 50 replications, 100% sampling)
- Bandwidth 0.06, biweight kernel throughout

### 5. What do the numbers in the tables mean?
**Table 4:** Monthly earnings impacts, bootstrapped SEs.
- Adult males: M(S_E) = $44/month, M(S_P) = $61, bias from non-overlap = $17, % bias = 39%
- Adult females: M(S_E) = $29, M(S_P) = $35, bias = $6, % = 21%
- Male youth: M(S_E) = −$58, M(S_P) = −$36, bias = $22, % = 38%
- Female youth: M(S_E) = −$1, M(S_P) = $25, bias = $26, % = 2500% (near-zero denominator)

**Table 5(a) adult males (ENP comparison):**
- Raw diff in means: −$337/month average; 775% of impact
- Nearest-neighbour without common support: $62 average; 142% of impact
- Nearest-neighbour with common support: $77; 177%
- Local linear P score matching: $47; 108%
- Regression-adjusted local linear: $38; 87%
- DiD local linear P score: $67; 153%
- DiD regression-adjusted local linear: $52; 120%
Best performer: Regression-adjusted local linear matching (87% of impact)

**Table 5(a) adult females:**
- Raw diff: +$33; 113%. Best: DiD regression-adjusted ($27; 76%).

**Table 5(b) male youth:**
- Raw diff: +$20; 34%. Best: Regression-adjusted local linear ($7; 19%).

**Table 5(b) female youth:**
- Raw diff: +$48; 7059%. Best: Regression-adjusted local linear ($8; 195%).

Conclusion: Matching dramatically reduces bias vs raw difference, but residual bias is still 20–200%+ of treatment impact. DiD generally works as well as or better than conventional matching, especially for adult females and youth.

### 6. What are the econometric equations?
All equations defined in Section 11 (Eq. 10, 11, and DiD variants). No new equations in this chunk.

### 7. What are the identifying assumptions?
Section 13 makes the point that adding more predictors to P(X) is not always good: if X perfectly predicts D, common support fails. The ideal X satisfies A-3/A-4 (conditional independence) without destroying overlap. This is the bias-variance tradeoff in propensity score selection.

### 8. What is the causal target parameter?
ATT M(S_P) — the average treatment effect restricted to the common support region. Tables 5(a)-(b) measure residual bias B̃_{Sp} relative to this parameter and relative to the experimental M(S_E).

### 9. What is the empirical application?
JTPA, same. Bias estimated by comparing experimental controls (D=1, R=0) vs matched ENPs (D=0). Outcomes: average monthly earnings quarters t=1 to t=6 post-programme. Sites: Fort Wayne, Corpus Christi, Jersey City, Providence.

---

## Chunk 9: Pages 33–36

### 1. What is this paper about?
This chunk presents Tables 6(a) and 6(b) — bias from regression-adjusted local linear matching and DiD matching under four alternative P(X) models (Regular, Coarse I, II, III) plus SIPP and site-mismatch comparison groups and no-shows. Section 14 begins the analysis of geographic mismatch and questionnaire non-uniformity, introducing the SIPP comparison group analysis.

### 2. Why should I care about this?
Table 6(a) shows that matching performance degrades dramatically when conditioning information is reduced. Coarse I (demographics only) produces biases of −$291/month for adult males — almost eight times the experimental impact — because it lacks unemployment/earnings histories. Table 6(b) shows the DiD estimator is more robust to coarser conditioning: for most groups and conditioning sets, DiD bias is smaller and less sensitive to information set. The SIPP site-mismatch analysis (introduced here) provides the key counterfactual confirming geographic mismatch as a major bias source.

### 3. Who is the intended audience?
Applied researchers. The key message is practical: data quality for the propensity score model matters enormously for matching but matters less for DiD.

### 4. What does the notation mean?
- "Regular" P(X): full model with demographics + earnings history + labour force transition indicators (best-predictor model from Table 2)
- "Coarse I": site, race, age, education, marital status, children <6 only
- "Coarse II": Coarse I + prior year earnings
- "Coarse III": Coarse I + labour force transition indicators
- SIPP column: bias using SIPP-eligible comparison group (different location, different questionnaire)
- "Site mismatch": controls from Providence/Jersey City matched to ENPs from Corpus Christi/Fort Wayne (same questionnaire, different city)
- "No-show": same-site, same-questionnaire; programme dropouts as comparison group
- (*): data not available for certain quarters (averages over available quarters)

### 5. What do the numbers in the tables mean?
**Table 6(a) — Bias from regression-adjusted local linear matching:**
- Adult males, Regular: $38 avg bias (87% of impact) — best model
- Adult males, Coarse I: −$291 avg — catastrophic failure (−666% of impact)
- Adult males, Coarse II: −$166 avg (partial improvement with earnings history)
- Adult males, Coarse III: −$25 avg (big improvement with labour force transitions)
- Adult males, SIPP: $115 avg (larger bias due to geographic/questionnaire mismatch)
- Adult males, Site mismatch: −$175 avg (large bias from geographic mismatch alone)
- Adult males, No-show: $16 avg (near-zero bias — same site, same questionnaire)
- Adult females, No-show: $4 avg — very good performance

**Table 6(b) — Bias from conditional DiD local linear matching:**
- Adult males, Regular: $52 avg bias (comparable to matching)
- Adult males, Coarse II: −$144 avg (worse than Table 6a for same coarse model)
- Adult males, SIPP: −$236 avg (DiD doesn't help when levels of Y₀ differ across sites)
- Adult females, SIPP: −$86 avg (DiD reverses sign, still large)
- Adult females, Regular: $27 avg (best performer overall)
- Site mismatch, DiD: varies widely across groups and quarters

Key finding: DiD is more robust to coarser P(X) within-site but fails when there is site mismatch, because SIPP and site-mismatch comparison groups have different pre-programme trends (A-5 is violated when locations differ).

### 6. What are the econometric equations?
No new equations. Tables 6(a)-(b) apply Eq. (10) and the DiD variant under different information sets for P(X) and different comparison groups.

### 7. What are the identifying assumptions?
The SIPP and site-mismatch results provide indirect tests of A-5: the DiD estimator fails when participants and controls are from different locations, suggesting that E(Y₀t − Y₀t'|P,D=1) ≠ E(Y₀t − Y₀t'|P,D=0) for geographically mismatched groups. This is consistent with local labour markets having different earnings dynamics.

### 8. What is the causal target parameter?
ATT M(S_P). Bias is expressed relative to M(S_E) and M(S_P) as in Tables 5(a)-(b).

### 9. What is the empirical application?
JTPA, four groups. Section 14 introduces the SIPP as a new comparison group: nationally-representative, 1988 panel (Oct 1987–Dec 1989), location suppressed for confidentiality, restricted to JTPA-eligible nonparticipants. Site mismatch experiment: controls from 2 sites matched to ENPs from 2 other sites — geographic difference only, no questionnaire difference.

---

## Chunk 10: Pages 37–40

### 1. What is this paper about?
This chunk completes Section 14 (SIPP geographic mismatch results and the internal site-mismatch experiment), introduces Section 15 (no-shows as a comparison group), presents Figure 2 (P-score histograms for no-shows — much better overlap than ENPs), Table 7 (bias estimates from matching on the no-show comparison), and begins Section 16 (Conclusions).

### 2. Why should I care about this?
The no-show analysis is the within-experiment test of whether having the same site + same questionnaire is sufficient, even without the strong common-support properties of a randomized experiment. The results are mixed: for adult groups, no-shows have low raw bias but B₃ (selection bias) is a larger share of the total. For youth, bias is large. The geographic decomposition (Smith 1995: 2/3 questionnaire, 1/3 geography) provides actionable guidance for evaluation design.

### 3. Who is the intended audience?
Applied evaluators. The Section 16 conclusions are written for a broad labor economics audience.

### 4. What does the notation mean?
- "No-shows": persons who applied to JTPA, were accepted, but did not enroll before receiving services
- In the no-show context: D=1 refers to controls (randomized-out), D=0 refers to no-shows
- P(X) for no-shows: conditional probability of being an enrollee (vs. a no-show) among those who expressed intent to enroll
- Figure 2: histograms of estimated P for controls vs no-shows — much more overlap than Figure 1 (ENPs)

### 5. What do the numbers in the tables mean?
**Table 7 — Bias for no-show comparison:**
- Adult males: difference in means B = $29/month average; local linear P matching = $25; regression-adjusted = $16; 14%–57% of impact. Low bias confirmed.
- Adult females: B = $9; matching $7–$28; 10%–29% of impact. Low bias.
- Male youth: B = $84 average; regression-adjusted = $88; 144%–171% of impact. High bias — selection bias B₃ is large.
- Female youth: B = $18 average; regression-adjusted = $49; 2639%–7441% of impact. Very small treatment effect denominator makes percentages large.
The "As a % of Control-ENP" row shows no-show bias relative to ENP bias — adult groups look substantially better (8–42%) but youth look worse (37%–619%).

**Figure 2:** Unlike Figure 1 (ENP), the P-score distributions for controls and no-shows overlap substantially across the full range. This is why B₁ and B₂ are near-zero for no-shows.

### 6. What are the econometric equations?
No new equations. Section 16 provides a synthesis formula as a conclusion: the two-stage evaluation strategy = (a) estimate P(X) + (b) apply matching/DiD.

### 7. What are the identifying assumptions?
The no-show analysis cannot apply the conditional DiD because pre-programme earnings are not available for no-shows. This means A-5 cannot be exploited, limiting the approach to cross-sectional matching (A-4).

### 8. What is the causal target parameter?
ATT over common support. For no-shows: the ATT of being a completer vs. a no-show — a different causal parameter than participant vs. eligible nonparticipant.

### 9. What is the empirical application?
JTPA no-shows: persons assigned to treatment who enrolled but dropped out before receiving services. Same four sites, same four demographic groups. DiD not available for no-shows (no pre-programme data).

---

## Chunk 11: Pages 41–44

### 1. What is this paper about?
This chunk completes Figure 2 (adult females and female youth no-show histograms), provides the conclusion of the no-shows discussion, and then presents Section 16 (Conclusions and Discussion of Related Work) and the beginning of the Appendix (A: Test Statistics and Variance Estimators). It discusses the contrast between matching and IV, the support problem as the key finding, and the full Appendix A derivations for conditional independence and mean independence tests using local linear regression.

### 2. Why should I care about this?
Section 16 is the paper's integrating summary: the bias reduction hierarchy is clear (same labour market + same questionnaire + reweighting eliminates most bias; selection on unobservables is residual). The IV vs matching contrast is important: IV assumes E(U₀|X,P,D)=0 for both groups; matching only assumes the difference E(U₀|P,D=1)=E(U₀|P,D=0). Appendix A provides the formal test statistics used in Section 10.

### 3. Who is the intended audience?
The conclusions are for all economists. Appendix A is for statisticians/econometricians wanting to replicate the tests.

### 4. What does the notation mean?
In Appendix A:
- F̂_d(p): estimated conditional CDF at p for group d, from local linear regression
- B_d: asymptotic bias term = ½F''_d(p)(C₂/C₁)a²_{N_d} where F''_d is second derivative of CDF at p
- V_d = (N_d a_{N_d})^{-1} Var(ε_{id}|D=d,P=p)(C₃/C₁): asymptotic variance
- ε_{id} = 1(Y_{0i}≤y₀) − F̂_d(P_i): indicator residual
- N_d: sample size for group d
- a_{N_d}: bandwidth, converging to 0 as N_d→∞
- C₁, C₂, C₃: kernel-dependent constants (defined via integrals of kernel G)
- G(s) = (15/16)(s²−1)² for |s|<1; = 0 for |s|≥1: biweight kernel formula
- m_d(p) = E(Y₀|P=p,D=d): conditional mean, estimated by local linear regression
- B̃_d, Ṽ_d: bias and variance analogues for conditional mean estimator
- ε̃_{id} = Y_{0i} − m_d(P_i): residual for mean test
- IV assumption: E(U₀|X,P,D=1) = 0 and E(U₀|X,P,D=0) = 0 (stronger than matching)
- Matching assumption: E(U₀|P,D=1) = E(U₀|P,D=0) (bias balanced, not zero)

### 5. What do the numbers in the tables mean?
No new results tables in this chunk. Appendix A is derivational.

### 6. What are the econometric equations?
**Biweight kernel:** G(s) = (15/16)(s²−1)² for |s|<1; = 0 for |s|≥1  
**Asymptotic distribution of F̂_d(p):** (F̂_d(p)−F_d(p)) ~ N(B_d, V_d)  
where B_d = ½F''_d(p)(C₂/C₁)a²_{N_d} and V_d = (N_d a_{N_d})^{-1} Var(ε_{id}|D=d,P=p)(C₃/C₁)  
**Test stat for H(A-3):** (F̂₁(p)−F̂₀(p))'(V̂₀+V̂₁)^{-1}(F̂₁(p)−F̂₀(p)) ~ χ²(1) under null  
**Asymptotic distribution of m̂_d(p):** (m̂_d(p)−m_d(p)) ~ N(B̃_d, Ṽ_d)  
where B̃_d = ½m''_d(p)(C₂/C₁)a²_{N_d} and Ṽ_d = (N_d a_{N_d})^{-1} Var(ε̃_{id}|D=d,P=p)(C₃/C₁)  
**Test stat for H(A-4):** (m̂₁(p)−m̂₀(p))'(Ṽ₀+Ṽ₁)^{-1}(m̂₁(p)−m̂₀(p)) ~ χ²_1  
(Bias terms cancel when common bandwidth used because B̃₁−B̃₀ = 0 under null)  
**Variance estimator:** V̂_d(p) = Σ_{i∈I_d} ε̂²_{id} Ŵ²_{id}(p) where Ŵ_{id}(p) = local linear weight (Eq. 11 with X replaced by p)

### 7. What are the identifying assumptions?
Section 16 formalizes the test of A-4' using exclusion restrictions: if A-4' holds, then E(Y₁|T,P(Z),D=1)−E(Y₀|T,P(Z),D=0) should not depend on Z variables excluded from T (given Z does not predict Y for participants). This is the overidentifying restriction test for matching validity.

### 8. What is the causal target parameter?
ATT. Section 16 confirms: the paper's two-stage strategy (estimate P, apply matching/DiD) provides "fairly close" estimates to experimental ATT, but residual selection bias remains a substantial fraction of the experimental impact.

### 9. What is the empirical application?
JTPA, same throughout. Section 16 notes the paper's findings are likely to generalize to other job training programmes (CETA, MDTA, programmes in other countries) given the common institutional features.

---

## Chunk 12: Pages 45–48

### 1. What is this paper about?
This chunk continues and completes Appendix A (variance estimators, generalization to panel data, and tests for H(A-5) and H(A-5')), presents Table B-1 (p-values from H(A-4') with and without adjustment for β estimation error), and presents Appendix C (operational definition of common support using kernel density estimation and the trimming rule).

### 2. Why should I care about this?
Table B-1 reveals a critical methodological issue: when tests are conducted on estimated residuals (H(A-4')), adjusting for the additional uncertainty from estimating β inflates standard errors dramatically, making it almost impossible to reject the null. The "true" p-value is somewhere between unadjusted and adjusted. This warns against over-reliance on residual-based tests. Appendix C defines the trimming procedure that implements the common support restriction in practice.

### 3. Who is the intended audience?
Technical econometricians and practitioners implementing the tests. Appendix C is needed by anyone applying the matching estimator computationally.

### 4. What does the notation mean?
**Appendix A (panel extension):**
- m(p) = [{m̂₁₁(p)−m̂₀₁(p)}, ..., {m̂₁_T(p)−m̂₀_T(p)}]': vector of mean differences over T time periods
- Ṽ^T_d: T×T variance-covariance matrix for group d across time periods
- L: restriction matrix for DiD test — takes differences m_{1t}(p)−m_{0t}(p)−[m_{1t'}(p)−m_{0t'}(p)]
- k: number of restrictions imposed by L
- q(i,t): indicator for whether observation i has usable data in period t (unbalanced panel indicator)
- V̂_d(p) = Σ_{i∈I_d} V̂_{id} V̂'_{id}: alternative panel variance estimator, guaranteed positive semidefinite
- V̂_{id} = [ε̃_{i1} q(i,1) Ŵ_{id}(p), ..., ε̃_{iT} q(i,T) Ŵ_{id}(p)]'
- Y_{0it}: panel outcome for individual i at time t
- β: coefficient in partial linear model Y_{0it} = X_{it}β + D_i E(U_{0it}|X_{it},D_i=1) + (1-D_i)E(U_{0it}|X_{it},D_i=0) + residual
- Û_{0it} = Y_{0it} − X_{it}β̂: estimated residuals

**Appendix C (common support):**
- Ŝ_{10} = {P∈Ŝ₁∩Ŝ₀: f̂(P|D=1)>0 and f̂(P|D=0)>0}: estimated overlap region
- q̂: trimming level (2% for adults, 5% for youth)
- c_q: threshold density value satisfying the trimming criterion
- S_q = {P∈Ŝ_{10}: f̂(P|D=1)>c_q and f̂(P|D=0)>c_q}: trimmed overlap region
- Silverman's rule-of-thumb bandwidth for density estimation

### 5. What do the numbers in the tables mean?
**Table B-1 — P-values for H(A-4') with and without β-adjustment:**
Columns: "Residuals not adjusted" (standard test) and "Residuals adjusted" (accounting for β estimation error).
- Adult males, Overall pre-programme: 0.2515 (unadjusted) → 1.0000 (adjusted) — dramatic change
- Adult males, Overall post-programme: 0.0001 (unadjusted) → 1.0000 (adjusted)
- Adult females, Overall pre: 0.0375 → 1.0000
- Male youth, Overall pre: 0.0015 → 1.0000

Implication: adjusting for parameter estimation uncertainty makes the H(A-4') test accept everything. The unadjusted tests are therefore the basis for the paper's rejections of A-4'. The authors note both are asymptotically equivalent and the truth lies between them.

### 6. What are the econometric equations?
**Panel test stat (H(A-4) joint over T periods):** [m̃(p)]'(Ṽ^T_0+Ṽ^T_1)^{-1}[m̃(p)] ~ χ²_T  
**DiD test stat (H(A-5)):** (L·m̃(p))'(L·(Ṽ^T_0+Ṽ^T_1)·L')^{-1}(L·m̃(p)) ~ χ²_k  
where L is the restriction matrix encoding symmetric differences around t=0

**Example L matrix for t∈{4,5,6}:**  
L = [[1,0,0,0,0,0,0,0,0,0,0,−1], [0,1,0,0,0,0,0,0,0,0,−1,0], [0,0,1,0,0,0,0,0,−1,0,0,0]]

**Common support rule:**  
S_q = {P∈Ŝ_{10}: f̂(P|D=1)>c_q and f̂(P|D=0)>c_q}  
where sup_{c_q} (1/2J) Σ_{i∈Ī₁} {1(f̂(P_i|D=1)<c_q)+1(f̂(P_i|D=0)<c_q)} ≤ q

### 7. What are the identifying assumptions?
No new identifying assumptions. This chunk completes the technical apparatus for testing A-3/A-3'/A-4/A-4'/A-5/A-5'.

### 8. What is the causal target parameter?
ATT M(S_q) where S_q is the trimmed common support region.

### 9. What is the empirical application?
JTPA, same. Appendix C applies to all four groups with group-specific trimming (2% adults, 5% youth). Monte Carlo evidence (available on request) shows trimming sensitivity matters for small youth samples.

---

## Chunk 13: Pages 49–50

### 1. What is this paper about?
The final two pages consist entirely of the references section (bibliography). No new substantive content.

### 2. Why should I care about this?
The references confirm the intellectual lineage: Fisher (1951) and Roy (1951) for potential outcomes; Rosenbaum and Rubin (1983) for propensity score; LaLonde (1986) for the benchmark nonexperimental evaluation critique; Heckman and Robb (1985, 1986) for selection model methods and the DiD precedent; Ashenfelter (1978) and Ashenfelter and Card (1985) for earnings dip and longitudinal methods; Fan (1992) for local linear regression.

### 3. Who is the intended audience?
All readers needing to trace the methodological lineage.

### 4. What does the notation mean?
Nothing in this chunk.

### 5. What do the numbers in the tables mean?
Nothing in this chunk.

### 6. What are the econometric equations?
Nothing in this chunk.

### 7. What are the identifying assumptions?
Nothing in this chunk.

### 8. What is the causal target parameter?
Nothing in this chunk.

### 9. What is the empirical application?
Nothing in this chunk — but the references confirm the JTPA National Study (Orr, Bloom, Bell, Lin, Cave and Doolittle, 1994) as the source of the experimental data.
