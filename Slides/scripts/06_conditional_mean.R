# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Ingredient 5: E[D | D >= l] — conditional mean above the cutoff.
# Regenerated to fix label collision with the curve (referee2 audit).
#
# Out: figures/dxt/06_conditional_mean.pdf
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
library(tidyverse)

setwd("/Users/scunning/the-remix-tour/glasgow/decks")

# Lu & Yu (2015) WTO dose: pmax(tariff_2001 - 0.10, 0) per sic3 industry.
df <- read_csv("kyle/China_WTO_Example/data/industry_by_year.csv",
               show_col_types = FALSE)

doses <- df |>
  filter(year == 2001) |>
  summarize(.by = sic3, dose = tariff[1]) |>
  drop_na(dose) |>
  pull(dose)

mean_D <- mean(doses)                                                # ≈ 0.164
cond_at_mean <- mean(doses[doses >= mean_D])                         # ≈ 0.290

# Grid of cutoff values l; E[D | D >= l] for each.
ls <- seq(0, max(doses) - 1e-6, length.out = 400)
cm <- sapply(ls, function(l) {
  s <- doses[doses >= l]
  if (length(s) == 0) NA else mean(s)
})

dat <- tibble(l = ls, cond_mean = cm) |> drop_na()

# Palette
remixgreen <- "#40A848"
remixgreendark <- "#1F5C25"
warmorange <- "#E85D04"
cream <- "#FAF8F2"
slate <- "#4A5568"

# Plot — label moved up-and-right into clear whitespace above the curve.
p <- ggplot(dat, aes(x = l, y = cond_mean)) +
  geom_line(colour = remixgreendark, linewidth = 1.2) +
  # E[D] horizontal reference
  geom_hline(yintercept = mean_D, colour = warmorange,
             linetype = "dashed", linewidth = 0.6) +
  # Vertical reference from the highlighted point down to the mean line
  annotate("segment", x = mean_D, xend = mean_D,
           y = mean_D, yend = cond_at_mean,
           colour = slate, linetype = "dotted", linewidth = 0.5) +
  # Highlight point at (E[D], E[D | D >= E[D]])
  annotate("point", x = mean_D, y = cond_at_mean,
           colour = remixgreendark, size = 2.8) +
  # E[D] label — placed BELOW the dashed line, where there's clean whitespace.
  annotate("text", x = 0.30, y = mean_D - 0.030,
           label = paste0("E[D] = ", sprintf("%.3f", mean_D)),
           colour = warmorange, fontface = "bold",
           size = 3.4, hjust = 0) +
  # CONDITIONAL-MEAN label placed in upper-LEFT whitespace, arrow points down-right to the dot.
  annotate("text", x = 0.02, y = 0.55,
           label = sprintf("E[D | D >= E[D]]  ~  %.3f", cond_at_mean),
           colour = remixgreendark, fontface = "bold",
           size = 3.4, hjust = 0) +
  annotate("segment",
           x = 0.12, y = 0.52,
           xend = mean_D - 0.003, yend = cond_at_mean + 0.012,
           colour = remixgreendark, linewidth = 0.4,
           arrow = arrow(length = unit(0.12, "cm"), type = "closed")) +
  scale_x_continuous(name = "Cutoff  l",
                     limits = c(0, max(doses) + 0.005),
                     expand = c(0, 0)) +
  scale_y_continuous(name = "E(D | D ≥ l)",
                     limits = c(0, 0.60),
                     expand = c(0, 0)) +
  theme_minimal(base_size = 12) +
  theme(
    panel.background = element_rect(fill = cream, colour = NA),
    plot.background  = element_rect(fill = cream, colour = NA),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(colour = "grey85", linewidth = 0.25),
    axis.title = element_text(colour = slate, face = "bold"),
    axis.text  = element_text(colour = slate),
    plot.margin = margin(8, 12, 6, 8)
  )

ggsave("figures/dxt/06_conditional_mean.pdf", p,
       width = 7.2, height = 4.4, units = "in", device = cairo_pdf)

cat("E[D] =", mean_D, "\n")
cat("E[D | D >= E[D]] =", cond_at_mean, "\n")
cat("Wrote figures/dxt/06_conditional_mean.pdf\n")
