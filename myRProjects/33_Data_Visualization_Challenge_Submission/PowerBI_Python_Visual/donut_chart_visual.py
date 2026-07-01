# Power BI Python visual script.
# Paste this into the Python script editor of a Python visual in Power BI Desktop.
#
# Field wells for this visual (Visualizations pane > Values):
#   1. ocean_proximity   (from housing.csv)
#   2. any other column, e.g. median_house_value, with its aggregation set to "Count"
#      (right-click the field in the Values well -> Count)
#
# Power BI auto-generates a pandas DataFrame called `dataset` containing exactly
# the columns you dropped into Values, already grouped/aggregated. With the two
# fields above it will look like:
#   ocean_proximity | Count of median_house_value
#   <1H OCEAN       | 9136
#   INLAND          | 6551
#   NEAR OCEAN      | 2658
#   NEAR BAY        | 2290
#   ISLAND          | 5

import pandas as pd
import matplotlib.pyplot as plt

df = dataset.copy()
df.columns = ["ocean_proximity", "homes"]
df = df.sort_values("homes", ascending=False)

colors = plt.cm.Set2.colors[: len(df)]

fig, ax = plt.subplots(figsize=(7, 7))
wedges, labels, autotexts = ax.pie(
    df["homes"],
    labels=df["ocean_proximity"],
    autopct=lambda pct: f"{pct:.1f}%\n({int(round(pct / 100 * df['homes'].sum())):,})",
    startangle=90,
    colors=colors,
    pctdistance=0.8,
    wedgeprops=dict(width=0.45, edgecolor="white"),
)

ax.set_title("Homes by Ocean Proximity", fontsize=14, fontweight="bold")
plt.setp(autotexts, size=9, weight="bold", color="white")
plt.setp(labels, size=10)
plt.tight_layout()
plt.show()
