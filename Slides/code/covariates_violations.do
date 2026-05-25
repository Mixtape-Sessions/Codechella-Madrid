********************************************************************************
* name: covariates_violations.do
* purpose: Demonstrate Bias_HTE, Bias_dX, Bias_FE jointly. Run six estimators
*          on 1000 Monte Carlo replications and plot the bias distribution
*          for each.
*
* DGP (per Scott's covariates.do, with heterogeneous tau added):
*   - 40 states, 25 workers each (N = 1000), 2 periods (1990, 1991)
*   - age ~ N(35, 10), gpa ~ N(2.0, 0.5), centered to mean 0
*   - Selection on X: P(treat) increases with age>0 and gpa>0
*       -> treated have higher mean age and higher mean gpa (imbalance)
*   - Y(0):
*       year 1990:  unit_fe          + 100*age + 1000*gpa + e
*       year 1991:  unit_fe + 1000   + 200*age + 2000*gpa + e
*       -> beta on age and gpa CHANGES from 1990 to 1991 (Bias_dX trigger
*          when combined with imbalance)
*   - Y(1) = Y(0) + tau(X) where tau depends on age and gpa:
*       year 1991:  tau = 1000 + 50*age + 500*gpa  (Bias_HTE trigger)
*   - earnings = treat*post*y1 + (1 - treat*post)*y0
*
* Estimators:
*   1. Naive DiD          (no covariates)
*   2. Additive-X TWFE    (X added linearly, no interactions)
*   3. Post*X TWFE        (X interacted with post; what L2-F2o slide proposes)
*   4. Saturated TWFE     (D*post*X fully interacted, ATT averaged by hand)
*   5. OR (DRDID)         (regression adjustment a la HIT 1997)
*   6. IPW (DRDID)        (Abadie 2005)
*   7. DR-DiD (DRDID)     (Sant'Anna-Zhao 2020)
*
* True ATT computed from delta = y1 - y0 over treated post-period cells.
********************************************************************************

clear
capture log close
set seed 20200403
set scheme s2color

********************************************************************************
* DGP
********************************************************************************
cap program drop dgp
program define dgp

  * 40 states, 25 workers per state -> N = 1000
  quietly set obs 40
  gen state = _n
  quietly expand 25
  bysort state: gen worker = runiform(0, 5)
  quietly egen id = group(state worker)

  * Covariates: time-invariant baseline characteristics
  gen age = rnormal(35, 10)
  gen gpa = rnormal(2.0, 0.5)

  * Center
  sum age, meanonly
  qui replace age = age - r(mean)
  sum gpa, meanonly
  qui replace gpa = gpa - r(mean)

  gen age_sq = age^2
  gen gpa_sq = gpa^2

  * SELECTION on X: treated tend to have age>0 and gpa>0
  gen propensity = 0.3 + 0.3 * (age > 0) + 0.2 * (gpa > 0)
  gen treat = runiform() < propensity

  * Expand to two periods
  quietly expand 2
  sort id
  bysort id: gen year = _n
  qui replace year = 1990 if year == 1
  qui replace year = 1991 if year == 2
  gen post = (year == 1991)

  * Unit fixed effect (control units start $10,000 higher)
  qui gen unit_fe = 40000 + 10000 * (treat == 0)

  * Y(0) — TIME-VARYING beta on age and gpa
  gen          e = rnormal(0, 1500)
  qui gen     y0 = unit_fe        + 100 * age + 1000 * gpa + e if year == 1990
  qui replace y0 = unit_fe + 1000 + 200 * age + 2000 * gpa + e if year == 1991

  * Y(1) = Y(0) + tau(X) — HETEROGENEOUS tau in X
  *   tau = 1000 + 50*age + 500*gpa in year 1991
  *   tau =    0                    in year 1990
  gen         y1 = y0
  qui replace y1 = y0 + 1000 + 50*age + 500*gpa if year == 1991

  gen delta = y1 - y0
  sum delta if post == 1, meanonly
  gen ate = r(mean)
  sum delta if treat == 1 & post == 1, meanonly
  gen att = r(mean)

  * Observed
  gen         earnings = y0
  qui replace earnings = y1 if post == 1 & treat == 1
end

********************************************************************************
* Single run — show the true ATT and run all estimators once
********************************************************************************
clear
quietly dgp
quietly sum att, meanonly
local true_att = r(mean)
display "True ATT = " %9.0fc `true_att'
display "True ATE = "
sum ate, meanonly
display %9.0fc r(mean)

display _n "===== Estimator: 1. Naive DiD (no covariates) ====="
reg earnings i.post##i.treat, robust
display "Naive DiD bias = " %9.0fc _b[1.post#1.treat] - `true_att'

display _n "===== Estimator: 2. Additive-X TWFE ====="
reg earnings i.post##i.treat age gpa age_sq gpa_sq, robust
display "Additive-X bias = " %9.0fc _b[1.post#1.treat] - `true_att'

display _n "===== Estimator: 3. Post*X TWFE ====="
reg earnings i.post##i.treat i.post#c.age i.post#c.gpa i.post#c.age_sq i.post#c.gpa_sq, robust
display "Post*X bias = " %9.0fc _b[1.post#1.treat] - `true_att'

display _n "===== Estimator: 4a. Saturated TWFE (FD with D x X interactions) ====="
* 2-period TWFE with unit FE is equivalent to first-differences. Then run a
* SATURATED regression of dy on X with full D x X interactions — this is what
* "fully saturated TWFE" means once the unit FE absorbs baseline level gaps.
preserve
  keep id treat earnings age gpa age_sq gpa_sq post
  reshape wide earnings, i(id treat age gpa age_sq gpa_sq) j(post)
  gen dy = earnings1 - earnings0
  reg dy age gpa age_sq gpa_sq i.treat##c.age i.treat##c.gpa i.treat##c.age_sq i.treat##c.gpa_sq
  gen treat_orig = treat
  replace treat = 1
  quietly predict dy_hat_1, xb
  replace treat = 0
  quietly predict dy_hat_0, xb
  replace treat = treat_orig
  drop treat_orig
  gen tau_sat = dy_hat_1 - dy_hat_0
  quietly sum tau_sat if treat == 1
  display "Saturated TWFE (FD) ATT = " %9.0fc r(mean)
  display "Saturated TWFE bias = " %9.0fc r(mean) - `true_att'
restore

display _n "===== Estimator: 4b. OR by hand (FD on controls only, HIT 1997) ====="
* HIT 1997 outcome regression: fit a single X-model on controls, predict for treated.
preserve
  keep id treat earnings age gpa age_sq gpa_sq post
  reshape wide earnings, i(id treat age gpa age_sq gpa_sq) j(post)
  gen dy = earnings1 - earnings0
  reg dy age gpa age_sq gpa_sq if treat == 0
  predict dy_hat
  gen tau_hat = dy - dy_hat if treat == 1
  quietly sum tau_hat
  display "OR by hand (FD) = " %9.0fc r(mean)
  display "OR by hand bias = " %9.0fc r(mean) - `true_att'
restore

display _n "===== Estimators 5-7: DRDID (OR, IPW, DR) ====="
drdid earnings age gpa age_sq gpa_sq, time(year) ivar(id) tr(treat) all

********************************************************************************
* Monte Carlo: 500 reps
********************************************************************************
cap program drop sim
program define sim, rclass
  clear
  quietly dgp
  quietly sum att, meanonly
  local true_att = r(mean)
  return scalar att = `true_att'

  * 1. Naive
  quietly reg earnings i.post##i.treat
  return scalar naive = _b[1.post#1.treat]

  * 2. Additive
  quietly reg earnings i.post##i.treat age gpa age_sq gpa_sq
  return scalar additive = _b[1.post#1.treat]

  * 3. Post*X
  quietly reg earnings i.post##i.treat i.post#c.age i.post#c.gpa i.post#c.age_sq i.post#c.gpa_sq
  return scalar postX = _b[1.post#1.treat]

  * 4a. Saturated TWFE: FD with D x X interactions on full sample, ATT via prediction
  preserve
    quietly keep id treat earnings age gpa age_sq gpa_sq post
    quietly reshape wide earnings, i(id treat age gpa age_sq gpa_sq) j(post)
    quietly gen dy = earnings1 - earnings0
    quietly reg dy age gpa age_sq gpa_sq i.treat##c.age i.treat##c.gpa i.treat##c.age_sq i.treat##c.gpa_sq
    quietly gen treat_orig = treat
    quietly replace treat = 1
    quietly predict dy_hat_1, xb
    quietly replace treat = 0
    quietly predict dy_hat_0, xb
    quietly replace treat = treat_orig
    quietly drop treat_orig
    quietly gen tau_sat = dy_hat_1 - dy_hat_0
    quietly sum tau_sat if treat == 1, meanonly
    return scalar sat_twfe = r(mean)
  restore

  * 4b. OR by hand (FD on controls only, HIT 1997)
  preserve
    quietly keep id treat earnings age gpa age_sq gpa_sq post
    quietly reshape wide earnings, i(id treat age gpa age_sq gpa_sq) j(post)
    quietly gen dy = earnings1 - earnings0
    quietly reg dy age gpa age_sq gpa_sq if treat == 0
    quietly predict dy_hat
    quietly gen tau_hat = dy - dy_hat if treat == 1
    quietly sum tau_hat, meanonly
    return scalar or_by_hand = r(mean)
  restore

  * 5-7. DRDID
  quietly drdid earnings age gpa age_sq gpa_sq, time(year) ivar(id) tr(treat) all
  return scalar dripw = e(b)[1,1]
  return scalar regadj = e(b)[1,3]
  return scalar ipw = e(b)[1,4]
end

simulate att = r(att) naive = r(naive) additive = r(additive) postX = r(postX) ///
         sat_twfe = r(sat_twfe) or_by_hand = r(or_by_hand) ///
         regadj = r(regadj) ipw = r(ipw) dripw = r(dripw), ///
         reps(500): sim

* Bias for each estimator
foreach e in naive additive postX sat_twfe or_by_hand regadj ipw dripw {
  gen `e'_bias = `e' - att
}

display _n "====================================================="
display    " Mean bias (500 reps) across all estimators "
display    "====================================================="
sum *_bias

* Plot
twoway (kdensity naive_bias, lcolor(black) lwidth(thick)) ///
       (kdensity additive_bias, lcolor(navy) lwidth(medthick) lpattern(dash)) ///
       (kdensity postX_bias, lcolor(orange) lwidth(medthick) lpattern(dot)) ///
       (kdensity sat_twfe_bias, lcolor(green) lwidth(medthick) lpattern(longdash)) ///
       (kdensity or_by_hand_bias, lcolor(forest_green) lwidth(medthick) lpattern(longdash_dot)) ///
       (kdensity regadj_bias, lcolor(maroon) lwidth(medthick) lpattern(dash_dot)) ///
       (kdensity ipw_bias, lcolor(purple) lwidth(medthick) lpattern(shortdash)) ///
       (kdensity dripw_bias, lcolor(red) lwidth(thick) lpattern(solid)), ///
       legend(order(1 "Naive DiD" 2 "Additive X" 3 "Post*X" 4 "Saturated TWFE" 5 "OR by hand (FD)" 6 "OR (DRDID)" 7 "IPW (DRDID)" 8 "DR (DRDID)") ///
              cols(2) position(6) ring(0) size(small)) ///
       xtitle("Bias in Estimated ATT") ytitle("Density") ///
       title("Sampling distribution of bias, 500 reps") ///
       xline(0, lcolor(gray) lpattern(dash)) ///
       graphregion(color(white)) bgcolor(white)

graph export covariates_violations.png, as(png) replace

capture log close
exit
