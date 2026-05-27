## spline_illustration.R
## ----------------------------------------------------------------------
## Two figures illustrating cubic B-splines for the Continuous DiD deck.
##
##   Figure A (spline_pieces.pdf):
##     Simulated dose-response data. Shows the 4 polynomial "pieces"
##     as differently-shaded background regions, separated by vertical
##     dashed lines at the 3 interior knots. The smooth spline curve
##     is drawn on top — making the join at knots visually obvious.
##
##   Figure B (spline_fitted.pdf):
##     Same data. Shows the raw scatter plus the fitted spline curve,
##     matching the look of the "fitted values" a researcher would plot.
##
## Output: figures/dxt/spline_pieces.pdf, figures/dxt/spline_fitted.pdf
## ----------------------------------------------------------------------

library(ggplot2)
library(splines)

set.seed(42)

## ── 0. Color palette (matches remix.sty / Scott's deck) ──────────────────
charcoal  <- "#2D3748"
warmgray  <- "#718096"
lightbg   <- "#F7FAFC"
ocean     <- "#2B6CB0"
green_dim <- "#D1FAE5"
blue_dim  <- "#DBEAFE"
amber_dim <- "#FEF3C7"
pink_dim  <- "#FCE7F3"
knot_col  <- "#A51C30"   # harvard crimson for knot markers

## ── 1. Simulate data ─────────────────────────────────────────────────────
n    <- 250
dose <- runif(n, 0, 12)
## True ATT(d) = 1.5*sin(d*pi/6) + 0.08*d  (rises, dips, rises)
true_att <- 1.5 * sin(dose * pi / 6) + 0.08 * dose
delta_y  <- true_att + rnorm(n, sd = 0.6)

df <- data.frame(dose = dose, delta_y = delta_y)

## ── 2. Fit cubic B-spline with 3 interior knots ──────────────────────────
knots_interior <- c(3, 6, 9)
fit <- lm(delta_y ~ bs(dose, knots = knots_interior, degree = 3), data = df)

## Prediction grid
grid <- data.frame(dose = seq(0, 12, length.out = 400))
grid$yhat <- predict(fit, newdata = grid)
grid$se   <- predict(fit, newdata = grid, se.fit = TRUE)$se.fit
grid$lo   <- grid$yhat - 1.96 * grid$se
grid$hi   <- grid$yhat + 1.96 * grid$se

## ── 3. Figure A: pieces ───────────────────────────────────────────────────
## Shade each of the 4 pieces with a different background color
piece_rects <- data.frame(
  xmin  = c(0, 3, 6, 9),
  xmax  = c(3, 6, 9, 12),
  fill  = c(blue_dim, green_dim, amber_dim, pink_dim),
  label = c("Piece 1", "Piece 2", "Piece 3", "Piece 4"),
  label_x = c(1.5, 4.5, 7.5, 10.5)
)

p_pieces <- ggplot() +
  ## piece background shading
  geom_rect(
    data = piece_rects,
    aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf, fill = fill),
    alpha = 0.55
  ) +
  scale_fill_identity() +
  ## knot vertical lines
  geom_vline(
    xintercept = knots_interior,
    linetype = "dashed", linewidth = 0.6, color = knot_col, alpha = 0.8
  ) +
  ## raw data
  geom_point(
    data = df, aes(x = dose, y = delta_y),
    color = warmgray, size = 1.0, alpha = 0.55
  ) +
  ## fitted spline
  geom_line(
    data = grid, aes(x = dose, y = yhat),
    color = charcoal, linewidth = 1.3
  ) +
  ## piece labels at top
  annotate("text",
    x = piece_rects$label_x,
    y = max(df$delta_y) * 0.92,
    label = piece_rects$label,
    size = 3.5, color = charcoal, fontface = "bold"
  ) +
  ## knot labels
  annotate("text",
    x = knots_interior + 0.18,
    y = min(df$delta_y) + 0.15,
    label = paste0("knot\n(d=", knots_interior, ")"),
    size = 2.8, color = knot_col, hjust = 0, lineheight = 0.85
  ) +
  labs(
    x = "Dose  (D)",
    y = expression(Delta * Y[i] ~ "(first difference)"),
    caption = "Simulated data. Cubic spline with 3 interior knots → 4 polynomial pieces,\njoined smoothly (continuous value, slope, curvature at each knot)."
  ) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey92"),
    plot.caption = element_text(color = warmgray, size = 8.5, hjust = 0),
    axis.title = element_text(color = charcoal),
    axis.text  = element_text(color = warmgray)
  )

## ── 4. Figure B: fitted values ────────────────────────────────────────────
p_fitted <- ggplot() +
  ## confidence band
  geom_ribbon(
    data = grid, aes(x = dose, ymin = lo, ymax = hi),
    fill = ocean, alpha = 0.15
  ) +
  ## raw data
  geom_point(
    data = df, aes(x = dose, y = delta_y),
    color = warmgray, size = 1.2, alpha = 0.60
  ) +
  ## fitted spline
  geom_line(
    data = grid, aes(x = dose, y = yhat),
    color = ocean, linewidth = 1.4
  ) +
  ## knot ticks at x-axis
  geom_vline(
    xintercept = knots_interior,
    linetype = "dashed", linewidth = 0.5, color = knot_col, alpha = 0.5
  ) +
  labs(
    x = "Dose  (D)",
    y = expression(Delta * Y[i] ~ "(first difference)"),
    caption = "Fitted cubic spline (blue line) with 95% pointwise confidence band.\nDashed lines mark the 3 interior knots."
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
outdir <- file.path(dirname(dirname(rstudioapi::getActiveDocumentContext()$path)),
                    "Slides", "figures", "dxt")
## Fallback if not in RStudio
if (!dir.exists(outdir)) {
  outdir <- file.path(
    "/Users/scunning/Codechella-Madrid/Slides/figures/dxt"
  )
}

ggsave(file.path(outdir, "spline_pieces.pdf"),  p_pieces, width = 9, height = 4.5)
ggsave(file.path(outdir, "spline_pieces.png"),  p_pieces, width = 9, height = 4.5, dpi = 150)
ggsave(file.path(outdir, "spline_fitted.pdf"),  p_fitted, width = 9, height = 4.5)
ggsave(file.path(outdir, "spline_fitted.png"),  p_fitted, width = 9, height = 4.5, dpi = 150)

message("Saved: spline_pieces.pdf, spline_pieces.png, spline_fitted.pdf, spline_fitted.png")
