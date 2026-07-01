# Machine Learning with R Challenge Submission

Dashboard built from the California housing dataset (`housing.csv`), covering:

1. **Homes by Ocean Proximity** — count of homes in each `ocean_proximity` category (`<1H OCEAN`, `INLAND`, `NEAR OCEAN`, `NEAR BAY`, `ISLAND`)
2. **Population vs. Households** — scatter plot with a linear trend line
3. **Total Rooms vs. Total Bedrooms** — scatter plot with a linear trend line

## Folder layout

- `Input/` — `housing.csv`, the raw dataset
- `Notebook/` — `housing_dashboard.Rmd`, the flexdashboard source
- `Output/` — `housing_dashboard.html`, the rendered dashboard

## Viewing the dashboard

Download `Output/housing_dashboard.html` and open it in any browser — it's a self-contained static file with no server required.

To re-render from source:

```r
rmarkdown::render("Notebook/housing_dashboard.Rmd", output_dir = "Output")
```

Requires the `flexdashboard`, `ggplot2`, `dplyr`, and `scales` R packages, plus [Pandoc](https://pandoc.org/).
