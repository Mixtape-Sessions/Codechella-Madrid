## 01_experimental_att.R
## Compute the canonical experimental ATT from Dehejia-Wahba NSW.
## Output: figures/fig_balance.pdf and tables/tab_experimental.tex

suppressPackageStartupMessages({
  library(haven); library(dplyr); library(ggplot2); library(scales)
})

setwd("/Users/scunning/Codechella-Madrid/Claude/decks/lalonde-arc")

nsw <- read_dta("/Users/scunning/mixtape/nsw_mixtape.dta")

## ---------- Real Madrid palette ----------
rm_blue   <- "#00529F"
rm_gold   <- "#FEBE10"
rm_violet <- "#6E2A82"
rm_char   <- "#1A1A1A"
rm_ash    <- "#8E8E8E"

## ---------- Experimental ATT ----------
exp_att <- mean(nsw$re78[nsw$treat==1]) - mean(nsw$re78[nsw$treat==0])
exp_se  <- summary(lm(re78 ~ treat, data=nsw))$coefficients["treat","Std. Error"]

## ---------- Balance check ----------
bal <- nsw %>%
  group_by(treat) %>%
  summarise(across(c(age, educ, black, hisp, marr, nodegree, re74, re75),
                   mean, .names="{.col}")) %>%
  mutate(treat = ifelse(treat==1, "Treated", "Control"))

cat("Experimental ATT (re78):  $", round(exp_att,0), " (SE ", round(exp_se,0), ")\n", sep="")

## ---------- Balance figure: standardized differences ----------
covars <- c("age", "educ", "black", "hisp", "marr", "nodegree", "re74", "re75")
stdiff <- sapply(covars, function(v) {
  mt <- nsw[[v]][nsw$treat==1]; mc <- nsw[[v]][nsw$treat==0]
  sd_pool <- sqrt((var(mt)+var(mc))/2)
  (mean(mt)-mean(mc))/sd_pool
})
df <- data.frame(
  covar = factor(c("Age","Education","Black","Hispanic","Married","No degree","1974 earn.","1975 earn."),
                 levels = c("1975 earn.","1974 earn.","No degree","Married","Hispanic","Black","Education","Age")),
  std_diff = stdiff
)

p_bal <- ggplot(df, aes(x=std_diff, y=covar)) +
  geom_vline(xintercept=0, color=rm_ash, linewidth=0.3) +
  geom_vline(xintercept=c(-0.1, 0.1), linetype="dashed", color=rm_gold, linewidth=0.4) +
  geom_segment(aes(x=0, xend=std_diff, y=covar, yend=covar), color=rm_blue, linewidth=0.8) +
  geom_point(color=rm_blue, size=3) +
  scale_x_continuous(limits=c(-0.25, 0.25), breaks=seq(-0.2,0.2,0.1)) +
  labs(x="Treated − Control, in pooled SD units",
       y=NULL,
       title=NULL,
       subtitle=NULL) +
  theme_minimal(base_size=11) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.text = element_text(color=rm_char),
        axis.title.x = element_text(color=rm_char))

ggsave("figures/fig_balance.pdf", p_bal, width=6.5, height=3.6)
cat("Wrote figures/fig_balance.pdf\n")

## ---------- Experimental table ----------
tab <- sprintf(
"\\begin{tabular}{lrr}
\\toprule
 & \\textbf{Treated} & \\textbf{Control} \\\\
 & ($N=%d$) & ($N=%d$) \\\\
\\midrule
1974 earnings & \\$%s & \\$%s \\\\
1975 earnings & \\$%s & \\$%s \\\\
\\textbf{1978 earnings} & \\textbf{\\$%s} & \\textbf{\\$%s} \\\\
\\midrule
\\multicolumn{3}{l}{\\textbf{Experimental ATT: \\textcolor{rmgold}{\\textbf{\\$%s}}} (SE %s)} \\\\
\\bottomrule
\\end{tabular}",
sum(nsw$treat==1), sum(nsw$treat==0),
format(round(mean(nsw$re74[nsw$treat==1])), big.mark=","), format(round(mean(nsw$re74[nsw$treat==0])), big.mark=","),
format(round(mean(nsw$re75[nsw$treat==1])), big.mark=","), format(round(mean(nsw$re75[nsw$treat==0])), big.mark=","),
format(round(mean(nsw$re78[nsw$treat==1])), big.mark=","), format(round(mean(nsw$re78[nsw$treat==0])), big.mark=","),
format(round(exp_att), big.mark=","), format(round(exp_se), big.mark=",")
)

writeLines(tab, "tables/tab_experimental.tex")
cat("Wrote tables/tab_experimental.tex\n")

## Save key number for downstream scripts
saveRDS(list(exp_att=exp_att, exp_se=exp_se), "scripts/.nums_experimental.rds")
