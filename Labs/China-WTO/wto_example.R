# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Trade Liberalization and Markup Dispersion: Evidence from China's WTO Accession
# By Yi Lu and Linhui Yu
# American Economic Journal: Applied Economics 2015
# %%
library(tidyverse)
library(here)
library(did2s)
library(ggplot2)
library(kfbmisc)
library(fixest)
library(splines)
library(stringmagic)

df <- read_csv("data/industry_by_year.csv")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Load and clean data ----------------------------------------------------------
collapsed <- df |>
  # 2x2
  filter(
    year == 2000 | year == 2004
  ) |>
  summarize(
    .by = sic3,
    # First-differenced outcome
    Delta_ln_theil = ln_theil[year == 2004] - ln_theil[year == 2000],
    # pre-WTO tariff rate
    tariff_2000 = tariff[year == 2000],
    # treatment dose
    dose = pmax(tariff_2000 - 0.1, 0)
  ) |>
  drop_na()

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Estimate continuous treatment effects ----
# Average change in Y for 0 dose group
count_trend_estimate <- collapsed |>
  filter(dose == 0) |>
  pull(Delta_ln_theil) |>
  mean(na.rm = TRUE)

# Regress \Delta Y - count trend estimate on a linear function of dose
est_linear <- feols(
  I(Delta_ln_theil - count_trend_estimate) ~ dose,
  collapsed |> filter(dose > 0)
)
# Regress \Delta Y - count trend estimate on a spline
est_spline <- feols(
  I(Delta_ln_theil - count_trend_estimate) ~ bs(dose),
  collapsed |> filter(dose > 0)
)
# Regress \Delta Y - count trend estimate on a set of bins
est_bins <- feols(
  I(Delta_ln_theil - count_trend_estimate) ~
    i(dose < 0.1) + i(0.1 <= dose & dose < 0.2) + i(dose >= 0.2),
  collapsed |> filter(dose > 0)
)

# Get points for plotting
predict_df <- tibble(dose = seq(0.01, max(collapsed$dose), by = 0.01))
predict_df <- predict_df |>
  mutate(
    dose_bin = case_when(
      dose < 0.1 ~ "< 0.1",
      0.1 <= dose & dose < 0.2 ~ "0.1 -- 0.2",
      dose >= 0.2 ~ "> 0.2",
    )
  )

linear_pred <- predict(est_spline, newdata = predict_df, se.fit = TRUE)
predict_df$te_est_linear <- linear_pred$fit
predict_df$te_est_linear_se <- linear_pred$se.fit

spline_pred <- predict(est_spline, newdata = predict_df, se.fit = TRUE)
predict_df$te_est_spline <- spline_pred$fit
predict_df$te_est_spline_se <- spline_pred$se.fit

bins_pred <- predict(est_bins, newdata = predict_df, se.fit = TRUE)
predict_df$te_est_bins <- bins_pred$fit
predict_df$te_est_bins_se <- bins_pred$se.fit

(p_ests <- ggplot() +
  # raw data
  geom_point(
    aes(x = dose, y = Delta_ln_theil - count_trend_estimate),
    data = collapsed,
    shape = 18,
    size = 2,
    color = tailwind_color("zinc-600")
  ) +
  geom_line(
    aes(x = dose, y = te_est_linear, color = "1"),
    data = predict_df,
    linewidth = 1.75
  ) +
  geom_line(
    aes(x = dose, y = te_est_spline, color = "2"),
    data = predict_df,
    linewidth = 1.75
  ) +
  geom_line(
    aes(x = dose, y = te_est_bins, color = "3", group = dose_bin),
    data = predict_df,
    linewidth = 1.75
  ) +
  scale_color_manual(
    values = c(
      "1" = kyle_color("magenta"),
      "2" = kyle_color("blue"),
      "3" = kyle_color("yellow")
    ),
    labels = c(
      "1" = "Linear Estimate",
      "2" = "Spline Estimate",
      "3" = "Bins Estimate"
    )
  ) +
  scale_y_continuous(limits = c(-1, 1), expand = c(0, 0)) +
  labs(
    x = "(Predicted) decline in tariff from WTO Entrance",
    y = "Estimated $\\text{ATT}\\left( d \\ | \\ d \\right)$",
    color = NULL
  ) +
  theme_kyle(legend = "top"))


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Pre-trends test ----
collapsed_pretrend <- df |>
  # 2x2
  filter(
    year == 2000 | year == 1998
  ) |>
  summarize(
    .by = sic3,
    # First-differenced outcome
    Delta_ln_theil = ln_theil[year == 1998] - ln_theil[year == 2000],
    # pre-WTO tariff rate
    tariff_2000 = tariff[year == 2000],
    # treatment dose
    dose = pmax(tariff_2000 - 0.1, 0)
  ) |>
  drop_na()

# Average change in Y for 0 dose group
count_trend_estimate <- collapsed_pretrend |>
  filter(dose == 0) |>
  pull(Delta_ln_theil) |>
  mean(na.rm = TRUE)

est_linear <- feols(
  I(Delta_ln_theil - count_trend_estimate) ~ dose,
  collapsed_pretrend |> filter(dose > 0)
)
est_spline <- feols(
  I(Delta_ln_theil - count_trend_estimate) ~ bs(dose),
  collapsed_pretrend |> filter(dose > 0)
)

# Get points for plotting
pretrends_predict_df <- tibble(dose = seq(0.01, max(collapsed$dose), by = 0.01))

linear_pred <- predict(
  est_spline,
  newdata = pretrends_predict_df,
  se.fit = TRUE
)
pretrends_predict_df$te_est_linear <- linear_pred$fit
pretrends_predict_df$te_est_linear_se <- linear_pred$se.fit

spline_pred <- predict(
  est_spline,
  newdata = pretrends_predict_df,
  se.fit = TRUE
)
pretrends_predict_df$te_est_spline <- spline_pred$fit
pretrends_predict_df$te_est_spline_se <- spline_pred$se.fit

(p_ests_pretrend <- ggplot() +
  geom_point(
    aes(x = dose, y = Delta_ln_theil - count_trend_estimate),
    data = collapsed_pretrend,
    shape = 18,
    size = 2,
    color = tailwind_color("zinc-600")
  ) +
  geom_line(
    aes(x = dose, y = te_est_linear, color = "1"),
    data = pretrends_predict_df,
    linewidth = 1.75
  ) +
  geom_line(
    aes(x = dose, y = te_est_spline, color = "2"),
    data = pretrends_predict_df,
    linewidth = 1.75
  ) +
  scale_color_manual(
    values = c(
      "1" = kyle_color("magenta"),
      "2" = kyle_color("blue")
    ),
    labels = c(
      "1" = "Linear Estimate",
      "2" = "Spline Estimate"
    )
  ) +
  scale_y_continuous(limits = c(-1, 1), expand = c(0, 0)) +
  labs(
    x = "(Predicted) decline in tariff from WTO Entrance",
    y = "Estimated pre-treatment $\\text{ATT}\\left( d \\ | \\ d \\right)$",
    color = NULL
  ) +
  theme_kyle(legend = "top"))
