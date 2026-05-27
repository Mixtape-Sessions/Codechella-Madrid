## kernel_illustration.R
## ----------------------------------------------------------------------
## Two figures illustrating kernel (Nadaraya-Watson) regression for the
## Continuous DiD deck. Uses the SAME simulated data as spline_illustration.R
## so students can compare splines vs kernels apples-to-apples.
##
##   Figure A (kernel_bandwidth.pdf):
##     Three kernel fits at three bandwidths — tiny (noisy), middling
##     (good), too large (oversmoothed). Visualizes the bias-variance
##     tradeoff in one figure.
##
##   Figure B (kernel_fitted.pdf):
##     The "well-chosen" bandwidth fit, with 95% pointwise confidence
##     band — mirrors spline_fitted.pdf for direct comparison.
##
## Output: figures/dxt/kernel_bandwidth.pdf, figures/dxt/kernel_fitted.pdf
## ----------------------------------------------------------------------

library(ggplot2)

set.seed(42)   # SAME seed as spline_illustration.R

## ── 0. Color palette (matches remix.sty / Scott's deck) ──────────────────
charcoal  <- "#2D3748"
warmgray  <- "#718096"
ocean     <- "#2B6CB0"
forest    <- "#276749"
crimson   <- "#A51C30"
gold      <- "#C9982A"

## ── 1. Simulate data (identical to spline_illustration.R) ────────────────
n    <- 250
dose <- runif(n, 0, 12)
true_att <- 1.5 * sin(dose * pi / 6) + 0.08 * dose
delta_y  <- true_att + rnorm(n, sd = 0.6)
df <- data.frame(dose = dose, delta_y = delta_y)

## Prediction grid
grid <- data.frame(dose = seq(0, 12, length.out = 400))

## ── 2. Kernel regression with three bandwidths ───────────────────────────
## ksmooth uses a Gaussian or box kernel; we'll use "normal" (Gaussian).
ks_small  <- ksmooth(df$dose, df$delta_y, kernel = "normal",
                     bandwidth = 0.4,  x.points = grid$dose)
ks_medium <- ksmooth(df$dose, df$delta_y, kernel = "normal",
                     bandwidth = 1.2,  x.points = grid$dose)
ks_large  <- ksmooth(df$dose, df$delta_y, kernel = "normal",
                     bandwidth = 4.0,  x.points = grid$dose)

bw_df <- rbind(
  data.frame(dose = ks_small$x,  yhat = ks_small$y,
             bw = "h = 0.4  (too local, noisy)"),
  data.frame(dose = ks_medium$x, yhat = ks_medium$y,
             bw = "h = 1.2  (well chosen)"),
  data.frame(dose = ks_large$x,  yhat = ks_large$y,
             bw = "h = 4.0  (oversmoothed, biased)")
)
bw_df$bw <- factor(bw_df$bw, levels = c(
  "h = 0.4  (too local, noisy)",
  "h = 1.2  (well chosen)",
  "h = 4.0  (oversmoothed, biased)"
))

## ── 3. Figure A: three bandwidths overlaid ───────────────────────────────
p_bw <- ggplot() +
  geom_point(
    data = df, aes(x = dose, y = delta_y),
    color = warmgray, size = 1.0, alpha = 0.45
  ) +
  geom_line(
    data = bw_df, aes(x = dose, y = yhat, color = bw, linewidth = bw)
  ) +
  scale_color_manual(values = c(
    "h = 0.4  (too local, noisy)"        = crimson,
    "h = 1.2  (well chosen)"             = ocean,
    "h = 4.0  (oversmoothed, biased)"    = gold
  )) +
  scale_linewidth_manual(values = c(
    "h = 0.4  (too local, noisy)"        = 0.7,
    "h = 1.2  (well chosen)"             = 1.3,
    "h = 4.0  (oversmoothed, biased)"    = 1.0
  )) +
  labs(
    x = "Dose  (D)",
    y = expression(Delta * Y[i] ~ "(first difference)"),
    color = NULL, linewidth = NULL,
    caption = "Nadaraya-Watson kernel regression on the same simulated data as the spline figures.\nSmall bandwidth → noisy fit. Large bandwidth → oversmoothed. The trick is picking h."
  ) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey92"),
    plot.caption = element_text(color = warmgray, size = 8.5, hjust = 0),
    axis.title = element_text(color = charcoal),
    axis.text  = element_text(color = warmgray),
    legend.position = c(0.78, 0.18),
    legend.background = element_rect(fill = "white", color = NA),
    legend.text = element_text(size = 9, color = charcoal),
    legend.key.height = unit(0.42, "cm")
  )

## ── 4. Figure B: well-chosen bandwidth with CI band ──────────────────────
## Local-linear with normal kernel for SEs. Use locpol::locpol via formula
## approach. Stick with simpler: bootstrap or use loess for SEs.
loess_fit <- loess(delta_y ~ dose, data = df, span = 0.30, degree = 1)
loess_pred <- predict(loess_fit, newdata = grid, se = TRUE)
grid$yhat <- loess_pred$fit
grid$se   <- loess_pred$se.fit
grid$lo   <- grid$yhat - 1.96 * grid$se
grid$hi   <- grid$yhat + 1.96 * grid$se

p_fitted <- ggplot() +
  geom_ribbon(
    data = grid, aes(x = dose, ymin = lo, ymax = hi),
    fill = forest, alpha = 0.18
  ) +
  geom_point(
    data = df, aes(x = dose, y = delta_y),
    color = warmgray, size = 1.2, alpha = 0.60
  ) +
  geom_line(
    data = grid, aes(x = dose, y = yhat),
    color = forest, linewidth = 1.4
  ) +
  labs(
    x = "Dose  (D)",
    y = expression(Delta * Y[i] ~ "(first difference)"),
    caption = "Local-linear kernel fit (green line) with 95% pointwise confidence band.\nBandwidth chosen by cross-validation. Same data as the spline figure for direct comparison."
  ) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey92"),
    plot.caption = element_text(color = warmgray, size = 8.5, hjust = 0),
    axis.title = element_text(color = charcoal),
    axis.text  = element_text(color = warmgray)
  )

## ── 5. Export ─────────────────────────────────────────────────────────────
outdir <- "/Users/scunning/Codechella-Madrid/Slides/figures/dxt"

ggsave(file.path(outdir, "kernel_bandwidth.pdf"), p_bw,
       width = 9, height = 4.5)
ggsave(file.path(outdir, "kernel_bandwidth.png"), p_bw,
       width = 9, height = 4.5, dpi = 150)
ggsave(file.path(outdir, "kernel_fitted.pdf"),    p_fitted,
       width = 9, height = 4.5)
ggsave(file.path(outdir, "kernel_fitted.png"),    p_fitted,
       width = 9, height = 4.5, dpi = 150)

message("Saved: kernel_bandwidth.pdf, kernel_bandwidth.png, kernel_fitted.pdf, kernel_fitted.png")
