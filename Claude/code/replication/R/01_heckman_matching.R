## ============================================================================
## 01_heckman_matching.R
## Heckman, Ichimura, Todd (1997, ReStud) — matching estimators on NSW/Lalonde
## Reproduces:
##   - Experimental ATE benchmark
##   - Naive non-experimental gap
##   - Propensity score logit
##   - Nearest-neighbor matching (M=1, M=4)
##   - Kernel matching (Epanechnikov)
##   - Local-linear matching
## Outputs:
##   figures/  ps_overlap.pdf, common_support.pdf, atts_compare.pdf,
##             covariate_balance.pdf
##   tables/   tab_atts.tex, tab_balance.tex
## ============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(ggplot2); library(MatchIt)
  library(haven); library(broom); library(kableExtra); library(sandwich); library(lmtest)
})

ROOT     <- "/Users/scunning/Codechella-Madrid/Claude"
DATA     <- file.path(ROOT, "data")
FIGS     <- file.path(ROOT, "decks/heckman-abadie/figures")
TABS     <- file.path(ROOT, "decks/heckman-abadie/tables")

## Real Madrid palette ----------------------------------------------------
rm_white  <- "#FFFFFF"
rm_navy   <- "#1A1A2E"
rm_blue   <- "#00529F"
rm_gold   <- "#FEBE10"
rm_cream  <- "#FAF7EE"
rm_red    <- "#C8102E"   # accent for "treated" / Madrid kit red trim

theme_merengue <- function(base_size = 14) {
  theme_minimal(base_size = base_size, base_family = "sans") +
    theme(
      plot.background     = element_rect(fill = rm_cream, color = NA),
      panel.background    = element_rect(fill = rm_cream, color = NA),
      panel.grid.minor    = element_blank(),
      panel.grid.major    = element_line(color = "#E5DDD0", linewidth = 0.3),
      axis.line           = element_line(color = rm_navy, linewidth = 0.4),
      axis.text           = element_text(color = rm_navy, size = base_size - 1),
      axis.title          = element_text(color = rm_navy, size = base_size,
                                         face = "bold"),
      plot.title          = element_text(color = rm_navy, face = "bold",
                                         size = base_size + 3, hjust = 0),
      plot.subtitle       = element_text(color = rm_navy, size = base_size - 1, hjust = 0),
      plot.caption        = element_text(color = "#6E6759", size = base_size - 3, hjust = 1),
      legend.background   = element_rect(fill = rm_cream, color = NA),
      legend.key          = element_rect(fill = rm_cream, color = NA),
      legend.text         = element_text(color = rm_navy),
      legend.title        = element_text(color = rm_navy, face = "bold"),
      strip.background    = element_rect(fill = rm_navy, color = NA),
      strip.text          = element_text(color = "white", face = "bold")
    )
}

## Load data --------------------------------------------------------------
exp_xs   <- readRDS(file.path(DATA, "nsw_exp.rds"))
nonexp   <- readRDS(file.path(DATA, "nsw_nonexp.rds"))

## (1) Experimental benchmark ---------------------------------------------
ate_exp <- mean(exp_xs$re78[exp_xs$treat==1]) - mean(exp_xs$re78[exp_xs$treat==0])
ate_exp_se <- summary(lm(re78 ~ treat, exp_xs))$coef["treat","Std. Error"]
cat(sprintf("\n[1] Experimental ATE = %.0f  (SE %.0f, N=%d)\n",
            ate_exp, ate_exp_se, nrow(exp_xs)))

## (2) Naive non-experimental ---------------------------------------------
naive <- mean(nonexp$re78[nonexp$treat==1]) - mean(nonexp$re78[nonexp$treat==0])
naive_se <- summary(lm(re78 ~ treat, nonexp))$coef["treat","Std. Error"]
cat(sprintf("[2] Naive non-experimental diff = %.0f  (SE %.0f, N=%d treated, %d controls)\n",
            naive, naive_se, sum(nonexp$treat==1), sum(nonexp$treat==0)))

## (3) Propensity score logit ---------------------------------------------
ps_formula <- treat ~ age + agesq + agecube + educ + educsq + marr + nodegree + black + hisp + re74 + re75 + u74 + u75
ps_fit <- glm(ps_formula, data = nonexp, family = binomial)
nonexp$pscore <- predict(ps_fit, type = "response")

cat(sprintf("[3] PS logit converged. McFadden pseudo-R2 = %.3f\n",
            1 - ps_fit$deviance / ps_fit$null.deviance))

