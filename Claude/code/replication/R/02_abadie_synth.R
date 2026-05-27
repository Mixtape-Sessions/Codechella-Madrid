## ============================================================================
## 02_abadie_synth.R
## Abadie, Diamond, Hainmueller (2010, JASA) — synthetic control for Prop 99
## Reproduces:
##   - California vs synthetic California cigarette sales, 1970-2000
##   - Donor weights (which states make up synthetic CA)
##   - Pre-period predictor balance
##   - In-time placebo: pretend treatment in 1975
##   - In-space placebos: each donor state, leave-one-out
## ============================================================================

suppressPackageStartupMessages({
  library(haven); library(dplyr); library(tidyr); library(ggplot2)
  library(Synth); library(kableExtra)
})

ROOT <- "/Users/scunning/Codechella-Madrid/Claude"
DATA <- file.path(ROOT, "data")
FIGS <- file.path(ROOT, "decks/heckman-abadie/figures")
TABS <- file.path(ROOT, "decks/heckman-abadie/tables")

rm_white  <- "#FFFFFF"
rm_navy   <- "#1A1A2E"
rm_blue   <- "#00529F"
rm_gold   <- "#FEBE10"
rm_cream  <- "#FAF7EE"
rm_red    <- "#C8102E"

theme_merengue <- function(base_size = 14) {
  theme_minimal(base_size = base_size, base_family = "sans") +
    theme(
      plot.background    = element_rect(fill = rm_cream, color = NA),
      panel.background   = element_rect(fill = rm_cream, color = NA),
      panel.grid.minor   = element_blank(),
      panel.grid.major   = element_line(color = "#E5DDD0", linewidth = 0.3),
      axis.line          = element_line(color = rm_navy, linewidth = 0.4),
      axis.text          = element_text(color = rm_navy, size = base_size - 1),
      axis.title         = element_text(color = rm_navy, face = "bold"),
      plot.title         = element_text(color = rm_navy, face = "bold",
                                        size = base_size + 3, hjust = 0),
      plot.subtitle      = element_text(color = rm_navy, hjust = 0,
                                        size = base_size - 1),
      plot.caption       = element_text(color = "#6E6759", size = base_size - 3, hjust = 1),
      legend.background  = element_rect(fill = rm_cream, color = NA),
      legend.key         = element_rect(fill = rm_cream, color = NA)
    )
}

## Load data --------------------------------------------------------------
d <- read_dta(file.path(DATA, "smoking.dta")) %>%
  mutate(state = as.numeric(state)) %>%
  as.data.frame()
CA <- 3

## State labels (canonical ADH ordering) ---------------------------------
state_names <- c("Alabama","Arkansas","California","Colorado","Connecticut",
                 "Delaware","Georgia","Idaho","Illinois","Indiana","Iowa",
                 "Kansas","Kentucky","Louisiana","Maine","Minnesota","Mississippi",
                 "Missouri","Montana","Nebraska","Nevada","New Hampshire",
                 "New Mexico","North Carolina","North Dakota","Ohio","Oklahoma",
                 "Pennsylvania","Rhode Island","South Carolina","South Dakota",
                 "Tennessee","Texas","Utah","Vermont","Virginia","West Virginia",
                 "Wisconsin","Wyoming")
state_lookup <- setNames(state_names, 1:39)
d$state_name <- state_lookup[as.character(d$state)]

## (1) Run synth with ADH's exact predictor list -------------------------
dataprep_out <- dataprep(
  foo = d,
  predictors = c("lnincome","beer","age15to24","retprice"),
  predictors.op = "mean",
  time.predictors.prior = 1980:1988,
  special.predictors = list(
    list("cigsale", 1975, "mean"),
    list("cigsale", 1980, "mean"),
    list("cigsale", 1988, "mean")
  ),
  dependent = "cigsale",
  unit.variable = "state",
  unit.names.variable = "state_name",
  time.variable = "year",
  treatment.identifier = 3,
  controls.identifier = setdiff(1:39, 3),
  time.optimize.ssr = 1970:1988,
  time.plot = 1970:2000
)

