## 02_lalonde_swap.R
## The LaLonde (1986) move: drop the experimental controls, paste in CPS,
## re-run naive estimators. Show the bias.
## Output: figures/fig_lalonde_horserace.pdf and tables/tab_lalonde.tex

suppressPackageStartupMessages({
  library(haven); library(dplyr); library(ggplot2); library(scales)
})

setwd("/Users/scunning/Codechella-Madrid/Claude/decks/lalonde-arc")

rm_blue   <- "#00529F"
rm_gold   <- "#FEBE10"
rm_violet <- "#6E2A82"
rm_char   <- "#1A1A1A"
rm_ash    <- "#8E8E8E"
rm_burg   <- "#8B1A1A"

nsw <- read_dta("/Users/scunning/mixtape/nsw_mixtape.dta")
cps <- read_dta("/Users/scunning/mixtape/nswcps.dta")
names(cps)[names(cps)=="treated"] <- "treat"
names(cps)[names(cps)=="hispanic"] <- "hisp"
names(cps)[names(cps)=="married"] <- "marr"

exp_att <- mean(nsw$re78[nsw$treat==1]) - mean(nsw$re78[nsw$treat==0])

## Naive estimators on the swapped sample
raw_diff <- mean(cps$re78[cps$treat==1]) - mean(cps$re78[cps$treat==0])
ols_no_cov  <- coef(lm(re78 ~ treat, data=cps))["treat"]
ols_all_cov <- coef(lm(re78 ~ treat + age + educ + black + hisp + marr + nodegree + re74 + re75,
                       data=cps))["treat"]

cat(sprintf("Experimental ATT (truth):         $%s\n", format(round(exp_att), big.mark=",")))
cat(sprintf("Raw mean diff (NSW treated − CPS): $%s\n", format(round(raw_diff), big.mark=",")))
cat(sprintf("OLS no covariates:                 $%s\n", format(round(ols_no_cov), big.mark=",")))
cat(sprintf("OLS with covariates:               $%s\n", format(round(ols_all_cov), big.mark=",")))

## ---------- Horserace plot ----------
hr <- data.frame(
  method = factor(c("Experimental\n(NSW only)", "Raw mean diff\n(NSW + CPS)",
                    "OLS\nno covariates", "OLS\nall covariates"),
                  levels = c("Experimental\n(NSW only)", "Raw mean diff\n(NSW + CPS)",
                             "OLS\nno covariates", "OLS\nall covariates")),
  estimate = c(exp_att, raw_diff, ols_no_cov, ols_all_cov),
  group = c("Truth", "Crisis", "Crisis", "Crisis")
)

p_hr <- ggplot(hr, aes(x=method, y=estimate, fill=group)) +
  geom_hline(yintercept=0, color=rm_ash, linewidth=0.4) +
  geom_hline(yintercept=exp_att, color=rm_gold, linewidth=0.7, linetype="dashed") +
  geom_col(width=0.6) +
  geom_text(aes(label = paste0("$", format(round(estimate), big.mark=","))),
            vjust = ifelse(hr$estimate >= 0, -0.5, 1.3),
            color = rm_char, size=3.6, fontface="bold") +
  scale_fill_manual(values = c("Truth"=rm_gold, "Crisis"=rm_blue)) +
  scale_y_continuous(labels = label_dollar(), limits=c(-10500, 3500),
                     breaks = seq(-10000, 3000, 2500)) +
  annotate("text", x=2.5, y=exp_att+1100,
           label="dashed line = experimental truth ($1,794)",
           color=rm_blue, fontface="italic", size=3.0) +
  labs(x=NULL, y="ATT estimate",
       title=NULL, subtitle=NULL) +
  theme_minimal(base_size=11) +
  theme(legend.position = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text = element_text(color=rm_char),
        axis.title.y = element_text(color=rm_char))

ggsave("figures/fig_lalonde_horserace.pdf", p_hr, width=7.0, height=4.0)
cat("Wrote figures/fig_lalonde_horserace.pdf\n")

## ---------- LaLonde swap table ----------
bias_raw <- raw_diff - exp_att
bias_ols <- ols_all_cov - exp_att
tab <- sprintf(
"\\begin{tabular}{lrr}
\\toprule
\\textbf{Estimator} & \\textbf{ATT} & \\textbf{Bias vs.\\ truth} \\\\
\\midrule
Experimental (NSW)         & \\textcolor{rmgold}{\\textbf{\\$%s}} & --- \\\\
\\midrule
\\multicolumn{3}{l}{\\textit{LaLonde's swap: replace NSW controls with CPS}} \\\\
Raw mean difference        & \\$%s & \\$%s \\\\
OLS, no covariates         & \\$%s & \\$%s \\\\
OLS, all covariates        & \\$%s & \\$%s \\\\
\\bottomrule
\\end{tabular}",
format(round(exp_att), big.mark=","),
format(round(raw_diff), big.mark=","), format(round(bias_raw), big.mark=","),
format(round(ols_no_cov), big.mark=","), format(round(ols_no_cov - exp_att), big.mark=","),
format(round(ols_all_cov), big.mark=","), format(round(bias_ols), big.mark=",")
)

writeLines(tab, "tables/tab_lalonde.tex")
cat("Wrote tables/tab_lalonde.tex\n")

saveRDS(list(exp_att=exp_att, raw_diff=raw_diff,
             ols_no_cov=ols_no_cov, ols_all_cov=ols_all_cov),
        "scripts/.nums_lalonde.rds")
