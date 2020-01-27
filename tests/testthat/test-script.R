context("script")

test_that("script", {
  input <- list(
    plan = default_text("plan.R"),
    functions = default_text("functions.R")
  )
  lines <- drake_script(input)
  file <- tempfile()
  writeLines(lines, file)
  dir <- tempfile()
  dir.create(dir)
  old <- setwd(dir) # nolint
  on.exit(setwd(old))
  source(file)
  out <- sort(drake::cached())
  exp <- c(
    "coef_regression1_large",
    "coef_regression1_small",
    "coef_regression2_large",
    "coef_regression2_small",
    "large",
    "regression1_large",
    "regression1_small",
    "regression2_large",
    "regression2_small",
    "small",
    "summ_regression1_large",
    "summ_regression1_small",
    "summ_regression2_large",
    "summ_regression2_small"
  )
  exp <- sort(exp)
  expect_identical(out, exp)
})
