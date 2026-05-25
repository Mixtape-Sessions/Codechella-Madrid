# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Regenerate the four weight figures (07-10) with labels placed in clean
# whitespace — fixes the referee2 collisions:
#   07_weight_level.pdf       — "sign flip at E[D]" / "positive above mean" overlapped
#   08_weight_scaled_level.pdf — "still flips" / "positive above mean" overlapped each other
#   09_weight_acrt.pdf        — "dose density (rescaled)" label sat on the curve
#   10_weight_2x2_heatmap.pdf — "h = l" label awkward on diagonal
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
library(tidyverse)

setwd("/Users/scunning/the-remix-tour/glasgow/decks")

# Palette (matches remix.sty)
NAVY <- "#2E4057"
NAVYDARK <- "#1F2D3D"
TEAL <- "#048A81"
TEALDARK <- "#03605A"
ORANGE <- "#E85D04"
WARMGRAY <- "#718096"
SLATE <- "#4A5568"
CREAM <- "#FAF8F2"
LIGHTORANGE <- "#FBD9C0"
LIGHTTEAL <- "#CDEAE6"

# Dose distribution (Lu & Yu 2015 WTO tariffs, pre-WTO levels)
df <- read_csv("kyle/China_WTO_Example/data/industry_by_year.csv",
               show_col_types = FALSE)
doses <- df |>
  filter(year == 2001) |>
  summarize(.by = sic3, dose = tariff[1]) |>
  drop_na(dose) |>
  pull(dose)

ED <- mean(doses)
VD <- var(doses)
maxD <- max(doses)
cat("E[D] =", round(ED, 3), "  Var(D) =", round(VD, 4),
    "  max(D) =", round(maxD, 3), "\n")

# Kernel-smooth the density on a fine grid
dens <- density(doses, n = 400, from = 0, to = maxD, bw = 0.025)
ls <- dens$x
fD <- dens$y

# ---- Weight #1: level weight w^lev(l) ∝ (l - E[D]) * f_D(l) / Var(D)
w_lev <- (ls - ED) * fD / VD

# ---- Weight #2: scaled-level w^s(l) ∝ l * (l - E[D]) * f_D(l) / Var(D)
# Multiplying by l shifts the mass toward high doses but keeps the sign flip
w_s <- ls * (ls - ED) * fD / VD * 2.0   # rescale to nice y-range

# ---- Weight #3: ACRT weight (non-negative).
# CBS define this as the weight on ATT(l | l) that yields ACRT semantics.
# We use the cumulative-density form: w^acrt(l) ∝ P(D ≥ l) — non-negative,
# monotone-ish, integrates to E[D].  Rescaled to integrate to 1 for display.
surv <- sapply(ls, function(l) mean(doses >= l))
w_acrt <- surv / sum(surv) / mean(diff(ls))   # density-style normalization

# Helper: theme for all plots
remix_theme <- theme_minimal(base_size = 12) +
  theme(
    panel.background = element_rect(fill = CREAM, colour = NA),
    plot.background  = element_rect(fill = CREAM, colour = NA),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(colour = "grey85", linewidth = 0.25),
    axis.title = element_text(colour = SLATE, face = "bold"),
    axis.text  = element_text(colour = SLATE),
    plot.margin = margin(8, 14, 6, 8)
  )

# ===========================================================================
# Figure 07 — Level weight
# ===========================================================================
dat1 <- tibble(l = ls, w = w_lev)

p1 <- ggplot(dat1, aes(x = l, y = w)) +
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
  # Labels — placed OUTSIDE the data region
  annotate("text", x = ED + 0.015, y = max(w_lev) * 0.95,
           label = "sign flip at E[D]", colour = ORANGE,
           fontface = "bold", size = 3.4, hjust = 0) +
  annotate("text", x = 0.04, y = min(w_lev) * 0.55,
           label = "negative\nbelow mean", colour = ORANGE,
           fontface = "bold", size = 3.4, hjust = 0, lineheight = 0.9) +
  annotate("text", x = 0.45, y = max(w_lev) * 0.50,
           label = "positive\nabove mean", colour = TEALDARK,
           fontface = "bold", size = 3.4, hjust = 0, lineheight = 0.9) +
  labs(x = "Dose  l", y = expression(w^lev*(l))) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, maxD + 0.01)) +
  remix_theme

ggsave("figures/dxt/07_weight_level.pdf", p1,
       width = 7.2, height = 4.2, units = "in", device = cairo_pdf)
cat("Wrote 07_weight_level.pdf\n")

# ===========================================================================
# Figure 08 — Scaled-level weight
# ===========================================================================
dat2 <- tibble(l = ls, w = w_s)