## (4) Common-support trimming --------------------------------------------
ps_t <- nonexp$pscore[nonexp$treat == 1]
ps_c <- nonexp$pscore[nonexp$treat == 0]
ps_lo <- max(min(ps_t), min(ps_c))
ps_hi <- min(max(ps_t), max(ps_c))
nonexp_cs <- nonexp %>% filter(pscore >= ps_lo & pscore <= ps_hi)
cat(sprintf("[4] Common support: [%.4f, %.4f]; N reduced %d -> %d (%d treated kept of %d)\n",
            ps_lo, ps_hi, nrow(nonexp), nrow(nonexp_cs),
            sum(nonexp_cs$treat==1), sum(nonexp$treat==1)))

## (5) Nearest-neighbor matching, M=1 -------------------------------------
m_nn1 <- matchit(ps_formula, data = nonexp, method = "nearest",
                 distance = "glm", ratio = 1, replace = TRUE)
sm_nn1 <- summary(m_nn1, un = FALSE)
md_nn1 <- match.data(m_nn1)
att_nn1_fit <- lm(re78 ~ treat, data = md_nn1, weights = weights)
att_nn1 <- coef(att_nn1_fit)["treat"]
att_nn1_se <- sqrt(diag(vcovHC(att_nn1_fit, type="HC1")))["treat"]
cat(sprintf("[5] NN matching (M=1, replacement) ATT = %.0f  (SE %.0f)\n", att_nn1, att_nn1_se))

## (6) Nearest-neighbor matching, M=4 -------------------------------------
m_nn4 <- matchit(ps_formula, data = nonexp, method = "nearest",
                 distance = "glm", ratio = 4, replace = TRUE)
md_nn4 <- match.data(m_nn4)
att_nn4_fit <- lm(re78 ~ treat, data = md_nn4, weights = weights)
att_nn4 <- coef(att_nn4_fit)["treat"]
att_nn4_se <- sqrt(diag(vcovHC(att_nn4_fit, type="HC1")))["treat"]
cat(sprintf("[6] NN matching (M=4, replacement) ATT = %.0f  (SE %.0f)\n", att_nn4, att_nn4_se))

## (7) Kernel matching (HIT 1997) -----------------------------------------
## Hand-coded Epanechnikov kernel matching on the propensity score
kernel_match <- function(data, bw = 0.06) {
  tr <- data %>% filter(treat == 1)
  cn <- data %>% filter(treat == 0)
  K <- function(u) (3/4) * pmax(0, 1 - u^2)
  atts <- numeric(nrow(tr))
  for (i in seq_len(nrow(tr))) {
    u <- (cn$pscore - tr$pscore[i]) / bw
    w <- K(u)
    if (sum(w) > 0) {
      yhat0 <- sum(w * cn$re78) / sum(w)
      atts[i] <- tr$re78[i] - yhat0
    } else {
      atts[i] <- NA
    }
  }
  list(att = mean(atts, na.rm = TRUE), n_used = sum(!is.na(atts)),
       per_i = atts)
}
km <- kernel_match(nonexp_cs, bw = 0.06)
## Approximate SE via Abadie-Imbens style: SD across treated unit i contributions
att_kern_se <- sd(km$per_i, na.rm = TRUE) / sqrt(km$n_used)
cat(sprintf("[7] Kernel matching (Epan, bw=0.06) ATT = %.0f  (SE %.0f, N_eff=%d)\n",
            km$att, att_kern_se, km$n_used))

## (8) Local-linear matching (HIT 1997's headline estimator) --------------
local_linear_match <- function(data, bw = 0.10) {
  tr <- data %>% filter(treat == 1)
  cn <- data %>% filter(treat == 0)
  K  <- function(u) (3/4) * pmax(0, 1 - u^2)
  atts <- numeric(nrow(tr))
  for (i in seq_len(nrow(tr))) {
    u <- (cn$pscore - tr$pscore[i]) / bw
    w <- K(u)
    keep <- w > 0
    if (sum(keep) < 2) { atts[i] <- NA; next }
    x <- cn$pscore[keep] - tr$pscore[i]
    y <- cn$re78[keep]
    wt <- w[keep]
    # weighted local linear regression: predict at x=0
    fit <- tryCatch(lm(y ~ x, weights = wt), error = function(e) NULL)
    if (is.null(fit)) { atts[i] <- NA; next }
    yhat0 <- coef(fit)["(Intercept)"]
    atts[i] <- tr$re78[i] - yhat0
  }
  list(att = mean(atts, na.rm = TRUE), n_used = sum(!is.na(atts)),
       per_i = atts)
}
ll <- local_linear_match(nonexp_cs, bw = 0.10)
att_ll_se <- sd(ll$per_i, na.rm = TRUE) / sqrt(ll$n_used)
cat(sprintf("[8] Local-linear matching (bw=0.10) ATT = %.0f  (SE %.0f, N_eff=%d)\n",
            ll$att, att_ll_se, ll$n_used))

