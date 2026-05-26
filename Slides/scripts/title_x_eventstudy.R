## title_x_eventstudy.R
## Recreates Scott's Title X clinics simulation:
##   - 500 counties, 10 years
##   - Treatment in year 6
##   - Imbalance: 70% of urban counties treated, 30% of rural
##   - Pre-period: small urban decline (-0.15..-0.10), small rural rise (+0.10)
##                 => approximately flat pre-trends
##   - Post-period: big urban decline (-0.5..-2.5), rural still +0.10
##   - True treatment effect: positive and growing (0.6*(t-5) for t>=6)
##
## Produces two event-study figures:
##   1. DiD with no covariate -> flat pre, negative post (the trap)
##   2. DiD conditioning on urban -> flat pre, positive post (the truth)

suppressPackageStartupMessages({
  library(did)
  library(dplyr)
  library(ggplot2)
})

## ----- Madrid palette (match deck) -----
mad_terra   <- "#C44536"
mad_navy    <- "#2C3E5C"
mad_peach   <- "#FBE5D0"
mad_gold    <- "#C9982A"
mad_warmgr  <- "#8C7866"

## ----- DGP -----
set.seed(12345)
N <- 500
T <- 10

county <- tibble(
  county_id = 1:N,
  urban     = as.integer(runif(N) < 0.5),
  county_fe = rnorm(N, 0, 2)
)
county <- county |>
  mutate(treated = as.integer(
    (urban == 1 & runif(N) < 0.7) | (urban == 0 & runif(N) < 0.3)
  )) |>
  mutate(treat_date = as.numeric(ifelse(treated == 1, 6, 0)))

panel <- expand.grid(county_id = 1:N, year = 1:T) |>
  as_tibble() |>
  left_join(county, by = "county_id")

## Scott's year-by-year X-specific trend
##   pre-period (1-5): small urban decline, small rural rise -> roughly flat pre-trends
##   post-period (6-10): urban falls fast, rural stays flat
trend_for <- function(y, urb) {
  slope <- switch(as.character(y),
    "1"  = -0.15, "2"  = -0.25, "3"  = -0.15, "4"  = -0.10, "5"  = -0.10,
    "6"  = -0.50, "7"  = -1.00, "8"  = -1.50, "9"  = -2.00, "10" = -2.50
  )
  slope * urb + 0.10 * (1 - urb)
}

panel <- panel |>
  group_by(county_id) |>
  mutate(
    trend = mapply(trend_for, year, urban),
    u     = rnorm(n(), 0, 1)
  ) |>
  ungroup() |>
  mutate(
    y0  = 15 + county_fe + trend * year + u,
    y1  = y0 + as.integer(year >= 6) * treated * (year - 5) * 0.6,
    birth_rate = ifelse(treated == 1, y1, y0)
  )

## ----- DiD event study, no covariate -----
attgt_naive <- att_gt(
  yname     = "birth_rate",
  tname     = "year",
  idname    = "county_id",
  gname     = "treat_date",
  data      = panel,
  control_group = "nevertreated",
  est_method    = "reg",
  panel     = TRUE
)
es_naive <- aggte(attgt_naive, type = "dynamic", na.rm = TRUE)

## ----- DiD event study, conditioning on urban -----
attgt_x <- att_gt(
  yname     = "birth_rate",
  tname     = "year",
  idname    = "county_id",
  gname     = "treat_date",
  xformla   = ~ urban,
  data      = panel,
  control_group = "nevertreated",
  est_method    = "dr",
  panel     = TRUE
)
es_x <- aggte(attgt_x, type = "dynamic", na.rm = TRUE)

## ----- Helper: tidy the aggte object -----
tidy_es <- function(es, label) {
  tibble(
    e   = es$egt,
    att = es$att.egt,
    se  = es$se.egt
  ) |>
    mutate(
      lo  = att - 1.96 * se,
      hi  = att + 1.96 * se,
      lab = label,
      pre = e < 0
    )
}

df_naive <- tidy_es(es_naive, "DiD with no covariate")
df_x     <- tidy_es(es_x,     "DiD conditioning on urban")

cat("\n=== Event study: no covariate ===\n")
print(df_naive)
cat(sprintf("Overall ATT (no covariate): %.3f\n", es_naive$overall.att))

cat("\n=== Event study: conditioning on urban ===\n")
print(df_x)
cat(sprintf("Overall ATT (with urban):  %.3f\n", es_x$overall.att))

## ----- Plotting -----
make_es_plot <- function(df, title_text, accent_color) {
  ggplot(df, aes(x = e, y = att)) +
    geom_hline(yintercept = 0, color = mad_warmgr, linewidth = 0.4) +
    geom_vline(xintercept = -0.5, color = mad_warmgr, linewidth = 0.4, linetype = "dashed") +
    geom_errorbar(aes(ymin = lo, ymax = hi),
                  width = 0.18, color = accent_color, linewidth = 0.7) +
    geom_point(color = accent_color, fill = "white", shape = 21,
               size = 3.2, stroke = 1.1) +
    scale_x_continuous(breaks = unique(df$e)) +
    labs(
      title    = title_text,
      x        = "Event time (years from treatment)",
      y        = "Effect on birth rate"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title       = element_text(face = "bold", color = mad_navy, size = 15),
      axis.title       = element_text(color = mad_navy),
      axis.text        = element_text(color = mad_navy),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey92", linewidth = 0.3),
      plot.background  = element_rect(fill = "white", color = NA)
    )
}

p_naive <- make_es_plot(
  df_naive,
  sprintf("No covariate — sign flips (ATT ≈ %.2f, truth = +1.80)",
          es_naive$overall.att),
  mad_terra
)
p_x <- make_es_plot(
  df_x,
  sprintf("Conditioning on urban — truth restored (ATT ≈ %.2f)",
          es_x$overall.att),
  mad_navy
)

ggsave(
  "/Users/scunning/Codechella-Madrid/Slides/figures/titlex_es_naive.pdf",
  p_naive, width = 8, height = 4.8, device = cairo_pdf
)
ggsave(
  "/Users/scunning/Codechella-Madrid/Slides/figures/titlex_es_urban.pdf",
  p_x, width = 8, height = 4.8, device = cairo_pdf
)
cat("\nFigures written to Slides/figures/titlex_es_{naive,urban}.pdf\n")
