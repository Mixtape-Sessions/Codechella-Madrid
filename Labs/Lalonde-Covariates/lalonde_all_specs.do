********************************************************************************
* name: lalonde_all_specs.do
* purpose: Run every estimator from the deck on the LaLonde-DW non-experimental
*          panel and compare to the RCT benchmark (~$1,794).
*
* Estimators:
*   Spec 0: Naive TWFE (no covariates)
*   Spec A: Additive X (X enters linearly, time-invariant)
*   Spec B: Post × X
*   Spec C: Fully Saturated TWFE (FD with D × X interactions)
*   OR by hand (HIT 1997): FD regression on controls only, impute
*   OR  (DRDID regadj)
*   IPW (DRDID, Abadie 2005)
*   DR  (DRDID dripw, Sant'Anna-Zhao 2020)
*
* Data: lalonde_nonexp_panel.dta — NSW treated + CPS controls, years 74/75/78.
*       We use years 75 (pre) and 78 (post) for the 2-period DiD.
*       Covariates: time-invariant baseline characteristics.
********************************************************************************

cd "/Users/scunning/Codechella-Madrid/Labs/Lalonde-Covariates"
clear all
capture log close
set more off
log using "lalonde_all_specs.log", replace text

use lalonde_nonexp_panel.dta, clear

* Restrict to 75 (pre) and 78 (post) for a 2-period DiD
keep if year == 75 | year == 78
gen post = (year == 78)

* "treat" in the panel = ever_treated × post; ever_treated is the group indicator
* Sanity check
display _n "===== Sanity check: cell counts ====="
tab ever_treated post

* X set matches Scott's canonical LaLonde spec (has agecube; no re75/u75)
global X "age agesq agecube educ educsq marr nodegree black hisp re74 u74"

display _n "================================================================"
display    "  LaLonde DiD specs — non-experimental panel (NSW + CPS controls)"
display    "  Pre = 1975, Post = 1978.  RCT benchmark ~\$1,794"
display    "================================================================"

********************************************************************************
* Spec 0: Naive TWFE (no covariates)
********************************************************************************
display _n "===== Spec 0: Naive TWFE ====="
reg re i.post##i.ever_treated, robust
local spec0    = _b[1.post#1.ever_treated]
local spec0_se = _se[1.post#1.ever_treated]
display "Spec 0 estimate = " %9.0fc `spec0' " (SE " %6.0fc `spec0_se' ")"

********************************************************************************
* Spec A: Additive X (X enters as linear controls)
********************************************************************************
display _n "===== Spec A: Additive X ====="
reg re i.post##i.ever_treated $X, robust
local specA    = _b[1.post#1.ever_treated]
local specA_se = _se[1.post#1.ever_treated]
display "Spec A estimate = " %9.0fc `specA' " (SE " %6.0fc `specA_se' ")"

********************************************************************************
* Spec B: Post × X  (double-## so X gets both pre and post effects)
********************************************************************************
display _n "===== Spec B: Post × X ====="
reg re i.post##i.ever_treated ///
    i.post##c.age i.post##c.agesq i.post##c.agecube ///
    i.post##c.educ i.post##c.educsq ///
    i.post##i.marr i.post##i.nodegree i.post##i.black i.post##i.hisp ///
    i.post##c.re74 i.post##i.u74, robust
local specB    = _b[1.post#1.ever_treated]
local specB_se = _se[1.post#1.ever_treated]
display "Spec B estimate = " %9.0fc `specB' " (SE " %6.0fc `specB_se' ")"

********************************************************************************
* Spec C: Fully Saturated TWFE (FD with D × X interactions)
* In 2-period panel with unit FE, this is equivalent to first-differencing,
* then regressing dy on X with full D × X interactions and predicting.
********************************************************************************
display _n "===== Spec C: Fully Saturated TWFE (FD) ====="
preserve
  keep id ever_treated re age agesq agecube educ educsq marr nodegree black hisp re74 u74 post
  reshape wide re, i(id) j(post)
  gen dy = re1 - re0

  * Saturated regression on FULL sample with D × X interactions
  reg dy $X ///
      i.ever_treated#c.age i.ever_treated#c.agesq i.ever_treated#c.agecube ///
      i.ever_treated#c.educ i.ever_treated#c.educsq ///
      i.ever_treated#i.marr i.ever_treated#i.nodegree ///
      i.ever_treated#i.black i.ever_treated#i.hisp ///
      i.ever_treated#c.re74 i.ever_treated#i.u74 ///
      i.ever_treated, robust

  * ATT: predict dy under ever_treated=1 minus dy under ever_treated=0
  gen evt_orig = ever_treated
  replace ever_treated = 1
  quietly predict dy_hat_1, xb
  replace ever_treated = 0
  quietly predict dy_hat_0, xb
  replace ever_treated = evt_orig
  drop evt_orig
  gen tau_sat = dy_hat_1 - dy_hat_0
  quietly sum tau_sat if ever_treated == 1
  local specC = r(mean)
  display "Spec C (Saturated TWFE) estimate = " %9.0fc `specC'
restore

********************************************************************************
* OR by hand (HIT 1997): FD on controls, impute counterfactual for treated
* + cross-check with drdid regadjust
********************************************************************************
display _n "===== OR by hand (HIT 1997, FD on controls only) ====="
preserve
  keep id ever_treated re age agesq agecube educ educsq marr nodegree black hisp re74 u74 post
  reshape wide re, i(id) j(post)
  gen dy = re1 - re0
  reg dy $X if ever_treated == 0, robust
  predict dy_hat
  gen delta_hat = dy - dy_hat if ever_treated == 1
  quietly sum delta_hat if ever_treated == 1
  local or_hand = r(mean)
  display "OR by hand estimate = " %9.0fc `or_hand'
restore

display _n "===== OR cross-check: drdid regadjust ====="
capture noisily drdid re $X, time(year) ivar(id) tr(ever_treated) reg
if _rc == 0 {
  matrix Bor = e(b)
  matrix Vor = e(V)
  local or_drdid = Bor[1,1]
  local or_se    = sqrt(Vor[1,1])
  display "drdid regadjust    = " %9.0fc `or_drdid' " (SE " %6.0fc `or_se' ")"
  display "difference         = " %9.0fc `or_hand' - `or_drdid'
}
else {
  display as error "drdid regadjust failed (rc=" _rc ")."
  local or_drdid = .
  local or_se    = .
}

********************************************************************************
* IPW (Abadie 2005) — by hand, + cross-check with drdid ipw
********************************************************************************
display _n "===== IPW by hand (Abadie 2005) ====="
preserve
  keep id ever_treated re age agesq agecube educ educsq marr nodegree black hisp re74 u74 post
  reshape wide re, i(id) j(post)
  gen dy = re1 - re0

  * Step 1: propensity score
  logit ever_treated $X
  predict phat, pr

  * Step 2: Abadie 2005 ATT weights
  quietly sum ever_treated
  local pr_treat = r(mean)
  gen w_ipw = (ever_treated - phat) / (1 - phat) / `pr_treat'
  gen ipw_dy = w_ipw * dy
  quietly sum ipw_dy
  local ipw_byhand = r(mean)
  display "IPW by hand estimate = " %9.0fc `ipw_byhand'

  * Step 3: DR (Sant'Anna-Zhao 2020)
  reg dy $X if ever_treated == 0
  predict dy_hat_dr
  gen dr_t = ever_treated * (dy - dy_hat_dr) / `pr_treat'
  gen dr_c = (1 - ever_treated) * (phat / (1 - phat)) * (dy - dy_hat_dr) / `pr_treat'
  quietly sum dr_t
  local dr_treated = r(mean)
  quietly sum dr_c
  local dr_byhand = `dr_treated' - r(mean)
  display "DR by hand estimate  = " %9.0fc `dr_byhand'
restore

display _n "===== IPW cross-check: drdid ipw ====="
capture noisily drdid re $X, time(year) ivar(id) tr(ever_treated) ipw
if _rc == 0 {
  matrix Bipw = e(b)
  matrix Vipw = e(V)
  local ipw_drdid = Bipw[1,1]
  local ipw_se    = sqrt(Vipw[1,1])
  display "drdid ipw          = " %9.0fc `ipw_drdid' " (SE " %6.0fc `ipw_se' ")"
  display "difference         = " %9.0fc `ipw_byhand' - `ipw_drdid'
}
else {
  display as error "drdid ipw failed (rc=" _rc ")."
  local ipw_drdid = .
  local ipw_se    = .
}

display _n "===== DR cross-check: drdid dripw ====="
capture noisily drdid re $X, time(year) ivar(id) tr(ever_treated) dripw
if _rc == 0 {
  matrix Bdr = e(b)
  matrix Vdr = e(V)
  local dr_drdid = Bdr[1,1]
  local dr_se    = sqrt(Vdr[1,1])
  display "drdid dripw        = " %9.0fc `dr_drdid' " (SE " %6.0fc `dr_se' ")"
  display "difference         = " %9.0fc `dr_byhand' - `dr_drdid'
}
else {
  display as error "drdid dripw failed (rc=" _rc ")."
  local dr_drdid = .
  local dr_se    = .
}

********************************************************************************
* Summary
********************************************************************************
display _n
display "================================================================"
display "             LaLonde — all estimators side-by-side"
display "================================================================"
display "RCT benchmark (target)                ~ \$1,794"
display "Spec 0  Naive TWFE                    = " %9.0fc `spec0'
display "Spec A  Additive X                    = " %9.0fc `specA'
display "Spec B  Post × X                      = " %9.0fc `specB'
display "Spec C  Saturated TWFE (FD)           = " %9.0fc `specC'
display "OR  by hand   (HIT 1997, FD)          = " %9.0fc `or_hand'
display "OR  drdid     (regadjust)             = " %9.0fc `or_drdid'
display "IPW by hand   (Abadie 2005)           = " %9.0fc `ipw_byhand'
display "IPW drdid     (ipw)                   = " %9.0fc `ipw_drdid'
display "DR  by hand   (Sant'Anna-Zhao 2020)   = " %9.0fc `dr_byhand'
display "DR  drdid     (dripw)                 = " %9.0fc `dr_drdid'
display "================================================================"

********************************************************************************
* Forest plot: 7 estimators with 95% CI vs $1,794 RCT benchmark
* (Saturated TWFE uses OR's drdid SE since the point estimates coincide and
*  the by-hand FD-OR has no closed-form SE without a bootstrap.)
********************************************************************************
preserve
clear
set obs 7
gen str40 estimator = ""
gen double att      = .
gen double se       = .
gen byte ord        = .

replace estimator = "Naive TWFE"      in 1
replace att = `spec0'                 in 1
replace se = `spec0_se'               in 1
replace ord = 7                       in 1

replace estimator = "Additive X"      in 2
replace att = `specA'                 in 2
replace se = `specA_se'               in 2
replace ord = 6                       in 2

replace estimator = "Post x X"        in 3
replace att = `specB'                 in 3
replace se = `specB_se'               in 3
replace ord = 5                       in 3

replace estimator = "Saturated TWFE"  in 4
replace att = `specC'                 in 4
replace se = `or_se'                  in 4
replace ord = 4                       in 4

replace estimator = "OR (HIT 1997)"   in 5
replace att = `or_drdid'              in 5
replace se = `or_se'                  in 5
replace ord = 3                       in 5

replace estimator = "IPW (Abadie)"    in 6
replace att = `ipw_drdid'             in 6
replace se = `ipw_se'                 in 6
replace ord = 2                       in 6

replace estimator = "DR (SZ 2020)"    in 7
replace att = `dr_drdid'              in 7
replace se = `dr_se'                  in 7
replace ord = 1                       in 7

gen lower = att - 1.96 * se
gen upper = att + 1.96 * se

list estimator att se lower upper, sep(0) noobs

twoway (rcap upper lower ord, horizontal lcolor(navy) lwidth(medthick)) ///
       (scatter ord att, mcolor(navy) msize(medlarge) msymbol(diamond)), ///
       xline(1794, lcolor(cranberry) lpattern(dash) lwidth(medthick)) ///
       ylabel(7 "Naive TWFE" 6 "Additive X" 5 "Post x X" ///
              4 "Saturated TWFE" 3 "OR (HIT 1997)" 2 "IPW (Abadie)" ///
              1 "DR (SZ 2020)", angle(0) labsize(small) nogrid) ///
       ytitle("") ///
       xtitle("ATT estimate, 95% CI") ///
       title("LaLonde-DW: seven estimators vs the {bf:$1,794} RCT benchmark", size(medium)) ///
       note("Red dashed line = RCT benchmark ($1,794). Saturated TWFE uses OR's drdid SE." ///
            "by-hand and drdid estimates agree to the dollar for OR and IPW.", size(vsmall)) ///
       legend(off) graphregion(color(white)) plotregion(color(white)) bgcolor(white) ///
       xlabel(, format(%9.0fc)) ///
       ysize(4) xsize(7)

graph export lalonde_forest.png, as(png) replace width(1600)
display _n "Forest plot saved to lalonde_forest.png"
restore

capture log close
exit