synth_out <- synth(dataprep_out, verbose = FALSE)

## Trajectories
ca_actual <- as.numeric(dataprep_out$Y1plot)
ca_synth  <- as.numeric(dataprep_out$Y0plot %*% synth_out$solution.w)
years     <- as.numeric(rownames(dataprep_out$Y1plot))

cat("\n[1] Synth solved. Top donor weights:\n")
w <- synth_out$solution.w
donors_df <- data.frame(state = rownames(w),
                        weight = round(as.numeric(w), 4)) %>%
  arrange(desc(weight)) %>% filter(weight > 0.001)
print(donors_df)

cat("\n[2] Pre-1988 RMSPE: ",
    round(sqrt(mean((ca_actual[years<=1988] - ca_synth[years<=1988])^2)), 3), "\n")
cat("Post-1988 RMSPE: ",
    round(sqrt(mean((ca_actual[years>1988] - ca_synth[years>1988])^2)), 3), "\n")

gap_table <- data.frame(year = years,
                        california = ca_actual,
                        synth_ca   = ca_synth,
                        gap        = ca_actual - ca_synth)
cat("\n[3] Effect sizes (CA - synth CA), selected years:\n")
print(round(gap_table[gap_table$year %in% c(1989, 1992, 1996, 2000), ], 2))

## ---------- FIGURE 1: California vs synthetic California -------------
fig_trend <- ggplot(gap_table, aes(x = year)) +
  geom_vline(xintercept = 1988, linetype = "dashed",
             color = rm_gold, linewidth = 0.8) +
  geom_line(aes(y = california, color = "California"),  linewidth = 1.2) +
  geom_line(aes(y = synth_ca,  color = "Synthetic California"), linewidth = 1.0,
            linetype = "longdash") +
  annotate("text", x = 1988.4, y = 145, label = "Prop 99",
           color = rm_gold, fontface = "bold", hjust = 0, size = 4.4) +
  annotate("text", x = 2000.2, y = ca_actual[length(ca_actual)],
           label = "California", color = rm_red, hjust = 0, fontface = "bold", size = 4.2) +
  annotate("text", x = 2000.2, y = ca_synth[length(ca_synth)],
           label = "Synthetic\nCalifornia", color = rm_blue, hjust = 0,
           fontface = "bold", size = 4.0, lineheight = 0.9) +
  scale_color_manual(values = c("California" = rm_red,
                                "Synthetic California" = rm_blue),
                     guide = "none") +
  scale_x_continuous(breaks = seq(1970, 2000, 5), limits = c(1970, 2003)) +
  scale_y_continuous(limits = c(30, 150)) +
  labs(title = "California vs. its synthetic twin",
       subtitle = "Per-capita cigarette sales (packs), 1970-2000",
       x = NULL, y = "Packs per person per year",
       caption = "Source: Abadie, Diamond, Hainmueller (2010, JASA)") +
  theme_merengue()
ggsave(file.path(FIGS, "synth_california.pdf"), fig_trend,
       width = 9, height = 5.2, device = cairo_pdf)

## ---------- FIGURE 2: Gap plot ---------------------------------------
fig_gap <- ggplot(gap_table, aes(x = year, y = gap)) +
  geom_hline(yintercept = 0, color = rm_navy, linewidth = 0.4) +
  geom_vline(xintercept = 1988, linetype = "dashed", color = rm_gold, linewidth = 0.8) +
  geom_line(color = rm_red, linewidth = 1.1) +
  geom_point(color = rm_red, size = 1.7) +
  annotate("text", x = 1988.5, y = 5, label = "Prop 99",
           color = rm_gold, fontface = "bold", hjust = 0, size = 4.2) +
  annotate("text", x = 2000, y = gap_table$gap[gap_table$year==2000],
           label = paste0(round(gap_table$gap[gap_table$year==2000],1)," packs"),
           color = rm_red, fontface = "bold", vjust = 1.6, hjust = 1, size = 4) +
  scale_x_continuous(breaks = seq(1970, 2000, 5)) +
  labs(title = "Treatment effect: gap between California and its synthetic twin",
       subtitle = "Per-capita cigarette sales, 1970-2000",
       x = NULL, y = "Gap (packs per person)") +
  theme_merengue()
