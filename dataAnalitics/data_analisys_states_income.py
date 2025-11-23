import pandas as pd
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
# %matplotlib inline
sns.set()
from matplotlib.ticker import MultipleLocator

brfss = pd.read_csv('brfss2022.csv')

# basic code

df = brfss.copy()  # must have columns: _STATE and _LLCPWT (the final weight)

# --- Build labels DataFrame from your table (as you did) ---
labels_data = [
    (1, "Alabama", "4,506", 1.01, 1.50),
    (2, "Alaska", "5,865", 1.32, 0.21),
    (4, "Arizona", "10,185", 2.29, 2.18),
    (5, "Arkansas", "5,309", 1.19, 0.89),
    (6, "California", "10,952", 2.46, 11.63),
    (8, "Colorado", "9,365", 2.10, 1.76),
    (9, "Connecticut", "9,784", 2.20, 1.09),
    (10, "Delaware", "3,987", 0.90, 0.30),
    (11, "District of Columbia", "3,237", 0.73, 0.21),
    (12, "Florida", "13,393", 3.01, 6.74),
    (13, "Georgia", "9,236", 2.07, 3.19),
    (15, "Hawaii", "7,747", 1.74, 0.43),
    (16, "Idaho", "6,280", 1.41, 0.56),
    (17, "Illinois", "4,056", 0.91, 3.74),
    (18, "Indiana", "10,466", 2.35, 1.99),
    (19, "Iowa", "8,949", 2.01, 0.94),
    (20, "Kansas", "11,247", 2.53, 0.85),
    (21, "Kentucky", "4,023", 0.90, 1.33),
    (22, "Louisiana", "5,629", 1.26, 1.35),
    (23, "Maine", "10,646", 2.39, 0.43),
    (24, "Maryland", "16,418", 3.69, 1.83),
    (25, "Massachusetts", "11,029", 2.48, 2.14),
    (26, "Michigan", "10,058", 2.26, 3.00),
    (27, "Minnesota", "16,821", 3.78, 1.68),
    (28, "Mississippi", "4,239", 0.95, 0.86),
    (29, "Missouri", "7,438", 1.67, 1.82),
    (30, "Montana", "7,048", 1.58, 0.33),
    (31, "Nebraska", "7,473", 1.68, 0.57),
    (32, "Nevada", "3,188", 0.72, 0.94),
    (33, "New Hampshire", "6,757", 1.52, 0.43),
    (34, "New Jersey", "8,209", 1.84, 2.77),
    (35, "New Mexico", "4,758", 1.07, 0.62),
    (36, "New York", "17,800", 4.00, 5.97),
    (37, "North Carolina", "4,505", 1.01, 3.17),
    (38, "North Dakota", "4,153", 0.93, 0.23),
    (39, "Ohio", "16,487", 3.70, 3.49),
    (40, "Oklahoma", "5,775", 1.30, 1.16),
    (41, "Oregon", "5,756", 1.29, 1.30),
    (42, "Pennsylvania", "4,582", 1.03, 3.91),
    (44, "Rhode Island", "5,893", 1.32, 0.34),
    (45, "South Carolina", "10,037", 2.25, 1.57),
    (46, "South Dakota", "7,424", 1.67, 0.26),
    (47, "Tennessee", "5,266", 1.18, 2.08),
    (48, "Texas", "14,245", 3.20, 8.52),
    (49, "Utah", "9,826", 2.21, 0.93),
    (50, "Vermont", "8,811", 1.98, 0.20),
    (51, "Virginia", "10,417", 2.34, 2.58),
    (53, "Washington", "26,152", 5.88, 2.33),
    (54, "West Virginia", "4,981", 1.12, 0.54),
    (55, "Wisconsin", "11,276", 2.53, 1.76),
    (56, "Wyoming", "4,142", 0.93, 0.17),
    (66, "Guam", "2,266", 0.51, 0.04),
    (72, "Puerto Rico", "5,509", 1.24, 1.11),
    (78, "Virgin Islands", "1,531", 0.34, 0.03),
]
labels_df = pd.DataFrame(
    labels_data,
    columns=["_STATE", "State", "Codebook_Frequency", "Codebook_Percentage", "Codebook_Weighted_Percentage"]
)
labels_df["Codebook_Frequency"] = labels_df["Codebook_Frequency"].str.replace(",", "", regex=False).astype(int)
labels_df["Codebook_Percentage"] = labels_df["Codebook_Percentage"].astype(float)
labels_df["Codebook_Weighted_Percentage"] = labels_df["Codebook_Weighted_Percentage"].astype(float)



