# `basics.tex` — Glasgow Day 1 Outline
### Advanced Topics in Applied Causal Inference · Mini-course at University of Glasgow · Mon May 18, 2026

---

## Audience and rhetoric (Step 0)

- **Source**: existing `CI-2/Slides/Tex/01-Basics.tex` + Scott's Google Sheet + `castle.dta` lab + Card-Krueger material + event-study Shiny app
- **Audience**: PhD students at the University of Glasgow Graduate School of Economics (20 registered; 7 writing for credit). Mixed prior exposure to DiD — some have seen the 2×2 before, some haven't. All have basic econometrics.
- **Aristotelian balance**: **Logos 45% · Ethos 20% · Pathos 35%** (teaching lecture, PhD level). Clarity > compression. Progressive revelation. Worked examples as content. Recap slides allowed.
- **Tone / aesthetic**: The Remix style — Helvetica scaled 0.92, bright green accent (`#40A848`) sampled from the book cover, cream warmth, deep green section bands. Restraint with personality. Already built in `remix.sty`.
- **Code language**: Both **Stata and R**. The two demos are `equivalence.do` and `equivalence.R` — Scott shows whichever he prefers live; both are runnable. Event study demo is `simple_eventstudy.R`. Live Shiny app at the end.
- **Format**: Beamer (default).
- **The ONE sentence** the audience walks away with: **"DiD is a research design with two ingredients — the 2×2 calculation, and parallel trends — and together they identify the ATT."**

---

## Theme

Already built in `remix.sty`. Brief recap:
- **Bright green** `#40A848` accent (cover-sampled), used for rules, bullets, eyebrows
- **Deep green** `#1F5C25` for section dividers (full-bleed top band)
- **Charcoal** `#2D3748` for frame titles and emphasis
- **Slate** `#4A5568` for body
- **Cream** `#FAF8F2` for title slide warmth
- **Helvetica** scaled 0.92, Source Code Pro for code
- **Section dividers** are full-bleed cream with deep green band on top and "LESSON" eyebrow above the title
- **One idea per slide** is the structural rule. Two max for inseparable contrasts.

---

## The narrative arc

**The ONE sentence**: DiD is a research design with two ingredients — the 2×2 calculation, and parallel trends — and together they identify the ATT.

**The pedagogical movement** (per `DESIGN_PRINCIPLES.md`): Narrative → Application → Picture → Codeblock → Technical. The technical arrives **last**, after the audience already understands what it says.

The deck has **3 acts** mapped to **7 lessons**, ending with the closing one-sentence linger.

---

### Act I — Tension and welcome (slides 1–7)

| # | Title (assertion) | Element | Density |
|---|---|---|---|
| 1 | *(title slide)* | green cover + title + venue | 2 |
| 2 | This week: three days of mine, one of Dan's | a four-day table | 2 |
| 3 | I'm Scott. I write a book called *The Remix*. | photo or cover + 3-line bio | 2 |
| 4 | We'll show Claude Code for research throughout | one concrete example screenshot | 2 |
| 5 | Pass / fail: a dataset, an analysis, an interpretation | the assessment one-pager | 2 |
| 6 | A roadmap: Mon foundations · Tue covariates+staggered · Wed synth+frontier | three-column visual | 3 |
| 7 | *(section divider)* — **Lesson 1: DiD Origins** | divider | 1 |

### Act II — Investigation: the 7 lessons (slides 8–32)

#### Lesson 1 — DiD origins: Ashenfelter and the 2×2 (slides 8–14)

| # | Title (assertion) | Element | Movement stage |
|---|---|---|---|
| 8 | DiD is a research design, not a regression | full-bleed quote / pullquote | Narrative |
| 9 | DiD has two ingredients | side-by-side: "1. a calculation" / "2. an assumption" | Narrative |
| 10 | One of several causal panel methods — not the only one | brief list: DiD, synth, panel IV, MCNN | Narrative / caveat |
| 11 | Princeton, late 1970s: Ashenfelter teaches bureaucrats | a person and a place; brief story | Narrative |
| 12 | His move: don't lead with regression — lead with four averages | annotated 2×2 cell diagram (TikZ) | Application |
| 13 | The four averages | the 2×2 table, four labeled cells | Picture |
| 14 | The three subtractions: (Y₁₁−Y₁₀) − (Y₀₁−Y₀₀) | one equation, big | Technical |

