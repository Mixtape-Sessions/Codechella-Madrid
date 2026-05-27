* replicate_main.do — INDEPENDENT replication of the four headline ATTs.
* Stata. Run:  stata -b do replicate_main.do

clear all
set more off

local nsw "/Users/scunning/mixtape/nsw_mixtape.dta"
local cps "/Users/scunning/mixtape/nswcps.dta"

* ---------- (1) Experimental ATT ----------
use "`nsw'", clear
qui mean re78, over(treat)
matrix M = e(b)
local exp_att = M[1,2] - M[1,1]
display "Experimental ATT:   $" %10.0fc `exp_att'

* ---------- (2) LaLonde OLS on CPS swap ----------
use "`cps'", clear
rename treated treat
rename hispanic hisp
rename married marr
qui regress re78 treat age educ black hisp marr nodegree re74 re75
local lalonde_ols = _b[treat]
display "LaLonde OLS:        $" %10.0fc `lalonde_ols'

* ---------- (3) HIT-style PSM + DiD on PS-matched pairs ----------
* Leaner PS spec to converge identically across R / Python / Stata.
* (The deck's R figures use the original quadratic spec; cross-language
* divergence on that spec is itself a Smith-Todd specification-dependence
* finding, acknowledged on the deck's "neighborhood, not a point" slide.)
capture drop ps
qui logit treat age educ black hisp marr nodegree re74 re75
predict ps, pr

* Common-support trim
qui sum ps if treat==1, meanonly
local pmin = max(r(min), 0.01)
local pmax = min(r(max), 0.99)
keep if ps >= `pmin' & ps <= `pmax'

* Approximate HIT estimator:
* nearest-neighbor PS match + conditional DiD on dy=re78-re75
* Use psmatch2 if installed; otherwise manual NN match by sort.
gen dy = re78 - re75
preserve
  keep if treat == 1
  gen tid = _n
  tempfile trt
  save `trt'
restore
preserve
  keep if treat == 0
  tempfile ctrl
  save `ctrl'
restore

* Nearest-neighbor match in PS for each treated unit
use `trt', clear
gen dy_ctrl_match = .
forval i = 1/`=_N' {
  local p_i = ps[`i']
  preserve
    use `ctrl', clear
    gen abs_diff = abs(ps - `p_i')
    sort abs_diff
    local matched_dy = dy[1]
  restore
  qui replace dy_ctrl_match = `matched_dy' in `i'
}
qui sum dy
local mean_dy_trt = r(mean)
qui sum dy_ctrl_match
local mean_dy_ctrl = r(mean)
local hit_att = `mean_dy_trt' - `mean_dy_ctrl'
display "HIT PSM+DiD (NN):   $" %10.0fc `hit_att'

* ---------- (4) Abadie 2005 PS-weighted DiD ----------
use "`cps'", clear
rename treated treat
rename hispanic hisp
rename married marr
capture drop ps
qui logit treat age educ black hisp marr nodegree re74 re75
predict ps, pr
keep if ps > 0.01 & ps < 0.99
qui sum treat
local p_treat = r(mean)
gen dY = re78 - re75
gen w = (treat - ps) / (1 - ps)
gen wdY = w * dY
qui sum wdY
local abadie_att = r(mean) / `p_treat'
display "Abadie 2005 PS-DiD: $" %10.0fc `abadie_att'

display _n "===== Stata replication complete ====="
