## weighted_pt_eventstudy.R
## ----------------------------------------------------------------------
## Two event-study panels showing what the weighted-vs-unweighted PT
## distinction looks like in practice.
##
##   A. Random selection (covgap ~= 0):
##       BOTH event studies have flat pre-trends; weighted and unweighted
##       disagree on the post point estimate because they estimate
##       different ATTs (size-weighted vs unit-weighted).
##
##   B. Strong selection on size (covgap large):
##       Unweighted event study: flat pre-trends, correct post.
##       Weighted event study: visibly drifting pre-trends, biased post.
##
## DGP — extension of weighted_pt_chart.R to multiple periods:
##   N = 5000 units, t in {-5,...,+5}, treatment turns on at t = 0.
##   S ~ Lognormal(0, 0.8).
##   Selection on size: P(D=1 | S) = sigmoid(gamma0 + g1 * ln S),
##     centered so P(D=1) ~ 0.5.
##   dY(0)_t = alpha + beta * (S - Sbar_d) + N(0, sige)  [group-centered]
##       => PT_unw = 0 by construction in every period.
##   Heterogeneous treatment effect: delta_i = delta_base + delta_size*(S - mean S).
##
## Output:
##   ../../figures/weighted_pt_eventstudy_A.pdf  (covgap ~= 0)
##   ../../figures/weighted_pt_eventstudy_B.pdf  (covgap large)
## ----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(fixest)
})

source(file.path("..", "..", "..", "..", "_themes", "remix_theme.R"))

set.seed(20260520)

# ---- DGP ----
#   beta = 0  -> dY independent of S, so kappa_d = 0 for both groups,
#                so covgap = 0 exactly regardless of selection.
#   beta = 1  -> dY = alpha + (S - Sbar_d) + noise, group-centered.
#                PT_unw = 0 by construction but covgap moves with selection.
simulate_panel <- function(g1, beta = 1, N = 5000, T_pre = 5, T_post = 5,
                            alpha = 2, sige = 1, p_treat = 0.5,
                            delta_base = 5, delta_size = 2) {
  S        <- exp(rnorm(N, 0, 0.8))
  lnS      <- log(S)
  meanlnS  <- mean(lnS)
  meanS    <- mean(S)

  gamma0   <- log(p_treat / (1 - p_treat)) - g1 * meanlnS
  prob     <- plogis(gamma0 + g1 * lnS)
  D        <- rbinom(N, 1, prob)

  Sbar1    <- mean(S[D == 1])
  Sbar0    <- mean(S[D == 0])
  S_ctr    <- ifelse(D == 1, S - Sbar1, S - Sbar0)

  delta    <- delta_base + delta_size * (S - meanS)

  periods  <- (-T_pre):T_post

  # Build long panel
  panel <- expand.grid(unit = seq_len(N), t = periods,
                       KEEP.OUT.ATTRS = FALSE)
  panel$D       <- D[panel$unit]
  panel$S       <- S[panel$unit]
  panel$S_ctr   <- S_ctr[panel$unit]
  panel$delta   <- delta[panel$unit]

  # dY draws — independent across (unit, t)
  panel$dY <- alpha + beta * panel$S_ctr +
              rnorm(nrow(panel), 0, sige)

  # Cumulate dY within unit to get Y(0)
  panel <- panel |> arrange(unit, t) |>
    group_by(unit) |>
    mutate(Y0 = 50 + 5 * log(S) + cumsum(dY)) |>
    ungroup()

  # Treatment turns on at t = 0
  panel$treated_post <- panel$D * (panel$t >= 0)
  panel$Y            <- panel$Y0 + panel$treated_post * panel$delta

  # Covariance gap based on a single-period dY draw to match the
  # diagnostic from the existing chart script
  k1 <- cov(panel$dY[panel$D == 1 & panel$t == 0],
             panel$S[panel$D == 1 & panel$t == 0]) /
        mean(panel$S[panel$D == 1])
  k0 <- cov(panel$dY[panel$D == 0 & panel$t == 0],
             panel$S[panel$D == 0 & panel$t == 0]) /
        mean(panel$S[panel$D == 0])

  list(panel = panel, S = S, D = D,
       covgap = k1 - k0,
       n_treated = sum(D),
       Sbar1 = Sbar1, Sbar0 = Sbar0)
}

