# Heckman, Ichimura & Todd (1997) — Condensed Synthesis
## "Matching as an Econometric Evaluation Estimator: Evidence from Evaluating a Job Training Programme"
## Review of Economic Studies, 64(4): 605–654

---

## Paper in one sentence
Using JTPA experimental data, the authors show that evaluation bias from nonexperimental matching is driven primarily by support mismatch and density weighting — not selection on unobservables — and that a new conditional DiD estimator, applied to same-location same-questionnaire comparison groups, can approximate experimental estimates.

---

## The core identification hierarchy

The paper introduces a nested hierarchy of identifying assumptions, from strongest to weakest:

| Assumption | Formal statement | Requirement |
|---|---|---|
| A-1 (strong ignorability) | (Y₁,Y₀) ⊥⊥ D\|X | Both potential outcomes independent of D given X |
| A-2 (overlap) | 0 < Pr(D=1\|X) < 1 | Common support |
| A-3 | Y₀ ⊥⊥ D\|X | Only untreated outcome independent of D |
| A-4 | E(Y₀\|P(X),D=1) = E(Y₀\|P(X),D=0) | Mean independence via propensity score |
| A-4' | E(U₀\|T,Z,D) = E(U₀\|Z,D) | Mean exclusion restriction on residuals |
| A-5 | E(Y₀t−Y₀t'\|X,D=1) = E(Y₀t−Y₀t'\|X,D=0) | Common pre-programme trends (DiD) |
| A-5' | Same as A-5 but via P(Z) instead of X | Index-sufficient DiD |

**Empirical verdict (Table 3a, 3b):** A-3 and A-4 are rejected. A-5 and A-5' are not rejected for any demographic group. The DiD assumption is the only one the data support.

---

## The bias decomposition (Section 9)

The total evaluation bias B decomposes as:

**B = B₁ + B₂ + B₃**

where:
- **B₁** = non-overlapping support bias (treated and comparison have different X support)
- **B₂** = density weighting bias (different distribution of X over common support)
- **B₃** = selection on unobservables (the "econometric" problem)

**Empirical finding (Table 2, ENP comparison):** B₁ and B₂ are large and roughly offsetting. B₃ is small and statistically insignificant for all four demographic groups when using the ENP comparison group (same location, same questionnaire). With the SIPP comparison group (different location, different questionnaire), B₃ is large and significant. Conclusion: the LaLonde (1986) critique reflects questionnaire and geographic mismatch, not selection on unobservables.

---

## The three preconditions for matching to work (Section 4)

Beyond statistical assumptions, matching requires:
1. **Same labour market**: participants and comparison group in the same local labour market
2. **Same questionnaire**: identical variables collected for both groups
3. **Common support**: propensity score distributions overlap (enforced by trimming)

**Operationally (Figure 1):** ENP propensity score mass concentrates at P ≈ 0, while participants span the full distribution. Overlap is thin. Even before testing A-3/A-4, the support problem is severe.

---

## The general matching estimator (Eq. 10)

All matching estimators nest within:

M̂(S) = Σ_{i∈I₁} ω(i) [Q_{1i} − Σ_{j∈I₀} W(i,j) Q_{0j}]

