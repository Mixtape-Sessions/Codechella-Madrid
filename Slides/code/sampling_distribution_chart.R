## sampling_distribution_chart.R
## ----------------------------------------------------------------------
## Two-panel illustration of the difference between *statistical*
## convergence (LLN/CLT) and *identification* (parallel trends).
##
##   Left panel  — PT holds:  the sampling distribution is centered on
##                  the population estimand, AND that estimand equals
##                  the target parameter (ATT). β̂ is unbiased for ATT.
##   Right panel — PT fails:  the sampling distribution is still
##                  centered on the population estimand, but the
##                  estimand now differs from ATT by a bias term.
##                  β̂ is unbiased for the estimand, but not for ATT.
##
## Point: a beautifully tight, beautifully normal sampling distribution
## can be centered on the wrong number. Statistical efficiency ≠ identification.
##
## Run: Rscript sampling_distribution_chart.R
## Output: ../figures/sampling_distribution.pdf
## ----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

source(file.path("..", "..", "..", "_themes", "remix_theme.R"))

## ---- DGP for the figure ----
att   <- 1.2     # the true causal effect
sigma <- 0.18    # sampling SD of beta_hat

scenarios <- list(
  list(label = "PT holds: estimand = ATT",
       estimand = 1.2),
  list(label = "PT fails: estimand differs from ATT by bias",
       estimand = 1.7)
)

df <- bind_rows(lapply(scenarios, function(s) {
  x <- seq(0.4, 2.4, length.out = 400)
  data.frame(
    scenario = s$label,
    x        = x,
    density  = dnorm(x, mean = s$estimand, sd = sigma),
    estimand = s$estimand,
    att      = att
  )
}))
df$scenario <- factor(df$scenario,
                      levels = sapply(scenarios, `[[`, "label"))

## helper: per-panel annotation data
ann <- bind_rows(lapply(scenarios, function(s) {
  data.frame(scenario = s$label, estimand = s$estimand, att = att)
}))
ann$scenario <- factor(ann$scenario, levels = levels(df$scenario))

p <- ggplot(df, aes(x = x, y = density, fill = scenario)) +
  geom_area(alpha = 0.85, color = remix_color("cream")) +
  ## ATT line (truth) — solid charcoal
  geom_vline(data = ann, aes(xintercept = att),
             color = remix_color("charcoal"),
             linewidth = 0.8) +
  ## Estimand line (where β̂ converges) — dashed ocean
  geom_vline(data = ann, aes(xintercept = estimand),
             color = remix_color("ocean"),
             linewidth = 0.8, linetype = "dashed") +
  ## labels for ATT and Estimand at top of each panel
  geom_text(data = ann, aes(x = att, y = 2.45, label = "ATT"),
            color = remix_color("charcoal"), fontface = "bold",
            size = 3.4, hjust = 1.15, inherit.aes = FALSE) +
  geom_text(data = ann, aes(x = estimand, y = 2.45, label = "estimand"),
            color = remix_color("ocean"), fontface = "italic",
            size = 3.4, hjust = -0.15, inherit.aes = FALSE) +
  facet_wrap(~ scenario, ncol = 2) +
  scale_fill_remix_d(guide = "none") +
  scale_x_continuous(limits = c(0.4, 2.4), breaks = c(0.5, 1.0, 1.5, 2.0)) +
  scale_y_continuous(limits = c(0, 2.6)) +
  labs(
    title    = "A tight sampling distribution can still miss the truth",
    subtitle = "LLN: beta_hat converges to the population estimand.  Identification: the estimand equals ATT only if PT holds.",
    x = expression(beta),
    y = "density",
    caption = "Same sampling distribution shape in both panels (LLN + CLT). What changes is whether the estimand is the causal parameter."
  ) +
  theme_remix() +
  theme(strip.text = element_text(face = "bold", size = 10))

remix_save("../figures/sampling_distribution.pdf", p, width = 9.0, height = 4.6)
cat("Saved: ../figures/sampling_distribution.pdf\n")
