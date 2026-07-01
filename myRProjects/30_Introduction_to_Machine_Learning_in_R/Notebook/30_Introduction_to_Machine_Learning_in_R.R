# ============================================================
# 30 - Introduction to Machine Learning in R
# Source: Kaggle notebook by camnugent
# https://www.kaggle.com/code/camnugent/introduction-to-machine-learning-in-r-tutorial
#
# Dataset: California Housing Prices ("housing.csv"), originally
# from chapter 2 of Aurelien Geron's "Hands-On Machine Learning"
# (https://github.com/ageron/handson-ml/tree/master/datasets/housing)
#
# Folder layout for this assignment (mirrors the Kaggle kernel tabs):
#   Notebook/  - this script
#   Input/     - housing.csv (the raw dataset)
#   Output/    - plots + prediction results produced by running this script
#   Logs/      - console output captured from the run
# ============================================================

# ---- Setup: paths + packages ---------------------------------

# Auto-detect this script's location (works whether run via Rscript,
# RStudio's "Run", or VS Code's R extension "Run") and set the working
# directory to the assignment root (one level up from Notebook/), so the
# relative Input/Output/Logs paths below resolve regardless of cwd.
get_script_path <- function() {
  for (frame in rev(sys.frames())) {
    if (!is.null(frame$ofile)) return(normalizePath(frame$ofile))
  }
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_flag <- grep("^--file=", cmd_args, value = TRUE)
  if (length(file_flag) > 0) return(normalizePath(sub("^--file=", "", file_flag[1])))
  NULL
}

script_path <- get_script_path()
if (!is.null(script_path)) {
  setwd(dirname(dirname(script_path))) # Notebook/.. == assignment root
}

input_path  <- "Input/housing.csv"
output_dir  <- "Output"
log_path    <- "Logs/run_log.txt"

# Fallback: if the relative Input/ path still isn't reachable (auto-detect can
# fail depending on how the IDE sources the file), try this project's known
# fixed location before giving up with an actionable error.
if (!file.exists(input_path)) {
  known_root <- "/Users/steven.dane.david/MySolutions/myRProjects/30_Introduction_to_Machine_Learning_in_R"
  if (dir.exists(known_root)) setwd(known_root)
}
if (!file.exists(input_path)) {
  stop(sprintf(
    "Could not find '%s' from working directory '%s'. Set your working ",
    input_path, getwd()
  ), "directory to the assignment root folder (the one containing Input/, ",
     "Output/, and Logs/) and try again, e.g.:\n  setwd(\"",
     "/Users/steven.dane.david/MySolutions/myRProjects/30_Introduction_to_Machine_Learning_in_R\")")
}

dir.create(output_dir, showWarnings = FALSE)
dir.create("Logs", showWarnings = FALSE)

# Capture console output to Logs/run_log.txt (mirrors the Kaggle "Logs" tab)
log_con <- file(log_path, open = "wt")
sink(log_con, split = TRUE)

suppressPackageStartupMessages({
  library(tidyverse)
  library(reshape2)
})

# ---- Step 1. Load in the data ---------------------------------

housing <- read.csv(input_path)

# First thing: head() to make sure the data isn't weird and looks how expected
head(housing)

# Next: summary(), to see if the numbers are numbers and the categoricals are categoricals
summary(housing)

# From the summary we can see a few things we need to do before running algorithms:
# 1. NA's in total_bedrooms need to be addressed (must be given a value)
# 2. Split ocean_proximity (categorical) into binary columns
# 3. Turn total_bedrooms / total_rooms into mean_bedrooms / mean_rooms per household,
#    since these are likely more accurate depictions of the houses in a given group

colnames(housing)

# Take a look at the distribution of each variable
hist_plot <- ggplot(data = melt(housing), mapping = aes(x = value)) +
  geom_histogram(bins = 30) +
  facet_wrap(~variable, scales = "free_x")

print(hist_plot)
ggsave(file.path(output_dir, "variable_histograms.png"), plot = hist_plot,
       width = 10, height = 7)

# Observations from the histograms:
# 1. Some housing blocks skew toward old-age homes.
# 2. median_house_value has a cap causing a spike at the rightmost bin -- there were
#    almost certainly houses worth more than $500,000 even in the 90s.
# 3. Non-tree-based methods will need standardized/scaled inputs, since some variables
#    range 0-10 while others go up to 500,000.
# 4. The price cap needs consideration -- it may be worth excluding capped values later.

# ---- Step 2. Clean the data ------------------------------------

# Impute missing values: fill total_bedrooms NAs with the median (robust to outliers)
housing$total_bedrooms[is.na(housing$total_bedrooms)] <- median(housing$total_bedrooms, na.rm = TRUE)

# Fix the total columns -- turn them into per-household means
housing$mean_bedrooms <- housing$total_bedrooms / housing$households
housing$mean_rooms    <- housing$total_rooms / housing$households

drops <- c("total_bedrooms", "total_rooms")
housing <- housing[, !(names(housing) %in% drops)]

head(housing)

# Turn the ocean_proximity categorical into one-hot boolean columns:
# 1. Get the unique categories
# 2. Build a data frame of zeros, one column per category
# 3. Loop through rows and flip the matching category to 1
# 4. Drop the original categorical column
categories <- unique(housing$ocean_proximity)

cat_housing <- data.frame(ocean_proximity = housing$ocean_proximity)

for (cat in categories) {
  cat_housing[, cat] <- rep(0, times = nrow(cat_housing))
}
head(cat_housing)

