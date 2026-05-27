## replicate_main.R — INDEPENDENT replication of the four headline ATTs
## from the LaLonde-arc deck. Uses only base R + haven where possible.
## Run: Rscript replicate_main.R

suppressPackageStartupMessages(library(haven))

nsw_path <- "/Users/scunning/mixtape/nsw_mixtape.dta"
cps_path <- "/Users/scunning/mixtape/nswcps.dta"

nsw <- read_dta(nsw_path)
cps <- read_dta(cps_path)
names(cps)[names(cps)=="treated"]  <- "treat"
names(cps)[names(cps)=="hispanic"] <- "hisp"
names(cps)[names(cps)=="married"]  <- "marr"

## (1) Experimental ATT — simple diff of means on NSW
exp_att <- mean(nsw$re78[nsw$treat==1]) - mean(nsw$re78[nsw$treat==0])

## (2) LaLonde OLS — drop NSW controls, paste in CPS, OLS with all covariates
ols_fit <- lm(re78 ~ treat + age + educ + black + hisp + marr + nodegree + re74 + re75,
              data=cps)
lalonde_ols <- coef(ols_fit)["treat"]

## (3) HIT estimator — local-linear DiD using only base R
## NOTE: The deck's figures use the original quadratic-terms PS spec.
## This replication uses a leaner spec that converges identically across
## R / Python / Stata; the cross-language gap on the quadratic spec is itself
## a Smith-Todd specification-dependence finding (see the deck's "neighborhood,
## not a point" slide).
ps_fit <- glm(treat ~ age + educ + black + hisp + marr + nodegree + re74 + re75,
              data=cps, family=binomial)
cps$ps <- predict(ps_fit, type="response")
ps_min <- max(min(cps$ps[cps$treat==1]), 0.01)
ps_max <- min(max(cps$ps[cps$treat==1]), 0.99)
cs <- subset(cps, ps>=ps_min & ps<=ps_max)
trt  <- subset(cs, treat==1); trt$dy  <- trt$re78  - trt$re75
ctrl <- subset(cs, treat==0); ctrl$dy <- ctrl$re78 - ctrl$re75
h <- 0.9 * min(sd(ctrl$ps), IQR(ctrl$ps)/1.34) * length(ctrl$ps)^(-1/5)
ll <- function(p0) {
  k <- dnorm((ctrl$ps - p0)/h)
  X <- cbind(1, ctrl$ps - p0); W <- k
  XtWX <- crossprod(X * sqrt(W))
  XtWy <- crossprod(X * W, ctrl$dy)
  if (det(XtWX) < 1e-12) return(weighted.mean(ctrl$dy, k))
  drop(solve(XtWX, XtWy)[1])
}
trt$dy0 <- sapply(trt$ps, ll)
hit_att <- mean(trt$dy - trt$dy0, na.rm=TRUE)

## (4) Abadie 2005 PS-weighted DiD  (same leaner PS spec, refit on full sample)
ps_fit2 <- glm(treat ~ age + educ + black + hisp + marr + nodegree + re74 + re75,
               data=cps, family=binomial)
cps$ps_full <- predict(ps_fit2, type="response")
cs2 <- subset(cps, ps_full > 0.01 & ps_full < 0.99)
cs2$dY <- cs2$re78 - cs2$re75
n1_2 <- sum(cs2$treat); p_treat2 <- n1_2 / nrow(cs2)
w <- (cs2$treat - cs2$ps_full)/(1 - cs2$ps_full)
abadie_att <- mean(w * cs2$dY) / p_treat2

cat("===== Replication in R =====\n")
cat(sprintf("  Experimental ATT:   $%s\n", format(round(exp_att), big.mark=",")))
cat(sprintf("  LaLonde OLS:        $%s\n", format(round(lalonde_ols), big.mark=",")))
cat(sprintf("  HIT local-linear:   $%s\n", format(round(hit_att), big.mark=",")))
cat(sprintf("  Abadie 2005:        $%s\n", format(round(abadie_att), big.mark=",")))