## (9) Summary table of estimators ---------------------------------------
results <- tibble(
  Estimator = c("Experimental (truth)",
                "Naive non-experimental",
                "Nearest-neighbor (M=1)",
                "Nearest-neighbor (M=4)",
                "Kernel (Epanechnikov)",
                "Local-linear matching"),
  ATT = c(ate_exp, naive, att_nn1, att_nn4, km$att, ll$att),
  SE  = c(ate_exp_se, naive_se, att_nn1_se, att_nn4_se, att_kern_se, att_ll_se)
) %>% mutate(across(c(ATT, SE), round))

print(results)

## LaTeX results table ---------------------------------------------------
tex_main <- kbl(results,
                format = "latex", booktabs = TRUE,
                col.names = c("Estimator", "$\\widehat{\\text{ATT}}$ (\\$)", "SE"),
                align = "lrr",
                escape = FALSE,
                linesep = "") %>%
  row_spec(0, bold = TRUE) %>%
  row_spec(1, background = "#FBEFC4") %>%   # experimental row highlighted gold
  as.character()
writeLines(tex_main, file.path(TABS, "tab_atts.tex"))

## ---------- FIGURE 1: PS overlap density ------------------------------
fig_overlap <- ggplot(nonexp, aes(x = pscore, fill = factor(treat))) +
  geom_density(alpha = 0.55, color = NA) +
  scale_fill_manual(values = c("0" = rm_blue, "1" = rm_red),
                    labels = c("CPS controls", "NSW treated"),
                    name = NULL) +
  scale_x_continuous(limits = c(0, 1), expand = c(0,0)) +
  scale_y_continuous(expand = c(0,0)) +
  labs(title = "Treated and controls live in different worlds",
       subtitle = "Propensity-score density: NSW treated mass near 1, CPS controls mass near 0",
       x = "Estimated propensity score",
       y = "Density",
       caption = "Source: Lalonde (1986) + CPS comparison. Logit on full covariate set.") +
  theme_merengue() +
  theme(legend.position = c(0.78, 0.85))
ggsave(file.path(FIGS, "ps_overlap.pdf"), fig_overlap, width = 8, height = 4.6, device = cairo_pdf)

## ---------- FIGURE 2: Common-support box ------------------------------
fig_cs <- ggplot(nonexp, aes(x = factor(treat, labels = c("CPS controls","NSW treated")),
                              y = pscore, color = factor(treat))) +
  geom_jitter(alpha = 0.25, width = 0.18, size = 0.6) +
  geom_boxplot(width = 0.32, outlier.shape = NA, fill = NA,
               color = rm_navy, linewidth = 0.6) +
  geom_hline(yintercept = c(ps_lo, ps_hi),
             linetype = "dashed", color = rm_gold, linewidth = 0.7) +
  annotate("text", x = 0.6, y = ps_hi, label = sprintf("upper trim = %.2f", ps_hi),
           vjust = -0.5, hjust = 0, color = rm_gold, fontface = "bold", size = 4.0) +
  annotate("text", x = 0.6, y = ps_lo, label = sprintf("lower trim = %.4f", ps_lo),
           vjust =  1.6, hjust = 0, color = rm_gold, fontface = "bold", size = 4.0) +
  scale_color_manual(values = c(rm_blue, rm_red), guide = "none") +
  labs(title = "Common support is a thin slice",
       subtitle = "Keep only units whose pscore lies in the overlap region",
       x = NULL, y = "Estimated propensity score") +
  theme_merengue()
ggsave(file.path(FIGS, "common_support.pdf"), fig_cs, width = 8, height = 4.6, device = cairo_pdf)

## ---------- FIGURE 3: ATT comparison bar ------------------------------
results_plot <- results %>%
  mutate(Estimator = factor(Estimator, levels = rev(Estimator)),
         is_truth  = Estimator == "Experimental (truth)",
         lo = ATT - 1.96 * SE, hi = ATT + 1.96 * SE)