ggsave(file.path(FIGS, "synth_gap.pdf"), fig_gap,
       width = 9, height = 4.6, device = cairo_pdf)

## ---------- FIGURE 3: Donor weights bar chart ------------------------
top_donors <- donors_df %>% head(8)
fig_donors <- ggplot(top_donors, aes(x = reorder(state, weight), y = weight)) +
  geom_col(fill = rm_blue, width = 0.66) +
  geom_text(aes(label = sprintf("%.0f%%", 100*weight)),
            hjust = -0.18, color = rm_navy, fontface = "bold", size = 4.0) +
  coord_flip() +
  scale_y_continuous(limits = c(0, max(top_donors$weight)*1.20),
                     labels = scales::percent_format(accuracy = 1)) +
  labs(title = "Who makes up synthetic California?",
       subtitle = "Optimal donor weights (states with weight > 0)",
       x = NULL, y = "Weight in synthetic California") +
  theme_merengue() +
  theme(panel.grid.major.y = element_blank())
ggsave(file.path(FIGS, "synth_weights.pdf"), fig_donors,
       width = 8, height = 4.6, device = cairo_pdf)

## ---------- FIGURE 4: in-space placebos ------------------------------
cat("\n[4] Running in-space placebos (this can take ~1 min)...\n")
placebo_gaps <- list()
for (s in setdiff(1:39, 3)) {
  prep_p <- tryCatch(dataprep(
    foo = d,
    predictors = c("lnincome","beer","age15to24","retprice"),
    predictors.op = "mean",
    time.predictors.prior = 1980:1988,
    special.predictors = list(
      list("cigsale", 1975, "mean"),
      list("cigsale", 1980, "mean"),
      list("cigsale", 1988, "mean")
    ),
    dependent = "cigsale",
    unit.variable = "state",
    unit.names.variable = "state_name",
    time.variable = "year",
    treatment.identifier = s,
    controls.identifier = setdiff(1:39, s),
    time.optimize.ssr = 1970:1988,
    time.plot = 1970:2000
  ), error = function(e) NULL)
  if (is.null(prep_p)) next
  syn_p <- tryCatch(synth(prep_p, verbose = FALSE, quadopt = "ipop"),
                    error = function(e) NULL)
  if (is.null(syn_p)) next
  gap_s <- as.numeric(prep_p$Y1plot) -
           as.numeric(prep_p$Y0plot %*% syn_p$solution.w)
  pre_rmspe <- sqrt(mean(gap_s[years<=1988]^2))
  placebo_gaps[[as.character(s)]] <- list(state = state_lookup[as.character(s)],
                                          gap = gap_s,
                                          pre_rmspe = pre_rmspe)
}

placebo_long <- do.call(rbind, lapply(names(placebo_gaps), function(k) {
  x <- placebo_gaps[[k]]
  data.frame(state = x$state, year = years, gap = x$gap, pre_rmspe = x$pre_rmspe)
}))
ca_gap_long <- data.frame(state = "California", year = years,
                          gap = ca_actual - ca_synth,
                          pre_rmspe = sqrt(mean((ca_actual[years<=1988] - ca_synth[years<=1988])^2)))

ca_pre_rmspe <- ca_gap_long$pre_rmspe[1]
keep <- placebo_long$pre_rmspe <= 5 * ca_pre_rmspe   # ADH 2010 trimming
placebo_kept <- placebo_long[keep, ]
cat(sprintf("Kept %d of %d placebos (pre-RMSPE <= 5x CA = %.2f)\n",
            length(unique(placebo_kept$state)),
            length(unique(placebo_long$state)),
            ca_pre_rmspe * 5))

