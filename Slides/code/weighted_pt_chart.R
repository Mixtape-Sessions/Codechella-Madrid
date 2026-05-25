## weighted_pt_chart.R
## ----------------------------------------------------------------------
## Companion figure for the deck slide
## "Simulation: PT_wtd tracks the covariance gap"
##
## Replicates the simulation in Scott's Substack post
##   "Diff-in-Diff, population weights and parallel trends (with code) -
##    part 2" (Sep 18, 2025).
##
## Lemma being illustrated:
##   PT_wtd = PT_unw + (kappa_1 - kappa_0),
## where  kappa_d = Cov(S, Delta Y(0) | D=d) / E[S | D=d].
##
## DGP:
##   - N = 100,000 units, S ~ Lognormal(0, 0.8)
##   - Y0_t0 = 50 + 5 ln(S) + N(0, 2)   (baseline depends on size)
##   - dY0 = alpha + beta*(S - Sbar_d) + N(0, 1)   (group-centered trend)
##   - Therefore PT_unw = 0 by construction
##   - Treatment selection: logit on ln(S) with strength g1
##         Sweep g1 from -2.0 to +2.0 in 41 steps
##         Intercept gamma0 = logit(0.5) - g1 * mean(lnS) keeps P(D=1) ~ 0.5
##
## Punch line: with PT_unw = 0 by design, the lemma forces
## PT_wtd = kappa_1 - kappa_0 exactly. Across 41 selection regimes the
## points trace y = x with slope 1.
##
## Output: ../../figures/weighted_pt_covgap.pdf
## ----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

source(file.path("..", "..", "..", "..", "_themes", "remix_theme.R"))

set.seed(424242)

## ---- DGP ----
N <- 100000
S      <- exp(rnorm(N, 0, 0.8))
lnS    <- log(S)
Y0_t0  <- 50 + 5 * lnS + rnorm(N, 0, 2)   # not used directly, kept for fidelity

alpha   <- 2
beta    <- 1
sige    <- 1
p_treat <- 0.5
meanlnS <- mean(lnS)

## ---- Sweep selection strength g1 ----
g1_grid <- seq(-2.0, 2.0, by = 0.1)
results <- data.frame()

for (g1 in g1_grid) {
  gamma0 <- log(p_treat / (1 - p_treat)) - g1 * meanlnS
  p      <- plogis(gamma0 + g1 * lnS)
  D      <- rbinom(N, 1, p)

  Sbar1 <- mean(S[D == 1]); Sbar0 <- mean(S[D == 0])
  eps   <- rnorm(N, 0, sige)
  dY0   <- alpha + ifelse(D == 1, beta * (S - Sbar1), beta * (S - Sbar0)) + eps

  # Unweighted PT
  mu1 <- mean(dY0[D == 1]); mu0 <- mean(dY0[D == 0])
  pt_unw <- mu1 - mu0

  # Weighted PT
  wmu1 <- weighted.mean(dY0[D == 1], w = S[D == 1])
  wmu0 <- weighted.mean(dY0[D == 0], w = S[D == 0])
  pt_wtd <- wmu1 - wmu0

  # Covariance gap
  ES1 <- mean(S[D == 1]); ES0 <- mean(S[D == 0])
  k1  <- cov(dY0[D == 1], S[D == 1]) / ES1
  k0  <- cov(dY0[D == 0], S[D == 0]) / ES0
  covgap <- k1 - k0

  results <- rbind(results, data.frame(g1 = g1, pt_unw = pt_unw,
                                       pt_wtd = pt_wtd, covgap = covgap))
}

cat(sprintf("PT_unw range: [%+.3f, %+.3f]  (zero by construction)\n",
            min(results$pt_unw), max(results$pt_unw)))
cat(sprintf("PT_wtd range: [%+.3f, %+.3f]\n",
            min(results$pt_wtd), max(results$pt_wtd)))
cat(sprintf("covgap range: [%+.3f, %+.3f]\n",
            min(results$covgap), max(results$covgap)))

## ---- Plot ----
p <- ggplot(results, aes(x = covgap, y = pt_wtd)) +
  ## 45-degree reference line  y = x
  geom_abline(slope = 1, intercept = 0,
              color = remix_color("warmgray"),
              linewidth = 0.5, linetype = "dotted") +
  ## Zero reference lines
  geom_hline(yintercept = 0, color = remix_color("charcoal"),
             linewidth = 0.4, linetype = "dashed") +
  geom_vline(xintercept = 0, color = remix_color("charcoal"),
             linewidth = 0.4, linetype = "dashed") +
  ## The 41 simulation points
  geom_path(color = remix_color("ocean"), linewidth = 0.4, alpha = 0.6) +
  geom_point(aes(color = g1), size = 2.8, alpha = 0.95) +
  scale_color_gradient2(low  = remix_color("ocean"),
                        mid  = remix_color("warmgray"),
                        high = remix_color("forest"),
                        midpoint = 0,
                        name = expression(paste("selection strength ", gamma[1]))) +
  ## Annotate the punchline — placed in the empty upper-left quadrant,
  ## well clear of the diagonal line and the 41 dots near origin.
  annotate("text", x = -0.95, y = 0.92,
           label = "Slope 1: the lemma in pictures",
           color = remix_color("charcoal"), size = 3.2,
           fontface = "italic", hjust = 0) +
  scale_x_continuous(breaks = seq(-1, 1, 0.5),
                     limits = c(-1, 1)) +
  scale_y_continuous(breaks = seq(-1, 1, 0.5),
                     limits = c(-1, 1)) +
  labs(
    title    = "Weighted PT tracks the covariance gap",
    subtitle = expression(paste("With ", PT[unw], " = 0 by construction, ",
                                PT[wtd], " = ", kappa[1] - kappa[0],
                                " across 41 selection regimes")),
    x = expression(paste("Covariance gap  ", kappa[1] - kappa[0])),
    y = expression(paste("Weighted PT violation  ", PT[wtd])),
    caption = "Each dot is one regime (one value of selection strength). 100,000 units per regime. Sampling noise is invisible -- the line is algebraic, not statistical."
  ) +
  theme_remix() +
  theme(
    legend.position = "right",
    aspect.ratio = 1
  )

remix_save("../../figures/weighted_pt_covgap.pdf", p, width = 8.2, height = 6.0)
cat("\nSaved: ../../figures/weighted_pt_covgap.pdf\n")
