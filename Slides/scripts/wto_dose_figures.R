# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# wto_dose_figures.R
#
# Generates figures/dxt/01_dose_histogram.pdf and 02..10 for the dose-as-X-treatment
# section of 03-continuous.tex, using Kyle's exact dose reparameterization
# from kyle/China_WTO_Example/wto_example.R:
#
#   dose = pmax(tariff_2001 - 0.10, 0)
#
# i.e. how far each industry's 2001 tariff exceeded the 10% WTO bound — the
# "bite of the policy" interpretation. Analytic sample is Kyle's: filter to
# years 2001 and 2004, drop industries with missing Delta_ln_theil. N = 154,
# E[D] ≈ 0.074, max(D) ≈ 0.46.
#
# Supersedes the earlier 06_conditional_mean.R and weights_07_to_10.R, both
# of which used dose = raw tariff[year==2001] and produced E[D] = 0.164 — the
# wrong dose distribution. Caption on the Title X / WTO histogram slide was
# written for Kyle's dose and is correct as-is.
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

suppressPackageStartupMessages(library(tidyverse))

# Path conventions: this script lives in Codechella-Madrid/Slides/scripts/
# and the data lives in the-remix-tour. We use absolute paths so the script
# can be run from anywhere.
DATA_CSV <- "/Users/scunning/the-remix-tour/glasgow/decks/kyle/China_WTO_Example/data/industry_by_year.csv"
OUT_DIR  <- "/Users/scunning/Codechella-Madrid/Slides/figures/dxt"

# ----- Palette (matches existing figures and remix.sty Warm Professional) -----
NAVY        <- "#2E4057"
NAVYDARK    <- "#1F2D3D"
TEAL        <- "#048A81"
TEALDARK    <- "#03605A"
ORANGE      <- "#E85D04"
WARMGRAY    <- "#718096"
SLATE       <- "#4A5568"
CREAM       <- "#FAF8F2"
LIGHTORANGE <- "#FBD9C0"
LIGHTTEAL   <- "#CDEAE6"

# ----- Kyle's dose: pmax(tariff_2001 - 0.10, 0) on his analytic sample -----
df <- read_csv(DATA_CSV, show_col_types = FALSE)

collapsed <- df |>
  filter(year == 2001 | year == 2004) |>
  summarize(
    .by = sic3,
    Delta_ln_theil = ln_theil[year == 2004] - ln_theil[year == 2001],
    tariff_2001    = tariff[year == 2001],
    dose           = pmax(tariff_2001 - 0.10, 0)
  ) |>
  drop_na()

doses <- collapsed$dose
ED    <- mean(doses)
VD    <- var(doses)
SD    <- sd(doses)
maxD  <- max(doses)
N     <- length(doses)

cat(sprintf(
  "N = %d   E[D] = %.4f   Var(D) = %.4f   SD = %.4f   max(D) = %.4f   pct(dose==0) = %.1f%%\n",
  N, ED, VD, SD, maxD, 100 * mean(doses == 0)
))

# Smallest positive dose (d_L) — referenced by Ingredient 6 slide
dL <- min(doses[doses > 0])
cat(sprintf("d_L (smallest positive dose) = %.4f\n", dL))

# Shared theme
remix_theme <- theme_minimal(base_size = 12) +
  theme(
    panel.background = element_rect(fill = CREAM, colour = NA),
    plot.background  = element_rect(fill = CREAM, colour = NA),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(colour = "grey85", linewidth = 0.25),
    axis.title       = element_text(colour = SLATE, face = "bold"),
    axis.text        = element_text(colour = SLATE),
    plot.margin      = margin(8, 14, 6, 8)
  )

# Binning for the histogram — chosen to give a reasonable look at max ~0.46
BIN_W <- 0.02
breaks <- seq(0, max(maxD + BIN_W, 0.5), by = BIN_W)
hist_df <- tibble(
  bin = cut(doses, breaks, include.lowest = TRUE, right = FALSE)
) |>
  count(bin) |>
  mutate(
    bin_lo = breaks[as.integer(bin)],
    bin_hi = bin_lo + BIN_W,
    bin_mid = (bin_lo + bin_hi) / 2
  )
xmax <- 0.5    # plot extent (a bit past max)