Variants:
- **Nearest-neighbour**: W(i,j) = 1 for closest match, 0 otherwise
- **Caliper**: nearest-neighbour within tolerance ||X_i − X_j|| < ε
- **Kernel**: W(i,j) = G((X_i−X_j)/h) / Σ_k G((X_i−X_k)/h)
- **Local linear**: adjusts kernel weights for local curvature (Fan 1992)
- **Regression-adjusted**: Q = Y − Xβ̂₀ (requires A-4')
- **Conditional DiD**: Q_{1i} = Y_{1it}−Y_{0it'}, Q_{0j} = Y_{0jt}−Y_{0jt'} (requires A-5)

---

## Key empirical results

### Bias magnitude across estimators (Tables 5a, 5b — ENP comparison, all 6 post-quarters average)

| Estimator | Adult males | Adult females | Male youth | Female youth |
|---|---|---|---|---|
| Raw diff in means | −$337 (775%) | +$33 (113%) | +$20 (34%) | +$48 (7059%) |
| Local linear P-score | $47 (108%) | — | — | — |
| Regression-adjusted LL | **$38 (87%)** | — | **$7 (19%)** | **$8 (195%)** |
| DiD regression-adjusted | $52 (120%) | **$27 (76%)** | — | — |

Percentages = bias as % of experimental treatment impact M(S_E).

### Effect of conditioning information on matching bias (Table 6a — adult males)

| P(X) model | Avg. bias | % of impact |
|---|---|---|
| Regular (full model) | $38 | 87% |
| Coarse III (+ labour force transitions) | −$25 | −57% |
| Coarse II (+ earnings history) | −$166 | −380% |
| Coarse I (demographics only) | −$291 | −666% |
| No-show (same site) | $16 | 37% |

**Labour force transition histories are the critical ingredient.** Without them, matching fails catastrophically.

### Effect of geographic mismatch (Table 6a/6b)
- SIPP comparison (different location): bias $115–$192/month for adults, 440–676% of impact
- Site mismatch within JTPA: bias −$175/month for adult males
- No-show comparison (same site): bias $16–$29/month for adults, 14–57% of impact

---

## The DiD estimator's advantages

1. **Weaker assumption**: A-5 (common trends) survives testing; A-3/A-4 do not
2. **More robust to coarser conditioning**: DiD bias degrades less than matching bias when propensity score model is coarsened (Table 6b vs 6a)
3. **Consistent with Roy-model selection**: A-5 permits selection on unobservable *levels* of Y₀ as long as *changes* are common
4. **Limitation**: DiD fails when comparison groups are from different locations (A-5 violated across labour markets)

---

## Testing methodology (Section 10, Appendix A)

Tests use local linear regression chi-squared statistics:

**For H(A-4) at point p:**  
(m̂₁(p) − m̂₀(p))'(Ṽ₁ + Ṽ₀)⁻¹(m̂₁(p) − m̂₀(p)) ~ χ²₁

Key technical advantage: using local linear regression in both groups with the same bandwidth causes asymptotic bias terms to cancel under the null, so the test statistic has correct size without bias correction.

**For H(A-5):**  
Replace Y₀ with Y₀t − Y₀t' differences. Same chi-squared structure.

**Biweight kernel throughout:** G(s) = (15/16)(s²−1)² for |s|<1; bandwidth 0.06.

**Table B-1 warning:** Adjusting test statistics for β estimation error in residual-based tests (H(A-4')) makes all p-values → 1.0. The pre-adjustment tests (which the paper uses) are the operative ones; the authors note both are asymptotically equivalent.

---

## Common support implementation (Appendix C)

Trimmed overlap region:  
S_q = {P ∈ Ŝ₁∩Ŝ₀ : f̂(P|D=1) > c_q and f̂(P|D=0) > c_q}

where c_q is chosen so that at most q fraction of treated observations fall below the threshold. Group-specific: q = 0.02 for adults, q = 0.05 for youth.

---

## What matching eliminates vs. what it cannot

| Bias component | What matching does | Result |
|---|---|---|
| B₁ (support mismatch) | Restricts to common support | Eliminated |
| B₂ (density weighting) | Reweights D=0 to match D=1 density | Eliminated |
| B₃ (selection on unobservables) | Cannot eliminate — requires A-3/A-4 | Residual |
| Geographic mismatch | Requires same-location data | Not eliminated by estimation |
| Questionnaire mismatch | Requires same-questionnaire data | Not eliminated by estimation |

---

## Intellectual lineage

- Potential outcomes / switching equation: Fisher (1951), Roy (1951), Rubin (1974)
- Propensity score dimension reduction: Rosenbaum & Rubin (1983)
- LaLonde (1986) critique: benchmark nonexperimental evaluation failure
- Heckman & Robb (1985, 1986): selection models and DiD precedent
- Ashenfelter (1978): earnings dip; Ashenfelter & Card (1985): longitudinal controls
- Fan (1992): local linear regression
- JTPA National Study: Orr, Bloom, Bell, Lin, Cave & Doolittle (1994)

---

## Practical recommendations for matching studies

1. **Use same-labour-market comparison groups.** Geographic mismatch is the dominant source of bias, not econometric failure.
2. **Use same questionnaire.** Questionnaire differences produce B₃ ≈ 2× as large as geographic mismatch.
3. **Collect labour force transition histories.** Monthly employment/unemployment records are more important than annual earnings histories for building a valid P(X) model.
4. **Enforce common support.** Use trimming (2–5%) to restrict to the overlap region.
5. **Prefer DiD over cross-sectional matching** when panel data exist and same-location controls are available. A-5 survives testing; A-3/A-4 do not.
6. **DiD fails with geographically mismatched controls.** Do not apply DiD to SIPP or CPS comparison groups from different regions.