**Frames: 7. Section divider before, code demo after. Slides 9–10 set the thesis: DiD = calculation + assumption, and DiD isn't the only causal panel design. The rest of the day fills in both ingredients.**

| # | Title (assertion) | Element |
|---|---|---|
| 13 | *(section divider)* — **Lesson 2: Calculating the 2×2 on castle.dta** | divider |

#### Lesson 2 — Calculating the 2×2 on castle.dta (slides 14–17)

| # | Title (assertion) | Element | Stage |
|---|---|---|---|
| 14 | castle.dta: stand-your-ground laws, 2005–2006, state-year panel | data structure table | Application |
| 15 | The four cells, by hand | live demo: Stata cell means | Codeblock |
| 16 | We get a number. Hold it. | the four cell values + the DiD | Picture / Technical |
| 17 | This is the answer. Now we'll get it three more ways. | one-line transition | Narrative bridge |

**Frames: 4. Live code demo at slide 15 (~5 min in Stata or R). Slide 17 is one sentence on a blank slide.**

| # | Title (assertion) | Element |
|---|---|---|
| 18 | *(section divider)* — **Lesson 3: Three Regressions, One Answer** | divider |

#### Lesson 3 — Three regressions, one answer (slides 19–23)

| # | Title (assertion) | Element | Stage |
|---|---|---|---|
| 19 | OLS with interactions recovers the 2×2 | code block: `reg l_homicide post##treat` + output | Codeblock |
| 20 | TWFE with state and year FE recovers the 2×2 | code block: `xtreg ... fe` + output | Codeblock |
| 21 | Long differences recovers the 2×2 | code block: reshape wide; `reg diff treat` + output | Codeblock |
| 22 | All three: the same number to machine epsilon | three numbers side by side | Picture / Technical |
| 23 | This equivalence is *what made DiD extensible* | one-sentence claim + small annotation | Narrative bridge |

**Frames: 5. Live code at 19–21. Slide 23 sets up the conjecture: OLS infrastructure enabled covariates, staggered, continuous — but breaks when you push it.**

| # | Title (assertion) | Element |
|---|---|---|
| 24 | *(section divider)* — **Lesson 4: From 2×2 to ATT** | divider |

#### Lesson 4 — Where the assumption comes in (slides 25–35)

This lesson adds **ingredient 2**: the identification assumption (parallel trends) that turns the 2×2 calculation into the target parameter (ATT).

| # | Title (assertion) | Element | Stage |
|---|---|---|---|
| 25 | Recap: we have ingredient 1 — the calculation. We need ingredient 2. | the two-ingredient frame, ingredient 1 checked off | Narrative |
| 26 | At Princeton in the 80s, Angrist never learned potential outcomes | a quote + brief story | Narrative |
| 27 | Rubin (1974) revives Neyman (1923): Y(1), Y(0), the counterfactual | side-by-side cover images + key dates | Narrative / Picture |
| 28 | The switching equation: Y = D·Y(1) + (1−D)·Y(0) | one equation, big | Technical |
| 29 | Suppose you had all the data — what would you compute? | a thought experiment | Narrative / Application |
| 30 | That's a **population estimand**: the calculation with all the data | definition + illustration | Technical |
| 31 | Regress earnings on a college dummy. Causal? | one regression, one question | Application |
| 32 | Yes if randomized. No if selection. | two scenarios side-by-side | Picture |
| 33 | A population estimand can be **biased** — a **target parameter** cannot | side-by-side definition | Technical |
| 34 | Bias = the non-causal terms that ride along with the causal term | estimand = causal + bias | Technical |
| 35 | **Identification** is what strips the bias. **Parallel trends** is the DiD strategy. | the bridge claim | Technical |
| 36 | The ATT is the target parameter for DiD | small equation + plain English | Technical |
| 37 | Add a zero, rearrange: 2×2 = ATT + non-PT bias (under NA) | the algebra | Technical |
| 38 | Parallel trends is weaker than randomization | parallel vs. crossing trends picture | Picture |
| 39 | Now we have both ingredients: calculation + PT → ATT | the two-ingredient frame, both checked off | Recap |

