##############################################################################
# build_gruber_extract.R
#
# Builds a teaching extract of the Gruber (1994) analysis sample from the
# fully-cleaned NBER May CPS replication file at:
#
#   ~/Dropbox-MixtapeConsulting/.../Claude_DDD/data/gruber_clean.dta
#
# That cleaned dataset was assembled in January 2026 from the raw NBER May CPS
# files (1974, 1975, 1977, 1978), with Gruber's sample restrictions applied
# (age 20-65, not self-employed, real wage in [1, 100] 1978 dollars), wages
# CPI-deflated to 1978, and the treated/placebo group flags constructed.
#
# Pedro Sant'Anna verified the resulting DDD: -0.05847 (no controls),
# matching across R, Stata, and Python.
#
# This script trims that file to the variables students need, writes
# .dta and .csv into ../data/, and re-runs the headline regression to
# confirm the extract reproduces Pedro's number.
#
# Author: Scott Cunningham (Baylor) for the Glasgow Remix Tour
##############################################################################

suppressPackageStartupMessages({
  library(haven)
  library(dplyr)
  library(fixest)
})

src <- file.path(
  "/Users/scunning/Library/CloudStorage/Dropbox-MixtapeConsulting",
  "scott cunningham/Claude_DDD/data/gruber_clean.dta"
)

g <- read_dta(src)

##############################################################################
# Apply Gruber's analysis-sample restrictions (the same filters used in
# Claude_DDD/programs/r/04_ddd_regression.R)
##############################################################################

ana <- g %>%
  filter(treat_group == 1 | control_group == 1) %>%
  filter(age >= 20, age <= 65) %>%
  filter(!is.na(hourly_wage_1978),
         hourly_wage_1978 >= 1, hourly_wage_1978 <= 100) %>%
  mutate(
    log_wage      = round(log(hourly_wage_1978), 5),
    state_law     = as.integer(treated_state == 1),
    after         = as.integer(year >= 1977),
    married_woman = as.integer(treat_group == 1),
    year          = as.integer(year),
    age           = as.integer(age)
  ) %>%
  select(year, state, state_law, age, married_woman, after, log_wage)

##############################################################################
# Verify the DDD reproduces
##############################################################################

m <- feols(log_wage ~ state_law * after * married_woman,
           data = ana, vcov = "hetero")

ddd <- coef(m)["state_law:after:married_woman"]
se  <- sqrt(diag(vcov(m)))["state_law:after:married_woman"]

cat(sprintf("\nAnalysis sample N: %d\n", nrow(ana)))
cat(sprintf("DDD (no controls): %.5f   (Pedro: -0.05847; Gruber published: -0.054)\n",
            ddd))
cat(sprintf("Robust SE:         %.5f   (Gruber published: 0.026)\n", se))

##############################################################################
# Save
##############################################################################

out_csv <- file.path("..", "data", "gruber1994.csv")
out_dta <- file.path("..", "data", "gruber1994.dta")

write.csv(ana, out_csv, row.names = FALSE)
write_dta(ana, out_dta)

cat("\nWrote:", normalizePath(out_csv), "\n")
cat("Wrote:", normalizePath(out_dta), "\n")