fig_placebo <- ggplot() +
  geom_hline(yintercept = 0, color = rm_navy, linewidth = 0.3) +
  geom_vline(xintercept = 1988, linetype = "dashed", color = rm_gold, linewidth = 0.7) +
  geom_line(data = placebo_kept,
            aes(x = year, y = gap, group = state),
            color = "#9CA3AF", alpha = 0.55, linewidth = 0.4) +
  geom_line(data = ca_gap_long, aes(x = year, y = gap),
            color = rm_red, linewidth = 1.5) +
  annotate("text", x = 2000.2, y = ca_gap_long$gap[ca_gap_long$year==2000],
           label = "California", color = rm_red, fontface = "bold", hjust = 0, size = 4) +
  scale_x_continuous(breaks = seq(1970, 2000, 5), limits = c(1970, 2003)) +
  scale_y_continuous(limits = c(-50, 35)) +
  labs(title = "In-space placebos: California stands alone",
       subtitle = "Gap (state - synthetic state) for each donor state",
       x = NULL, y = "Gap (packs per person)",
       caption = "Donor states with pre-1988 RMSPE > 5x California's are dropped (ADH 2010 trim).") +
  theme_merengue()
ggsave(file.path(FIGS, "synth_placebos.pdf"), fig_placebo,
       width = 9, height = 5.2, device = cairo_pdf)

## ---------- TABLE: pre-1988 predictor balance ------------------------
ca_pre <- d %>% filter(state == 3, year >= 1980, year <= 1988) %>%
  summarise(lnincome=mean(lnincome, na.rm=TRUE), beer=mean(beer, na.rm=TRUE),
            age15to24=mean(age15to24), retprice=mean(retprice))
synth_pre <- d %>% filter(state != 3, year >= 1980, year <= 1988) %>%
  group_by(state) %>%
  summarise(lnincome=mean(lnincome, na.rm=TRUE), beer=mean(beer, na.rm=TRUE),
            age15to24=mean(age15to24), retprice=mean(retprice)) %>%
  left_join(data.frame(state = as.numeric(rownames(w)),
                       w = as.numeric(w)), by = "state") %>%
  summarise(lnincome  = sum(w * lnincome,  na.rm = TRUE),
            beer      = sum(w * beer,      na.rm = TRUE),
            age15to24 = sum(w * age15to24),
            retprice  = sum(w * retprice))
us_avg <- d %>% filter(state != 3, year >= 1980, year <= 1988) %>%
  summarise(lnincome=mean(lnincome, na.rm=TRUE), beer=mean(beer, na.rm=TRUE),
            age15to24=mean(age15to24), retprice=mean(retprice))

bal_tab <- tibble(
  Predictor = c("Log GDP per capita", "Beer consumption (gal)",
                "Share aged 15-24", "Retail cigarette price"),
  California        = round(c(ca_pre$lnincome, ca_pre$beer,
                              ca_pre$age15to24, ca_pre$retprice), 2),
  `Synthetic CA`    = round(c(synth_pre$lnincome, synth_pre$beer,
                              synth_pre$age15to24, synth_pre$retprice), 2),
  `Avg of 38 donors`= round(c(us_avg$lnincome, us_avg$beer,
                              us_avg$age15to24, us_avg$retprice), 2)
)
tex_bal <- kbl(bal_tab, format = "latex", booktabs = TRUE, escape = FALSE,
               align = "lrrr", linesep = "") %>%
  row_spec(0, bold = TRUE) %>% as.character()
writeLines(tex_bal, file.path(TABS, "tab_synth_balance.tex"))

## Save numerical results
saveRDS(list(
  ca_actual = ca_actual, ca_synth = ca_synth, years = years,
  gap = ca_actual - ca_synth, donors_df = donors_df,
  pre_rmspe = ca_pre_rmspe
), file.path(DATA, "synth_results.rds"))

cat("\nDone. All figures in", FIGS, "\n")