# ===========================================================================
# Figure 01 — dose histogram with E[D] vline
# ===========================================================================
p01 <- ggplot(hist_df, aes(x = bin_mid, y = n)) +
  geom_col(width = BIN_W * 0.92, fill = TEALDARK, alpha = 0.85) +
  geom_vline(xintercept = ED, colour = ORANGE,
             linetype = "dotted", linewidth = 0.9) +
  annotate("text", x = ED + 0.005, y = max(hist_df$n) * 0.95,
           label = sprintf("E[D] = %.3f", ED),
           colour = ORANGE, fontface = "bold", size = 4.4, hjust = 0) +
  scale_x_continuous(
    name = "Dose  D  (2001 industry tariff, re-parameterized)",
    limits = c(0, xmax), expand = c(0, 0)
  ) +
  scale_y_continuous(
    name = "Number of industries", expand = expansion(mult = c(0, 0.06))
  ) +
  remix_theme

ggsave(file.path(OUT_DIR, "01_dose_histogram.pdf"), p01,
       width = 7.2, height = 4.0, units = "in", device = cairo_pdf)
cat("Wrote 01_dose_histogram.pdf\n")

# ===========================================================================
# Figure 02 — same histogram, E[D] highlighted as the anchoring marker
# ===========================================================================
p02 <- ggplot(hist_df, aes(x = bin_mid, y = n)) +
  geom_col(width = BIN_W * 0.92, fill = TEAL, alpha = 0.18) +
  annotate("segment", x = ED, xend = ED, y = 0, yend = max(hist_df$n) * 1.02,
           colour = ORANGE, linewidth = 1.2) +
  annotate("point", x = ED, y = max(hist_df$n) * 1.02,
           colour = ORANGE, size = 3.2) +
  annotate("text", x = ED + 0.008, y = max(hist_df$n) * 0.97,
           label = sprintf("E[D] = %.3f", ED),
           colour = ORANGE, fontface = "bold", size = 4.4, hjust = 0) +
  scale_x_continuous(name = "Dose  D",
                     limits = c(0, xmax), expand = c(0, 0)) +
  scale_y_continuous(name = "Count",
                     expand = expansion(mult = c(0, 0.10))) +
  remix_theme

ggsave(file.path(OUT_DIR, "02_mean.pdf"), p02,
       width = 7.2, height = 4.0, units = "in", device = cairo_pdf)
cat("Wrote 02_mean.pdf\n")

# ===========================================================================
# Figure 03 — same histogram, ±1 SD region shaded, Var(D) and SD labeled
# ===========================================================================
sd_lo <- max(0, ED - SD)
sd_hi <- ED + SD
p03 <- ggplot(hist_df, aes(x = bin_mid, y = n)) +
  annotate("rect", xmin = sd_lo, xmax = sd_hi,
           ymin = 0, ymax = max(hist_df$n) * 1.05,
           fill = LIGHTTEAL, alpha = 0.55) +
  geom_col(width = BIN_W * 0.92, fill = SLATE, alpha = 0.25) +
  geom_vline(xintercept = ED, colour = ORANGE,
             linetype = "dotted", linewidth = 0.9) +
  annotate("segment", x = sd_lo, xend = sd_hi,
           y = max(hist_df$n) * 0.93, yend = max(hist_df$n) * 0.93,
           colour = TEALDARK, linewidth = 0.7,
           arrow = arrow(ends = "both", length = unit(0.16, "cm"), type = "closed")) +
  annotate("text", x = (sd_lo + sd_hi) / 2, y = max(hist_df$n) * 1.00,
           label = sprintf("Var(D) = %.4f   (SD = %.3f)", VD, SD),
           colour = TEALDARK, fontface = "bold", size = 4.0) +
  scale_x_continuous(name = "Dose  D",
                     limits = c(0, xmax), expand = c(0, 0)) +
  scale_y_continuous(name = "Count",
                     expand = expansion(mult = c(0, 0.14))) +
  remix_theme

ggsave(file.path(OUT_DIR, "03_variance.pdf"), p03,
       width = 7.2, height = 4.0, units = "in", device = cairo_pdf)
cat("Wrote 03_variance.pdf\n")

# ===========================================================================
# Density (used in 04 and 09) and survival (used in 05).
# Density: kernel-smoothed over positive doses; survival empirical.
# ===========================================================================
dens <- density(doses, n = 400, from = 0, to = xmax, bw = 0.025)
ls   <- dens$x
fD   <- dens$y
surv <- sapply(ls, function(l) mean(doses >= l))