# --- State mapping (using your labels_data) ---
state_map = {code: name for code, name, *_ in labels_data}

# --- Prepare data ---
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# ---------- helper: weighted quantile ----------
def weighted_quantile(values, weights, q):
    """
    values, weights are 1D numpy arrays; q in [0,1] or list-like.
    Returns the value(s) at quantile q of the weighted distribution.
    """
    values  = np.asarray(values)
    weights = np.asarray(weights)
    sorter  = np.argsort(values)
    v = values[sorter]
    w = weights[sorter]
    cdf = np.cumsum(w) / np.sum(w)          # weighted CDF in [0,1]
    q = np.atleast_1d(q)
    return np.interp(q, cdf, v)

# ---------- 0) CLEAN INPUT ----------
d = df.copy()
d["_STATE"]   = pd.to_numeric(d["_STATE"], errors="coerce")
d["_INCOMG1"] = pd.to_numeric(d["_INCOMG1"], errors="coerce")  # income bin 1..7
d["_LLCPWT"]  = pd.to_numeric(d["_LLCPWT"],  errors="coerce")  # survey weight
d = d[(d["_LLCPWT"] > 0) & d["_INCOMG1"].between(1, 7)]

# (optional) nice state names if you already have labels_df
code_to_name = dict(zip(labels_df["_STATE"], labels_df["State"]))

# ---------- 1) PER-STATE DISTRIBUTION (BACKTRACKABLE) ----------
# weight mass per (state, bin)
tmp = (d.groupby(["_STATE", "_INCOMG1"], as_index=False)
         .agg(w_sum=("_LLCPWT", "sum")))

# total weight per state
tot = tmp.groupby("_STATE", as_index=False)["w_sum"].sum().rename(columns={"w_sum":"w_tot"})

# proportions and CDF per state (sorted by bin)
dist_df = (tmp.merge(tot, on="_STATE", how="left")
              .assign(prop = lambda x: x["w_sum"]/x["w_tot"])
              .sort_values(["_STATE","_INCOMG1"]))

# cumulative distribution per state (handy for audit)
dist_df["cdf"] = dist_df.groupby("_STATE")["prop"].cumsum()

# attach names (optional)
dist_df["State"] = dist_df["_STATE"].map(code_to_name)

# ---------- 2) SUMMARY (QUARTILES / WHISKERS / MEAN) ----------
def summarize_state(g):
    vals = g["_INCOMG1"].to_numpy()
    wts  = g["prop"].to_numpy()          # proportions sum ~ 1
    q1, med, q3 = weighted_quantile(vals, wts, [0.25, 0.50, 0.75])
    lo, hi     = weighted_quantile(vals, wts, [0.05, 0.95])  # whiskers
    mean_val   = np.sum(vals * wts)      # weighted mean bin
    return pd.Series({
        "q05": lo, "q25": q1, "median": med, "q75": q3, "q95": hi,
        "mean_bin": mean_val
    })

summary_df = (dist_df.groupby("_STATE", as_index=False)
                        .apply(summarize_state)
                        .reset_index(drop=True))
summary_df["State"] = summary_df["_STATE"].map(code_to_name)

# Also keep tails if you like:
tails = (dist_df[dist_df["_INCOMG1"].isin([1,7])]
           .pivot(index="_STATE", columns="_INCOMG1", values="prop")
           .rename(columns={1:"p_lowest", 7:"p_highest"})
           .reset_index()
           .fillna(0.0))
summary_df = summary_df.merge(tails, on="_STATE", how="left")

