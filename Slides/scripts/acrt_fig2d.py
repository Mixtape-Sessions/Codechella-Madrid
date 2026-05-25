"""
Regenerate acrt_fig2d.png (slide 33) — fix overlapping ATT(50|a) / ATT(50|b)
labels that collided with the Selection Bias arrow in the original.

Out: figures/dxt/acrt_fig2d.png
"""
import numpy as np
import matplotlib.pyplot as plt
import os

os.chdir("/Users/scunning/the-remix-tour/glasgow/decks")

# Palette — match remix.sty
NAVY = "#2E4057"
OCEAN = "#2B6CB0"
ORANGE = "#E85D04"
GOLD = "#F0A050"
SLATE = "#4A5568"
WARMGRAY = "#718096"
CREAM = "#FAF8F2"

# Concave dose-response curves for two units
d = np.linspace(0, 120, 400)
att_a = 48.0 * (1 - np.exp(-d / 40))   # higher, faster-saturating
att_b = 35.0 * (1 - np.exp(-d / 45))   # lower

# Key points
d50, d100 = 50, 100
ya50 = 48.0 * (1 - np.exp(-d50 / 40))   # ≈ 34.3
ya100 = 48.0 * (1 - np.exp(-d100 / 40)) # ≈ 44.1
yb50 = 35.0 * (1 - np.exp(-d50 / 45))   # ≈ 23.6

fig, ax = plt.subplots(figsize=(7.6, 4.6))
fig.patch.set_facecolor(CREAM)
ax.set_facecolor(CREAM)

# Curves
ax.plot(d, att_a, color=OCEAN, linewidth=2.2, label="ATT(d | a)", zorder=2)
ax.plot(d, att_b, color=ORANGE, linewidth=2.2, label="ATT(d | b)", zorder=2)

# Points
ax.plot(d50, ya50, "x", color=OCEAN, markersize=10, markeredgewidth=2.0, zorder=4)
ax.plot(d100, ya100, "x", color=OCEAN, markersize=10, markeredgewidth=2.0, zorder=4)
ax.plot(d50, yb50, "x", color=ORANGE, markersize=10, markeredgewidth=2.0, zorder=4)

# ACRT arrow (between the two blue points)
ax.annotate("", xy=(d100, ya100), xytext=(d50, ya50),
            arrowprops=dict(arrowstyle="->", color=NAVY, lw=1.6))
ax.text((d50 + d100) / 2, (ya50 + ya100) / 2 + 3.3, "ACRT(a)",
        color=NAVY, fontsize=10.5, fontweight="bold",
        ha="center", va="bottom")

# Selection Bias arrow (vertical between blue & orange at d=50)
ax.annotate("", xy=(d50, yb50 + 0.4), xytext=(d50, ya50 - 0.4),
            arrowprops=dict(arrowstyle="<->", color="#C0392B", lw=1.5,
                            linestyle="--"))
# Selection Bias label — placed to the LEFT, with a connector
ax.text(28, (ya50 + yb50) / 2, "Selection\nBias",
        color="#C0392B", fontsize=10.5, fontweight="bold",
        ha="center", va="center")
ax.annotate("", xy=(d50 - 2, (ya50 + yb50) / 2),
            xytext=(34, (ya50 + yb50) / 2),
            arrowprops=dict(arrowstyle="-", color="#C0392B", lw=0.8))

# ATT(50 | a) label — placed UP-LEFT of the point, into whitespace above the orange curve
ax.annotate("ATT(50 | a)",
            xy=(d50, ya50), xytext=(d50 - 16, ya50 + 5.5),
            color=OCEAN, fontsize=10, fontweight="bold",
            ha="right", va="center",
            arrowprops=dict(arrowstyle="-", color=OCEAN, lw=0.6))

# ATT(50 | b) label — placed BELOW the orange point, well away from the arrow
ax.annotate("ATT(50 | b)",
            xy=(d50, yb50), xytext=(d50 + 14, yb50 - 6.0),
            color=ORANGE, fontsize=10, fontweight="bold",
            ha="left", va="center",
            arrowprops=dict(arrowstyle="-", color=ORANGE, lw=0.6))

# ATT(100 | a) label — placed ABOVE the point (clear whitespace)
ax.annotate("ATT(100 | a)",
            xy=(d100, ya100), xytext=(d100, ya100 + 6),
            color=OCEAN, fontsize=10, fontweight="bold",
            ha="center", va="center",
            arrowprops=dict(arrowstyle="-", color=OCEAN, lw=0.6))

# Title & axes
ax.set_title("ATT for a Given Dose", fontsize=12, color=NAVY, pad=10)
ax.set_xlabel("Aspirin Dosage (mg)", fontsize=11, color=SLATE)
ax.set_ylabel("Reduction in Headache Symptoms", fontsize=11, color=SLATE)
ax.set_xlim(-3, 140)
ax.set_ylim(-2, 55)

# Legend top-left
ax.legend(loc="upper left", frameon=False, fontsize=10)

# Grid
ax.grid(True, linewidth=0.4, color="grey", alpha=0.35)
ax.tick_params(colors=SLATE)
for spine in ax.spines.values():
    spine.set_color(SLATE)
    spine.set_linewidth(0.8)

plt.tight_layout()
plt.savefig("figures/dxt/acrt_fig2d.png", dpi=200, facecolor=CREAM,
            bbox_inches="tight", pad_inches=0.15)
print(f"ya50={ya50:.1f}  ya100={ya100:.1f}  yb50={yb50:.1f}")
print("Wrote figures/dxt/acrt_fig2d.png")