# ===========================================================================
# Figure 04 — kernel density f_D(l) with E[D] vline
# ===========================================================================
dens_df <- tibble(l = ls, f = fD)
p04 <- ggplot(dens_df, aes(x = l, y = f)) +
  geom_area(fill = LIGHTTEAL, alpha = 0.7) +
  geom_line(colour = TEALDARK, linewidth = 1.2) +
  geom_vline(xintercept = ED, colour = ORANGE,
             linetype = "dotted", linewidth = 0.9) +
  annotate("text", x = ED + 0.008, y = max(fD) * 0.95,
           label = "E[D]", colour = ORANGE, fontface = "bold",
           size = 4.2, hjust = 0) +
  scale_x_continuous(name = "Dose  l",
                     limits = c(0, xmax), expand = c(0, 0)) +
  scale_y_continuous(name = expression(f[D](l)),
                     expand = expansion(mult = c(0, 0.06))) +
  remix_theme

ggsave(file.path(OUT_DIR, "04_density.pdf"), p04,
       width = 7.2, height = 4.0, units = "in", device = cairo_pdf)
cat("Wrote 04_density.pdf\n")

# ===========================================================================
# Figure 05 — survival P(D >= l), point at (E[D], P(D >= E[D]))
# ===========================================================================
surv_at_mean <- mean(doses >= ED)
surv_df <- tibble(l = ls, s = surv)
p05 <- ggplot(surv_df, aes(x = l, y = s)) +
  geom_area(fill = LIGHTORANGE, alpha = 0.7) +
  geom_line(colour = ORANGE, linewidth = 1.2) +
  annotate("segment", x = ED, xend = ED,
           y = 0, yend = surv_at_mean,
           colour = ORANGE, linetype = "dotted", linewidth = 0.5) +
  annotate("point", x = ED, y = surv_at_mean,
           colour = ORANGE, size = 3) +
  annotate("text", x = ED + 0.015, y = surv_at_mean + 0.02,
           label = sprintf("P(D >= E[D])  ~  %.2f", surv_at_mean),
           colour = ORANGE, fontface = "bold", size = 4.0, hjust = 0) +
  scale_x_continuous(name = "Cutoff  l",
                     limits = c(0, xmax), expand = c(0, 0)) +
  scale_y_continuous(name = expression(P(D >= l)),
                     limits = c(0, 1.02), expand = c(0, 0)) +
  remix_theme

ggsave(file.path(OUT_DIR, "05_survival.pdf"), p05,
       width = 7.2, height = 4.0, units = "in", device = cairo_pdf)
cat("Wrote 05_survival.pdf\n")

# ===========================================================================
# Figure 06 — conditional mean E[D | D >= l]
# ===========================================================================
cm <- sapply(ls, function(l) {
  s <- doses[doses >= l]
  if (length(s) == 0) NA else mean(s)
})
cm_df <- tibble(l = ls, cm = cm) |> drop_na()
cond_at_mean <- mean(doses[doses >= ED])

# Position the long label up-and-left of the highlight point.
# At ED ≈ 0.074, cond_at_mean ≈ 0.20+, leaving room above.
label_x <- 0.18
label_y <- cond_at_mean + 0.18
p06 <- ggplot(cm_df, aes(x = l, y = cm)) +
  geom_line(colour = TEALDARK, linewidth = 1.2) +
  geom_hline(yintercept = ED, colour = ORANGE,
             linetype = "dashed", linewidth = 0.6) +
  annotate("segment", x = ED, xend = ED,
           y = ED, yend = cond_at_mean,
           colour = SLATE, linetype = "dotted", linewidth = 0.5) +
  annotate("point", x = ED, y = cond_at_mean,
           colour = TEALDARK, size = 2.8) +
  annotate("text", x = label_x + 0.01, y = ED - 0.030,
           label = sprintf("E[D] = %.3f", ED),
           colour = ORANGE, fontface = "bold",
           size = 3.6, hjust = 0) +
  annotate("text", x = label_x, y = label_y,
           label = sprintf("E[D | D >= E[D]]  ~  %.3f", cond_at_mean),
           colour = TEALDARK, fontface = "bold",
           size = 3.6, hjust = 0) +
  annotate("segment",
           x = label_x + 0.015, y = label_y - 0.018,
           xend = ED + 0.005,   yend = cond_at_mean + 0.015,
           colour = TEALDARK, linewidth = 0.4,
           arrow = arrow(length = unit(0.12, "cm"), type = "closed")) +
  scale_x_continuous(name = "Cutoff  l",
                     limits = c(0, xmax), expand = c(0, 0)) +
  scale_y_continuous(name = "E(D | D ≥ l)",
                     limits = c(0, max(cm_df$cm) + 0.05), expand = c(0, 0)) +
  remix_theme

