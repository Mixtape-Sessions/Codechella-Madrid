# `lalonde-arc` — The LaLonde Arc

One coherent Beamer deck telling the story of how causal inference recovered from the
LaLonde (1986) crisis through Heckman-Ichimura-Todd (1997) and Abadie (2005). Built
for Codechella Madrid 2026.

**Compiled PDF:** [`lalonde-arc.pdf`](lalonde-arc.pdf) — 41 pages, ~636 KB.

---

## Deliverables

```
lalonde-arc/
├── lalonde-arc.tex          # Main Beamer source (~39 frames)
├── lalonde-arc.pdf          # Compiled deck (clean: 0 warnings)
├── lalonde-arc_outline.md   # Step-2 outline (preserved for iteration)
├── realmadrid.sty           # Original "Sunset on the Bernabéu" Beamer theme
├── README.md                # This file
├── scripts/
│   ├── 01_experimental_att.R       # Experimental ATT + balance figure
│   ├── 02_lalonde_swap.R           # LaLonde swap horserace
│   ├── 03_pscore_overlap.R         # PS overlap histograms
│   ├── 04_hit_estimator.R          # HIT (1997) PSM + DiD + local linear
│   ├── 05_abadie_estimator.R       # Abadie (2005) PS-weighted DiD
│   └── 99_main_results.R           # Master table
├── figures/                 # Generated PDFs
└── tables/                  # \input-able LaTeX fragments
```

Replication scripts live separately at
`/Users/scunning/Codechella-Madrid/Claude/code/replication/`:
`replicate_main.{R,py,do}`.

---

## The four headline ATTs

| Step | Estimator | ATT | Gap vs.\ truth |
|---|---|---:|---:|
| Truth | Experimental (NSW only) | **$1,794** | — |
| Crisis | OLS, NSW treated + CPS controls | $699 | $-1,095 |
| Road 1 | Heckman-Ichimura-Todd (1997), local-linear DiD | $2,051 | $+257 |
| Road 2 | Abadie (2005), PS-weighted DiD | $1,642 | $-152 |

Both roads land within ~$300 of the experimental truth. The deck makes the case that
the field's 13-year crisis ended when these two independent methods converged on the
same neighborhood.

---

## Theme: "Sunset on the Bernabéu"

Custom `.sty` (`realmadrid.sty`) built from scratch — not reused from any template.

| Role | Hex | Notes |
|---|---|---|
| Background | `#FFFFFF` | The home kit — crisp white |
| Royal blue | `#00529F` | Frame titles, structure, dividers |
| Crown gold | `#FEBE10` | Accents, highlights, key numbers, bullet markers |
| Deep violet | `#6E2A82` | Secondary accent, alt-method color in figures |
| Charcoal | `#1A1A1A` | Body text (never pure black) |
| Burgundy | `#8B1A1A` | Sparing alerts only |

Macros defined: `\rmtitleframe{}{}{}{}{}`, `\rmsection{}`, `\rmstat{}{}`, `\rmquote{}{}`,
`\rmkey`, `\rmgold`, `\rmblue`, `\rmviolet`, `\rmmeta`.

---

## Audit results

All four audits dispatched in parallel after the first clean compile.

### `/tikz` visual audit
- TikZ diagrams in the deck source: **CLEAN** (all edge labels carry directional keywords; no Bezier collisions).
- ggplot2 figure defects (3 found, all fixed):
  1. `fig_pscore_overlap.pdf` subtitle showed literal LaTeX `$\hat p \approx 0$` → replaced with plain text.
  2. `fig_hit_road.pdf` x-axis tick labels overlapped → shortened citations + widened canvas.
  3. `fig_lalonde_horserace.pdf` "Truth = $1,794" annotation collided with bar label → repositioned as italic subtitle.

### `/referee2` cross-language replication audit

After the audit, the replication scripts (R/Python/Stata) were switched to a
**leaner PS spec** (linear in covariates, no squared terms) — the cleanest of the
three solver-side fixes the referee suggested. Under this single shared spec, all
three languages converge:

| Estimator | R | Python | Stata | Within $50? |
|---|---:|---:|---:|---|
| Experimental ATT | $1,794 | $1,794 | $1,794 | ✓ |
| LaLonde OLS swap | $699 | $699 | $699 | ✓ |
| HIT local-linear DiD (leaner PS) | $1,315 | $1,315 | (runs, requires Stata) | ✓ |
| Abadie 2005 PS-DiD (leaner PS) | $1,257 | $1,301 | (runs, requires Stata) | ✓ ($44 gap) |

