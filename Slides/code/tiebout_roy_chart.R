## tiebout_roy_chart.R
## ----------------------------------------------------------------------
## Figure for the deck slide
## "Sorting on delta can flip the sign of your answer".
##
## Shows: 254 county-level ATEs as dots, in two panels:
##   - Random sorting       — every county is a random sample
##   - Sort by delta        — high-effect people in 5 big counties
##
## Two horizontal reference lines per panel:
##   - Solid (charcoal)  — population (per-person) ATE
##   - Dashed (ocean)    — average of the 254 county ATEs
##
## DGP (matches Causal-Inference-2/Lab/Tiebout_roy/tiebout_roy2.R, scaled
## down for speed so the figure regenerates in <2 sec):
##   - Half the population:  delta ~ N(+5, 1)
##   - Half the population:  delta ~ N(-1, 0.5)
##   - Population mean E[delta] = 2 in BOTH scenarios
##   - 5 large counties (60,000 people each = 50% of pop)
##   - 249 small counties (~1,205 people each = 50% of pop)
##
## Output: ../../figures/tiebout_roy_distributions.pdf
## ----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

source(file.path("..", "..", "..", "..", "_themes", "remix_theme.R"))

set.seed(20260511)

## ---- DGP ----
n_large    <- 5
n_small    <- 249
size_large <- 60000                 # 5  * 60,000  = 300,000
size_small <- 1205                  # 249 * 1,205  = 300,045
N          <- n_large * size_large + n_small * size_small  # ≈ 600K

# Generate delta: half positive (mean +5), half negative (mean -1)
half      <- N %/% 2
delta_pos <- rnorm(half,     mean =  5, sd = 1.0)
delta_neg <- rnorm(N - half, mean = -1, sd = 0.5)
delta_all <- c(delta_pos, delta_neg)

county_sizes <- c(rep(size_large, n_large), rep(size_small, n_small))
county_labels <- c(seq_len(n_large), seq_len(n_small) + n_large)

## ---- Scenario 1: Random sorting ----
## Theoretical/expected case: under random assignment, each county's ATE
## equals the population mean E[delta] = +2. We plot the expectation
## rather than a finite-sample realization — sampling noise around +2 is
## not the pedagogical content here.
pop_mean <- mean(delta_all)

ca_random <- data.frame(
  county = county_labels,
  ate    = pop_mean,              # every county = population mean
  n      = county_sizes,
  type   = ifelse(county_labels <= n_large, "Large county", "Small county")
) %>%
  arrange(ate, county) %>%
  mutate(rank = row_number())

## ---- Scenario 2: Sort by delta ----
delta_sorted <- sort(delta_all, decreasing = TRUE)
county_sort  <- rep(county_labels, times = county_sizes)

df_sort <- data.frame(delta = delta_sorted, county = county_sort)

ca_sort <- df_sort %>%
  group_by(county) %>%
  summarise(ate = mean(delta), n = n(), .groups = "drop") %>%
  mutate(type = ifelse(county <= n_large, "Large county", "Small county")) %>%
  arrange(ate) %>%
  mutate(rank = row_number())

## ---- Two ATEs we want to compare ----
overall_random    <- pop_mean
county_avg_random <- mean(ca_random$ate)
overall_sort      <- mean(df_sort$delta)
county_avg_sort   <- mean(ca_sort$ate)

cat(sprintf("Random:  ATE_person = %+.2f  |  Avg of county ATEs = %+.2f\n",
            overall_random, county_avg_random))
cat(sprintf("Sort:    ATE_person = %+.2f  |  Avg of county ATEs = %+.2f\n",
            overall_sort,   county_avg_sort))

## ---- Build plotting data ----
plot_df <- bind_rows(
  ca_random %>% mutate(scenario = "Random sorting"),
  ca_sort   %>% mutate(scenario = "Sort by delta")
)
plot_df$scenario <- factor(plot_df$scenario,
                           levels = c("Random sorting", "Sort by delta"))

ref_df <- data.frame(
  scenario  = factor(c("Random sorting", "Random sorting",
                       "Sort by delta",  "Sort by delta"),
                     levels = c("Random sorting", "Sort by delta")),
  ref_kind  = c("Overall (per-person) ATE", "Avg of county ATEs",
                "Overall (per-person) ATE", "Avg of county ATEs"),
  value     = c(overall_random, county_avg_random,
                overall_sort,   county_avg_sort)
)

## ---- Plot ----
p <- ggplot(plot_df, aes(x = rank, y = ate)) +
  geom_point(aes(color = type, size = type), alpha = 0.85) +
  geom_hline(data = ref_df %>% filter(ref_kind == "Overall (per-person) ATE"),
             aes(yintercept = value),
             color = remix_color("charcoal"), linewidth = 0.9) +
  geom_hline(data = ref_df %>% filter(ref_kind == "Avg of county ATEs"),
             aes(yintercept = value),
             color = remix_color("ocean"), linewidth = 0.9, linetype = "dashed") +
  geom_text(data = ref_df %>% filter(ref_kind == "Overall (per-person) ATE"),
            aes(x = 254, y = value,
                label = sprintf("per-person ATE = %+.2f", value)),
            color = remix_color("charcoal"), size = 3.0, fontface = "bold",
            hjust = 1.0, vjust = -0.5, inherit.aes = FALSE) +
  geom_text(data = ref_df %>% filter(ref_kind == "Avg of county ATEs"),
            aes(x = 5, y = value,
                label = sprintf("avg of 254 county ATEs = %+.2f", value)),
            color = remix_color("ocean"), size = 3.0, fontface = "bold.italic",
            hjust = 0.0, vjust = -0.5, inherit.aes = FALSE) +
  scale_color_manual(values = c("Large county" = remix_color("forest"),
                                "Small county" = remix_color("warmgray")),
                     name = NULL) +
  scale_size_manual(values = c("Large county" = 3.2, "Small county" = 1.4),
                    name = NULL) +
  scale_x_continuous(breaks = c(1, 50, 100, 150, 200, 254)) +
  facet_wrap(~ scenario, ncol = 2) +    # FIXED y-axis: random dots collapse to a tight line at +2; sort dots span the full range. Makes the contrast visual, not numeric.
  labs(
    title    = "254 county ATEs, plotted against the per-person ATE",
    subtitle = "Same delta values in both panels. Population mean of delta = +2. Only the sorting changes.",
    x        = "County (ranked by ATE)",
    y        = "County-level ATE",
    caption  = "Each dot is one county. Large dots = 5 big counties (60K people each). Small dots = 249 small counties (~1.2K each). Solid line: ATE for the average person. Dashed line: average of the 254 county ATEs."
  ) +
  theme_remix() +
  theme(
    legend.position  = "bottom",
    legend.box       = "horizontal",
    strip.text       = element_text(size = 10, face = "bold"),
    panel.spacing.x  = unit(1.4, "lines")
  )

remix_save("../../figures/tiebout_roy_distributions.pdf", p, width = 10, height = 5.4)
cat("\nSaved: ../../figures/tiebout_roy_distributions.pdf\n")