ggsave(file.path(OUT_DIR, "06_conditional_mean.pdf"), p06,
       width = 7.2, height = 4.0, units = "in", device = cairo_pdf)
cat("Wrote 06_conditional_mean.pdf\n")

# ===========================================================================
# Figure 07 — Level weight w^lev(l) = (l - E[D]) * f_D(l) / Var(D)
# ===========================================================================
w_lev <- (ls - ED) * fD / VD
dat1  <- tibble(l = ls, w = w_lev)

p07 <- ggplot(dat1, aes(x = l, y = w)) +
  geom_ribbon(data = filter(dat1, l <= ED),
              aes(ymin = pmin(w, 0), ymax = 0),
              fill = LIGHTORANGE, alpha = 0.7) +
  geom_ribbon(data = filter(dat1, l >= ED),
              aes(ymin = 0, ymax = pmax(w, 0)),
              fill = LIGHTTEAL, alpha = 0.7) +
  geom_line(colour = NAVYDARK, linewidth = 1.2) +
  geom_hline(yintercept = 0, colour = SLATE, linewidth = 0.4) +
  geom_vline(xintercept = ED, colour = ORANGE,
             linetype = "dashed", linewidth = 0.5) +
  annotate("text", x = ED + 0.010, y = max(w_lev) * 0.95,
           label = "sign flip at E[D]", colour = ORANGE,
           fontface = "bold", size = 3.4, hjust = 0) +
  annotate("text", x = 0.005, y = min(w_lev) * 0.55,
           label = "negative\nbelow mean", colour = ORANGE,
           fontface = "bold", size = 3.4, hjust = 0, lineheight = 0.9) +
  annotate("text", x = 0.35, y = max(w_lev) * 0.50,
           label = "positive\nabove mean", colour = TEALDARK,
           fontface = "bold", size = 3.4, hjust = 0, lineheight = 0.9) +
  labs(x = "Dose  l", y = expression(w^lev*(l))) +
  scale_x_continuous(limits = c(0, xmax), expand = c(0, 0)) +
  remix_theme

ggsave(file.path(OUT_DIR, "07_weight_level.pdf"), p07,
       width = 7.2, height = 4.2, units = "in", device = cairo_pdf)
cat("Wrote 07_weight_level.pdf\n")

# ===========================================================================
# Figure 08 — Scaled-level weight w^s(l) = l*(l-E[D])*f_D(l)/Var(D) * 2
# ===========================================================================
w_s  <- ls * (ls - ED) * fD / VD * 2.0
dat2 <- tibble(l = ls, w = w_s)

p08 <- ggplot(dat2, aes(x = l, y = w)) +
  geom_ribbon(data = filter(dat2, l <= ED),
              aes(ymin = pmin(w, 0), ymax = 0),
              fill = LIGHTORANGE, alpha = 0.7) +
  geom_ribbon(data = filter(dat2, l >= ED),
              aes(ymin = 0, ymax = pmax(w, 0)),
              fill = LIGHTTEAL, alpha = 0.7) +
  geom_line(colour = NAVYDARK, linewidth = 1.2) +
  geom_hline(yintercept = 0, colour = SLATE, linewidth = 0.4) +
  geom_vline(xintercept = ED, colour = ORANGE,
             linetype = "dashed", linewidth = 0.5) +
  annotate("text", x = ED + 0.010, y = max(w_s) * 0.95,
           label = "still flips at E[D]", colour = ORANGE,
           fontface = "bold", size = 3.4, hjust = 0) +
  annotate("text", x = 0.005, y = min(w_s) * 0.65,
           label = "negative\nbelow mean", colour = ORANGE,
           fontface = "bold", size = 3.4, hjust = 0, lineheight = 0.9) +
  annotate("text", x = 0.32, y = max(w_s) * 0.55,
           label = "mass pulled\nto high doses", colour = TEALDARK,
           fontface = "bold", size = 3.4, hjust = 0, lineheight = 0.9) +
  labs(x = "Dose  l", y = expression(w^s*(l))) +
  scale_x_continuous(limits = c(0, xmax), expand = c(0, 0)) +
  remix_theme

ggsave(file.path(OUT_DIR, "08_weight_scaled_level.pdf"), p08,
       width = 7.2, height = 4.2, units = "in", device = cairo_pdf)
