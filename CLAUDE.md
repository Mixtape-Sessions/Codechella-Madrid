# CLAUDE.md — Codechella Madrid 2026 Operating Manual

This file is for **Claude agents picking up work on this repo.** It captures the design decisions, file structure, and gotchas that aren't obvious from grepping.

If you're a human and prefer the participant-facing overview, see `README.md`.

---

## 1. What this repo is, and the two-repo relationship

This is **`Codechella-Madrid`** — the public workshop repo for **Codechella Madrid 2026** (May 25–28, CUNEF Auditorium).

The **source-of-truth** for slide content lives in a sister repo, **`the-remix-tour`**, at:
```
/Users/scunning/the-remix-tour/glasgow/decks/
/Users/scunning/the-remix-tour/glasgow/labs/
/Users/scunning/the-remix-tour/glasgow/shiny_apps/
```

That repo holds Scott's working copies for the multi-city 2026 workshop tour (Glasgow → Madrid → Pisa → Leuven → Berlin → Lucca → Zurich). Each workshop "stop" reuses the same core decks with stop-specific adaptations.

**Sync direction:** changes flow from `the-remix-tour` → `Codechella-Madrid`. **Do not edit Codechella-Madrid/Slides/*.tex directly without also updating the corresponding file in the-remix-tour.** Otherwise the two will drift.

The sync is a manual `cp` — there's no automation. The standard sync block is:
```bash
SRC=/Users/scunning/the-remix-tour/glasgow/decks
DST=/Users/scunning/Codechella-Madrid/Slides
cp "$SRC"/*.tex "$DST"/
cp "$SRC"/*.pdf "$DST"/
cp "$SRC"/remix.sty "$DST"/
cp -R "$SRC"/figures "$DST"/
cp -R "$SRC"/scripts "$DST"/
```

For labs (which were last synced selectively), see §6 below.

---

## 2. What happened in the May 2026 migration

Before May 2026, this repo held the original **Codechella Madrid 2025** material — five decks (`01-Codechella-Core.tex` through `05-Codechella-Imputation.tex`) plus seven labs.

In a single migration session (May 22–24, 2026), the 2025 material was **archived in place** and replaced with the Glasgow-2026 deck series + the new `01-basics.tex` (a 90-minute condensed Core DiD deck designed specifically for the Madrid Day 1 slot).

### What was archived
- `Slides/archived_2025/` now holds: `01-Codechella-Core.{tex,pdf,...}`, `02-Codechella-Violations.{tex,pdf}`, `03-Codechella-Continuous.{tex,pdf}`, `04-Codechella-GxT.{tex,pdf}`, `05-Codechella-Imputation.{tex,pdf}`, plus `lecture_includes/`, `math_old.sty`, `preamble_old.tex`, and an explanatory `README.md`.
- The archived decks still compile — `lecture_includes/` and the old `math.sty` (renamed to `math_old.sty`) were moved alongside so the archive is self-contained.

### What was added to `Slides/`
- **`01-basics.tex`** — 65-page, 90-min Core DiD deck. Madrid-themed. **NEW for this workshop.**
- All other Glasgow decks copied wholesale: `basics.tex` (the full 169-page Glasgow Day 1), `04-staggered.tex`, `06-checklist.tex`, `03-continuous.tex`, `02-covariates.tex`, `02b-lalonde.tex`, `synth.tex`, `triple-diff.tex`, `05-claude.tex`, `test_remix.tex`.
- `remix.sty` — the shared Beamer style.
- `figures/` — all figure PDFs/PNGs referenced by the decks.
- `scripts/` — R/Python that regenerates the figures.
- `code/` — figure-generation source (excluding the two ~100 MB shinylive bundles for SE-Demo and Event-Study-Demo; those live in `the-remix-tour` only).
- `codechella_2026.jpg` — Madrid Gran Vía sunset image used on the `01-basics.tex` title slide.

### What was added to `Labs/`
The Codechella-Madrid `Labs/` folder already had: Baker, China-WTO, DDD, Example-Code, Kline-Moretti, Lalonde, Medicaid-Expansion.

These Glasgow-only labs were copied in: **Brazil, Castle, Lalonde-Covariates, Texas, Triple-Diff, basic**.

`China-WTO/` was overwritten with the Glasgow version because the Glasgow copy had bug fixes (year filter `2000`→`2001` to match the R, removed orphaned `npregress`, etc. — see `Labs/China-WTO/README.md`).

---

## 3. The 90-minute `01-basics.tex` constraint and its design

**Why `01-basics.tex` exists separately from `basics.tex`:**

The Glasgow workshop runs Day 1 over 4 hours (basics.tex is 169 pages). The Madrid Day 1 Core DiD slot is **90 minutes only.** A 169-page deck won't fit. So `01-basics.tex` is a **46-frame (now 53-frame after restorations) compressed version** keyed to a 12-section spine.

The spine (built around the 2×2 as the conceptual anchor):
1. **DiD's empirical roots** — Semmelweis + Orley (3 slides)
2. **DiD = a calculation AND an assumption** — PO, switching equation, PT, bridge slide (5 slides)
3. **Five regressions, one number** — Cheng-Hoekstra + 5 equivalent regressions (8 slides)
4. **Decomposing the 2×2** — proof + 3 failure modes (5 slides)
5. **Card-Krueger; PT visualized** — incl. "Aside: across-group PT" (6 slides)
6. **Open the Sheet** — live Google Sheet demo (1 slide)
7. **Standard errors** — three flavors + HC1 numerical + why HC fails in DiD + CRVE numerical + BDM placebo (5 slides)
8. **Population weighting** — ten people two counties → sorting on δ → pick a target (5 slides)
9. **Event studies as falsification** — PT-is-Y(0) + saturated OLS spec (5 slides)
10. **Event study: by hand vs OLS** — tiny panel + code (2 slides)
12. **Five pieces of a strong DiD** — Medicaid bites + falsification + result + recap (8 slides)

(Section 11 = the covgap material is intentionally dropped — too dense for 90 min, lives in `02-covariates.tex`.)

**Pedagogical hinges that were added (not in basics.tex):**
- §2.5 — bridge slide: "Under PT, the 2×2 hits the ATT" — explicit punchline
- §3.1 — Cheng & Hoekstra (2013) setup as the running empirical example (replaces "castle.dta" abstraction)
- §3.6 — **Regression 4: across-group difference on post dummy** — FWL mirror of Regression 3. NEW pedagogy.
- §5.5 — "Aside: across-group parallel trends" — marked Aside so it's drop-in-drop-out if behind schedule
- §6 — Google Sheet walkthrough: https://docs.google.com/spreadsheets/d/1onabpc14JdrGo6NFv0zCWo-nuWDLLV2L1qNogDT9SBw/edit
- §9.1 — explicit "PT is about Y(0), not 'trends' abstractly"

Time math: 90 min ÷ 53 slides = ~1.7 min/slide. Live Google Sheet demo eats clock; the buffer is thin.

---

## 4. The Madrid palette ("Sunset on Gran Vía")

`01-basics.tex` overrides the default Glasgow green with a Madrid-themed warm palette. The override pattern is local to `01-basics.tex` — **`remix.sty` is unchanged**, so every other deck (continuous, synth, bacon_cs, ...) still renders in Glasgow green.

| Role | Hex | Replaces |
|---|---|---|
| `madridterracotta` `#C44536` | Highlights, bullets, eyebrow text, math callouts | `remixgreen` `#40A848` |
| `madridtwilight` `#2C3E5C` | Section-divider top band | `remixgreendark` `#1F5C25` |
| `madridpeach` `#FBE5D0` | Alert block backgrounds | `remixgreenlight` `#D9F0DB` |
| `madridgold` `#C9982A` | Secondary accent (cluster 3 in CRVE table) | `forest` `#276749` |
| `madridcream` `#FAF6EE` | Page background | `cream` `#FAF8F2` |

The override block lives near the top of `01-basics.tex`, immediately after `\usepackage{remix}`. It uses `\colorlet` to remap color names rather than `\definecolor` (which would conflict with the package's definitions).

**Two style hooks were added to `remix.sty`** (these benefit all decks, not just Madrid):

1. **`\remixsectionvenue`** (line ~123 of `remix.sty`): overridable string for the section-divider top-right venue. Default: `"Glasgow \textperiodcentered\ May 2026"`. Override per deck:
   ```latex
   \renewcommand{\remixsectionvenue}{Codechella Madrid \textperiodcentered\ May 2026}
   ```

2. The `\remixfooter` was already overridable via `\providecommand`. `01-basics.tex` sets it to:
   ```latex
   \renewcommand{\remixfooter}{Codechella Madrid 2026\,\textperiodcentered\,CUNEF\,\textperiodcentered\,May 25--28}
   ```

---

## 5. The Madrid title-frame override

`01-basics.tex` does **not** use the default `\remixtitleframe{}` macro because the Madrid image (`codechella_2026.jpg`) is **landscape 1536×1024** — the default title layout expects a portrait image on the left (the green-cassette `green_remix_cover.png` is 1100×1714 portrait).

Instead, `01-basics.tex` defines a one-off banner-on-top title frame inline:

- Madrid skyline image as a **clipped banner** (top 55% of the slide), full width.
- Thin terracotta accent rule below the banner.
- Title text block centered in the lower 45%.

The clipping uses TikZ's `\clip` to chop the image at the right height; without that, the 3:2 image is too tall for the 16:9 slide.

**Do not** promote this pattern back to `remix.sty` without first deciding whether all future workshops will use a landscape title image. If yes, add a `\remixtitleframeBanner{title}{subtitle}{author}{venue}{image}` macro to the style file.

---

## 6. The lab inventory and the China-WTO fixes

`Labs/` mixes legacy 2025 labs (kept untouched) with synced-from-Glasgow labs.

### Recent China-WTO fixes (May 2026, in the Glasgow source and synced here)
1. **R: `predict(est_spline, ...)` → `predict(est_linear, ...)`** at lines 76 + 182 — the "Linear Estimate" was mistakenly showing the spline prediction.
2. **R event-study loop:** duplicate `2005` → `2004` so the loop covers `c(1998, 1999, 2000, 2002, 2003, 2004, 2005)`.
3. **Stata:** hardcoded `cd ~/Documents/Mixtape-Sessions/Codechella-Madrid/...` removed (was stale path); replaced with a `* cd "..." ` comment for the user.
4. **Stata year filter:** `2000`→`2001` (Lu & Yu use the immediately-pre-WTO 2001 tariff, not 2000). All variable names `tariff_2000`/`ln_theil_2000` renamed to `_2001`.
5. **Stata:** orphaned `npregress` commented out so the subsequent `predict te_est_spline` correctly uses the spline regression.
6. **Stata:** `i.bin_*` → `bin_*` (drop the `i.` prefix with `nocons`).
7. Added `Labs/China-WTO/README.md` explaining the workflow.

### The five-equivalence pattern in `basic/equivalence.{do,R}`
Updated in May 2026 to demonstrate **five equivalent paths** to the 2×2 (β_DD = 0.108 on `castle.dta`):

1. Manual 2×2 (Snow's long differences)
2. OLS with treat × post interaction
3. TWFE
4. First difference ΔY on treatment dummy
5. **Across-group difference (treated − control by year) on post dummy** — NEW (FWL mirror of Path 4)

Path 5 has NaN standard errors (only 2 observations after the collapse + reshape). That's expected — it's an identity, not an inference object. Pedagogically useful as exactly that.

---

## 7. Open items

Not yet done as of the May 2026 migration session:

- **Reformat `01-basics.tex` slide 6** (Google Sheet demo) — currently a simple title-link slide; could be more visually interesting.
- **Decide whether to restore `\remixtitleframeBanner{}` to `remix.sty`** if more decks will use landscape title images.
- **Verify `code/` figure-generation scripts still run** — they were synced from Glasgow but not smoke-tested in this folder.
- **The image at `img/banner.png`** is referenced in the README's top banner (`<img src="https://github.com/Mixtape-Sessions/Codechella-Madrid/blob/main/img/banner.png?raw=true">`). Verify it still exists and points to a 2026 banner, not the 2025 banner.
- **Git push** — the May 2026 migration has not been committed to the GitHub remote (`https://github.com/Mixtape-Sessions/Codechella-Madrid.git`). When Scott is ready, the commit message should reference: "Migrate to Glasgow-2026 deck series + Madrid-themed 01-basics for Codechella Madrid 2026."

---

## 8. Compile guide

Every deck in `Slides/` compiles with one `pdflatex` pass (the bibliography is embedded). They all use `remix.sty` in the same folder.

```bash
cd Slides
pdflatex 01-basics.tex
```

A second pass is needed only if you change section structure or cross-references. There are no `bibtex` calls.

**Expected output:**
- `01-basics.pdf`: 65 pages, ~2.7 MB
- `basics.pdf`: 169 pages (the original Glasgow Day 1; kept for reference)
- `continuous.pdf`: 58 pages
- `covariates.pdf`: 99 pages
- `bacon_cs.pdf`: 74 pages
- `synth.pdf`: 65 pages

Zero overfull box warnings expected on a clean build (one harmless `Underfull \hbox` on each section divider is the `\textsc{The Remix}` text — ignore).

---

## 9. Provenance and credits

- `contdid` R package — **Brantly Callaway** (not Kyle Butts; this was corrected in `03-continuous.tex` during the May 2026 session).
- Kyle Butts' continuous-DiD pedagogy (the discrete pill example, the WTO lab) is used with attribution but the slide that *named* him as the running-example author was renamed to "A discrete multi-valued example."
- Cheng & Hoekstra (2013, JHR) — "Does Strengthening Self-Defense Law Deter Crime or Escalate Violence?" — the running 2×2 example in §3 of `01-basics.tex`.
- Miller, Johnson & Wherry (2021, QJE) — the Medicaid expansion → near-elderly mortality study used as the closing courtroom case.
- Lu & Yu (2015, AEJ:Applied) — the China WTO tariff data used in the `03-continuous.tex` deck and the `China-WTO` lab.

---

## Quick orientation for a future Claude

If you just opened this repo and need to know where to start:
1. Read `README.md` for the workshop schedule + deck inventory.
2. **`Slides/01-basics.tex`** is the marquee deck (Madrid-themed, 90 min).
3. The source-of-truth is `the-remix-tour/glasgow/decks/` — keep them in sync, don't edit only here.
4. The Madrid palette override is local to `01-basics.tex` — other decks render green.
5. If you're adding slides to `01-basics.tex`, mind the 90-minute budget (currently 53 slides ≈ 1.7 min/slide).
6. If you're updating any other deck, mirror the change in `the-remix-tour` first, then sync.
