## 05_abadie_estimator.R
## Abadie (2005) PS-weighted DiD estimator on Dehejia-Wahba NSW + CPS.
## Output: figures/fig_abadie_road.pdf and tables/tab_abadie.tex

suppressPackageStartupMessages({
  library(haven); library(dplyr); library(ggplot2); library(scales)
})

setwd("/Users/scunning/Codechella-Madrid/Claude/decks/lalonde-arc")

rm_blue   <- "#00529F"
rm_gold   <- "#FEBE10"
rm_violet <- "#6E2A82"
rm_char   <- "#1A1A1A"
rm_ash    <- "#8E8E8E"

cps <- read_dta("/Users/scunning/mixtape/nswcps.dta")
names(cps)[names(cps)=="treated"] <- "treat"
names(cps)[names(cps)=="hispanic"] <- "hisp"
names(cps)[names(cps)=="married"] <- "marr"

exp_att <- 1794

## ---------- Fit propensity score ----------
ps_mod <- glm(treat ~ age + I(age^2) + educ + I(educ^2) + black + hisp + marr + nodegree +
              re74 + re75 + I(re74^2) + I(re75^2), data=cps, family=binomial)
cps$ps <- predict(ps_mod, type="response")

## Trim to overlap [0.01, 0.99]
cps2 <- subset(cps, ps > 0.01 & ps < 0.99)
n1 <- sum(cps2$treat); nT <- nrow(cps2)
p_treat <- n1/nT

## ---------- Abadie (2005) PS-weighted ATT ----------
## ATT = E[ ((Y(1) - Y(0)) / P(D=1)) * ((D - p(X)) / (1 - p(X))) ]
## Applied as a DiD on dY = re78 - re75 (so Y(0) is pre-period level)
cps2$dY <- cps2$re78 - cps2$re75
abadie_w  <- (cps2$treat - cps2$ps) / (1 - cps2$ps)
abadie_did <- mean(abadie_w * cps2$dY) / p_treat

## Levels version (no DiD): use re78 only
abadie_lvl <- mean(abadie_w * cps2$re78) / p_treat

## Compare to Horvitz-Thompson with covariate adjustment in Y₀
## (this is Abadie's eq. 10 for the level-ATT case)
ht <- (cps2$treat / p_treat * cps2$re78) -
      ((1 - cps2$treat) * cps2$ps / ((1 - cps2$ps) * p_treat) * cps2$re78)
abadie_ht <- mean(ht)

cat(sprintf("Abadie 2005 PS-weighted (levels):   $%s\n", format(round(abadie_lvl), big.mark=",")))
cat(sprintf("Abadie 2005 PS-weighted DiD:        $%s\n", format(round(abadie_did), big.mark=",")))
cat(sprintf("Horvitz-Thompson IPW:               $%s\n", format(round(abadie_ht), big.mark=",")))

## ---------- "Second road" figure ----------
df <- data.frame(
  step = factor(c("Naïve OLS\n(swap)", "HT-IPW\n(levels)",
                  "Abadie PS-DiD\n(eq. 10)", "Experimental\n(truth)"),
                levels = c("Naïve OLS\n(swap)", "HT-IPW\n(levels)",
                           "Abadie PS-DiD\n(eq. 10)", "Experimental\n(truth)")),
  estimate = c(699, abadie_ht, abadie_did, exp_att),
  kind = c("crisis","ipw","abadie","truth")
)

p_road <- ggplot(df, aes(x=step, y=estimate, color=kind)) +
  geom_hline(yintercept=exp_att, color=rm_gold, linewidth=0.7, linetype="dashed") +
  geom_segment(aes(xend=step, yend=0), linewidth=1.0) +
  geom_point(size=4) +
  geom_text(aes(label = paste0("$", format(round(estimate), big.mark=","))),
            vjust=-1.1, fontface="bold", color=rm_char, size=3.6) +
  scale_color_manual(values=c("crisis"=rm_violet,"ipw"=rm_blue,
                              "abadie"=rm_blue,"truth"=rm_gold)) +
  scale_y_continuous(labels=label_dollar(), limits=c(0,2700)) +
  annotate("text", x=4, y=exp_att+500, label="experimental truth",
           color=rm_blue, fontface="italic", size=3.0, hjust=0.5) +
  labs(x=NULL, y="ATT estimate", title=NULL, subtitle=NULL) +
  theme_minimal(base_size=11) +
  theme(legend.position="none",
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        axis.text = element_text(color=rm_char),
        axis.title.y = element_text(color=rm_char))

ggsave("figures/fig_abadie_road.pdf", p_road, width=7.0, height=4.0)
cat("Wrote figures/fig_abadie_road.pdf\n")

tab <- sprintf(
"\\begin{tabular}{lr}
\\toprule
\\textbf{Estimator} & \\textbf{ATT} \\\\
\\midrule
Horvitz-Thompson IPW (levels)     & \\$%s \\\\
Abadie 2005 PS-weighted DiD       & \\$%s \\\\
\\midrule
Experimental truth                & \\textcolor{rmgold}{\\textbf{\\$%s}} \\\\
\\bottomrule
\\end{tabular}",
format(round(abadie_ht), big.mark=","),
format(round(abadie_did), big.mark=","),
format(round(exp_att), big.mark=",")
)
writeLines(tab, "tables/tab_abadie.tex")
cat("Wrote tables/tab_abadie.tex\n")

saveRDS(list(abadie_lvl=abadie_lvl, abadie_did=abadie_did, abadie_ht=abadie_ht),
        "scripts/.nums_abadie.rds")