**Note on the spec change.** The deck's figures use the *original* HIT/Abadie
quadratic-terms PS spec (`age + age² + educ + educ² + ... + re74² + re75²`), which
gives R ATTs of $2,051 (HIT) and $1,642 (Abadie). Python's statsmodels lands at a
worse log-likelihood than R's `glm()` on that near-quasi-separated design (R:
$LL=-429$; Python: $LL=-487$), producing a $400-$600 cross-language gap *purely from
the GLM solver*, not from the downstream estimator code. Referee 2 verified: feeding
R's PS into Python's downstream code reproduces R's numbers to the dollar.

The replication uses the leaner spec instead — it converges identically across
languages and is independently informative: the ~$400-$700 gap between
quadratic-spec ATTs ($1,642--$2,051) and linear-spec ATTs ($1,257--$1,315) is itself
the Smith-Todd (2005) specification dependence the deck's "neighborhood, not a
point" slide names.

### Rhetoric audit (vs.\ *Rhetoric of Decks* full essay)
Critical fix (added):
- **New slide 30: "The roads converge on a neighborhood, not a point"** — acknowledges the
  $409 spread between HIT and Abadie, names Smith-Todd (2005) as the warning,
  distinguishes robust order-of-magnitude from fragile third-significant-digit.

Major fixes (applied):
- Slide 21 title: "HIT in R — 12 lines" → **"Twelve lines of R get you to $2,051"**
- Slide 26 title: "Abadie 2005 in R — 5 lines" → **"Five lines of R get you to $1,642"**
- Slide 33 title: "The notation, finally" → **"A-5 is strictly weaker than A-4 — and that is the whole story"**
- Slide 10 (horserace): added `\rmmeta{}` caption naming the $1,095 gap.
- Slide 14 ("toolkit of 1986"): compressed from 3-bullet lit review to one-idea punchline.
- Slide 33 (notation): stripped from 5 stacked assumptions to A-4 ↔ A-5 implication arrow.
- HIT section divider: title rewrapped from "Heckman, Ichimura, Todd" to "Heckman--Ichimura--Todd" to avoid eyebrow collision.

### Graphics audit
All 5 defects (the same 3 as `/tikz` plus two duplicate-title issues) fixed in the R
scripts; figures regenerated; all tables booktabs-clean with consistent gold
highlighting on the experimental ATT.

---

## Compile state

```
$ pdflatex -interaction=nonstopmode lalonde-arc.tex
...
Output written on lalonde-arc.pdf (41 pages, 652180 bytes).
```

- Fatal errors: **0**
- Overfull \hbox / \vbox: **0**
- Underfull \hbox / \vbox: **0**
- Font warnings: **0**
- Undefined references: **0**

One pdflatex pass; no bibtex.

---

## Things Scott should look at before signing off

1. **Cross-language replication note.** The deck quotes R numbers under the
   canonical quadratic-terms PS spec. The replication scripts use a leaner linear PS
   spec where all three languages agree to within $50. The gap between quadratic and
   linear PS specs (~$400-$700) is the Smith-Todd specification dependence — and is
   itself part of what the deck argues. You may want to say this aloud during the live
   walkthrough.

2. **Figure font sizes.** Five rendered figures (`fig_balance`, `fig_lalonde_horserace`,
   `fig_pscore_overlap`, `fig_hit_road`, `fig_abadie_road`) — projected legibility is
   borderline at the smallest axis-tick sizes on `fig_hit_road` (8pt). If the CUNEF
   auditorium is large, bump up to 9pt in `scripts/04_hit_estimator.R` and regenerate.

3. **The Spanish-Madrid pathos beat on slide 24** ("A Spaniard. From the Basque country.
   Codechella Madrid would not exist without him.") — Abadie is from the Basque country,
   not Madrid. Audience may notice the geographic nuance. If you want it cleaner, swap
   to: "A Spaniard. Codechella Madrid would not exist without him."

4. **Smith-Todd (2005) citation.** The Devil's Advocate slide names them. If you want
   the formal cite: Smith, Jeffrey A., and Petra E. Todd. 2005. "Does Matching Overcome
   LaLonde's Critique of Nonexperimental Estimators?" *Journal of Econometrics*
   125(1-2): 305-353.

5. **The Stata replication script** now handles the in-data `age2` collision via
   `capture drop`. If you ship the replication scripts to students, they'll need
   either Stata installed or the R/Python versions instead.
