********************************************************************************
* name: check_simulation.do
* purpose: Audit the DGP and estimators in covariates_violations.do.
*          Runs the DGP ONCE (not the Monte Carlo) and prints diagnostics
*          that let us confirm:
*           (a) the DGP produces the imbalance and heterogeneity we claim
*           (b) the true ATT matches the analytical formula
*           (c) the naive bias matches the analytical formula
*           (d) Saturated (FD) and DRDID 'reg' compute the same thing
*           (e) DRDID column ordering is what we assume
********************************************************************************

clear
capture log close
log using check_simulation.log, replace text
set seed 20200403

* Re-define DGP (copy from covariates_violations.do)
cap program drop dgp
program define dgp
  quietly set obs 40
  gen state = _n
  quietly expand 25
  bysort state: gen worker = runiform(0, 5)
  quietly egen id = group(state worker)
  gen age = rnormal(35, 10)
  gen gpa = rnormal(2.0, 0.5)
  sum age, meanonly
  qui replace age = age - r(mean)
  sum gpa, meanonly
  qui replace gpa = gpa - r(mean)
  gen age_sq = age^2
  gen gpa_sq = gpa^2
  gen propensity = 0.3 + 0.3 * (age > 0) + 0.2 * (gpa > 0)
  gen treat = runiform() < propensity
  quietly expand 2
  sort id
  bysort id: gen year = _n
  qui replace year = 1990 if year == 1
  qui replace year = 1991 if year == 2
  gen post = (year == 1991)
  qui gen unit_fe = 40000 + 10000 * (treat == 0)
  gen          e = rnormal(0, 1500)
  qui gen     y0 = unit_fe        + 100 * age + 1000 * gpa + e if year == 1990
  qui replace y0 = unit_fe + 1000 + 200 * age + 2000 * gpa + e if year == 1991
  gen         y1 = y0
  qui replace y1 = y0 + 1000 + 50*age + 500*gpa if year == 1991
  gen delta = y1 - y0
  sum delta if treat == 1 & post == 1, meanonly
  gen att = r(mean)
  gen         earnings = y0
  qui replace earnings = y1 if post == 1 & treat == 1
end

quietly dgp

********************************************************************************
* (a) Sample sizes and imbalance check
********************************************************************************
display _n "===== (a) Sample sizes and imbalance ====="
tab treat if post == 0
display _n "Mean of age and gpa by treatment (should be IMBALANCED):"
tabstat age gpa, by(treat) statistics(mean sd n)

quietly sum age if treat == 1 & post == 0, meanonly
local mean_age_treat = r(mean)
quietly sum age if treat == 0 & post == 0, meanonly
local mean_age_control = r(mean)
quietly sum gpa if treat == 1 & post == 0, meanonly
local mean_gpa_treat = r(mean)
quietly sum gpa if treat == 0 & post == 0, meanonly
local mean_gpa_control = r(mean)

display _n "E[age|D=1] = " %6.3f `mean_age_treat'
display    "E[age|D=0] = " %6.3f `mean_age_control'
display    "Age imbalance (treat - control) = " %6.3f `mean_age_treat' - `mean_age_control'
display _n "E[gpa|D=1] = " %6.3f `mean_gpa_treat'
display    "E[gpa|D=0] = " %6.3f `mean_gpa_control'
display    "GPA imbalance (treat - control) = " %6.3f `mean_gpa_treat' - `mean_gpa_control'

********************************************************************************
* (b) True ATT — does the formula match?
********************************************************************************
display _n "===== (b) True ATT decomposition ====="
quietly sum att, meanonly
local true_att = r(mean)
local predicted_att = 1000 + 50*`mean_age_treat' + 500*`mean_gpa_treat'
display "Empirical True ATT (mean of y1-y0 over treated post)  = " %9.2f `true_att'
display "Formula: 1000 + 50*E[age|D=1] + 500*E[gpa|D=1]        = " %9.2f `predicted_att'
display "                                          difference  = " %9.2f `true_att' - `predicted_att'

********************************************************************************
* (c) Naive DiD bias — does the formula match?
********************************************************************************
display _n "===== (c) Naive DiD bias formula ====="
quietly reg earnings i.post##i.treat
local naive_did = _b[1.post#1.treat]
local naive_bias_actual = `naive_did' - `true_att'
local naive_bias_formula = 100 * (`mean_age_treat' - `mean_age_control') ///
                         + 1000 * (`mean_gpa_treat' - `mean_gpa_control')
display "Empirical Naive DiD                          = " %9.2f `naive_did'
display "Empirical Naive bias (Naive - True ATT)      = " %9.2f `naive_bias_actual'
display "Formula: 100*Delta_age + 1000*Delta_gpa      = " %9.2f `naive_bias_formula'
display "                                  difference = " %9.2f `naive_bias_actual' - `naive_bias_formula'
display _n "(Note: difference is sampling error on the regression vs cell means;"
display    " should be small relative to the bias magnitude.)"

********************************************************************************
* (d) Additive-X must equal Naive (X is time-invariant)
********************************************************************************
display _n "===== (d) Additive-X equals Naive (X time-invariant) ====="
quietly reg earnings i.post##i.treat age gpa age_sq gpa_sq
local additive_did = _b[1.post#1.treat]
display "Naive DiD coefficient    = " %9.6f `naive_did'
display "Additive-X DiD coefficient = " %9.6f `additive_did'
display "Difference               = " %9.6f `naive_did' - `additive_did'
display "(Must be ~0 to machine precision)"

********************************************************************************
* (e) DRDID column indexing — verify by name
********************************************************************************
display _n "===== (e) DRDID column ordering audit ====="
quietly drdid earnings age gpa age_sq gpa_sq, time(year) ivar(id) tr(treat) all
matrix B = e(b)
matrix list B
display _n "Column names in e(b):"
local cnames : colnames B
display "`cnames'"
display _n "Sim uses: e(b)[1,1] -> dripw, e(b)[1,3] -> reg (OR), e(b)[1,4] -> ipw"
display "Actual:"
display "  e(b)[1,1] = " %9.2f B[1,1]
display "  e(b)[1,3] = " %9.2f B[1,3]
display "  e(b)[1,4] = " %9.2f B[1,4]
display _n "Reference (named):"
display "  dripw    = " %9.2f B[1,colnumb(B,"dripw")]
display "  reg      = " %9.2f B[1,colnumb(B,"reg")]
display "  ipw      = " %9.2f B[1,colnumb(B,"ipw")]

********************************************************************************
* (f) Saturated TWFE (FD) vs DRDID reg — should be identical
********************************************************************************
display _n "===== (f) Saturated TWFE (FD) vs DRDID reg ====="
preserve
  keep id treat earnings age gpa age_sq gpa_sq post
  reshape wide earnings, i(id treat age gpa age_sq gpa_sq) j(post)
  gen dy = earnings1 - earnings0
  quietly reg dy age gpa age_sq gpa_sq if treat == 0
  quietly predict dy_hat
  gen tau_hat = dy - dy_hat if treat == 1
  quietly sum tau_hat, meanonly
  local sat_fd = r(mean)
restore
display "Saturated TWFE (FD)                = " %9.4f `sat_fd'
display "DRDID reg                          = " %9.4f B[1,colnumb(B,"reg")]
display "Difference                         = " %9.4f `sat_fd' - B[1,colnumb(B,"reg")]
display _n "(Should be ~0 if both estimators are HIT 1997 outcome regression)"

capture log close
exit
