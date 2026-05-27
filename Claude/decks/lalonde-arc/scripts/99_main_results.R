## 99_main_results.R
## Assemble the four headline ATTs into one master table.
## Output: tables/tab_main_results.tex

setwd("/Users/scunning/Codechella-Madrid/Claude/decks/lalonde-arc")

e <- readRDS("scripts/.nums_experimental.rds")
l <- readRDS("scripts/.nums_lalonde.rds")
h <- readRDS("scripts/.nums_hit.rds")
a <- readRDS("scripts/.nums_abadie.rds")

cat("================ MAIN RESULTS ================\n")
cat(sprintf("Experimental truth:        $%s\n", format(round(e$exp_att), big.mark=",")))
cat(sprintf("LaLonde swap OLS:          $%s  (bias: $%s)\n",
            format(round(l$ols_all_cov), big.mark=","),
            format(round(l$ols_all_cov - e$exp_att), big.mark=",")))
cat(sprintf("Heckman-Ichimura-Todd DiD: $%s  (gap: $%s)\n",
            format(round(h$hit_ll_did), big.mark=","),
            format(round(h$hit_ll_did - e$exp_att), big.mark=",")))
cat(sprintf("Abadie 2005 PS-DiD:        $%s  (gap: $%s)\n",
            format(round(a$abadie_did), big.mark=","),
            format(round(a$abadie_did - e$exp_att), big.mark=",")))
cat("==============================================\n")

tab <- sprintf(
"\\begin{tabular}{lrr}
\\toprule
\\textbf{Method} & \\textbf{ATT} & \\textbf{Gap vs.\\ truth} \\\\
\\midrule
\\textit{LaLonde's swap (the crisis)} & & \\\\
\\quad OLS, all covariates              & \\$%s & \\textcolor{rmburgundy}{\\$%s} \\\\
\\midrule
\\textit{The two roads home (the resolution)} & & \\\\
\\quad Heckman--Ichimura--Todd (1997)    & \\$%s & \\$%s \\\\
\\quad Abadie (2005) PS-weighted DiD     & \\$%s & \\$%s \\\\
\\midrule
\\textit{Experimental benchmark}        & \\textcolor{rmgold}{\\textbf{\\$%s}} & --- \\\\
\\bottomrule
\\end{tabular}",
format(round(l$ols_all_cov), big.mark=","),
format(round(l$ols_all_cov - e$exp_att), big.mark=","),
format(round(h$hit_ll_did), big.mark=","),
format(round(h$hit_ll_did - e$exp_att), big.mark=","),
format(round(a$abadie_did), big.mark=","),
format(round(a$abadie_did - e$exp_att), big.mark=","),
format(round(e$exp_att), big.mark=",")
)
writeLines(tab, "tables/tab_main_results.tex")
cat("Wrote tables/tab_main_results.tex\n")
