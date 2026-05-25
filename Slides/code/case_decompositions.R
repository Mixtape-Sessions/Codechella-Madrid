# ============================================================
# Four ways the 2x2 can go wrong — Monte Carlo
#
# Generates: figures/case_decompositions.pdf
#
# Each panel shows the sampling distribution of beta_hat_2x2 over
# 2000 Monte Carlo replications. True ATT = 10 in all four cases.
#
# Case 1: NA holds + never-treated comparison  -> unbiased
# Case 2: NA fails + never-treated comparison  -> biased by -anticipation
# Case 3: NA holds + spillover into control    -> biased by -spillover
# Case 4: NA holds + already-treated comparison -> biased by -DeltaATT (sign flip!)
# ============================================================

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(patchwork)
})

set.seed(20260513)

# --- Remix palette (matches the deck) -----------------------
deepnavy  <- "#1B3A5C"
forest    <- "#276749"
ocean     <- "#2B6CB0"
accent    <- "#C53030"
warmgray  <- "#718096"
cream     <- "#FAF6EE"
charcoal  <- "#2D3748"

# --- Simulation primitives ----------------------------------
N_per_group <- 200
n_reps      <- 2000
sigma       <- 2.0
baseline_T  <- 5
baseline_C  <- 4
trend       <- 2
ATT         <- 10

run_case <- function(case_id) {
  betas <- numeric(n_reps)
  for (r in seq_len(n_reps)) {

    # Pre-period draws
    Y_T_pre  <- baseline_T + rnorm(N_per_group, 0, sigma)
    Y_C_pre  <- baseline_C + rnorm(N_per_group, 0, sigma)

    # Post-period draws — case-specific
    if (case_id == 1) {
      # NA + never-treated control: clean DiD
      Y_T_post <- baseline_T + trend + ATT + rnorm(N_per_group, 0, sigma)
      Y_C_post <- baseline_C + trend         + rnorm(N_per_group, 0, sigma)

    } else if (case_id == 2) {
      # NA fails: treated group anticipates -> pre-period contaminated by ATT_pre = 3
      ATT_pre  <- 3
      Y_T_pre  <- baseline_T + ATT_pre + rnorm(N_per_group, 0, sigma)
      Y_T_post <- baseline_T + trend + ATT + rnorm(N_per_group, 0, sigma)
      Y_C_post <- baseline_C + trend         + rnorm(N_per_group, 0, sigma)

    } else if (case_id == 3) {
      # NA holds, but control absorbs spillover = 4 in post period only
      spillover <- 4
      Y_T_post <- baseline_T + trend + ATT       + rnorm(N_per_group, 0, sigma)
      Y_C_post <- baseline_C + trend + spillover + rnorm(N_per_group, 0, sigma)

    } else if (case_id == 4) {
      # NA holds, but comparison group is already-treated
      # Their ATT(Pre,  D=0) = 1
      # Their ATT(Post, D=0) = 15    -> DeltaATT = 14 (Scott's eye-popper)
      ATT_C_pre  <- 1
      ATT_C_post <- 15
      Y_C_pre  <- baseline_C + ATT_C_pre  + rnorm(N_per_group, 0, sigma)
      Y_C_post <- baseline_C + trend + ATT_C_post + rnorm(N_per_group, 0, sigma)
      Y_T_post <- baseline_T + trend + ATT        + rnorm(N_per_group, 0, sigma)
    }

    betas[r] <- (mean(Y_T_post) - mean(Y_T_pre)) -
                (mean(Y_C_post) - mean(Y_C_pre))
  }
  betas
}

cases <- list(
  list(id = 1,
       title  = "Case 1.  NA holds, never-treated control",
       subtitle = "Predicted:  beta = ATT = 10",
       expected_bias = 0),
  list(id = 2,
       title  = "Case 2.  NA fails (anticipation = 3)",
       subtitle = "Predicted:  beta = ATT - ATT_pre = 10 - 3 = 7",
       expected_bias = -3),
  list(id = 3,
       title  = "Case 3.  Spillover into control (= 4)",
       subtitle = "Predicted:  beta = ATT - spillover = 10 - 4 = 6",
       expected_bias = -4),
  list(id = 4,
       title  = "Case 4.  Already-treated control (ΔATT = 14)",
       subtitle = "Predicted:  beta = ATT - ΔATT = 10 - 14 = -4",
       expected_bias = -14)
)