p2 <- ggplot(dat2, aes(x = l, y = w)) +
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
  # Labels separated: "sign flip" stays at top-left near the vline; "high-dose
  # mass" replaces the redundant "positive above mean" — single message per region.
  annotate("text", x = ED + 0.015, y = max(w_s) * 0.95,
           label = "still flips at E[D]", colour = ORANGE,
           fontface = "bold", size = 3.4, hjust = 0) +
  annotate("text", x = 0.04, y = min(w_s) * 0.65,
           label = "negative\nbelow mean", colour = ORANGE,
           fontface = "bold", size = 3.4, hjust = 0, lineheight = 0.9) +
  annotate("text", x = 0.42, y = max(w_s) * 0.55,
           label = "mass pulled\nto high doses", colour = TEALDARK,
           fontface = "bold", size = 3.4, hjust = 0, lineheight = 0.9) +
  labs(x = "Dose  l", y = expression(w^s*(l))) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, maxD + 0.01)) +
  remix_theme

ggsave("figures/dxt/08_weight_scaled_level.pdf", p2,
       width = 7.2, height = 4.2, units = "in", device = cairo_pdf)
cat("Wrote 08_weight_scaled_level.pdf\n")

# ===========================================================================
# Figure 09 — ACRT weight (non-negative) with dose density for comparison
# ===========================================================================
# Rescale density to share y-range with the ACRT weight so they're comparable
fD_scaled <- fD / max(fD) * max(w_acrt) * 0.55

dat3 <- tibble(l = ls, w = w_acrt, dens = fD_scaled)

p3 <- ggplot(dat3, aes(x = l)) +
  geom_ribbon(aes(ymin = 0, ymax = w), fill = LIGHTTEAL, alpha = 0.7) +
  geom_line(aes(y = w), colour = TEALDARK, linewidth = 1.3) +
  geom_line(aes(y = dens), colour = WARMGRAY,
            linetype = "dashed", linewidth = 0.7) +
  # Labels placed in clean whitespace, not on the curves
  annotate("text", x = 0.30, y = max(w_acrt) * 0.95,
           label = expression(w^acrt*(l)), colour = TEALDARK,
           fontface = "bold", size = 4.2, hjust = 0) +
  annotate("text", x = 0.42, y = fD_scaled[which.min(abs(ls - 0.05))] * 0.4,
           label = "dose density  f[D](l)  (rescaled)",
           colour = WARMGRAY, fontface = "italic", size = 3.2,
           hjust = 0, parse = FALSE) +
  # Small connector from density label to the dashed curve
  annotate("segment", x = 0.42, y = fD_scaled[which.min(abs(ls - 0.05))] * 0.4 + 0.1,
           xend = 0.50, yend = fD_scaled[which.min(abs(ls - 0.50))] + 0.15,
           colour = WARMGRAY, linewidth = 0.4,
           arrow = arrow(length = unit(0.1, "cm"), type = "closed")) +
  labs(x = "Dose  l", y = "Weight / density (rescaled)") +
  scale_x_continuous(expand = c(0, 0), limits = c(0, maxD + 0.01)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  remix_theme

ggsave("figures/dxt/09_weight_acrt.pdf", p3,
       width = 7.2, height = 4.2, units = "in", device = cairo_pdf)
cat("Wrote 09_weight_acrt.pdf\n")

# ===========================================================================
# Figure 10 — 2×2 weight heatmap on (l, h) pairs
# ===========================================================================
gridn <- 80
gx <- seq(0, maxD, length.out = gridn)
gy <- seq(0, maxD, length.out = gridn)
grid_df <- expand.grid(l = gx, h = gy) |>
  filter(h > l) |>
  mutate(
    fl = approx(ls, fD, xout = l, rule = 2)$y,
    fh = approx(ls, fD, xout = h, rule = 2)$y,
    w = (h - l)^2 * fl * fh
  )
grid_df$w_norm <- grid_df$w / max(grid_df$w) * 40

p4 <- ggplot(grid_df, aes(x = l, y = h, fill = w_norm)) +
  geom_tile() +
  scale_fill_gradient(low = CREAM, high = TEALDARK,
                      name = "w (l,h)") +
  geom_abline(slope = 1, intercept = 0,
              colour = SLATE, linetype = "dotted", linewidth = 0.5) +
  # h=l label moved OFF the diagonal, with arrow pointing to it
  annotate("text", x = 0.45, y = 0.30,
           label = "h = l (diagonal)",
           colour = SLATE, fontface = "italic", size = 3.2,
           hjust = 0) +
  annotate("segment", x = 0.45, y = 0.31,
           xend = 0.38, yend = 0.38,
           colour = SLATE, linewidth = 0.4,
           arrow = arrow(length = unit(0.1, "cm"), type = "closed")) +
  labs(x = "Lower dose  l", y = "Higher dose  h") +
  scale_x_continuous(expand = c(0, 0), limits = c(0, maxD)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, maxD)) +
  remix_theme +
  theme(legend.position = c(0.88, 0.30),
        legend.background = element_rect(fill = CREAM, colour = NA),
        legend.title = element_text(colour = SLATE, size = 8.5),
        legend.text  = element_text(colour = SLATE, size = 8),
        legend.key.size = unit(0.35, "cm"))

ggsave("figures/dxt/10_weight_2x2_heatmap.pdf", p4,
       width = 6.4, height = 4.6, units = "in", device = cairo_pdf)
cat("Wrote 10_weight_2x2_heatmap.pdf\n")
