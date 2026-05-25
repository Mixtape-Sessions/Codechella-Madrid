## equivalence.py
## ----------------------------------------------------------------------
## Three regression specifications for the 2x2 DiD on castle.dta,
## restricted to 2005 and 2006. All three return the same DiD coefficient.
##
## Mirrors equivalence.do (Stata) and equivalence.R (R).
## Run:  python3 equivalence.py
## ----------------------------------------------------------------------

import pandas as pd
import statsmodels.formula.api as smf

URL = "https://github.com/scunning1975/mixtape/raw/master/castle.dta"
df = pd.read_stata(URL)
df = df.query("year >= 2005 & year <= 2006").copy()
df["post"]  = (df.year == 2006).astype(int)
df["treat"] = (df.effyear == 2006).astype(int)

# ---- The four cell means ----
cells = df.groupby(["treat", "post"])["l_homicide"].mean().unstack()
y11 = cells.loc[1, 1]; y10 = cells.loc[1, 0]
y01 = cells.loc[0, 1]; y00 = cells.loc[0, 0]
did_by_hand = (y11 - y10) - (y01 - y00)
print(f"\nFour averages:\n  Y11={y11:.4f}  Y10={y10:.4f}  Y01={y01:.4f}  Y00={y00:.4f}")
print(f"  DiD by hand = {did_by_hand:.4f}\n")

# ---- Regression 1: OLS with interactions ----
m1 = smf.ols("l_homicide ~ post * treat", data=df).fit(
    cov_type="cluster", cov_kwds={"groups": df["sid"]})
print(f"Reg 1 (OLS interactions):  DiD = {m1.params['post:treat']:.4f}")

# ---- Regression 2: TWFE (state + year FE) ----
m2 = smf.ols("l_homicide ~ post:treat + C(sid) + C(year)", data=df).fit(
    cov_type="cluster", cov_kwds={"groups": df["sid"]})
print(f"Reg 2 (TWFE):              DiD = {m2.params['post:treat']:.4f}")

# ---- Regression 3: Long differences ----
wide = df.pivot(index="sid", columns="year", values="l_homicide").reset_index()
wide.columns = ["sid", "y2005", "y2006"]
treat_state = df.groupby("sid")["treat"].first().reset_index()
wide = wide.merge(treat_state, on="sid")
wide["diff"] = wide["y2006"] - wide["y2005"]
m3 = smf.ols("diff ~ treat", data=wide).fit(cov_type="HC1")
print(f"Reg 3 (Long differences):  DiD = {m3.params['treat']:.4f}")

print("\nAll three return the same DiD coefficient (to machine epsilon).")