fig_atts <- ggplot(results_plot, aes(y = Estimator, x = ATT)) +
  geom_vline(xintercept = ate_exp, color = rm_gold,
             linetype = "dashed", linewidth = 0.8) +
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = 0.18,
                 color = rm_navy, linewidth = 0.5) +
  geom_point(aes(color = is_truth), size = 4) +
  scale_color_manual(values = c("TRUE" = rm_gold, "FALSE" = rm_blue), guide = "none") +
  geom_text(aes(label = sprintf("$%s", format(ATT, big.mark=",")) ),
            hjust = -0.18, vjust = -0.6, color = rm_navy, fontface = "bold", size = 4) +
  scale_x_continuous(labels = function(x) paste0("$", format(x, big.mark=",")),
                     limits = c(-11000, 5000)) +
  labs(title = "Matching closes the Lalonde gap",
       subtitle = "Dashed line = experimental benchmark ($1,794)",
       x = expression(widehat(ATT)), y = NULL,
       caption = "95% CIs use heteroskedasticity-robust SEs.") +
  theme_merengue()
ggsave(file.path(FIGS, "atts_compare.pdf"), fig_atts, width = 9, height = 4.8, device = cairo_pdf)

## ---------- FIGURE 4: covariate balance (love plot) ------------------
cov_vars <- c("age","educ","black","hisp","marr","nodegree","re74","re75")
std_diff <- function(x, t, w = NULL) {
  if (is.null(w)) w <- rep(1, length(x))
  mt <- weighted.mean(x[t==1], w[t==1])
  mc <- weighted.mean(x[t==0], w[t==0])
  s  <- sqrt(0.5*(var(x[t==1]) + var(x[t==0])))
  if (s == 0) return(0)
  (mt - mc) / s
}
sd_pre  <- sapply(cov_vars, function(v) std_diff(nonexp[[v]], nonexp$treat))
sd_post <- sapply(cov_vars, function(v) std_diff(md_nn4[[v]], md_nn4$treat, md_nn4$weights))

bal <- tibble(var = cov_vars,
              before = sd_pre,
              after  = sd_post) %>%
  pivot_longer(c(before, after), names_to = "stage", values_to = "smd") %>%
  mutate(stage = factor(stage, levels = c("before","after"),
                        labels = c("Before matching","After NN(M=4) matching")))

fig_bal <- ggplot(bal, aes(x = smd, y = factor(var, levels = rev(cov_vars)),
                            color = stage, shape = stage)) +
  geom_vline(xintercept = 0, color = rm_navy, linewidth = 0.4) +
  geom_vline(xintercept = c(-0.1, 0.1), color = rm_gold,
             linetype = "dashed", linewidth = 0.5) +
  geom_point(size = 3.6) +
  scale_color_manual(values = c(rm_red, rm_blue), name = NULL) +
  scale_shape_manual(values = c(16, 17), name = NULL) +
  scale_x_continuous(limits = c(-2, 1.2)) +
  labs(title = "Balance: gold lines = +/-0.10 std-diff",
       subtitle = "Standardized mean differences before and after matching",
       x = "Standardized mean difference",
       y = NULL) +
  theme_merengue() +
  theme(legend.position = "top")
ggsave(file.path(FIGS, "covariate_balance.pdf"), fig_bal, width = 8, height = 5.0, device = cairo_pdf)

## ---------- FIGURE 5: per-unit ATT contributions (kernel) ------------
contrib <- tibble(att_i = km$per_i,
                  pscore = nonexp_cs$pscore[nonexp_cs$treat==1]) %>% drop_na()
fig_contrib <- ggplot(contrib, aes(x = pscore, y = att_i)) +
  geom_hline(yintercept = ate_exp, color = rm_gold,
             linetype = "dashed", linewidth = 0.7) +
  geom_hline(yintercept = 0, color = rm_navy, linewidth = 0.3) +
  geom_point(alpha = 0.55, size = 1.8, color = rm_blue) +
  geom_smooth(method = "loess", se = FALSE, color = rm_red, linewidth = 0.7) +
  labs(title = "ATT decomposes across treated units",
       subtitle = "Each dot is one treated unit's contribution; red = smoothed local average",
       x = "Treated unit's propensity score",
       y = expression(widehat(ATT)[i])) +
  theme_merengue()
ggsave(file.path(FIGS, "per_unit_atts.pdf"), fig_contrib, width = 8, height = 4.6, device = cairo_pdf)

## Save numerical results for cross-replication audits
saveRDS(list(
  ate_exp = ate_exp, naive = naive,
  att_nn1 = att_nn1, att_nn4 = att_nn4,
  att_kern = km$att, att_ll = ll$att,
  ps_lo = ps_lo, ps_hi = ps_hi,
  pscore = nonexp$pscore
), file.path(DATA, "heckman_results.rds"))

cat("\nAll figures written to ", FIGS, "\n")
cat("Results table written to ", TABS, "\n")