cat("Wrote 08_weight_scaled_level.pdf\n")

# ===========================================================================
# Figure 09 — ACRT weight  w^acrt(l) ∝ P(D >= l), with density for compare
# ===========================================================================
w_acrt    <- surv / sum(surv) / mean(diff(ls))
fD_scaled <- fD / max(fD) * max(w_acrt) * 0.55
dat3 <- tibble(l = ls, w = w_acrt, dens = fD_scaled)

p09 <- ggplot(dat3, aes(x = l)) +
  geom_ribbon(aes(ymin = 0, ymax = w), fill = LIGHTTEAL, alpha = 0.7) +
  geom_line(aes(y = w), colour = TEALDARK, linewidth = 1.3) +
  geom_line(aes(y = dens), colour = WARMGRAY,
            linetype = "dashed", linewidth = 0.7) +
  annotate("text", x = 0.18, y = max(w_acrt) * 0.95,
           label = expression(w^acrt*(l)), colour = TEALDARK,
           fontface = "bold", size = 4.2, hjust = 0) +
  annotate("text", x = 0.30,
           y = fD_scaled[which.min(abs(ls - 0.05))] * 0.5,
           label = "dose density  f[D](l)  (rescaled)",
           colour = WARMGRAY, fontface = "italic", size = 3.2,
           hjust = 0, parse = FALSE) +
  annotate("segment", x = 0.30,
           y = fD_scaled[which.min(abs(ls - 0.05))] * 0.5 + 0.4,
           xend = 0.36,
           yend = fD_scaled[which.min(abs(ls - 0.30))] + 0.4,
           colour = WARMGRAY, linewidth = 0.4,
           arrow = arrow(length = unit(0.1, "cm"), type = "closed")) +
  labs(x = "Dose  l", y = "Weight / density (rescaled)") +
  scale_x_continuous(limits = c(0, xmax), expand = c(0, 0)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  remix_theme

ggsave(file.path(OUT_DIR, "09_weight_acrt.pdf"), p09,
       width = 7.2, height = 4.2, units = "in", device = cairo_pdf)
cat("Wrote 09_weight_acrt.pdf\n")

# ===========================================================================
# Figure 10 — 2x2 weight heatmap on (l, h) with h > l
# ===========================================================================
gridn <- 80
gx    <- seq(0, maxD, length.out = gridn)
gy    <- seq(0, maxD, length.out = gridn)
grid_df <- expand.grid(l = gx, h = gy) |>
  filter(h > l) |>
  mutate(
    fl = approx(ls, fD, xout = l, rule = 2)$y,
    fh = approx(ls, fD, xout = h, rule = 2)$y,
    w  = (h - l)^2 * fl * fh
  )
grid_df$w_norm <- grid_df$w / max(grid_df$w) * 40

p10 <- ggplot(grid_df, aes(x = l, y = h, fill = w_norm)) +
  geom_tile() +
  scale_fill_gradient(low = CREAM, high = TEALDARK,
                      name = "w (l,h)") +
  geom_abline(slope = 1, intercept = 0,
              colour = SLATE, linetype = "dotted", linewidth = 0.5) +
  annotate("text", x = 0.35, y = 0.20,
           label = "h = l (diagonal)",
           colour = SLATE, fontface = "italic", size = 3.2, hjust = 0) +
  annotate("segment", x = 0.35, y = 0.21,
           xend = 0.30, yend = 0.30,
           colour = SLATE, linewidth = 0.4,
           arrow = arrow(length = unit(0.1, "cm"), type = "closed")) +
  labs(x = "Lower dose  l", y = "Higher dose  h") +
  scale_x_continuous(limits = c(0, maxD), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, maxD), expand = c(0, 0)) +
  remix_theme +
  theme(legend.position = c(0.88, 0.30),
        legend.background = element_rect(fill = CREAM, colour = NA),
        legend.title = element_text(colour = SLATE, size = 8.5),
        legend.text  = element_text(colour = SLATE, size = 8),
        legend.key.size = unit(0.35, "cm"))

ggsave(file.path(OUT_DIR, "10_weight_2x2_heatmap.pdf"), p10,
       width = 6.4, height = 4.6, units = "in", device = cairo_pdf)
cat("Wrote 10_weight_2x2_heatmap.pdf\n")

cat("\nAll 10 figures regenerated with Kyle's dose definition.\n")
