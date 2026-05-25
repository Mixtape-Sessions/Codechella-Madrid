********************************************************************************
* name: cheng_hoekstra.do
* description: Various Difference-in-Differences Estimators with Cheng and 
* Hoekstra dataset.
********************************************************************************


use "https://github.com/scunning1975/mixtape/raw/master/castle.dta", clear


* Step 1: Write down the target parameter as potential outcomes, population and weights

* Step 2: Make a table of treated units (states by cohort)

preserve
keep if year==2000
replace effyear=0 if effyear==.

* Define labels for treatment cohorts first
label define g_labels 0 "Never treated" ///
                     2005 "2005 cohort" ///
                     2006 "2006 cohort" ///
                     2007 "2007 cohort" ///
                     2008 "2008 cohort" ///
                     2009 "2009 cohort"

* Apply the label to the g variable
label values effyear g_labels

* Close any open file handles first
capture file close tex

* Create a table with counts and percentages
contract effyear, freq(count)

* Total number of treated states (sum of all non-zero cohort counts)
quietly sum count if effyear != 0
local treated_total = r(sum)

* Calculate share of treated states (excluding never-treated)
gen share_treated = .
replace share_treated = count/`treated_total' if effyear != 0

* Get totals
quietly sum count
local total_count : display %9.0fc r(sum)

quietly sum count if effyear != 0
local analysis_treated : display %9.0fc r(sum)

quietly sum count if effyear == 0
local never_treated : display %9.0fc r(sum)

* Create formatted percentage
gen share_pct = share_treated
format share_pct %4.2f

* Export to LaTeX
file open tex using "./castle.tex", write replace
file write tex "\begin{table}[htbp]\centering" _n
file write tex "\footnotesize" _n
file write tex "\caption{Castle doctrine law}" _n
file write tex "\label{tab:municipalitybycohort}" _n
file write tex "\begin{threeparttable}" _n
file write tex "\begin{tabular}{lcc}" _n
file write tex "\toprule" _n
file write tex "\textbf{Castle Doctrine Group} & \textbf{States} & \textbf{Share of Treated States} \\" _n
file write tex "\midrule" _n

* Loop through treatment cohorts (2005-2009)
forvalues cohort = 2005/2009 {
   quietly sum count if effyear == `cohort'
   if r(N) > 0 {
       local count = r(mean)
       quietly sum share_pct if effyear == `cohort'
       local pct = r(mean)
       file write tex "`cohort' cohort & " %9.0fc (`count') " & " %4.2f (`pct') " \\" _n
   }
}

file write tex "\midrule" _n
file write tex "\textbf{Total treated states (analysis sample)} & \textbf{`analysis_treated'} & \textbf{1.00} \\" _n
file write tex "\midrule" _n
file write tex "Never treated (control group) & `never_treated' & -- \\" _n
file write tex "\midrule" _n
file write tex "\textbf{Total} & \textbf{`total_count'} & \textbf{--} \\" _n
file write tex "\bottomrule" _n
file write tex "\end{tabular}" _n
file write tex "\begin{tablenotes}" _n
file write tex "\footnotesize" _n
file write tex "\item This table shows the number of states that reformed castle doctrine laws in each year as well as the share of treated states that each timing cohort makes up." _n
file write tex "\end{tablenotes}" _n
file write tex "\end{threeparttable}" _n
file write tex "\end{table}" _n
file close tex

restore

gen treat=0
replace treat=1 if year>=effyear 
replace treat=0 if effyear==0

* Step 3: Plot the rollout with panelview
panelview l_homicide treat, prepost bytiming i(sid) t(year) type(treat) xtitle("Year") ylabel(none) ytitle("US States")  title("Rollout of Castle Doctrine Reform") legend(position(6) label(1 "Never Treated") label(2 "Treated (Pre)") label(3 "Treated (Post)"))
graph export "./castle_rollout.png", as(png) name("Graph") replace width(2000)


* Step 4: Plot the outcome by cohort

preserve
collapse (mean) l_homicide, by(effyear year)
xtset effyear year

// For homicides - create separate series for background lines
separate l_homicide, by(effyear) gen(yr)

// Create individual homicide rate plots with reference lines
foreach t in 0 2005 2006 2007 2008 2009 {
    if (`t' == 0) {
        local label "Never treated"
        local rline 0
    }
    else {
        local label "`t' cohort"
        local rline `t'
    }

    // Plot background lines in light gray, then highlight the focal cohort
    scatter yr* year, recast(line) lc(gs14 gs14 gs14 gs14 gs14 gs14) ///
        lp(solid solid solid solid solid solid) ///
        lw(thin thin thin thin thin thin) ///
        legend(off) || ///
        line l_homicide year if effyear == `t', ///
        lc(gs6) lp(solid) lw(thick) ///
        xtitle("") subtitle("`label'", size(medsmall)) ///
        name(plot_`t', replace) ///
        xline(`rline', lcolor(black) lpattern(dash) lw(medium)) ///
        xlabel(2000(2)2010, labsize(small)) ///
        xscale(range(2000 2010)) ///
        ylabel(, angle(0) labsize(small) format(%3.1f)) ///
        plotregion(color(white)) graphregion(color(white))
}

// Combine the homicide rate individual plots into a single graph
graph combine plot_0 plot_2005 plot_2006 plot_2007 plot_2008 plot_2009, ///
    title("Average Log Homicide by Treatment Cohort", size(medium)) ///
    ysize(6) xsize(10) ///
    scale(0.9) ///
    plotregion(color(white)) graphregion(color(white))

graph export "./rollout_lhomicide.png", as(png) name("Graph") replace width(2400)
cap n drop yr*

restore

* Step 5: Pick the covariates using outcome regression and propensity score reasoning

* Step 6: Estimate and inspect the propensity score

logit treat age gpa
predict pscore
label variable pscore "Propensity score"
	
twoway (histogram pscore if treat==1,  color(red)) ///
       (histogram pscore if treat==0,  ///
	   fcolor(none) lcolor(black)), legend(order(1 "Treated" 2 "Not treated" ))
	   
* Step 7: Estimate the Callaway and Sant'Anna estimator

* Step 8: Event studies

	   
	   
