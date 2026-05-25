## ipw_simulation.R
## ----------------------------------------------------------------------
## Monte Carlo comparison of two ways people implement "propensity score" methods:
##
##   Method A — IPW the correct way: reweight the control group by
##              p(X)/(1-p(X)) and compute the ATT directly.
##              Flexible; recovers the ATT under heterogeneous treatment effects.
##
##   Method B — Regression with additive PS as a covariate:
##              lm(Y ~ D + p_hat). Collapses multi-dim covariate structure
##              to a single scalar. Imposes homogeneous treatment effects.
##              Does NOT recover the ATT.
##
##   Method C — Naive OLS (for context):
##              lm(Y ~ D). Confounded.
##
## The simulation builds heterogeneous treatment effects (tau varies with X),
## with selection-into-treatment driven by the same X. Method A is unbiased
## for the true ATT. Method B is biased — by construction, because the
## regression cannot capture the D x X interaction it has imposed away.
##
## Output:
##   - Console summary (mean bias, RMSE, coverage)
##   - Histogram plot saved to figures/ipw_comparison.pdf
##
## Run with:  Rscript ipw_simulation.R
## ----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(ggplot2)
})

## Shared Remix theme (palette + theme_remix + scale_color_remix_*)
source(file.path("..", "..", "..", "..", "_themes", "remix_theme.R"))

set.seed(20260511)
n_sim <- 500
n     <- 1000

## ---- Data-generating process ----
## X1, X2 ~ N(0,1)
## Treatment selection: p(X) = inv-logit(0.5*X1 + 0.3*X2 - 0.2)
## Y(0) = X1 + 0.5*X2 + epsilon
## Y(1) = Y(0) + tau(X),  tau(X) = 1 + 0.5*X1   <-- heterogeneous effects

gen_data <- function(n) {
  X1 <- rnorm(n)
  X2 <- rnorm(n)
  ps_true <- plogis(0.5*X1 + 0.3*X2 - 0.2)
  D  <- rbinom(n, 1, ps_true)
  tau_i <- 1 + 0.5*X1
  Y0 <- X1 + 0.5*X2 + rnorm(n)
  Y1 <- Y0 + tau_i
  Y  <- D*Y1 + (1-D)*Y0
  data.frame(Y, D, X1, X2, tau_i, ps_true)
}

## ---- Method A: correct IPW reweighting controls ----
ipw_reweight_att <- function(dat) {
  ps <- glm(D ~ X1 + X2, data = dat, family = binomial)$fitted.values
  ## Trim extreme propensities to avoid numerical blowups
  keep <- ps > 0.01 & ps < 0.99
  d <- dat[keep, ]; ps <- ps[keep]
  w <- ifelse(d$D == 1, 1, ps / (1 - ps))
  ## ATT = E[Y | D=1] - weighted E[Y | D=0]
  m1 <- mean(d$Y[d$D == 1])
  m0 <- sum(d$Y[d$D == 0] * w[d$D == 0]) / sum(w[d$D == 0])
  m1 - m0
}

## ---- Method B: regression with additive propensity score ----
reg_additive_ps <- function(dat) {
  ps <- glm(D ~ X1 + X2, data = dat, family = binomial)$fitted.values
  fit <- lm(Y ~ D + ps, data = cbind(dat, ps = ps))
  unname(coef(fit)["D"])
}

## ---- Method C: naive OLS ----
naive_ols <- function(dat) {
  unname(coef(lm(Y ~ D, data = dat))["D"])
}

## ---- Run the Monte Carlo ----
results <- data.frame(
  true_ATT = numeric(n_sim),
  method_A = numeric(n_sim),
  method_B = numeric(n_sim),
  method_C = numeric(n_sim)
)

cat("Running", n_sim, "Monte Carlo replications with n =", n, "\n")
for (i in seq_len(n_sim)) {
  d <- gen_data(n)
  results$true_ATT[i] <- mean(d$tau_i[d$D == 1])
  results$method_A[i] <- ipw_reweight_att(d)
  results$method_B[i] <- reg_additive_ps(d)
  results$method_C[i] <- naive_ols(d)
  if (i %% 100 == 0) cat("  rep", i, "of", n_sim, "\n")
}

## ---- Summary ----
summ <- function(est, truth) {
  bias <- mean(est - truth)
  rmse <- sqrt(mean((est - truth)^2))
  sd_e <- sd(est - truth)
  c(mean = mean(est), bias = bias, rmse = rmse, sd = sd_e)
}

cat("\n========== Monte Carlo summary ==========\n")
cat("True ATT (averaged across replications):", round(mean(results$true_ATT), 4), "\n\n")
cat(sprintf("%-32s  %8s  %8s  %8s  %8s\n", "Method", "Mean", "Bias", "RMSE", "SD"))
cat(strrep("-", 80), "\n", sep = "")
cat(sprintf("%-32s  %8.4f  %8.4f  %8.4f  %8.4f\n",
            "A: IPW reweight controls (ATT)",
            summ(results$method_A, results$true_ATT)["mean"],
            summ(results$method_A, results$true_ATT)["bias"],
            summ(results$method_A, results$true_ATT)["rmse"],
            summ(results$method_A, results$true_ATT)["sd"]))
cat(sprintf("%-32s  %8.4f  %8.4f  %8.4f  %8.4f\n",
            "B: Regression with additive PS",
            summ(results$method_B, results$true_ATT)["mean"],
            summ(results$method_B, results$true_ATT)["bias"],
            summ(results$method_B, results$true_ATT)["rmse"],
            summ(results$method_B, results$true_ATT)["sd"]))
cat(sprintf("%-32s  %8.4f  %8.4f  %8.4f  %8.4f\n",
            "C: Naive OLS",
            summ(results$method_C, results$true_ATT)["mean"],
            summ(results$method_C, results$true_ATT)["bias"],
            summ(results$method_C, results$true_ATT)["rmse"],
            summ(results$method_C, results$true_ATT)["sd"]))
cat(strrep("-", 80), "\n", sep = "")

## ---- Figure: distribution of estimates around the true ATT ----
plot_df <- data.frame(
  method = factor(rep(c("A: IPW (correct)",
                        "B: Regression w/ additive PS",
                        "C: Naive OLS"), each = n_sim),
                  levels = c("A: IPW (correct)",
                             "B: Regression w/ additive PS",
                             "C: Naive OLS")),
  estimate = c(results$method_A, results$method_B, results$method_C),
  truth = rep(results$true_ATT, 3)
)
plot_df$deviation <- plot_df$estimate - plot_df$truth

p <- ggplot(plot_df, aes(x = deviation, fill = method)) +
  geom_histogram(bins = 35, alpha = 0.9, color = remix_color("cream")) +
  geom_vline(xintercept = 0, color = remix_color("remixgreendark"), linewidth = 0.6) +
  facet_wrap(~ method, ncol = 1, scales = "free_y") +
  scale_fill_remix_d() +
  labs(
    title    = "Estimate minus true ATT, across 500 Monte Carlo runs",
    subtitle = "Heterogeneous treatment effects with selection on X",
    x = "estimate - true ATT",
    y = NULL
  ) +
  theme_remix()

remix_save("figures/ipw_comparison.pdf", p)
cat("\nFigure saved: figures/ipw_comparison.pdf\n")
