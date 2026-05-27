# Heckman, Ichimura & Todd (1997) — Paper-Level Synthesis

**Full citation:** Heckman, J., Ichimura, H. & Todd, P. (1997). "Matching as an Econometric Evaluation Estimator: Evidence from Evaluating a Job Training Programme." *Review of Economic Studies* 64(4): 605–654.

This is a synthesis of all 13 chunk-level reading notes ([Heckman-Ichimura-Todd-1997-reading-notes.md](Heckman-Ichimura-Todd-1997-reading-notes.md)).

---

## 1. What is this paper about?

The paper asks a single, sharply focused question: **when can nonexperimental matching estimators replicate the results of a randomized experiment?** The setting is the National JTPA Study (Job Training Partnership Act), where the authors have access to *both* an experimental control group (people randomized out of training) and several nonexperimental comparison groups (Eligible NonParticipants — ENPs — in the same towns surveyed with the same instrument; SIPP nonparticipants from different cities and a different instrument; programme no-shows).

Using this design, they do four things:

1. **Decompose evaluation bias** B into three orthogonal components — B₁ (support mismatch), B₂ (density-weighting mismatch over the common support), and B₃ (selection on unobservables). This is the paper's most-cited conceptual contribution.
2. **Formally test** the identifying assumptions used by all major nonexperimental estimators (strong ignorability A-1, weaker conditional independence A-3/A-3', mean independence A-4/A-4', and conditional difference-in-differences A-5/A-5') against the experimental benchmark.
3. **Introduce a new conditional difference-in-differences matching estimator** D̂_{t,t'}(X) that combines propensity-score matching with before/after differencing, and demonstrate that its identifying assumption A-5 is *not* rejected when conventional matching assumptions are.
4. **Empirically demonstrate** that the LaLonde (1986) critique of nonexperimental methods is mostly an artifact of *data quality* — specifically the use of comparison groups from different labour markets and different survey instruments — rather than an econometric failure of matching per se.

The methodological apparatus (propensity-score estimation, local linear matching, kernel matching, regression-adjusted variants, the bias decomposition, the nonparametric tests of mean and distributional independence) is built up systematically and tied to the JTPA data throughout.

---

## 2. Why should I care about this?

Because this paper reframed the entire question of when matching is a defensible substitute for random assignment. Before HIT (1997), the field had absorbed LaLonde (1986) as a wholesale indictment of nonexperimental evaluation. After HIT (1997), three things were clear:

- **Data quality (same location, same survey instrument, same observable history) dominates econometric sophistication.** A simple matching estimator on a well-chosen comparison group outperforms a sophisticated estimator on a poorly chosen one.
- **Common support is a first-order practical problem.** Figure 1 of the paper (propensity-score histograms for ENPs vs. controls) shows that overlap can be so thin that experimental and nonexperimental estimates implicitly target *different populations*. This is the B₁ component of bias.
- **Conditional difference-in-differences (the within-paper innovation) survives specification testing when conventional matching fails.** A-5 is not rejected for any demographic group; A-3/A-4 are rejected for most. This is direct empirical motivation for the DiD-with-matching workflow that has dominated quasi-experimental practice for the last 25 years.

The paper is also the seminal applied reference for: the role of pre-treatment outcome histories in matching, the formal nonparametric test of conditional mean independence using local linear regression, the operational definition of trimmed common support, and the integration of Rosenbaum-Rubin (1983) propensity-score theory with Heckman-Robb (1985) longitudinal selection methods.

---

## 3. Who is the intended audience?

**Primary:** Labor economists and applied econometricians evaluating active labour-market programmes (JTPA, CETA, MDTA, European training programmes, welfare-to-work). Knowledge of the LaLonde (1986) controversy, Ashenfelter's dip, Rosenbaum-Rubin (1983) propensity-score theory, and Heckman-Robb (1985, 1986) selection models is assumed throughout.

**Secondary:** Theoretical econometricians interested in nonparametric and semiparametric identification — particularly the asymptotic theory of local linear regression (Fan 1992) applied to conditional CDF and conditional mean estimation, and the use of pre-programme data as a falsification test.

**Tertiary:** Practitioners who implement matching, who will read Sections 11 (the unified matching framework via Eq. 10), 12, and Appendices A and C closely.

The paper is mathematically demanding — most of the post-1990 propensity-score literature in econometrics traces to it — but the policy conclusions are accessible to anyone working in programme evaluation.

---

## 4. What does the notation mean?

The paper has a large notational apparatus that builds across sections. Synthesized:

**Potential outcomes and treatment:**
- `Y₁, Y₀`: potential outcomes under treatment / no treatment.
- `D`: treatment indicator (1 if treated, 0 otherwise).
- `Y = DY₁ + (1−D)Y₀`: observed outcome (switching equation).
- `Δ = Y₁ − Y₀`: individual treatment gain.
- `R`: randomization indicator (1 in, 0 out) — distinguishes "treated" from "would-be treated but randomized out."

**Outcome models:**
- `g₁(X), g₀(X)`: systematic (observable) components of Y₁, Y₀.
- `U₁, U₀`: unobservable error terms.
- `X = (T, Z)`: covariate partition — T enters outcome equations, Z enters participation equation. This partition supports exclusion restrictions (A-3', A-4').

**Causal parameter:**
- `M(S)`: ATT averaged over a subset S of the support of X|D=1. The choice of S matters: S = S_E (full experimental support) vs. S = S_P = S_{10} (common support) gives a different parameter.

**Propensity score and matching:**
- `P(X) = Pr(D=1|X)`: propensity score; balancing score in the Rosenbaum-Rubin sense.
- `B(X) = E(Y₀|X,D=1) − E(Y₀|X,D=0)`: selection bias function.
- `B̃(P(X))`: index-representation of bias — bias depends on X only through P(X) (the "index property" P-1).
- `S₁, S₀, S₁₀`: supports of X for D=1, D=0, and their intersection.

**Bias decomposition:**
- `B`: overall conventional bias (mean Y₀ difference between treated and comparison).
- `B₁`: bias from non-overlapping support.
- `B₂`: bias from differing density of X over the common support.
- `B₃`: bias from selection on unobservables — what matching is supposed to fix.
- `B̄_{S_x}`: average selection bias over the common support, weighted by f(X|D=1).

**Matching estimator (Eq. 10) and special cases:**
- `M̂(S) = Σ_{i∈I₁} ω(i) [Q_{1i} − Σ_{j∈I₀} W(i,j) Q_{0j}]`: general matching estimator.
- Weights `W(i,j)` differ by method: nearest-neighbour, caliper, kernel, local linear.
- `Q_{1i}, Q_{0j}` can be: raw outcomes (matching), regression-adjusted outcomes (regression-adjusted matching), pre-post differences (conditional DiD).

**DiD estimator (the paper's innovation):**
- `D̂_{t,t'}(X) = E(Y_{1t} − Y_{0t'}|X,D=1) − E(Y_{0t} − Y_{0t'}|X,D=0)`: conditional DiD.
- `t` = post-period, `t'` = pre-period.

**Testing:**
- `F̂_d(p), m̂_d(p)`: nonparametric local linear estimators of conditional CDF and conditional mean at P=p for group d.
- Test statistics distributed χ²(1) or χ²_T under the null.
- Bandwidth 0.06, biweight kernel `G(s) = (15/16)(s²−1)²` for |s|<1.

**Operational tools:**
- Trimming rule (Appendix C): drop observations where density falls below `c_q`, with q = 2% for adults, 5% for youth.
- Bootstrap SE: 50 replications, 100% resampling.

---

## 5. What do the numbers in the tables mean?

Eight tables (plus B-1) and two figures tell the empirical story:

**Table 1** — A catalogue of prior nonexperimental evaluations of US job training programmes (Ashenfelter 1978, Ashenfelter-Card 1985, Westat 1986, LaLonde 1986, Fraker-Maynard 1987). Rows tabulate features of comparison-group design: same labour market, same questionnaire, programme eligibility known, variables available. **Almost every prior study fails on most dimensions; JTPA + ENPs is the first design that passes them all.** This is the empirical motivation for the entire paper.

**Figure 1** — Histograms of estimated propensity scores for ENPs (D=0) vs. controls (D=1), by demographic group. **Common support is extremely thin:** ENPs cluster at P ≈ 0–0.025, controls span the whole range. Visual proof that B₁ is large.

**Table 2** — Bias decomposition: B = B₁ + B₂ + B₃ for ENPs, SIPP, and no-shows.
- For ENPs: B₁ and B₂ are large and roughly *offsetting* (e.g., adult males: B₁ = +$218, B₂ = −$584, net B = −$342/month). B₃ is small and statistically insignificant for all four demographic groups (e.g., adult males B₃ = +$23, not significantly different from zero).
- For SIPP comparison: B₃ is large and significant — up to +$122/month for adult males, 440–676% of treatment impact. Geographic + questionnaire mismatch produces real residual selection bias.
- For no-shows: B₁ ≈ 0 (overlap is good — same site) but B₃ becomes the dominant component, especially for youth.

The pedagogical punchline of Table 2: **for well-chosen comparison groups (ENPs), the "econometric problem" (B₃ = selection on unobservables) is small. The "data problem" (B₁ + B₂) is what kills you.** For badly-chosen comparison groups (SIPP), B₃ matters too.

**Table 3(a)** — p-values for nonparametric tests of H(A-4) and H(A-4') (mean independence of Y₀ from D, given P(X)). Run separately for pre- and post-programme periods. Findings:
- A-4 is rejected for all four demographic groups in both pre- and post-programme periods (most overall p-values < 0.05; many at 0.0000).
- A-4' (the version using residuals from a partially linear outcome model) is rejected in most cases but passes for male youth in the post-programme.
- Bottom line: **conventional matching's identifying assumption fails empirically.**

**Table 3(b)** — p-values for nonparametric tests of H(A-5) and H(A-5') (mean independence of *differences* Y_{0t} − Y_{0t'}, the DiD assumption). Joint tests across post-programme quarters t = 1..6 with symmetric pre-post periods.
- **No group rejects A-5 at conventional significance** (overall p-values all ≥ 0.05 except adult females residuals at borderline 0.0506).
- A-5' (residual-based) passes uniformly.
- Bottom line: **the DiD assumption survives the test that matching fails.**

**Table 4** — Experimental ATT M(S_E) vs. trimmed-support ATT M(S_P). The two parameters differ substantially: e.g., for adult males M(S_E) = $44/month vs. M(S_P) = $61, a 39% gap from non-overlap alone. **You are not estimating the same parameter** when you restrict to common support.

**Tables 5(a)-(b)** — The horse race: seven matching estimators × four demographic groups, reporting B̃_{Sp} (residual bias over common support) by quarter and as a percentage of the experimental impact. Estimators compared:
1. Difference in means (no matching) — catastrophic (e.g., −$337/month, 775% of impact for adult males).
2. Nearest-neighbour without common support.
3. Nearest-neighbour with common support.
4. Local linear P-score matching.
5. Regression-adjusted local linear matching.
6. Conditional DiD local linear P-score matching.
7. Regression-adjusted conditional DiD.

**Findings:** No single estimator dominates. Imposing common support matters enormously. The best performers are regression-adjusted local linear matching and conditional DiD, with residual biases of roughly 20–200% of the experimental impact — better than raw matching but still uncomfortably large.

**Tables 6(a)-(b)** — Robustness to "Coarser" P(X) specifications and to different comparison groups (SIPP, site-mismatch, no-shows).
- Matching performance degrades dramatically with coarser P(X) — e.g., Coarse I (demographics only, no labour-force history) gives adult-male bias of −$291/month vs. $38 for the full P(X).
- DiD is more robust to coarser P(X) within-site but **fails when locations differ** (SIPP and site-mismatch produce large DiD biases). This is consistent with A-5 being violated when treated and comparison have different labour-market dynamics.
- No-shows (same site, same questionnaire) produce small bias for adults but large bias for youth — even within-site geography is not enough when populations differ on unobserved dynamics.

**Figure 2** — P-score histograms for no-shows: dramatically more overlap than Figure 1 (ENPs). Confirms that B₁ and B₂ are near zero for no-shows.

**Table 7** — Bias from matching on no-shows: low for adults (10–57% of impact), high for youth (144–7441% — though youth treatment effects are small so percentages are large).

**Table B-1** — p-values for H(A-4') with and without adjustment for β estimation error. Adjusting inflates SE so much that the test never rejects (all adjusted p-values = 1.0000). **A methodological warning:** residual-based tests are sensitive to whether one accounts for first-step estimation uncertainty. The "true" p-value lies between unadjusted and adjusted.

---

## 6. What are the econometric equations?

Synthesizing across the paper, the key equations are:

**Outcome model (1a-b):** `Y₁ = g₁(X) + U₁`, `Y₀ = g₀(X) + U₀`.

**Switching equation:** `Y = D Y₁ + (1−D) Y₀`.

**ATT (2):** `E(Y₁−Y₀|X,D=1) = g₁(X) − g₀(X) + E(U₁−U₀|X,D=1)`.

**M(S) — the causal target (3):** `M(S) = ∫_S E(Δ|X,D=1) dF(X|D=1) / ∫_S dF(X|D=1)`.

**Experimental identification (5):** `E(Y|X,D=1,R=1) − E(Y|X,D=1,R=0) = E(Δ|X,D=1)`. Randomization gives the ATT under perfect compliance.

**Matching condition (6):** `E(Y₀|X,D=1) = E(Y₀|X,D=0) = E(Y₀|X)`. The nonparticipants' counterfactual mean serves as the counterfactual for the treated.

**Bias function:** `B(X) = E(Y₀|X,D=1) − E(Y₀|X,D=0)`. Index property (P-1): `B(X) = B̃(P(X))`. Matching requires `B̃(P(X)) = 0` (P-2).

**Bias decomposition:**
```
B = B₁ + B₂ + B₃
B₁ = ∫_{S₁\S₁₀} E(Y₀|X,D=1) f(X|D=1) dX − ∫_{S₀\S₁₀} E(Y₀|X,D=0) f(X|D=0) dX   [non-overlap]
B₂ = ∫_{S₁₀} E(Y₀|X,D=0) {f(X|D=1) − f(X|D=0)} dX                                 [density weighting]
B₃ = ∫_{S₁₀} {E(Y₀|X,D=1) − E(Y₀|X,D=0)} f(X|D=1) dX                              [selection on unobservables]
```

**Conditional DiD estimator:** `D̂_{t,t'}(X) = E(Y_{1t} − Y_{0t'}|X,D=1) − E(Y_{0t} − Y_{0t'}|X,D=0)`.

**General matching estimator (Eq. 10):** `M̂(S) = Σ_{i∈I₁} ω(i) [Q_{1i} − Σ_{j∈I₀} W(i,j) Q_{0j}]` for X ∈ S.

**Special cases (weight function W(i,j) defines the estimator):**
- Nearest-neighbour: W = 1 on a singleton match.
- Caliper: W>0 only if `||X_i − X_j|| < ε`.
- Kernel: `W(i,j) = G_{ij} / Σ_k G_{ik}` with bandwidth a_{N₀}.
- Local linear (Eq. 11): kernel weight corrected for local linear curvature; bias terms cancel in difference under common bandwidth.
- Regression-adjusted: `Q_{1i} = Y_{1i} − X_i β̂₀`, `Q_{0j} = Y_{0j} − X_j β̂₀`.
- Conditional DiD: `Q_{1i} = Y_{1it} − Y_{0it'}`, `Q_{0j} = Y_{0jt} − Y_{0jt'}`.

**Nonparametric tests:**
- H(A-3) (CDF independence) test statistic: `(F̂₁(p) − F̂₀(p))′ (V̂₀ + V̂₁)⁻¹ (F̂₁(p) − F̂₀(p)) ∼ χ²(1)`.
- H(A-4) (mean independence) test statistic: `(m̂₁(p) − m̂₀(p))′ (Ṽ₀ + Ṽ₁)⁻¹ (m̂₁(p) − m̂₀(p)) ∼ χ²_T`.
- H(A-5) (DiD): same as H(A-4) but with pre-post differences `Y_{0t} − Y_{0t'}` in place of levels, and L matrix encoding symmetric differences.

**Logit propensity score:** `Pr(D=1|X) = Λ(Xγ)` with γ chosen to maximize the hit-or-miss classification rate against threshold `P̂ = sample treatment rate`.

**Common-support trimming (Appendix C):** `S_q = {P ∈ Ŝ_{10}: f̂(P|D=1) > c_q  and  f̂(P|D=0) > c_q}` with `c_q` chosen so trimming fraction equals q ∈ {2%, 5%}.

---

## 7. What are the identifying assumptions?

The paper deploys, *tests*, and ranks a hierarchy of assumptions:

**(A-1) Strong ignorability** (Rosenbaum-Rubin 1983): `(Y₁, Y₀) ⊥⊥ D | X`. Both potential outcomes are conditionally independent of treatment. Sufficient for ATT and ATE identification. *Not directly tested* — implied by A-3 + a symmetric condition on Y₁.

**(A-2) Common support / overlap:** `0 < Pr(D=1|X) < 1`. Every X-value has positive treatment and control mass. *Empirically fails dramatically* in JTPA — Figure 1 shows extremely thin overlap. Trimming is required.

**(A-3) Untreated potential-outcome independence:** `Y₀ ⊥⊥ D | X`. Weaker than A-1 — only the counterfactual untreated outcome need be independent of treatment. Sufficient for ATT identification under A-2. **Tested and rejected.**

**(A-4) Mean independence via propensity score:** `E(Y₀|P(X), D=1) = E(Y₀|P(X), D=0)`. Weakest matching condition. **Tested and rejected** for almost all groups in pre- and post-programme periods.

**(A-3')** and **(A-4')** — Exclusion-restriction variants using the partition X = (T, Z). T enters outcome, Z enters participation. *Independence of U₀ from T given (Z, D).* **Tested; mostly rejected**; A-4' passes only for male youth post-programme.

**(A-5) Conditional DiD assumption** (the paper's innovation): `E(Y_{0t} − Y_{0t'} | X, D=1) = E(Y_{0t} − Y_{0t'} | X, D=0)`. Pre-/post-programme *changes* in Y₀ are mean-independent of D given X. **Strictly weaker than A-3/A-4** — permits selection on Y₀ levels, only requires parallel time trends. **Tested and NOT rejected** for any of the four demographic groups.

**(A-5')** — Residual version using U₀. Also not rejected.

The empirical hierarchy emerging from JTPA: **A-3 ≻ A-4 (both fail) and A-5 ≻ A-5' (both pass)** — the conditional DiD assumption survives testing where conventional matching does not. But A-5 breaks down across geographic mismatch: SIPP and site-mismatch comparison groups violate A-5 because labour-market dynamics differ across cities.

---

## 8. What is the causal target parameter?

The causal target is the **average treatment effect on the treated**:

`M(S) = ∫_S E(Δ|X,D=1) dF(X|D=1) / ∫_S dF(X|D=1)`

where S is the region of X-support over which the parameter is defined. The paper's repeated, central methodological point is that **the choice of S is itself an identification decision:**

- `M(S_E)` — ATT over the full experimental support (what randomization identifies).
- `M(S_P) = M(S_{10})` — ATT restricted to the common support of treated and comparison X (what matching can identify).
- `M(S_q)` — ATT over the trimmed common support (what is operationally estimable).

When S_E ≠ S_P (which is always the case in JTPA), experimental and nonexperimental estimates are **estimating different parameters**, not the same parameter with different error. Table 4 quantifies this: M(S_E) ≠ M(S_P) by 21–39% across demographic groups before any matching is applied.

This is the paper's most under-appreciated message — much of what looks like "bias" in nonexperimental matching is really a difference in the target parameter induced by the common-support restriction.

---

## 9. What is the empirical application?

**The National JTPA Study (Job Training Partnership Act).** The programme provides on-the-job training, classroom training, and job-search assistance to disadvantaged US workers. Eligibility: family income near or below the poverty line for 6 months prior, or welfare/food stamp receipt.

**Experimental design:** At four sites (Fort Wayne IN, Corpus Christi TX, Jersey City NJ, Providence RI), accepted applicants were randomized: 2/3 to treatment, 1/3 to an 18-month control embargo.

**Data structure:**
- 36-month panel: 18 months pre-, 18 months post-random assignment.
- Baseline survey + 2 follow-up surveys. ~84% response rate.
- Four demographic groups studied separately: adult males, adult females, male youth, female youth.
- Outcome variable: monthly earnings (analysis often averages over post-randomization quarters 1–6).

**Comparison groups (the paper's secret weapon — multiple, varied):**
- **Eligible nonparticipants (ENPs):** JTPA-eligible persons in the same four sites surveyed with the same instrument. Programme eligibility *known* (rare in evaluation literature). **The "ideal" nonexperimental comparison.**
- **SIPP comparison:** JTPA-eligible nonparticipants from the 1988 SIPP panel — nationally representative, different sites, different questionnaire. **Worst-case design** for testing the matching framework.
- **Site mismatch:** controls from Providence/Jersey City matched to ENPs from Corpus Christi/Fort Wayne — same questionnaire, different city. **Isolates geographic mismatch.**
- **No-shows:** persons accepted into JTPA who never enrolled. Same site, same questionnaire as controls, but no pre-programme data. **Tests within-site selection.**

**Propensity-score covariates:** site indicators, age, race, education, marital status, presence of young children, monthly labour force transition indicators, monthly earnings histories (5 years pre-randomization), earnings at month of random assignment.

**Implementation details:**
- Logit P(X) estimated separately by demographic group.
- Local linear regression with biweight kernel, bandwidth 0.06.
- Trimming: 2% for adults, 5% for youth.
- Bootstrap inference: 50 replications, 100% resampling.

The four sites + four demographic groups × seven estimators × multiple comparison groups generates an exceptionally rich empirical structure. **This is the empirical paper that defined the standard for matching-method evaluation for the next 30 years.**
