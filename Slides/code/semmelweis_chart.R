## semmelweis_chart.R
## ----------------------------------------------------------------------
## Recreates the Semmelweis maternal mortality chart for the Glasgow deck,
## in the Remix visual style.
##
## Data: annual maternal mortality per 100 admissions at Vienna General
## Hospital, 1841-1849, by clinic. Sourced from Semmelweis's own tables
## as reproduced in standard secondary sources.
##
## The First Obstetric Clinic was staffed by physicians and medical
## students (cadaver dissection in the mornings, deliveries after).
## The Second was staffed by midwives. Chlorinated lime handwashing
## was instituted in the First Clinic starting May 15, 1847.
##
## Run: Rscript semmelweis_chart.R
## Output: ../figures/semmelweis_remix.pdf
## ----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
})

source(file.path("..", "..", "..", "_themes", "remix_theme.R"))

## ---- Annual maternal mortality (%) at the two clinics, 1841-1849 ----
df <- tibble::tribble(
  ~year, ~physicians, ~midwives,
   1841,        7.74,      3.40,
   1842,       15.80,      7.45,
   1843,        8.86,      5.97,
   1844,        8.21,      2.33,
   1845,        6.56,      2.04,
   1846,       11.42,      2.79,
   1847,        5.04,      3.06,   # handwashing starts May 15, 1847
   1848,        1.27,      1.33,
   1849,        1.27,      1.85
) |>
  pivot_longer(c(physicians, midwives), names_to = "clinic", values_to = "mortality") |>
  mutate(clinic = factor(clinic,
                         levels = c("physicians", "midwives"),
                         labels = c("First Clinic (physicians)",
                                    "Second Clinic (midwives)")))

## End-of-line label positions (for direct labels — no legend)
label_df <- df |> filter(year == 1849)

p <- ggplot(df, aes(x = year, y = mortality, color = clinic, group = clinic)) +
  ## intervention band: light tint behind handwashing era
  annotate("rect",
           xmin = 1847.4, xmax = 1849.4,
           ymin = -Inf,   ymax = Inf,
           fill = remix_color("remixgreenlight"), alpha = 0.55) +
  ## intervention vertical
  geom_vline(xintercept = 1847.4,
             color = remix_color("remixgreendark"),
             linewidth = 0.45, linetype = "dashed") +
  ## the two clinic lines
  geom_line(linewidth = 1.0) +
  geom_point(size = 2.1) +
  ## direct labels at line endpoints
  geom_text(data = label_df,
            aes(label = clinic),
            hjust = 0, nudge_x = 0.15, size = 3.4, fontface = "bold",
            show.legend = FALSE) +
  ## intervention annotation
  annotate("text",
           x = 1847.5, y = 16.5,
           label = "Handwashing\nbegins May 1847",
           hjust = 0, vjust = 1,
           color = remix_color("remixgreendark"),
           fontface = "bold", size = 3.4, lineheight = 0.9) +
  scale_color_manual(values = c(
    "First Clinic (physicians)"  = remix_color("remixgreen"),
    "Second Clinic (midwives)"   = remix_color("ocean")
  ), guide = "none") +
  scale_x_continuous(breaks = 1841:1849, limits = c(1841, 1851.4)) +
  scale_y_continuous(
    breaks = seq(0, 16, 4),
    labels = function(x) paste0(x, "%"),
    limits = c(0, 17.5)
  ) +
  labs(
    title    = "Maternal mortality fell from 11.4% to 1.3% within a year of handwashing",
    subtitle = "Vienna General Hospital, First and Second Obstetric Clinics, 1841–1849",
    x = NULL,
    y = NULL,
    caption = "Source: Semmelweis (1861), annual mortality per 100 admissions."
  ) +
  theme_remix() +
  theme(panel.grid.major.x = element_blank())

remix_save("../figures/semmelweis_remix.pdf", p, width = 8.4, height = 5.4)
cat("Saved figure: ../figures/semmelweis_remix.pdf\n")
