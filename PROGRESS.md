# Codechella Madrid 2026 — Progress Log

A running log of session-by-session work on the workshop materials. Newest entry on top.

---

## 2026-05-26 — Bias_ΔX restructure + Title X clinics event-study reveal

### `Slides/02-covariates.tex` — Bias_ΔX section rebuilt

**Distributed the dense slides for lower cognitive density.** The old section crammed multiple ideas onto each frame (RCT analogy + DiD-no-randomization + arithmetic + formal product all on one slide). New layout breaks each idea onto its own slide so each frame breathes. The section is now 17 slides where it was 6.

**Reframed the bias as a product.** The formal statement now writes
$$\text{Bias}_{\Delta X} \;=\; (\beta_{\text{post}} - \beta_{\text{pre}}) \;\times\; \big(\mathbb{E}[X|D{=}1] - \mathbb{E}[X|D{=}0]\big)$$
under the time-varying-coefficient model $Y(0)_{it} = \alpha_i + \gamma_t + \beta_t X_i + \varepsilon$. Either factor at zero kills the bias.

**Imbalance is the root.** Two-bullet slide makes the point that randomization zeroes the imbalance term (RCT) and conditioning on $X$ (DR / IPW / OR) does the same job. The two mechanisms — time-varying $X$ with constant $\beta$, vs. time-invariant $X$ with time-varying $\beta_t$ — collapse to the same factorization.

### `Slides/02-covariates.tex` — Title X clinics reveal added (7 slides)

New worked example designed to demonstrate the violation of changing $\beta_t$ on an imbalanced $X$, with an event-study reveal as the pedagogical climax:

| # | Slide | Purpose |
|---|---|---|
| 1 | A worked example of the violation | Names the three ingredients: positive effect, $\beta_t$ shift at year of treatment, imbalanced $X$ |
| 2 | What we built in | Truth $+1.8$, urban slope shifts from $\sim\!-0.1$ to $-2.5$ at year 6, 70/30 urban imbalance |
| 3 | The DGP | Year-by-year `replace trend = ...` Stata block per Scott's exact specification |
| 4 | Run a DiD event study | Naive event-study figure — flat pre-trends, ATT $\approx -3.34$ (sign-flipped from $+1.8$) |
| 5 | We can recover this with the methods today | Same event study conditioned on urban — flat pre-trends, ATT $\approx +1.75$ |
| 6 | One extra variable | Brief code comparison; preview that DR / IPW / OR are coming next |
| 7 | Pre-trends don't protect us from imbalance | Lesson: pre-trends are necessary but not sufficient |

### `Slides/scripts/title_x_eventstudy.R` — new simulation script

R script that recreates Scott's exact DGP (year-by-year trend block: pre-period urban decline $-0.15$ to $-0.10$, rural $+0.10$; post-period urban $-0.5$ to $-2.5$, rural $+0.10$). Runs `did::att_gt` twice — once with no covariate, once conditioning on `urban` — and aggregates via `did::aggte` to event-study form. Plots both event studies with the Madrid palette (terracotta for the wrong answer, navy for the truth) and saves to `Slides/figures/`.

**Estimates produced:**
- No covariate: ATT $\approx -3.34$. Pre-trend coefficients $-0.09$, $+0.09$, $-0.18$, $+0.01$ (all CIs cover zero). Post: $-0.5$, $-1.4$, $-3.1$, $-4.8$, $-7.0$.
- With urban: ATT $\approx +1.75$. Pre-trends still near zero. Post: $+0.5$, $+1.3$, $+1.6$, $+2.4$, $+3.1$.

### Figures generated
- `Slides/figures/titlex_es_naive.pdf` — event study with no covariate, sign flips
- `Slides/figures/titlex_es_urban.pdf` — event study conditioning on urban, truth restored

### Other
- Copied `mit_deck.pdf` (1.5 MB) from `claudecode33/` into `Slides/` as reference material.

### Pedagogical decisions worked through
- **Imbalance is the root, $X$-trends are the channel.** Originally framed the bias as "X-specific trends in $Y(0)$"; Scott pushed back that imbalance is the deeper engine because if treated and control had been equally urban, the urban-specific decline would wash out across groups. Reformulated the bias as the explicit product so either factor at zero kills it.
- **The Title X simulation has time-invariant $X$ ($\Delta X = 0$) — so the bias engine is the time-varying $\beta_t$, not $\Delta X$.** Updated the formalization slide accordingly: bias = $(\beta_{\text{post}}-\beta_{\text{pre}})\cdot(\mathbb{E}[X|D{=}1]-\mathbb{E}[X|D{=}0])$ unifies both the time-varying-X and time-varying-$\beta$ cases.
- **DGP designed so pre-trends pass but post-period sign-flips.** The pre-period urban-rural slope gap is small ($\sim\!0.1$ vs $\sim\!0.1$ in magnitude). The post-period gap grows fast ($-0.5$ to $-2.5$ vs $+0.1$). Pre-trend coefficients in the event study sit near zero with CIs covering zero; post-trend coefficients hockey-stick down.
- **Don't introduce `csdid` by name in this section.** The estimators (DR, IPW, OR) and their Stata wrappers come later in the deck — these slides only show "a DiD event study" and "the methods today."

### Commit landed
`365d463` — "02-covariates: Title X clinics event-study reveal + add mit_deck reference" (9 files changed, 594 insertions, 266 deletions)

---

## 2026-05-25 — Madrid-2026 deck series migration

Foundational rebuild that converted the 2025 Glasgow-era materials into the Madrid-2026 deck series.

- `Codechella Madrid 2026: migrate from 2025 decks to Glasgow-2026 series` — full deck inventory rebuilt, 2025 decks archived under `Slides/archived_2025/`
- `Madrid theme: factor into madrid_theme.sty, apply to all 7 decks` — palette switched from Glasgow green to Madrid (terracotta `#C44536`, twilight navy `#2C3E5C`, peach `#FBE5D0`, gold `#C9982A`, cream `#FAF6EE`); `\codechellatitle{Title}{Subtitle}{Author}{Venue}` macro added with Gran Vía banner (`codechella_2026.jpg`)
- `README: switch banner to codechella_2026.jpg, fix deck list, add Registration row` — schedule table updated
- `01-basics: restructure Medicaid arc as building case + honest pre-trends` — §10 reorganized with framework-emphasis slides (Bite / Falsification / Event-study+Main-result / Mechanism each get a "five pieces" recall with current piece highlighted); honest pre-trends caveat added per Rambachan-Roth 2024 sensitivity
- `Fix Day-N labels: workshop is 4 days not 5; drop morning/afternoon` — corrected all "Day 2 morning/afternoon" framings; workshop runs Mon–Thu

---

*Going forward: each working session adds a new dated entry on top.*
