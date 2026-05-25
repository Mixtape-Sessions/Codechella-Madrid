# `covariates.tex` — Glasgow Day 2 (Part 2) Outline
### Advanced Topics in Applied Causal Inference · Mini-course at University of Glasgow · Tue May 19, 2026

---

## Where this sits in the arc

Day 2 Part 1 (`triple-diff.tex`) said: if you don't believe PT, use a third group. But triple diff requires that third group to exist — and to share the bias trend. **Often you don't have one.** Then the move is: **condition on covariates and hope PT holds *conditionally***. That's the territory of this deck.

The plan trades down through three methods of increasing sophistication, motivated by the limitations of the previous one:
1. **TWFE with controls** (outcome regression) — the obvious first attempt
2. **IPW** (Abadie 2005) — reweighting the comparison group
3. **The "can't I just control for the pscore?" trap** — Scott's specific teaching moment
4. **Doubly robust** (Sant'Anna & Zhao 2020) — the right way to combine OR and IPW

Then we close with **compositional change** — a separate but related problem (the *units* are different across periods, not just imbalanced covariates), which sets up Hong (2013) and Sant'Anna & Xu (2026). Pedro's overlap paper and Caetano-Callaway time-varying covariates are explicitly held for the advanced deck.

**Day 2 afternoon structure (planned)**: `covariates.tex` → ends Day 2.

---

## Audience and rhetoric (Step 0)

- **Source**: `CI-2/Slides/Tex/02-Covariates.tex` (1,159 lines, well-developed), `decks/code/IPW-Demo/` (ready, the simulation that drives Scott's "control-for-pscore" critique), `readings/SantAnna_DiD_CompositionalChanges_text.md` (extracted notes), Hong (2013) figures in `CI-2/lecture_includes/`.
- **Audience**: same as before. By now they've digested PT, DDD, and weighted-vs-unweighted PT from Day 1. They're ready for IPW + DR.
- **Aristotelian balance**: **Logos 55% · Ethos 20% · Pathos 25%**. This is the most technical deck of the three days. We earn the right to be more technical *because* the previous two decks set up the motivation. But still: narrative → simulation → math.
- **Tone / aesthetic**: Remix style.
- **Code language**: R primary (the IPW-Demo and DR-DiD use `drdid` package which is R-native), Stata secondary.
- **Format**: Beamer.
- **The ONE sentence** the audience walks away with: **"Doubly robust isn't 'controlling for the propensity score in a regression' — it's reweighting the comparison group with IPW and imputing the missing trend with OR, so you have two chances to be right."**

---

## The narrative arc

### Act I — Tension: "Without a placebo group, can covariates save you?" (3 slides)

1. **Title slide** (Remix cover).
2. **Opening hook**: The DDD escape hatch requires a parallel-bias placebo group. Often you don't have one. *What if the differential trend is driven by a covariate you can observe?* → **conditional PT**.
3. **Conditional PT, formally**: $\mathbb{E}[\Delta Y(0) \mid D=1, X] = \mathbb{E}[\Delta Y(0) \mid D=0, X]$. Within strata of $X$, parallel trends holds. Three estimators target this: OR, IPW, DR. We'll do all three — and we'll see why the "naive" attempt at combining them is wrong.

### Act II — The investigation (~22 slides)

Pedagogical sequence: **OR (the natural first move) → IPW (the cleaner approach) → the trap → DR (the right combination) → compositional change (a different problem).**

#### Block A: Outcome regression (4 slides)

4. **OR (Heckman, Ichimura, Todd 1997)**: regress control-group $\Delta Y$ on $X$. Use the fitted model to impute the counterfactual trend for the treated. Take the average difference. *That is the OR-DiD estimator.*
5. **The regression form**: $Y_{it} = \alpha_i + \gamma_t + \tau D_{it} + X_{it}'\beta + \varepsilon$. TWFE-with-controls. **Easy to estimate. Easy to misinterpret.**
6. **What OR assumes**: the *trend* in $Y(0)$ is fully captured by a parametric function of $X$. If $X$ is wrong or the functional form is wrong, OR is biased. *(Slide as cautionary fact, not derivation.)*
7. **The first failure mode**: OR is sensitive to functional form on the covariate side. Especially in the post-period where you're imputing.

#### Block B: IPW — the reweighting move (5 slides)

8. **The intuition** — *Abadie (2005)*: instead of imputing the trend, reweight the controls until they "look like" the treated in their covariate distribution. Then the simple difference-in-differences on the reweighted sample identifies the ATT.
9. **The propensity score** — quick refresher. $p(X) = \Pr(D=1 \mid X)$. Estimated via logit/probit MLE. *Hidden in the optimizer*: convergence depends on overlap and the optimizer's behavior in the corners (sparse cells, near-perfect prediction). Mention briefly that the propensity-score *estimation* method matters — link forward to Pedro's overlap paper (advanced).
10. **The Rosenbaum-Rubin dimension-reduction theorem**: if treatment is unconfounded given $X$ (a vector), it's unconfounded given $p(X)$ (a scalar). One scalar that absorbs all the conditioning information. *That's why pscore-based methods are tractable.*
11. **The IPW-DiD estimator** (Abadie 2005, sketched): weight controls by $p(X)/(1-p(X))$, weight treated by 1. Take the weighted DiD. **Under conditional PT, this recovers the ATT.**
12. **Common support is non-negotiable**: if $p(X) \to 1$ in some region, the weight blows up and the estimator is unstable. Standard practice: trim or flag. *(One-slide warning.)*

#### Block C: The trap — "can't I just control for the pscore?" (4 slides) ★ NEW CONTENT

This is the block Scott specifically asked to be built. It's not in the existing CI-2 deck — the critique lives in the IPW-Demo README. This block makes it visible on slides *before* DR is introduced, so DR's value is properly motivated.

13. **The natural temptation**: *"If the propensity score is the one-scalar summary of confounding (Rosenbaum-Rubin), why not just run `Y ~ D + p_hat`? Add the pscore as a control. Done."* — frame as the audience's reasonable instinct.
14. **What that regression actually estimates**: it imposes that the treatment effect is *constant with respect to $p(X)$*. The regression has no $D \times X$ interaction (or equivalently $D \times p(X)$), so by construction it can't recover heterogeneous treatment effects across the propensity strata. **Even when $p(X)$ is the correct summary of confounding, the regression's functional form imposes structure on the *outcome* side that you didn't sign up for.**
15. **The simulation**: run `decks/code/IPW-Demo/ipw_simulation.R` live (~30 sec). 500 reps, heterogeneous $\tau(X) = 1 + 0.5 X_1$. Method A (IPW reweighting): bias ≈ 0. Method B (regression with $\hat p$ as additive control): bias ≈ −10%. Method C (naive OLS): bias bigger still. *Picture: three histograms from `figures/ipw_comparison.pdf`.*
16. **The general lesson**: the propensity score is for *weighting*, not for *regressing on*. Different uses of the same scalar serve different purposes. Once we've seen this, DR makes sense — it uses the pscore as a weight, then *separately* models the outcome.

#### Block D: Doubly robust (5 slides)

17. **The DR-DiD estimator (Sant'Anna & Zhao 2020)** — full formula on one slide, in clean form. Two pieces: (i) the IPW reweighting of the controls; (ii) the OR imputation of the counterfactual trend. Take the difference. *(Use the exact formula from frame 593–615 of `02-Covariates.tex`.)*
18. **Why "doubly robust"**: if *either* the pscore model is correct *or* the outcome model is correct (not necessarily both), DR is consistent. Two chances to be right. **The OR side handles the level; the IPW side handles the weighting. Each protects the other.**
19. **Why this is not "controlling for the pscore in a regression"**: contrast Block C explicitly. DR doesn't use $\hat p$ as a regressor. It uses $\hat p$ as a weight in one piece and the OR model on the outcome in another piece, then *combines them by subtraction*. The structure that Method B imposed (constant effect w.r.t. $p$) is absent here.
20. **Efficiency**: DR is semiparametrically efficient under conditional PT. *(One bullet on the efficiency bound, not a derivation.)*
21. **Live demo**: load `drdid` package, run `drdid::drdid_panel(...)` on a simulated dataset where heterogeneous $\tau(X)$ defeats Methods A–C but DR recovers the ATT. (Build the simulation: `decks/code/Covariates-Demo/dr_dgp.R`. Use the same DGP as IPW-Demo but with deliberate pscore-model misspecification, then with deliberate OR misspecification — show DR robust to either.)

#### Block E: Compositional change (4 slides)

22. **A different problem**: in repeated cross-sections, the *units* are different each period. Even if PT holds for the population, the *sample* you observe pre vs. post might differ in $X$ — and if $Y(0)$ depends on $X$, you'll see a "trend" that's just compositional shift.
23. **Hong (2013) — Napster and music expenditure**: classic example. As internet users became more representative of the broader population (1996 vs. 2002), the apparent effect of Napster on music spending shifts even without any real behavioral change. *(Use `lecture_includes/hong_napster.png` and `hong_table.png`.)*
24. **Sant'Anna & Xu (2026)** — the formal fix. Stationarity-of-$X$ test (Hausman-style), and an estimator that adjusts for compositional shifts. *(Pull from `readings/SantAnna_DiD_CompositionalChanges_text.md`.)*
25. **What this means for practice**: with repeated cross-sections, check whether your $X$ distribution is moving over time. If it is, your DiD is partly identifying a compositional effect — and Hong / Sant'Anna-Xu give you the correction.

### Act III — Resolution (2 slides)

26. **Covariates recap** — 4 bullets. (1) Conditional PT is weaker than unconditional PT, but still an assumption. (2) IPW reweights; OR imputes; DR does both. (3) **Don't confuse "controlling for the pscore" with "using the pscore correctly."** (4) Compositional change is a separate problem and Hong / Sant'Anna-Xu address it.
27. **Closing one-sentence linger**: *Doubly robust isn't "controlling for the propensity score." It's reweighting the comparison group with IPW and imputing the missing trend with OR — two chances to be right.*

---

## Total: ~27 frames

This is the longest of the three Day 1/2 decks. **Streamline aggressively** in Block A (OR) — it's the most familiar to the audience and we can move through it fast.

---

## Figures and tables (code-first)

| Asset | Source | Status | New build? |
|---|---|---|---|
| IPW-vs-regression-with-PS histogram | `decks/code/IPW-Demo/figures/ipw_comparison.pdf` | **Already exists** | No — copy in place |
| DR simulation result (DR robust under pscore misspec, OR misspec) | `decks/code/Covariates-Demo/dr_dgp.R` + chart | Build | **Yes** — new simulation showing DR's double robustness vs. OR-only and IPW-only |
| Hong (2013) Napster figures | `CI-2/lecture_includes/hong_napster.png` and `hong_table.png` | Exists | No — copy in place |
| Sant'Anna-Xu compositional change schematic | new | Optional | Maybe — a clean TikZ showing compositional shift in $X$ across periods |
| Common-support / weight-blowup visualization | new | Optional | Maybe — show distribution of $\hat p$ for treated and control with the trim region marked |

### Folder layout

```
decks/code/
├── IPW-Demo/                       ★ already exists, reuse
│   ├── README.md
│   ├── ipw_simulation.R
│   └── figures/ipw_comparison.pdf
└── Covariates-Demo/                ★ NEW for the DR robust simulation
    ├── README.md                   (write — describe the DR misspec robustness simulation)
    ├── dr_dgp.R                    (generate data + run OR, IPW, DR; compare under misspec)
    └── figures/dr_misspec.pdf      (3-panel: correct PS+correct OR | correct PS+wrong OR | wrong PS+correct OR)
```

---

## Critical files (sources to port)

**Existing CI-2 (read-only sources):**
- `/Users/scunning/Causal-Inference-2/Slides/Tex/02-Covariates.tex` — primary frame source (1,159 lines)
- `/Users/scunning/Causal-Inference-2/Lab/Lalonde/covariates.R` — R DR-DiD simulation (full DGP, polynomial interactions)
- `/Users/scunning/Causal-Inference-2/Lab/Lalonde/covariates.do` — Stata version
- `/Users/scunning/Causal-Inference-2/Slides/Tex/lecture_includes/Hong_1.pdf`, `Hong_2.pdf`, `hong_napster.png`, `hong_table.png` — Hong figures

**Existing in the Remix folder:**
- `/Users/scunning/the-remix-tour/glasgow/decks/code/IPW-Demo/ipw_simulation.R` — the 500-rep Monte Carlo showing IPW vs. regression-with-PS bias (this is the lever for Block C)
- `/Users/scunning/the-remix-tour/glasgow/decks/code/IPW-Demo/README.md` — pedagogical commentary (extract into slides)

**Existing reading notes:**
- `/Users/scunning/Library/CloudStorage/Dropbox-MixtapeConsulting/scott cunningham/0.1 Mixtape Consulting/Workshops/2026/readings/SantAnna_DiD_CompositionalChanges_text.md` — Sant'Anna & Xu (2026) structured extraction

**Master content map (where the pscore-control note lives):**
- `/Users/scunning/Library/CloudStorage/Dropbox-MixtapeConsulting/scott cunningham/0.1 Mixtape Consulting/Workshops/2026/Glasgow/glasgow_content_map.md` lines 133–155: "IPW teaching note" and "Propensity-score estimation refresher." **This is where Scott's prior request to "make notes" landed** — the IPW critique and pscore-MLE-optimizer angle are both written up here.

**To create:**
- `/Users/scunning/the-remix-tour/glasgow/decks/covariates.tex` — the deck
- `/Users/scunning/the-remix-tour/glasgow/decks/code/Covariates-Demo/dr_dgp.R` — DR robustness simulation
- `/Users/scunning/the-remix-tour/glasgow/decks/code/Covariates-Demo/README.md`
- `/Users/scunning/the-remix-tour/glasgow/decks/figures/dr_misspec.pdf` — generated

---

## Sequencing (when building)

1. **Build `Covariates-Demo/dr_dgp.R`** — DGP with: (i) heterogeneous $\tau(X)$, (ii) nonlinear $p(X)$ that a simple logit gets wrong if naïvely specified, (iii) nonlinear OR equation that a linear model gets wrong. Run OR-only, IPW-only, DR. Show DR is the only one robust to *either* misspecification.
2. **Generate the figure** — three panels, three misspec regimes. Use Remix theme.
3. **Update IPW-Demo README** if needed; verify the existing `ipw_comparison.pdf` works.
4. **Write `covariates.tex` skeleton** with assertion titles only. Compile.
5. **Pull content** from `02-Covariates.tex` lesson-by-lesson, streamlining per `DESIGN_PRINCIPLES.md`. Block A (OR) and Block B (IPW) are heavy lifts that need aggressive trimming.
6. **Write Block C from scratch** using the IPW-Demo README + `glasgow_content_map.md` lines 133–155 as the source. This is the new pedagogical content.
7. **Compile** to zero warnings.
8. **Test live demos**: `ipw_simulation.R` and `dr_dgp.R` should each run in <60 sec.

---

## Verification

1. `Rscript decks/code/IPW-Demo/ipw_simulation.R` → produces (or confirms) `ipw_comparison.pdf` with three histograms; Method A bias near 0, Methods B and C clearly biased.
2. `Rscript decks/code/Covariates-Demo/dr_dgp.R` → produces `dr_misspec.pdf` showing DR robust where OR-only or IPW-only fails.
3. `pdflatex covariates.tex` → 0 warnings, ~27 frames, section breaks at Act boundaries.
4. Visual: deck feels like Day 1 and triple-diff — same palette, same restraint.
5. Block C is unambiguous: a student leaving the room can explain *why* `Y ~ D + p_hat` is wrong and *why* DR is different.

---

## Risk notes

- **The pscore-MLE / optimizer block** is a tempting tangent. Scott noted in `glasgow_content_map.md` that this matters for weak overlap. Keep it to **one slide** in Block B — a forward link to the advanced deck. Don't go down the rabbit hole tonight.
- **Sant'Anna & Xu (2026) compositional change** is a recent paper; treat it as a 4-slide cap, not a self-contained lesson. The Hong example does most of the intuition work; Sant'Anna-Xu provides the formal estimator.
- **Caetano & Callaway time-varying covariates** is held for advanced — explicitly NOT in this deck.
- **Sant'Anna et al. weak-overlap / trim-then-bias-correct** is held for advanced — explicitly NOT in this deck.
- **27 frames is on the long side**. If Day 2 morning runs over (which it might — DDD takes time), trim Block E (compositional change) to 2 slides and move the full treatment to Day 3 or advanced.

---

## What's deferred to the advanced deck (not here)

- Caetano-Callaway 2024: time-varying covariates and the unobservable-trend problem
- Sant'Anna et al. weak overlap and trimming methods
- Pedro's overlap-violation triple-diff
- Propensity-score estimation under separation, regularization, Bayesian alternatives
- DR with staggered timing (CS / SA / BJS extensions)

---

## Cross-deck callbacks

This deck should explicitly reference (one bullet each, no full slides):

- Day 1 Lesson 6 (Two ATTs, Two PTs) — *"We saw that weighting changes both the ATT and PT. IPW is the same idea: reweight controls to make conditional PT hold."*
- Day 2 triple-diff — *"DDD said: find a third group that shares the trend. Covariates say: condition on $X$ that absorbs the trend. Both are responses to a PT violation, but they use different identifying information."*
- Forward to advanced — *"What if your pscore model is wrong AND the overlap is weak? That's the advanced deck."*