**Frames: 15. The longest lesson because it carries the formal core: target parameter vs. population estimand, identification, ATT, and the parallel trends assumption. Still one idea per slide. This is the conceptual machinery the rest of Days 1–3 depends on.**

| # | Title (assertion) | Element |
|---|---|---|
| 31 | *(section divider)* — **Lesson 5: Stability and Trends — A Live Walkthrough** | divider |

#### Lesson 5 — Google Sheet walkthrough (slide 32 + live)

| # | Title (assertion) | Element | Stage |
|---|---|---|---|
| 32 | We'll open the sheet — what's there to see | screenshot of the sheet + URL | Live |

**1 slide + ~15-20 min interactive on the sheet** (tabs: Potential Outcomes → 2×2 → Balancing → 2XT #1). The point: visually show Y=Y(0) pre-treatment, and Y=Y(0) for D=0 regardless of D=1's status (SUTVA / stability). No additional slides — the sheet *is* the content.

| # | Title (assertion) | Element |
|---|---|---|
| 33 | *(section divider)* — **Lesson 6: The Minimum Wage Wars** | divider |

#### Lesson 6 — Card-Krueger minimum wages (slides 34–38)

| # | Title (assertion) | Element | Stage |
|---|---|---|---|
| 34 | NJ raises its minimum wage to $5.05. PA doesn't. | the timeline + the map | Narrative |
| 35 | Card & Krueger 1994: fast-food employment | the headline finding + a single figure (employment trends) | Picture |
| 36 | Card on the study | a quote pulled from the original interview | Pathos |
| 37 | Neumark and Wascher push back | one-line summary + video clip cue | Narrative / Application |
| 38 | What the right answer is — and why pre-trends matter | pre-trends plot + one bullet | Picture / Application |

**Frames: 5. Video clips of the C-K / N-W debate punctuate. This is the lesson's emotional core (pathos) — the human reality of an empirical fight that mattered.**

| # | Title (assertion) | Element |
|---|---|---|
| 39 | *(section divider)* — **Lesson 7: Event Studies as a Series of 2×2s** | divider |

#### Lesson 7 — Event studies as a series of 2×2s (slides 40–45)

| # | Title (assertion) | Element | Stage |
|---|---|---|---|
| 40 | An event study is the 2×2 viewed in motion | one annotated event-study plot | Picture |
| 41 | Every coefficient is a 2×2 against t−1 | the saturated regression spec | Technical |
| 42 | The baseline period is the hinge | small TikZ schematic — time axis with t−1 as the zero | Picture / Technical |
| 43 | castle.dta event study, live | live demo: `simple_eventstudy.R` | Codeblock |
| 44 | What we see and what we *don't* see in pre-trends | the result, annotated | Application |
| 45 | Try it yourself: the Event-Study Shiny app | screenshot of the Shiny + URL | Live / Application |

**Frames: 6. Live R demo at slide 43. Slide 45 closes the day with the interactive app — students can play with it tonight.**

---

### Act III — Resolution (slides 46–48)

| # | Title (assertion) | Element |
|---|---|---|
| 46 | What we've done today | recap: 7 lessons listed, no commentary | Picture |
| 47 | Tomorrow: when the 2×2 stops working | preview of Day 2 — Bacon, CS, BJS, dCdH | Narrative bridge |
| 48 | **DiD is a research design with two ingredients — the 2×2 calculation and parallel trends. Together they identify the ATT.** | full-bleed cream + one sentence in charcoal | THE CLOSING |

**Frames: 3. Slide 48 lingers. It is what they remember.**

---

## Total slide count

- **Act I (welcome)**: 7 slides
- **Act II (7 lessons + 7 section dividers)**: ~50 slides
  - Lesson 1 (DiD as design → 2-ingredient thesis → Ashenfelter → 2×2): 7 + divider
  - Lesson 2 (castle.dta four cells, live): 4 + divider
  - Lesson 3 (three regressions, live): 5 + divider
  - **Lesson 4 (estimand → target → identification → ATT → DiD): 15 + divider** *(longest — formal core, both ingredients land)*
  - Lesson 5 (Google Sheet live): 1 + divider
  - Lesson 6 (Card-Krueger / min wage): 5 + divider
  - Lesson 7 (event studies, live): 6 + divider
- **Act III (close)**: 3 slides
- **TOTAL**: ~60 slides for a 6-hour teaching day.

That's ~6 minutes of teaching per slide on average. Slower than a typical seminar, faster than a glacial graduate lecture. The cadence works for PhD students — one idea per slide leaves room for questions between slides. Lesson 4 is the conceptual fulcrum where the two ingredients (calculation + assumption) lock together; the rest of Days 1–3 builds on it.

---

## Figures and tables (code-first)

All figures/tables that appear in the deck must have a corresponding generating script. Most exist already in the source repos:

| Element | Where it lives now | Need to create? |
|---|---|---|
| `castle.dta` four-cell calculation output | `CI-2/Lab/Basic-DiD/equivalence.do` | No — run live |
| Three regressions output | same | No — run live |
| Card-Krueger employment trends plot | needs check — `01-Basics.tex` may have it; if not, build one from CK data | Maybe — small ggplot script |
| Pre-trends plot for CK | same | Maybe |
| Event-study plot for castle.dta | `CI-2/Lab/Basic-DiD/simple_eventstudy.R` | No — run live |
| Event-Study Shiny app screenshot | `CI-2/Shiny-Apps/Event-Study/app.R` (running) | Maybe — capture a clean screenshot for the slide |
| TikZ: 2×2 cell diagram | build new in remix.sty TikZ — small | Yes — one diagram |
| TikZ: time-axis with t−1 baseline | build new — small | Yes — one diagram |
| TikZ: parallel vs. crossing trends | build new — small | Yes — one diagram |

**3 new TikZ diagrams** + possibly **2 ggplot figures** (Card-Krueger). The rest are live demos or existing assets.

---

## Critical files (re-confirming from plan)

**Read-only sources:**
- `CI-2/Slides/Tex/01-Basics.tex` — content source
- `CI-2/Lab/Basic-DiD/equivalence.do`, `.R` — three-regressions live demo
- `CI-2/Lab/Basic-DiD/simple_eventstudy.R` — event study live demo
- `CI-2/Shiny-Apps/Event-Study/app.R` — interactive close
- `/Users/scunning/the-remix-tour/glasgow/decks/remix.sty` — the style (already built)
- `/Users/scunning/the-remix-tour/glasgow/decks/green_remix_cover.png` — title slide asset (already copied)

**To create:**
- `/Users/scunning/the-remix-tour/glasgow/decks/basics.tex` — the deck itself (~47 frames)
- `/Users/scunning/the-remix-tour/glasgow/decks/scripts/cardkrueger_employment.R` — if needed for CK figure
- `/Users/scunning/the-remix-tour/glasgow/decks/scripts/cardkrueger_pretrends.R` — if needed
- `/Users/scunning/the-remix-tour/glasgow/decks/figures/` — output directory
- Three TikZ blocks defined inline in `basics.tex` (cell diagram, time-axis hinge, parallel-vs-crossing)

---

## Checkpoint: what to confirm with Scott

Before writing a single slide, confirm:

1. **47 slides feels about right for 6 hours?** (~7-8 min/slide average. If Scott wants fewer/more, adjust now.)
2. **The 7-lesson structure?** (Ashenfelter → castle 2×2 → three regressions → ATT → Google Sheet → minimum wage → event study)
3. **The closing sentence?** "DiD is a research design with two ingredients — the 2×2 calculation and parallel trends. Together they identify the ATT."
4. **Stata or R as primary live language?** (Or alternate by demo?)
5. **Card-Krueger figure approach** — pull from `01-Basics.tex` if present, or build a fresh ggplot? (Verify when we get there.)
6. **Three TikZ diagrams** — cell layout, time axis with t−1, parallel-vs-crossing trends. OK to build, or want different ones?

---

*This outline follows `/beautiful_deck` Step 2. Get Scott's sign-off before slide-writing begins.*
