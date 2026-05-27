* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* twfe_reconstruction.do
*
* Demonstrates numerically that the TWFE coefficient is *literally* the
* weighted sum of first differences using CBS-style per-unit level weights
* W_i = (D_i - D_bar) / SS_D, on Kyle's Lu & Yu (2015) WTO sample.
*
* Three steps:
*   (1) Get beta_hat from OLS of  Delta_ln_theil ~ dose
*   (2) Build per-industry weights W_i
*   (3) Verify Sum_i W_i * Delta_ln_theil_i = beta_hat from OLS
*
* Companion script: twfe_reconstruction.R
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd "/Users/scunning/Codechella-Madrid/Labs/China-WTO"
clear all
use "data/industry_by_year.dta", clear

* Kyle's dose pipeline: 2x2 panel of 2001 and 2004, drop NA on Delta_ln_theil
keep if year == 2001 | year == 2004
bysort sic3: gen ln_theil_2001 = ln_theil if year == 2001
bysort sic3: gen ln_theil_2004 = ln_theil if year == 2004
bysort sic3: gen tariff_2001   = tariff   if year == 2001
foreach v in ln_theil_2001 ln_theil_2004 tariff_2001 {
    bysort sic3: egen tmp = max(`v')
    replace `v' = tmp
    drop tmp
}
gen Delta_ln_theil = ln_theil_2004 - ln_theil_2001
gen dose = max(tariff_2001 - 0.10, 0)
collapse (firstnm) Delta_ln_theil dose, by(sic3)
drop if missing(Delta_ln_theil)

* (1) beta_hat from OLS
reg Delta_ln_theil dose
local beta_ols = _b[dose]

* (2) Per-industry weights  W_i = (D_i - D_bar) / SS_D
egen D_bar = mean(dose)
gen  W_num = dose - D_bar
egen SS_D  = total(W_num^2)
gen  W     = W_num / SS_D

* (3) Reconstruct beta_hat by hand
gen  contrib    = W * Delta_ln_theil
egen beta_man   = total(contrib)
local beta_manual = beta_man[1]

* Diagnostics
egen sum_W   = total(W)
egen sum_WD  = total(W * dose)
local sum_W_val  = sum_W[1]
local sum_WD_val = sum_WD[1]

display _newline ///
    "===================================================================" _n ///
    " TWFE reconstruction on Kyle's WTO sample (Lu & Yu 2015)"           _n ///
    "===================================================================" _n ///
    " N industries                              = " _N                   _n ///
    " (1) beta_hat from OLS:                    = " %9.6f `beta_ols'     _n ///
    " (2) Sum_i  W_i * Delta_ln_theil_i:        = " %9.6f `beta_manual'  _n ///
    " |OLS - manual|:                           = " %9.2e abs(`beta_ols' - `beta_manual') _n ///
    _n ///
    " Weight diagnostics:" _n ///
    "   Sum_i W_i        (should be 0):         = " %9.2e `sum_W_val'    _n ///
    "   Sum_i W_i * D_i  (should be 1):         = " %9.6f `sum_WD_val'   _n ///
    "==================================================================="