# ---------- 3) (OPTIONAL) SAVE FOR BACKTRACK ----------
# dist_df = per-state, per-bin mass/prop/CDF (full detail)
# summary_df = per-state quartiles/mean/tails (compact)
# dist_df.to_csv("state_income_distribution.csv", index=False)
# summary_df.to_csv("state_income_summary.csv", index=False)

# ---------- 4) PLOT (bxp wants a list of dicts per state) ----------
# order states by mean bin (poorest -> richest)
summary_df = summary_df.sort_values("mean_bin", ascending=True, ignore_index=True)
summary_df.to_csv("summary_df.csv", index=False)
# build bxp "stats" list
subset_df = pd.concat([
    summary_df.head(7),   # 7 poorest
    summary_df.tail(7)    # 7 richest
], ignore_index=True)

colors = ['#2E86AB'] * 7 + ['#F39C12'] * 7

# Build plain bxp stats (no styling inside items)
boxes_all = []
for _, row in subset_df.iterrows():
    boxes_all.append({
        "label": row["State"] if pd.notna(row["State"]) else str(row["_STATE"]),
        "q1": row["q25"],
        "med": row["median"],
        "q3": row["q75"],
        "whislo": row["q05"],
        "whishi": row["q95"],
        "mean": row["mean_bin"],
        "fliers": []
    })

# Split into poorest (first 7) and richest (last 7)
boxes_poor = boxes_all[:7]
boxes_rich = boxes_all[7:]

# Positions along the vertical axis (since vert=False)
pos_poor = list(range(1, 8))          # 1..7
pos_rich = list(range(8, 15))         # 8..14

# Labels in correct order for y-axis
ylabels = [b["label"] for b in boxes_poor + boxes_rich]
yticks = pos_poor + pos_rich



fig, ax = plt.subplots(figsize=(10, 12))

# 1) draw poorest (blue)
ax.bxp(
    boxes_poor, positions=pos_poor, vert=False, showmeans=True,
    boxprops=dict(color="#2E86AB", linewidth=1.4),
    whiskerprops=dict(color="#2E86AB", linewidth=1.2),
    capprops=dict(color="#2E86AB", linewidth=1.2),
    medianprops=dict(color="black", linewidth=1.4),
    meanprops=dict(marker='o', markerfacecolor="#2E86AB", markeredgecolor='black', markersize=5),
)

# 2) draw richest (orange)
ax.bxp(
    boxes_rich, positions=pos_rich, vert=False, showmeans=True,
    boxprops=dict(color="#F39C12", linewidth=1.4),
    whiskerprops=dict(color="#F39C12", linewidth=1.2),
    capprops=dict(color="#F39C12", linewidth=1.2),
    medianprops=dict(color="black", linewidth=1.4),
    meanprops=dict(marker='o', markerfacecolor="#F39C12", markeredgecolor='black', markersize=5),
)

# Y labels for all 14 boxes
ax.set_yticks(yticks)
ax.set_yticklabels(ylabels)

# Axes titles
ax.set_xlabel("Income bin (1 = poorest … 7 = richest)", fontsize=12, fontweight='bold')
ax.set_ylabel("State (7 poorest • 7 richest)", fontsize=12, fontweight='bold')
ax.set_title("Weighted income distribution — 7 Poorest vs 7 Richest States", fontsize=14, fontweight='bold', pad=12)

# Ticks on both top & bottom; darker grid with 1.0 majors and 0.1 minors
ax.xaxis.set_ticks_position('both')
ax.tick_params(axis='x', labeltop=True, labelbottom=True)

ax.xaxis.set_major_locator(MultipleLocator(1.0))
ax.xaxis.set_minor_locator(MultipleLocator(0.1))
ax.grid(which='major', axis='x', color='black', linestyle='--', linewidth=0.8, alpha=0.7)
ax.grid(which='minor', axis='x', color='gray', linestyle=':', linewidth=0.6, alpha=0.8)

# Optional legend
from matplotlib.lines import Line2D
legend_elems = [
    Line2D([0], [0], color="#2E86AB", lw=2, label="7 Poorest"),
    Line2D([0], [0], color="#F39C12", lw=2, label="7 Richest"),
]
ax.legend(handles=legend_elems, loc="lower right")

plt.tight_layout()
plt.show()
