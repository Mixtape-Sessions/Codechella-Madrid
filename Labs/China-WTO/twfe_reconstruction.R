################################################################################
# twfe_reconstruction.R
#
# Demonstrates numerically that the TWFE coefficient is *literally* the
# weighted sum of first differences using CBS-style per-unit level weights
# W_i = (D_i - D_bar) / SS_D, on Kyle's Lu & Yu (2015) WTO sample.
#
# Three steps:
#   (1) Get beta_hat from OLS of  Delta_ln_theil ~ dose
#   (2) Build per-industry weights W_i
#   (3) Verify Sum_i W_i * Delta_ln_theil_i = beta_hat from OLS
#
# Companion script: twfe_reconstruction.do
################################################################################

suppressPackageStartupMessages(library(tidyverse))

# Use Kyle's dose pipeline: pmax(tariff_2001 - 0.10, 0) on industries with
# non-missing Delta_ln_theil from a 2x2 panel of years 2001 and 2004.
df <- read_csv("data/industry_by_year.csv", show_col_types = FALSE)
collapsed <- df |>
  filter(year == 2001 | year == 2004) |>
  summarize(
    .by = sic3,
    Delta_ln_theil = ln_theil[year == 2004] - ln_theil[year == 2001],
    tariff_2001    = tariff[year == 2001],
    dose           = pmax(tariff_2001 - 0.10, 0)
  ) |>
  drop_na()

# (1) beta_hat from OLS
ols      <- lm(Delta_ln_theil ~ dose, data = collapsed)
beta_ols <- unname(coef(ols)["dose"])

# (2) Per-industry weights W_i = (D_i - D_bar) / SS_D
D_bar       <- mean(collapsed$dose)
SS_D        <- sum((collapsed$dose - D_bar)^2)
collapsed$W <- (collapsed$dose - D_bar) / SS_D

# (3) Reconstruct beta_hat by hand
beta_manual <- sum(collapsed$W * collapsed$Delta_ln_theil)

cat("================================================================\n")
cat(" TWFE reconstruction on Kyle's WTO sample (Lu & Yu 2015)\n")
cat("================================================================\n")
cat(sprintf(" N industries (drop-NA on Delta_ln_theil):    %d\n", nrow(collapsed)))
cat(sprintf(" E[D]:                                         %.4f\n", D_bar))
cat(sprintf(" Var(D)  (population):                         %.4f\n",
            SS_D / nrow(collapsed)))
cat("\n")
cat(sprintf(" (1) beta_hat from OLS:                        %.6f\n", beta_ols))
cat(sprintf(" (2) Sum_i  W_i * Delta_ln_theil_i:            %.6f\n", beta_manual))
cat(sprintf(" |OLS - manual|:                                %.2e\n",
            abs(beta_ols - beta_manual)))
cat("\n")
cat(" Weight diagnostics (must hold by construction):\n")
cat(sprintf("   Sum_i W_i           (should be 0):           %.2e\n",
            sum(collapsed$W)))
cat(sprintf("   Sum_i W_i * D_i     (should be 1):           %.6f\n",
            sum(collapsed$W * collapsed$dose)))
cat("================================================================\n")