# ---- Event-study regression ----
run_es <- function(panel, weights = NULL) {
  if (is.null(weights)) {
    m <- feols(Y ~ i(t, D, ref = -1) | unit + t, data = panel)
  } else {
    panel$.w <- weights
    m <- feols(Y ~ i(t, D, ref = -1) | unit + t,
               data = panel, weights = ~.w)
  }
  cf <- coeftable(m)
  # rownames look like "t::-5:D" etc.
  e <- as.numeric(sub("^t::(-?[0-9.]+):D$", "\\1", rownames(cf)))
  data.frame(e = e, est = cf[, 1], se = cf[, 2]) |>
    mutate(lo = est - 1.96 * se, hi = est + 1.96 * se) |>
    arrange(e)
}

# Add the omitted e = -1 reference row at zero
add_ref_row <- function(df) {
  bind_rows(df, data.frame(e = -1, est = 0, se = 0, lo = 0, hi = 0)) |>
    arrange(e)
}

# ---- Run both cases ----
A <- simulate_panel(g1 = 0, beta = 0)   # clean — covgap = 0 exactly
B <- simulate_panel(g1 = 2, beta = 1)   # PT_wtd violated by selection

cat(sprintf("\nCase A: covgap = %+.4f,  N_treated = %d\n",  A$covgap, A$n_treated))
cat(sprintf("Case B: covgap = %+.4f,  N_treated = %d\n\n", B$covgap, B$n_treated))

A_unw <- run_es(A$panel)                    |> mutate(spec = "Unweighted") |> add_ref_row()
A_wtd <- run_es(A$panel, weights = A$panel$S) |> mutate(spec = "Weighted by S") |> add_ref_row()
A_df  <- bind_rows(
  A_unw |> mutate(spec = "Unweighted"),
  A_wtd |> mutate(spec = "Weighted by S")
)

B_unw <- run_es(B$panel)                    |> mutate(spec = "Unweighted") |> add_ref_row()
B_wtd <- run_es(B$panel, weights = B$panel$S) |> mutate(spec = "Weighted by S") |> add_ref_row()
B_df  <- bind_rows(
  B_unw |> mutate(spec = "Unweighted"),
  B_wtd |> mutate(spec = "Weighted by S")
)

# ---- Plot function ----
make_es_plot <- function(df, title_text, subtitle_text) {
  ggplot(df, aes(x = e, y = est, color = spec, group = spec)) +
    geom_hline(yintercept = 0, color = remix_color("warmgray"),
               linewidth = 0.4, linetype = "dashed") +
    geom_vline(xintercept = -0.5, color = remix_color("warmgray"),
               linewidth = 0.4, linetype = "dashed") +
    geom_ribbon(aes(ymin = lo, ymax = hi, fill = spec),
                color = NA, alpha = 0.15) +
    geom_line(linewidth = 0.6) +
    geom_point(size = 2.2) +
    scale_color_manual(values = c(
      "Unweighted"    = remix_color("ocean"),
      "Weighted by S" = remix_color("forest")
    ), name = NULL) +
    scale_fill_manual(values = c(
      "Unweighted"    = remix_color("ocean"),
      "Weighted by S" = remix_color("forest")
    ), guide = "none") +
    scale_x_continuous(breaks = seq(-5, 5, 1)) +
    labs(
      title    = title_text,
      subtitle = subtitle_text,
      x        = "event time  e  (t - treatment date)",
      y        = expression(paste("event-study coefficient  ", hat(beta)[e]))
    ) +
    theme_remix() +
    theme(
      legend.position = "top",
      legend.justification = "left",
      aspect.ratio    = 0.62
    )
}

# ---- Case A figure ----
sub_A <- sprintf("covgap = %+.3f. Both pre-trends look flat. Different post estimates: same data, different estimands.", A$covgap)
p_A   <- make_es_plot(A_df,
                       "Case A. Random selection — both PTs hold",
                       sub_A)

remix_save("../../figures/weighted_pt_eventstudy_A.pdf", p_A, width = 8.0, height = 5.2)
cat("Saved: ../../figures/weighted_pt_eventstudy_A.pdf\n")

# ---- Case B figure ----
sub_B <- sprintf("covgap = %+.3f. Unweighted pre-trends flat; weighted pre-trends drift. Weighted PT fails — weighted post is biased.", B$covgap)
p_B   <- make_es_plot(B_df,
                       "Case B. Strong selection on size — only one PT holds",
                       sub_B)

remix_save("../../figures/weighted_pt_eventstudy_B.pdf", p_B, width = 8.0, height = 5.2)
cat("Saved: ../../figures/weighted_pt_eventstudy_B.pdf\n")
