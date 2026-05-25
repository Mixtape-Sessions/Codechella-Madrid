## bacon_sw_sampling_dist.R
## ----------------------------------------------------------------------
## Sampling distribution of the TWFE static coefficient on Stevenson-
## Wolfers data, with question-marked ATT lines on either side.
##
## Pedagogical point (Scott's framing):
##   The finding is what it is. The sampling distribution of TWFE
##   centers on its OLS population estimand (LLN/CLT). The estimand
##   here is the -3.08 reported in Bacon (2021) Fig. 5.
##   Whether the estimand IS the ATT is a separate question.
##
##   Under heterogeneity, the bias is -ΔATT. We don't know its sign
##   or size in general. So the true ATT could be to the left OR the
##   right of where the sampling distribution centers.
##
## Run:    Rscript bacon_sw_sampling_dist.R
## Output: ../figures/bacon_sw_sampling_dist.pdf
## ----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(ggplot2)
})

source(file.path("..", "..", "..", "_themes", "remix_theme.R"))

set.seed(20260513)

## ---- numbers from Bacon (2021) Fig. 5 ----
estimand <- -3.08    # the OLS population estimand (where TWFE converges)
se       <-  1.27    # s.e. of beta_hat from Bacon Fig. 5

## ---- simulate iid draws of beta_hat under CLT ----
nsim     <- 8000
beta_hat <- rnorm(nsim, mean = estimand, sd = se)
df       <- data.frame(beta_hat = beta_hat)

## ---- candidate ATT positions to flag with question marks ----
##   one negative-leaning (e.g. event-study average -4.92, removing
##   late/early -5.44, somewhere around -5.5 captures the negative
##   "true ATT" possibility), one less-negative-leaning (the ATT could
##   also be smaller in magnitude than the estimand, depending on the
##   true heterogeneity)
att_left  <- -5.50
att_right <- -1.20

## ---- top of plot reference for annotations ----
ytop <- 0.36

p <- ggplot(df, aes(x = beta_hat)) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 55,
                 fill  = remix_color("ocean"),
                 color = remix_color("cream"),
                 alpha = 0.78) +

  ## --- the estimand line (solid, ocean) ---
  geom_vline(xintercept = estimand,
             color = remix_color("ocean"),
             linewidth = 1.05) +
  annotate("text",
           x = estimand, y = ytop * 1.08,
           label = "estimand:  -3.08",
           color = remix_color("ocean"),
           fontface = "bold",
           hjust = 0.5, vjust = 0,
           size = 4.0) +

  ## --- candidate ATT to the LEFT (more negative) ---
  geom_vline(xintercept = att_left,
             color = remix_color("charcoal"),
             linewidth = 0.7, linetype = "dashed") +
  annotate("text",
           x = att_left, y = ytop * 1.08,
           label = "ATT?",
           color = remix_color("charcoal"),
           fontface = "italic",
           hjust = 0.5, vjust = 0,
           size = 4.0) +

  ## --- candidate ATT to the RIGHT (less negative) ---
  geom_vline(xintercept = att_right,
             color = remix_color("charcoal"),
             linewidth = 0.7, linetype = "dashed") +
  annotate("text",
           x = att_right, y = ytop * 1.08,
           label = "ATT?",
           color = remix_color("charcoal"),
           fontface = "italic",
           hjust = 0.5, vjust = 0,
           size = 4.0) +

  scale_x_continuous(
    limits = c(-9, 3),
    breaks = seq(-9, 3, 2),
    labels = function(x) ifelse(x < 0, sprintf("-%g", abs(x)), as.character(x))
  ) +
  scale_y_continuous(limits = c(0, ytop * 1.22),
                     expand = expansion(mult = c(0, 0.02))) +

  labs(
    title    = "TWFE is unbiased for its estimand",
    subtitle = expression("8,000 iid draws of " * hat(beta) * " ~ N(-3.08, 1.27"^2 * ")  ·  Bacon (2021) SW replication"),
    x = expression(hat(beta)^{"TWFE"} ~ " (suicides per million women)"),
    y = "density",
    caption = expression(
      "PT works  -  every 2x2 is a real ATT.  Heterogeneity kills  -  forbidden 2x2 picks up " * - Delta * "ATT."
    )
  ) +
  theme_remix(base_size = 12) +
  theme(plot.caption = element_text(size = 9.5,
                                    color = remix_color("warmgray"),
                                    hjust = 0))

remix_save("../figures/bacon_sw_sampling_dist.pdf", p,
           width = 9.5, height = 4.6)

cat("Saved: ../figures/bacon_sw_sampling_dist.pdf\n")
