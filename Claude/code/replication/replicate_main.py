"""replicate_main.py — INDEPENDENT replication of the four headline ATTs.
Uses pandas, statsmodels, numpy. Run: python3 replicate_main.py
"""
import pandas as pd
import numpy as np
import statsmodels.api as sm
from statsmodels.formula.api import ols, glm

NSW_PATH = "/Users/scunning/mixtape/nsw_mixtape.dta"
CPS_PATH = "/Users/scunning/mixtape/nswcps.dta"

nsw = pd.read_stata(NSW_PATH)
cps = pd.read_stata(CPS_PATH)
cps = cps.rename(columns={"treated": "treat", "hispanic": "hisp", "married": "marr"})

# (1) Experimental ATT
exp_att = nsw.loc[nsw.treat == 1, "re78"].mean() - nsw.loc[nsw.treat == 0, "re78"].mean()

# (2) LaLonde OLS
ols_fit = ols("re78 ~ treat + age + educ + black + hisp + marr + nodegree + re74 + re75",
              data=cps).fit()
lalonde_ols = ols_fit.params["treat"]

# (3) HIT local-linear DiD
# NOTE: The deck's figures use the original quadratic-terms PS spec, but
# Python's statsmodels GLM lands at a different local optimum than R's glm()
# on that near-quasi-separated design. This replication uses a leaner spec
# (well-conditioned across all three languages), per the referee2 audit.
from statsmodels.formula.api import logit
ps_formula = "treat ~ age + educ + black + hisp + marr + nodegree + re74 + re75"
ps_fit = logit(ps_formula, data=cps).fit(method="newton", maxiter=200, disp=0)
cps["ps"] = ps_fit.predict(cps)
ps_min = max(cps.loc[cps.treat == 1, "ps"].min(), 0.01)
ps_max = min(cps.loc[cps.treat == 1, "ps"].max(), 0.99)
cs = cps[(cps.ps >= ps_min) & (cps.ps <= ps_max)].copy()
trt = cs[cs.treat == 1].copy(); trt["dy"] = trt.re78 - trt.re75
ctrl = cs[cs.treat == 0].copy(); ctrl["dy"] = ctrl.re78 - ctrl.re75
sd_p = ctrl.ps.std(); iqr_p = ctrl.ps.quantile(0.75) - ctrl.ps.quantile(0.25)
h = 0.9 * min(sd_p, iqr_p/1.34) * (len(ctrl)**(-1/5))

def local_linear_dy(p0):
    k = np.exp(-0.5 * ((ctrl.ps.values - p0)/h)**2) / (h*np.sqrt(2*np.pi))
    if k.sum() < 1e-10:
        return np.nan
    X = np.column_stack([np.ones(len(ctrl)), ctrl.ps.values - p0])
    W = np.diag(k)
    XtWX = X.T @ W @ X
    if np.linalg.det(XtWX) < 1e-12:
        return float(np.average(ctrl.dy.values, weights=k))
    b = np.linalg.solve(XtWX, X.T @ W @ ctrl.dy.values)
    return float(b[0])

trt["dy0"] = trt.ps.apply(local_linear_dy)
hit_att = (trt.dy - trt.dy0).mean()

# (4) Abadie 2005 PS-weighted DiD
cs["dY"] = cs.re78 - cs.re75
p_treat = cs.treat.mean()
w = (cs.treat - cs.ps) / (1 - cs.ps)
abadie_att = (w * cs.dY).mean() / p_treat

print("===== Replication in Python =====")
print(f"  Experimental ATT:   ${exp_att:>10,.0f}")
print(f"  LaLonde OLS:        ${lalonde_ols:>10,.0f}")
print(f"  HIT local-linear:   ${hit_att:>10,.0f}")
print(f"  Abadie 2005:        ${abadie_att:>10,.0f}")
