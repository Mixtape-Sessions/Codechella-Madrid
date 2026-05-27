## 03_pscore_overlap.R
## Propensity-score histograms for NSW-treated vs CPS-controls.
## Echoes HIT 1997 Figure 1: shows that common support is the problem.
## Output: figures/fig_pscore_overlap.pdf

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

ps_mod <- glm(treat ~ age + I(age^2) + educ + I(educ^2) + black + hisp + marr + nodegree +
              re74 + re75 + I(re74^2) + I(re75^2), data=cps, family=binomial)
cps$ps <- predict(ps_mod, type="response")

cat("Treated mean PS: ", round(mean(cps$ps[cps$treat==1]),3), "\n")
cat("Control mean PS: ", round(mean(cps$ps[cps$treat==0]),3), "\n")
cat("Median PS for treated: ", round(median(cps$ps[cps$treat==1]),3), "\n")
cat("Share of controls with PS<0.01: ",
    round(mean(cps$ps[cps$treat==0]<0.01),3), "\n")

df <- cps %>% transmute(treat=factor(treat, levels=c(1,0),
                                     labels=c("NSW treated (n=185)",
                                              "CPS controls (n=15,992)")),
                        ps=ps)

p_hist <- ggplot(df, aes(x=ps, fill=treat, color=treat)) +
  geom_histogram(aes(y = after_stat(density)),
                 position="identity", alpha=0.65, bins=40,
                 boundary=0) +
  scale_fill_manual(values=c("NSW treated (n=185)"=rm_blue,
                             "CPS controls (n=15,992)"=rm_gold)) +
  scale_color_manual(values=c("NSW treated (n=185)"=rm_blue,
                              "CPS controls (n=15,992)"=rm_gold)) +
  scale_x_continuous(limits=c(0,1), breaks=seq(0,1,0.2)) +
  labs(x="Estimated propensity score",
       y="Density",
       title=NULL,
       subtitle=NULL,
       fill=NULL, color=NULL) +
  theme_minimal(base_size=11) +
  theme(legend.position=c(0.7, 0.85),
        legend.background = element_rect(fill=alpha("white",0.85), color=NA),
        panel.grid.minor = element_blank(),
        axis.text = element_text(color=rm_char),
        axis.title = element_text(color=rm_char))

ggsave("figures/fig_pscore_overlap.pdf", p_hist, width=7.0, height=3.8)
cat("Wrote figures/fig_pscore_overlap.pdf\n")
