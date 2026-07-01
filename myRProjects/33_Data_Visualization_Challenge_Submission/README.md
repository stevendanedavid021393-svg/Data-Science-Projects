# Data Visualization Challenge Submission

**Task:** change how one existing data visualization is presented, using Python or R
inside Power BI Desktop.

**Change made:** the "Homes by Ocean Proximity" bar chart (from the
[Machine Learning with R Challenge](../32_Machine_Learning_with_R_Challenge_Submission))
is re-presented as a **donut chart** with percentage + count labels, using a
Power BI **Python script visual**.

## Status

> Power BI Desktop is Windows-only and wasn't available on the machine this was
> prepared on (macOS, no Windows/VM access at the time). The Python script below was
> written and validated locally (outside Power BI) against a simulated copy of the
> `dataset` DataFrame Power BI passes into a Python visual, using the exact grouping
> Power BI would produce -- see `Output/donut_chart_preview.png` for the verified result.
> The remaining step is purely mechanical: opening Power BI Desktop, pasting the script
> into a Python visual, and exporting the `.pbix` / a screenshot once Windows access is
> available.

## Folder layout

- `Input/` -- `housing.csv`, the raw dataset
- `PowerBI_Python_Visual/donut_chart_visual.py` -- the Python script visual code
- `Output/donut_chart_preview.png` -- local validation render of the exact script/data
  Power BI Desktop would produce

## Steps to finish in Power BI Desktop

1. Install [Power BI Desktop](https://www.microsoft.com/en-us/power-platform/products/power-bi/desktop) (Windows only) and Python (with `pandas` + `matplotlib` installed, e.g. `pip install pandas matplotlib`).
2. In Power BI Desktop: **File > Options and settings > Options > Python scripting** -- set the "Detected Python home directories" to your Python install.
3. **Get Data > Text/CSV** -- load `Input/housing.csv`.
4. From the Visualizations pane, insert a **Python visual**.
5. Drag fields into the visual's **Values** well:
   - `ocean_proximity`
   - any other column (e.g. `median_house_value`) -- click its dropdown in the Values well and set the aggregation to **Count**
6. Paste the contents of `PowerBI_Python_Visual/donut_chart_visual.py` into the Python script editor and click **Run script**.
7. (Original presentation for comparison: a bar chart of the same counts, as built in the ML with R Challenge dashboard.)
8. Save as `.pbix`, then export a screenshot or PDF of the report page for the repo.

## Before / after

| Before | After |
|---|---|
| Bar chart (see `32_Machine_Learning_with_R_Challenge_Submission/Output/housing_dashboard.html`) | Donut chart (see `Output/donut_chart_preview.png`) |