for (i in 1:length(cat_housing$ocean_proximity)) {
  cat <- as.character(cat_housing$ocean_proximity[i])
  cat_housing[, cat][i] <- 1
}
head(cat_housing)

cat_columns   <- names(cat_housing)
keep_columns  <- cat_columns[cat_columns != "ocean_proximity"]
cat_housing   <- select(cat_housing, one_of(keep_columns))

tail(cat_housing)

# ---- Scale the numerical variables -----------------------------

# Scale every numeric predictor except median_house_value (the target),
# so no variable dominates due to its raw magnitude.
colnames(housing)

drops         <- c("ocean_proximity", "median_house_value")
housing_num   <- housing[, !(names(housing) %in% drops)]

head(housing_num)

scaled_housing_num <- scale(housing_num)

head(scaled_housing_num)

# ---- Merge the cleaned numerical + categorical data ------------

cleaned_housing <- cbind(cat_housing, scaled_housing_num,
                          median_house_value = housing$median_house_value)

head(cleaned_housing)

# ---- Step 3. Create a test set ----------------------------------

# Hold out 20% of the data to validate models on data never seen during training.
# Never "peek" at the test set during model development -- that introduces bias.
set.seed(1738)

sample <- sample.int(n = nrow(cleaned_housing),
                      size = floor(.8 * nrow(cleaned_housing)),
                      replace = FALSE)
train <- cleaned_housing[sample, ]
test  <- cleaned_housing[-sample, ]

# Sanity checks
head(train)
nrow(train) + nrow(test) == nrow(cleaned_housing)

# ---- Step 4. Test some predictive models -------------------------

# --- Simple linear model with 5-fold cross-validation ---
# K-fold CV: split the training data into 5 folds, hold one out as a mini test set,
# train on the other 4, predict on the held-out fold, and repeat for each fold.
# Averaging the results estimates how well the model generalizes to unseen data.
library(boot)

glm_house <- glm(median_house_value ~ median_income + mean_rooms + population,
                  data = cleaned_housing)
k_fold_cv_error <- cv.glm(cleaned_housing, glm_house, K = 5)

k_fold_cv_error$delta
# delta[1] = raw cross-validation estimate of prediction error
# delta[2] = adjusted cross-validation estimate

glm_cv_rmse <- sqrt(k_fold_cv_error$delta)[1]
glm_cv_rmse # off by roughly $80K+ -- a starting point

names(glm_house)
glm_house$coefficients
# Since inputs were scaled, the coefficient magnitudes are directly comparable --
# median_income has the largest effect on housing price of the three predictors used.

# --- Random forest model ---
library(randomForest)

names(train)

set.seed(1738)
train_y <- train[, "median_house_value"]
train_x <- train[, names(train) != "median_house_value"]

head(train_y)
head(train_x)

rf_model <- randomForest(train_x, y = train_y, ntree = 500, importance = TRUE)

names(rf_model)
rf_model$importance

# %IncMSE: how much prediction error increases when a variable is shuffled --
# higher = more important predictor.
importance_df <- as.data.frame(rf_model$importance)
write.csv(importance_df, file.path(output_dir, "rf_variable_importance.csv"))

png(file.path(output_dir, "rf_variable_importance.png"), width = 800, height = 600)
varImpPlot(rf_model)
dev.off()

# Out-of-bag (OOB) error estimate: each tree is grown on a bootstrap sample, leaving
# ~1/3 of rows out, which lets us estimate test error without a separate holdout set.
oob_prediction <- predict(rf_model)

train_mse  <- mean(as.numeric((oob_prediction - train_y)^2))
oob_rmse   <- sqrt(train_mse)
oob_rmse

# How well does the model predict on the held-out test data?
test_y <- test[, "median_house_value"]
test_x <- test[, names(test) != "median_house_value"]

y_pred    <- predict(rf_model, test_x)
test_mse  <- mean((y_pred - test_y)^2)
test_rmse <- sqrt(test_mse)
test_rmse

# Comparable train (OOB) vs. test RMSE suggests the random forest isn't overfit
# and generalizes reasonably well.

# ---- Save results summary --------------------------------------

results_summary <- c(
  "Model comparison (RMSE, lower is better):",
  sprintf("  Linear model (5-fold CV):  $%s", format(round(glm_cv_rmse, 0), big.mark = ",")),
  sprintf("  Random forest (OOB):       $%s", format(round(oob_rmse, 0), big.mark = ",")),
  sprintf("  Random forest (test set):  $%s", format(round(test_rmse, 0), big.mark = ","))
)
writeLines(results_summary, file.path(output_dir, "results_summary.txt"))

predictions_df <- data.frame(actual = test_y, predicted = y_pred)
write.csv(predictions_df, file.path(output_dir, "test_predictions.csv"), row.names = FALSE)

cat("\n", results_summary, sep = "\n")

# ---- Step 5. Next steps ------------------------------------------

# Possible ways to extend this assignment:
# - Feature engineer from longitude/latitude (e.g. distance to nearest major city)
# - Try gradient boosting (library(gbm)), extreme gradient boosting (library(xgboost)),
#   support vector machines (library(e1071)), or neural networks (library(neuralnet))
# - Tune hyperparameters (e.g. ntree, mtry) via grid search or random search --
#   see the "caret" package for streamlined cross-validated tuning

# Stop logging to Logs/run_log.txt
sink()
close(log_con)