# --- Run all four simulations -------------------------------
results <- lapply(cases, function(cc) {
  data.frame(case = cc$id,
             title = cc$title,
             beta = run_case(cc$id))
})

# --- Plot helper --------------------------------------------
make_panel <- function(df, cc) {
  mean_beta <- mean(df$beta)
  true_att  <- ATT
  expected  <- ATT + cc$expected_bias

  # Color: forest if essentially unbiased, accent if biased
  fill_color   <- if (abs(cc$expected_bias) < 0.5) forest else accent
  stroke_color <- if (abs(cc$expected_bias) < 0.5) forest else accent

  # X-axis range: cover the truth and the biased estimate
  x_min <- min(-6, expected - 4)
  x_max <- max(14,  expected + 4)

  ggplot(df, aes(x = beta)) +
    geom_density(fill = fill_color, alpha = 0.30,
                 color = stroke_color, linewidth = 0.7) +
    # True ATT — dashed reference line
    geom_vline(xintercept = true_att,
               color = ocean, linewidth = 0.9, linetype = "dashed") +
    annotate("text", x = true_att + 0.25, y = Inf,
             label = "true ATT = 10", vjust = 1.6, hjust = 0,
             color = ocean, size = 3.0, fontface = "bold") +
    # Mean of sampling distribution — solid
    geom_vline(xintercept = mean_beta,
               color = stroke_color, linewidth = 1.1) +
    annotate("text", x = mean_beta - 0.25, y = Inf,
             label = sprintf("mean = %.2f", mean_beta),
             vjust = 3.0, hjust = 1,
             color = stroke_color, size = 3.0, fontface = "bold") +
    coord_cartesian(xlim = c(x_min, x_max)) +
    labs(title = cc$title,
         subtitle = cc$subtitle,
         x = expression(widehat(beta)["2x2"]),
         y = NULL) +
    theme_minimal(base_size = 11) +
    theme(
      plot.background  = element_rect(fill = cream, color = NA),
      panel.background = element_rect(fill = cream, color = NA),
      panel.grid.major = element_line(color = "#E2E0D6", linewidth = 0.3),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_blank(),
      axis.text.y      = element_blank(),
      axis.ticks.y     = element_blank(),
      axis.title.x     = element_text(color = charcoal, size = 10),
      axis.text.x      = element_text(color = charcoal, size = 9),
      plot.title       = element_text(color = deepnavy, size = 12,
                                       face = "bold"),
      plot.subtitle    = element_text(color = charcoal, size = 10,
                                       margin = margin(t = 2, b = 8)),
      plot.margin      = margin(10, 14, 8, 14)
    )
}

panels <- mapply(make_panel, results, cases, SIMPLIFY = FALSE)

# --- Assemble 2x2 grid --------------------------------------
combined <- (panels[[1]] | panels[[2]]) /
            (panels[[3]] | panels[[4]]) +
  plot_annotation(
    title    = "Four ways the 2×2 can go wrong",
    subtitle = sprintf("Sampling distribution of β̂ over %d Monte Carlo reps · n = %d per group · True ATT = 10",
                       n_reps, N_per_group),
    theme = theme(
      plot.background  = element_rect(fill = cream, color = NA),
      plot.title       = element_text(color = deepnavy, size = 16,
                                       face = "bold",
                                       margin = margin(b = 2)),
      plot.subtitle    = element_text(color = warmgray, size = 11,
                                       margin = margin(b = 8))
    )
  )

ggsave("/Users/scunning/the-remix-tour/glasgow/decks/figures/case_decompositions.pdf",
       combined, width = 11, height = 7.2, device = cairo_pdf)

ggsave("/Users/scunning/the-remix-tour/glasgow/decks/figures/case_decompositions.png",
       combined, width = 11, height = 7.2, dpi = 220)

# --- Console summary ----------------------------------------
cat("\nSummary of sampling distributions (2000 reps each):\n\n")
for (i in seq_along(results)) {
  cat(sprintf("  Case %d: mean = %6.3f,  sd = %5.3f,  expected bias = %+d  (predicted point = %d)\n",
              results[[i]]$case[1],
              mean(results[[i]]$beta),
              sd(results[[i]]$beta),
              cases[[i]]$expected_bias,
              ATT + cases[[i]]$expected_bias))
}
cat("\nFigure saved to figures/case_decompositions.{pdf,png}\n")
