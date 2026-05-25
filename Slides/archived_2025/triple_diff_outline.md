# `triple-diff.tex` — Glasgow Day 2 (Part 1) Outline
### Advanced Topics in Applied Causal Inference · Mini-course at University of Glasgow · Tue May 19, 2026

---

## Where this sits in the arc

Day 1 ended with: *DiD is a research design with two ingredients — the 2×2 calculation and parallel trends — and together they identify the ATT.*

Day 2 opens with the next obvious question: **what do you do when you don't believe parallel trends?** The answer the literature gave first — chronologically and pedagogically — is the **triple difference** (DDD). It's a *design* response to PT violations, not a regression trick. Covariates come second (the next deck). Pedro's new DDD/OVS estimator and the weak-overlap paper are explicitly held for the advanced deck.

**Day 2 morning structure (planned)**: `triple-diff.tex` → `covariates.tex`.

---

## Audience and rhetoric (Step 0)

- **Source**: `CI-2/Slides/Tex/01-Basics.tex` (DDD frames), `CI-2/Slides/Tex/02-Codechella-Violations.tex` (identical DDD section, more polished), `CI-2/Lab/DDD/ddd2.R` + `ddd2.do` (the canonical simulation), `lecture_includes/gruber_ddd_3.pdf` (visual).
- **Audience**: same as Day 1 — University of Glasgow PhD students, mixed prior exposure to DDD. Most have seen DiD but not DDD as a *design* (they've seen it as "add an interaction").
- **Aristotelian balance**: **Logos 50% · Ethos 20% · Pathos 30%**. The audience is now warmed up; we can go a touch more technical. But the move is still narrative → calculation → simulation → regression → real example.
- **Tone / aesthetic**: Remix style (already in `remix.sty`). No restyling needed.
- **Code language**: Stata primary, R secondary — `ddd2.do` is the cleaner of the two and Stata is closer to how Gruber's original work was published. R version available as a fallback.
- **Format**: Beamer.
- **The ONE sentence** the audience walks away with: **"Triple diff trades parallel trends for parallel bias — when the placebo group experiences the same shock as the treated group's counterfactual, DDD recovers the ATT even when DiD doesn't."**

---

## The narrative arc

### Act I — Tension: "DiD is breaking. Now what?" (3–4 slides)

1. **Title slide** (Remix cover).
2. **Opening hook**: Day 1 closing claim restated, then immediately challenged. *"Parallel trends is an identifying assumption. What happens when you don't believe it?"* — concrete scene: a state passes a law you study, but you suspect that state was already on a different trajectory.
3. **Three ways out** (preview the lesson): (a) find a third group that experiences the same trend shock but isn't treated → DDD; (b) condition on covariates that absorb the differential trend → next deck; (c) use a fundamentally different design (SCM, RDD, IV) → not today.
4. **Today**: just DDD. The first historical response to "I don't believe PT."

### Act II — The investigation (15–18 slides)

Pedagogical sequence: **narrative (Gruber) → 8-cell calculation → simulation that proves DDD recovers ATT when DiD doesn't → regression specification → event-study version → real-world cautions.**

#### Block A: The story (3 slides)
5. **Gruber (1994) — maternity benefit mandates** (the canonical DDD application). Set the scene: in 1976 several states mandated employer-provided maternity insurance coverage. Did this shift the labor-market cost of childbearing to women themselves (in the form of lower wages)?
6. **The 2×2 problem**: married women 20–40 in mandate states (treated) vs. married women 20–40 in non-mandate states (control), pre/post 1976. *Why a naive DiD might fail*: trends in women's labor-market outcomes were diverging across states for many reasons — not just the mandate.
7. **Gruber's move**: add a third dimension. Compare the wage gap between *fertile-aged married women* and *single men + older women* (a within-state placebo group), before and after, in mandate vs. non-mandate states. If "everything else moving" hits both groups, the within-state difference washes it out.

#### Block B: The calculation (3–4 slides)
8. **The 8 cells**: state × time × group. Show as a 2×2×2 cube → flatten to a table. *(visual: small TikZ cube or a clean 8-row table)*
9. **The DDD formula**: $\delta_{\text{DDD}} = \big[(Y^{T,A}_1 - Y^{T,A}_0) - (Y^{C,A}_1 - Y^{C,A}_0)\big] - \big[(Y^{T,B}_1 - Y^{T,B}_0) - (Y^{C,B}_1 - Y^{C,B}_0)\big]$, where $A$ = treated demographic (fertile-aged married women), $B$ = placebo demographic (everyone else). *"DDD is the difference between two DiDs."*
10. **The new identifying assumption** — **parallel bias**: $\text{PT-bias}_A = \text{PT-bias}_B$. The trend you couldn't kill in the original DiD is the same trend operating on the placebo group. *"DDD doesn't require PT — it requires that the PT violation is shared across the two demographic groups."*
11. **What gets us out of trouble**: levels can differ, *trends* can differ across groups, but the **divergence between trends** must be the same across treated and control states. Articulate clearly — this is the slide students underestimate.

#### Block C: The simulation (4 slides)
12. **DGP**: 3 groups (men, married women, older women) × 2 states (Texas treated, Arkansas control) × 10 years. True ATT for married women in Texas = **−$5,000**. Build in differential state-level trend that breaks the simple DiD.
13. **Result 1: the naive 2×2 DiD** → **−$7,487**. Biased by the differential trend.
14. **Result 2: the DDD using older women as placebo** → **−$4,972**. Recovers (close to) the true ATT.
15. **The picture**: side-by-side trends plot. Treated group in TX clearly trending differently than AR. *But the placebo group in TX is also trending differently from placebo in AR — and by the same amount.* DDD subtracts that off. *(Build this figure: `decks/code/Triple-Diff/triple_diff_chart.R`, Remix-styled, two-panel.)*

#### Block D: The regression specification (3 slides)
16. **The triple-interaction regression**: $Y_{ist} = \alpha + \beta_1 D_{st} + \beta_2 \mathbf{1}[A]_i + \beta_3 \mathbf{1}[\text{post}]_t + \beta_4 (D_{st} \times \mathbf{1}[A]_i) + \beta_5 (D_{st} \times \mathbf{1}[\text{post}]_t) + \beta_6 (\mathbf{1}[A]_i \times \mathbf{1}[\text{post}]_t) + \delta (D_{st} \times \mathbf{1}[A]_i \times \mathbf{1}[\text{post}]_t) + \varepsilon$. **$\delta$ is the DDD coefficient.**
17. **What each lower-order term does**: $\beta_4$ is the cross-sectional A-vs-B gap in treated states; $\beta_5$ is the average post-period change in treated states; $\beta_6$ is the trend in A vs. B everywhere. The triple interaction strips all of them out.
18. **Live demo**: run `ddd2.do` (or `ddd2.R`) — load the simulated data, summarize the 8 cells, run the regression, get $\hat\delta \approx -4{,}972$. Three places confirm: the by-hand calculation, the regression, the event-study coefplot.

#### Block E: The event-study version (2 slides)
19. **The DDD event study**: $\sum_\tau \delta_\tau (D_{st} \times \mathbf{1}[A]_i \times \tau)$ — pre-period coefficients are the falsification, post-period are the dynamic effect. Same logic as Day 1's event study but in DDD form.
20. **Coefplot**: Generate from the same simulation. Show pre-trend coefficients near zero (parallel bias holds), post-trend showing the effect.

#### Block F: Real-world cautions (2 slides)
21. **Gruber's actual result**: DDD = −5.4% (very close to his naive DiD of −6.2%). *Pedagogical question*: was DDD necessary if it gave nearly the same answer? The honest answer: **probably not, in his case** — but the DDD design was credible because the placebo could have moved the estimate, and it didn't. **The value of DDD is what it would have caught**, not what it changed.
22. **When DDD is wrong**: if the placebo group is treated by a *different* policy that hit at the same time, parallel bias fails and DDD is worse than DiD. Falsification logic still applies — test the placebo group separately.

### Act III — Resolution (2–3 slides)

23. **DDD recap** — 4 bullets. (1) DDD is a design, not a regression trick. (2) It replaces PT with parallel bias. (3) The third group has to experience the same shock the treated group's counterfactual would have. (4) Event-study version is the falsification.
24. **Tomorrow morning preview**: when you can't find a third group, condition on covariates → next deck.
25. **Closing one-sentence linger**: *Triple diff trades parallel trends for parallel bias.*

---

## Total: ~25 frames

Per `DESIGN_PRINCIPLES.md`: one idea per slide, assertion titles, code-first figures.

---

## Figures and tables (code-first)

| Asset | Source | Status | New build? |
|---|---|---|---|
| Gruber visual / cube | `CI-2/lecture_includes/gruber_ddd_3.pdf` | Exists | No |
| DDD simulation 8-cell table | `decks/code/Triple-Diff/triple_diff_table.R` (new) | Build | **Yes** — generates a `\input{}` `.tex` table from the simulation |
| Trend plot (treated vs. control, group A vs. group B, all 4 lines) | `decks/code/Triple-Diff/triple_diff_chart.R` (new) | Build | **Yes** — Remix-styled, single panel with 4 colored lines + treatment marker |
| Bias plot (DiD-biased vs. DDD-unbiased, side by side) | `decks/code/Triple-Diff/triple_diff_chart.R` | Build | **Yes** — second panel or separate figure showing the bias correction |
| DDD event-study coefplot | `decks/code/Triple-Diff/triple_diff_eventstudy.R` (new) | Build | **Yes** — pre-period at zero, post-period showing effect |

### Folder layout

```
decks/code/Triple-Diff/
├── README.md                       (write — describe DGP, mirror Tiebout-Roy README style)
├── triple_diff_chart.R             (Remix-styled trend + bias plots)
├── triple_diff_table.R             (8-cell DDD calculation, exports LaTeX table)
├── triple_diff_eventstudy.R        (event-study coefplot)
├── ddd_simulation.do               (Stata version, port of CI-2/Lab/DDD/ddd2.do)
└── ddd_simulation.R                (R version, port of CI-2/Lab/DDD/ddd2.R)
```

All scripts source `_themes/remix_theme.R`. All figures save to `decks/figures/` with the `triple_diff_*` prefix.

---

## Critical files (sources to port)

**Existing CI-2 (read-only sources):**
- `/Users/scunning/Causal-Inference-2/Slides/Tex/02-Codechella-Violations.tex` — primary DDD frame source (more polished than 01-Basics)
- `/Users/scunning/Causal-Inference-2/Slides/Tex/01-Basics.tex` — secondary DDD frames
- `/Users/scunning/Causal-Inference-2/Lab/DDD/ddd2.do` — Stata simulation (19.5 KB, full)
- `/Users/scunning/Causal-Inference-2/Lab/DDD/ddd2.R` — R simulation (7.9 KB)
- `/Users/scunning/Causal-Inference-2/Lab/DDD/ddd.do` — earlier draft (6 KB)
- `/Users/scunning/Causal-Inference-2/Slides/Tex/lecture_includes/gruber_ddd_3.pdf` — Gruber visual

**To create:**
- `/Users/scunning/the-remix-tour/glasgow/decks/triple-diff.tex` — the deck
- `/Users/scunning/the-remix-tour/glasgow/decks/code/Triple-Diff/` — folder + 5 scripts above
- `/Users/scunning/the-remix-tour/glasgow/decks/figures/triple_diff_*.pdf` — generated figures

**Reuse from Day 1:**
- `remix.sty` — no changes
- `_themes/remix_theme.R` — no changes
- Section divider pattern (`\remixsection{...}`)

---

## Sequencing (when building)

1. **Port and Remix-styleify** `CI-2/Lab/DDD/ddd2.R` → `decks/code/Triple-Diff/ddd_simulation.R`. Keep DGP identical. Use Remix color scales. Verify the result: biased DiD ≈ −$7,500, DDD ≈ −$5,000.
2. **Build `triple_diff_chart.R`** — single-panel 4-line plot using the simulated data. Save to `decks/figures/`.
3. **Build `triple_diff_table.R`** — generates the 8-cell table from the simulation and exports a LaTeX fragment.
4. **Build `triple_diff_eventstudy.R`** — event-study coefplot.
5. **Write `triple-diff.tex`** skeleton with assertion titles only. Compile. Verify section breaks render.
6. **Pull content** from the CI-2 DDD frames, streamlining per `DESIGN_PRINCIPLES.md`.
7. **Compile** to zero warnings.
8. **Test the live demo** (`ddd_simulation.R` and `.do`) on Scott's machine.

---

## Verification

1. `Rscript triple_diff_chart.R` → produces `figures/triple_diff_trends.pdf` showing four trend lines (TX-A, AR-A, TX-B, AR-B) with treatment marker. Visually obvious that the *gap* between treated and control trends is the same across A and B (parallel bias holds).
2. `Rscript ddd_simulation.R` → console prints biased DiD ≈ −$7,500 and DDD ≈ −$5,000. Matches the original CI-2 simulation.
3. `pdflatex triple-diff.tex` → 0 warnings, ~25 frames, 6 section breaks (Act I → Block A → B → C → D → E → F → Act III).
4. Visual: deck feels like Day 1 — same palette, same restraint, same "deck breathes" rhythm.
5. Scott can teach the full DDD lesson without referring to any other deck.

---

## Risk notes

- **Pedagogy temptation**: there's a strong urge to dive straight into the regression specification. **Resist.** The narrative → calculation → simulation sequence is what makes DDD feel like a *design* rather than an interaction term. The regression arrives **after** the audience already understands what DDD is doing.
- **Gruber's actual numbers**: his DDD and DiD were close. That's not a flaw of the lesson — it's a teaching moment about when DDD is "necessary" vs. "defensive." Don't hide it; lean into it on slide 21.
- **The placebo-group failure mode**: explicitly cover "what if the placebo is also treated by something else." This is where DDD goes wrong and needs to be named — otherwise students will use DDD as a blanket fix.
- **Pedro's new DDD/OVS estimator and weak-overlap paper are NOT included** — held for the advanced deck per Scott's instruction. Mention by name once if asked, but no slides.
- **Heterogeneous staggered DDD** is also not included — Day 3 / advanced territory.

---

## What's deferred to the advanced deck (not here)

- Sant'Anna's DDD/OVS estimator (covariate-adjusted triple diff under overlap violations)
- Staggered DDD (different placebo groups treated at different times)
- DDD with continuous treatment
- DDD vs. synthetic control as alternative responses to PT violation
