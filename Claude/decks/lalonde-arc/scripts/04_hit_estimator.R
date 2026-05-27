## 04_hit_estimator.R
## Heckman-Ichimura-Todd (1997) style estimator on Dehejia-Wahba NSW + CPS.
## Three flavors: PSM-only, conditional DiD, local-linear kernel matching.
## Output: figures/fig_hit_road.pdf and tables/tab_hit.tex

suppressPackageStartupMessages({
  library(haven); library(dplyr); library(ggplot2); library(scales); library(MatchIt)
})

setwd("/Users/scunning/Codechella-Madrid/Claude/decks/lalonde-arc")
set.seed(42)

rm_blue   <- "#00529F"
rm_gold   <- "#FEBE10"
rm_violet <- "#6E2A82"
rm_char   <- "#1A1A1A"
rm_ash    <- "#8E8E8E"

cps <- read_dta("/Users/scunning/mixtape/nswcps.dta")
names(cps)[names(cps)=="treated"] <- "treat"
names(cps)[names(cps)=="hispanic"] <- "hisp"
names(cps)[names(cps)=="married"] <- "marr"

exp_att <- 1794  # canonical from script 01

## ---------- Propensity score ----------
ps_mod <- glm(treat ~ age + I(age^2) + educ + I(educ^2) + black + hisp + marr + nodegree +
              re74 + re75 + I(re74^2) + I(re75^2), data=cps, family=binomial)
cps$ps <- predict(ps_mod, type="response")

## Trim to common support [min(treated), max(treated)]
ps_min <- max(min(cps$ps[cps$treat==1]), 0.01)
ps_max <- min(max(cps$ps[cps$treat==1]), 0.99)
cps_cs <- cps %>% filter(ps >= ps_min & ps <= ps_max)

## ---------- (1) PSM only ----------
m1 <- matchit(treat ~ age + educ + black + hisp + marr + nodegree + re74 + re75,
              data=cps_cs, method="nearest", distance="glm", ratio=1, replace=TRUE)
d1 <- match.data(m1)
psm_att <- mean(d1$re78[d1$treat==1]) - sum(d1$re78[d1$treat==0]*d1$weights[d1$treat==0]) /
           sum(d1$weights[d1$treat==0])

## ---------- (2) Conditional DiD on matched pairs ----------
d1$dy <- d1$re78 - d1$re75
hit_did <- mean(d1$dy[d1$treat==1]) - sum(d1$dy[d1$treat==0]*d1$weights[d1$treat==0]) /
           sum(d1$weights[d1$treat==0])

## ---------- (3) Local-linear kernel matching with DiD ----------
## Implement Fan (1992) local linear regression of dy on ps, evaluate at treated PS values
local_linear_at <- function(p0, x, y, h) {
  k <- dnorm((x - p0)/h)
  if (sum(k) < 1e-10) return(NA)
  X <- cbind(1, x - p0)
  W <- diag(k)
  XtWX <- t(X) %*% W %*% X
  if (det(XtWX) < 1e-12) return(weighted.mean(y, k))
  bhat <- solve(XtWX) %*% (t(X) %*% W %*% y)
  as.numeric(bhat[1])
}

ctrl <- subset(cps_cs, treat==0)
trt  <- subset(cps_cs, treat==1)
trt$dy  <- trt$re78  - trt$re75
ctrl$dy <- ctrl$re78 - ctrl$re75

## Silverman's rule on the control propensity scores
h <- 0.9 * min(sd(ctrl$ps), IQR(ctrl$ps)/1.34) * length(ctrl$ps)^(-1/5)
trt$dy0_hat <- sapply(trt$ps, local_linear_at, x=ctrl$ps, y=ctrl$dy, h=h)
hit_ll_did <- mean(trt$dy - trt$dy0_hat, na.rm=TRUE)

cat(sprintf("PSM ATT (no DiD):           $%s\n", format(round(psm_att),  big.mark=",")))
cat(sprintf("PSM + conditional DiD:      $%s\n", format(round(hit_did), big.mark=",")))
cat(sprintf("Local-linear kernel DiD:    $%s\n", format(round(hit_ll_did), big.mark=",")))

## ---------- "Two roads converging" figure ----------
df_road <- data.frame(
  step = factor(c("Naïve OLS\n(LaLonde swap)",
                  "PSM\n(Dehejia-Wahba)",
                  "PSM + DiD\n(HIT 1997)",
                  "Local-linear DiD\n(Fan kernel)",
                  "Experimental\n(NSW truth)"),
                levels = c("Naïve OLS\n(LaLonde swap)",
                           "PSM\n(Dehejia-Wahba)",
                           "PSM + DiD\n(HIT 1997)",
                           "Local-linear DiD\n(Fan kernel)",
                           "Experimental\n(NSW truth)")),
  estimate = c(699, psm_att, hit_did, hit_ll_did, exp_att),
  kind = c("crisis","crack","road","road","truth")
)
df_road$lab <- paste0("$", format(round(df_road$estimate), big.mark=","))

p_road <- ggplot(df_road, aes(x=step, y=estimate, color=kind)) +
  geom_hline(yintercept=exp_att, color=rm_gold, linewidth=0.7, linetype="dashed") +
  geom_segment(aes(xend=step, yend=0), linewidth=1.0) +
  geom_point(size=4) +
  geom_text(aes(label=lab),
            vjust=-1.1, fontface="bold", color=rm_char, size=3.4) +
  scale_color_manual(values=c("crisis"=rm_violet,"crack"=rm_blue,
                              "road"=rm_blue,"truth"=rm_gold)) +
  scale_y_continuous(labels=label_dollar(), limits=c(0,2700)) +
  annotate("text", x=5, y=exp_att+500, label="experimental truth",
           color=rm_blue, fontface="italic", size=3.0, hjust=0.5) +
  labs(x=NULL, y="ATT estimate", title=NULL, subtitle=NULL) +
  theme_minimal(base_size=10) +
  theme(legend.position="none",
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        axis.text.x = element_text(color=rm_char, size=8),
        axis.text.y = element_text(color=rm_char),
        axis.title.y = element_text(color=rm_char))

ggsave("figures/fig_hit_road.pdf", p_road, width=8.4, height=4.0)

cat("Wrote figures/fig_hit_road.pdf\n")

## Table
tab <- sprintf(
"\\begin{tabular}{lr}
\\toprule
\\textbf{Estimator} & \\textbf{ATT} \\\\
\\midrule
PSM, nearest neighbor (NN)        & \\$%s \\\\
PSM + conditional DiD             & \\$%s \\\\
Local-linear kernel + DiD         & \\$%s \\\\
\\midrule
Experimental truth                & \\textcolor{rmgold}{\\textbf{\\$%s}} \\\\
\\bottomrule
\\end{tabular}",
format(round(psm_att), big.mark=","),
format(round(hit_did), big.mark=","),
format(round(hit_ll_did), big.mark=","),
format(round(exp_att), big.mark=",")
)
writeLines(tab, "tables/tab_hit.tex")
cat("Wrote tables/tab_hit.tex\n")

saveRDS(list(psm_att=psm_att, hit_did=hit_did, hit_ll_did=hit_ll_did),
        "scripts/.nums_hit.rds")
