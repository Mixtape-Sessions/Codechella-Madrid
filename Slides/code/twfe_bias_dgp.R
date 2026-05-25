## twfe_bias_dgp.R
## ----------------------------------------------------------------------
## Map each Caetano-Callaway bias to a specific TWFE-with-X failure
## by generating Y(0) directly cell-by-cell (NOT through an additive
## linear model). Each DGP turns on ONE knob.
##
##   DGP 0 — clean linear baseline (no violation; all specs recover tau)
##   DGP 1 — Bias B: time-varying beta (additive-X biased; Post*X fixes)
##   DGP 2 — Bias A: heterogeneous tau in X (Post*X still biased; need D*X or DR)
##   DGP 3 — Bias C: time-invariant Z that FE eats (additive-Z = no-Z;
##                   need Post*Z to recover)
##
## True tau = 2 in every DGP. Run four specs on each DGP and tabulate
## what each recovers. The pattern of recoveries IS the pedagogical
## map of which fix each bias actually requires.
## ----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(dplyr)
  library(fixest)
})

set.seed(20260520)

TRUE_TAU <- 2.0
N <- 4000

# ---- DGP factory ----
# Note: X selection MUST be correlated with D for the biases to be visible.
# Treated units have higher X in the post period (the typical empirical case).
simulate <- function(dgp) {
  units <- data.frame(
    id = 1:N,
    D  = rbinom(N, 1, 0.5),
    Z  = rbinom(N, 1, 0.5)            # time-invariant baseline (e.g., high educ)
  )
  panel <- merge(units, data.frame(t = c(0, 1)))
  panel <- panel[order(panel$id, panel$t), ]
  panel$post <- as.integer(panel$t == 1)

  # X is time-varying. Treated get a +0.3 X bump in the post period.
  # This is the "policy moves X for treated" pattern.
  panel$X <- runif(nrow(panel)) + 0.3 * panel$D * panel$post

  # Unit-level baseline noise (a la fixed effect)
  alpha_i <- rnorm(N, 0, 0.5)
  panel$alpha <- alpha_i[panel$id]
  panel$eps   <- rnorm(nrow(panel), 0, 0.5)

  if (dgp == "clean") {
    panel$Y0  <- panel$alpha + 0.5 * panel$post + 1 * panel$X + panel$eps
    panel$tau <- TRUE_TAU
  } else if (dgp == "time_varying_beta") {
    # beta_pre = 1, beta_post = 3 — X's effect on Y shifts at the policy break
    panel$Y0  <- panel$alpha + 0.5 * panel$post +
                  ifelse(panel$post == 0, 1, 3) * panel$X + panel$eps
    panel$tau <- TRUE_TAU
  } else if (dgp == "het_tau") {
    # Heterogeneous tau in X: treatment effect grows with X.
    panel$Y0  <- panel$alpha + 0.5 * panel$post + 1 * panel$X + panel$eps
    panel$tau <- TRUE_TAU + 4 * (panel$X - 0.5)
  } else if (dgp == "time_invariant_Z") {
    # Z is time-invariant baseline. Its effect on Y appears only in post.
    # FE within-unit transformation eats Z.
    panel$Y0  <- panel$alpha + 0.5 * panel$post + 1 * panel$X +
                  5 * panel$Z * panel$post + panel$eps
    panel$tau <- TRUE_TAU
  }

  panel$Y <- panel$Y0 + panel$D * panel$post * panel$tau
  panel
}

# ---- Four estimators ----
run_specs <- function(panel) {
  m0 <- feols(Y ~ D*post, data = panel)                    # no covariates
  m1 <- feols(Y ~ D*post + X, data = panel)                # additive X
  m2 <- feols(Y ~ D*post + post*X, data = panel)           # Post * X
  m3 <- feols(Y ~ D*post + post*X + post*Z, data = panel)  # Post * X + Post * Z
  c(
    "no_cov"     = unname(coef(m0)["D:post"]),
    "additive_X" = unname(coef(m1)["D:post"]),
    "post_X"     = unname(coef(m2)["D:post"]),
    "post_X_Z"   = unname(coef(m3)["D:post"])
  )
}

# ---- Run all four DGPs ----
dgps <- c("clean", "time_varying_beta", "het_tau", "time_invariant_Z")
results <- t(sapply(dgps, function(d) run_specs(simulate(d))))
results <- round(results, 2)

cat("\nTrue tau =", TRUE_TAU, "\n\n")
cat("Each row is one DGP, each column is one TWFE spec.\n")
cat("Cells close to 2 mean the spec recovers truth on that DGP.\n\n")
print(results)
cat("\n")

# ---- Interpretation guide (printed for the slide deck builder) ----
cat("Pedagogical map:\n")
cat("  DGP 0 (clean):         all four specs recover tau ~ 2.\n")
cat("  DGP 1 (time-var beta): no-cov & additive-X biased; Post*X fixes.\n")
cat("  DGP 2 (het tau in X):  all specs biased toward some weighted ATT.\n")
cat("                          Need D*X interaction or DR estimator.\n")
cat("  DGP 3 (time-inv Z):    additive-X same as no-cov (Z eaten by FE).\n")
cat("                          Need Post*Z to recover.\n")
