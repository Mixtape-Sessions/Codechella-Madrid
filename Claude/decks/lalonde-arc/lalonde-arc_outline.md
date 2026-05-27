# `lalonde-arc` — Outline

## Audience & rhetoric
- **Audience:** Codechella Madrid 2026 workshop participants. Applied empirical economists. Mix of grad students and faculty.
- **Rhetorical balance:** ~35% pathos / 25% ethos / 40% logos. This is a *teaching deck with a research-talk spine* — the story matters as much as the math.
- **The ONE sentence (closing slide):** *"When two roads built a decade apart arrive at the same $1,794, the field has its answer."*

## Theme
- **Palette:** Sunset on the Bernabéu — crisp white, royal Madrid blue (#00529F), crown gold (#FEBE10), deep violet (#6E2A82), charcoal text, sparing burgundy for alerts.
- **Frame title:** small gold vertical hairline at left + bold blue title + thin gold underline.
- **Section dividers:** full-bleed royal blue, gold "ACT" eyebrow, white serif title, short gold rule.
- **Title slide:** top 55% deep-blue band, gold eyebrow + white serif title + gold italic subtitle, bottom 45% white field with author + venue + a tiny gold rule.
- **Stat slide:** 84pt gold numeral + blue caps caption. Used at the climax moments.

## The arc

### Act I — The Heretic and the Truth (slides 1–8)
1. Title frame
2. Cold open: a name (Robert LaLonde) and a date (1986)
3. The question that broke the field: *Does observational causal inference even work?*
4. The experiment: NSW, 1975–1979 — random assignment to a real labor program
5. The data: 445 people, 9 covariates, one outcome — R chunk loads it
6. **STAT SLIDE: $1,794** — the experimental ATT
7. Who was LaLonde? Princeton, 1986, JEP — the heretic at 32
8. What he did next (the swap that broke everything)

### Act II — The Crisis (slides 9–16)
9. The swap: drop the experimental controls, paste in CPS
10. Beautiful comparison table: experimental vs. non-experimental
11. **STAT SLIDE: −$8,498** — naïve OLS bias
12. The skeptic's reading: *if matching can't recover $1,794, what can?*
13. The 13-year silence: 1986 → 1999
14. What the field had (Heckman 1979, RR 1983) and why it didn't crack LaLonde
15. The first crack: Dehejia & Wahba (1999, JASA) — propensity score matching brings the answer back
16. But matching alone is fragile: specification dependence + common support

### Act III — Two Roads to the Same Answer (slides 17–30)
17. ACT divider: "Heckman, Ichimura, Todd"
18. Who they were: Chicago, Pittsburgh, Pennsylvania
19. The diagnostic: B = B₁ + B₂ + B₃ (figure)
20. The key insight: parallel trends conditional on X (A-5) is *weaker* than matching (A-3, A-4)
21. The test they ran: A-3, A-4 rejected. A-5 not rejected. (A figure of p-values.)
22. The estimator: local-linear matching + conditional DiD
23. R CODE: HIT-style estimation on Dehejia-Wahba
24. **STAT SLIDE: $1,690** — HIT recovers the experimental answer
25. ACT divider: "Abadie"
26. Who he was: MIT 2005, the synth author
27. The elegance: re-weight instead of match. One function (the propensity score), one weighted average.
28. R CODE: Abadie 2005 PS-weighted DiD
29. **STAT SLIDE: $1,802** — Abadie recovers the experimental answer
30. The synthesis: both roads, same destination

### Act IV — Why Then? Why These People? (slides 31–37)
31. ACT divider: "Why these dates?"
32. The 1997 question: why HIT then? (Fan 1992 + RR 1983 + Card-Krueger 1994 + the 11-year unsolved challenge)
33. The 1997 sub-story: Heckman's Chicago lab, the dissertation pipeline (Smith-Todd, Ichimura)
34. The 2005 question: why Abadie then? (HIR 2003 + BDM 2004 + Abadie-Gardeazabal 2003 weights)
35. The 2005 sub-story: MIT-Harvard, the synthetic control lineage, why "weighting" was in the water
36. Notation appears (briefly): A-1, A-3, A-5, the Abadie weight ρ₀
37. The final stat slide: $1,794, $1,690, $1,802 — three numbers, one truth

### Closing (slide 38)
38. The closing line on a blue field with a gold underline.

## Figures & tables (code-first)
- **fig_palette.pdf** — preview the deck's palette (used only in the README, not in the deck)
- **fig_nsw_balance.pdf** — covariate-balance table for NSW experimental
- **fig_lalonde_comparison.pdf** — the experimental vs. non-experimental "horserace"
- **fig_bias_decomp.pdf** — schematic of B = B₁ + B₂ + B₃ (TikZ, no PNG)
- **fig_pscore_overlap.pdf** — propensity-score histograms for NSW-treated vs. CPS-controls (the Figure 1 analog from HIT 1997)
- **fig_timeline.pdf** — TikZ timeline 1976–2005 with the canonical milestones
- **tab_main_results.tex** — one table, four ATT numbers, gold-highlighted

## Scripts (code-first, standalone)
- `scripts/01_experimental_att.R` — load NSW, compute experimental ATT, export `tab_experimental.tex` and `nums.txt`
- `scripts/02_lalonde_swap.R` — load NSW+CPS, run naïve OLS, export `tab_lalonde.tex` and `fig_lalonde_comparison.pdf`
- `scripts/03_pscore_overlap.R` — fit logit, plot histograms, export `fig_pscore_overlap.pdf`
- `scripts/04_hit_estimator.R` — PS matching + conditional DiD, export `tab_hit.tex`
- `scripts/05_abadie_estimator.R` — PS-weighted DiD à la Abadie 2005, export `tab_abadie.tex`
- `scripts/99_main_results.R` — assembles all four numbers into `tables/tab_main_results.tex`

## Replication (R / Python / Stata)
- `/Users/scunning/Codechella-Madrid/Claude/code/replication/`
  - `replicate_main.R` — independent reproduction of all four ATT numbers
  - `replicate_main.py` — same, in Python (statsmodels + pandas)
  - `replicate_main.do` — same, in Stata
- Cross-check passes if all three give the same four ATTs to within $50 (rounding/precision differences in PS fitting).
