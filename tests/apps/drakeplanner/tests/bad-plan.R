library(shinytest)
app <- ShinyDriver$new("../")
app$snapshotInit("bad-plan")

app$setInputs(table_rows_current = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10), allowInputNoBinding_ = TRUE)
app$setInputs(table_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14), allowInputNoBinding_ = TRUE)
app$snapshot()
app$setInputs(plan = "# From https://github.com/wlandau/drake-examples/blob/master/mtcars/R/plan.R # nolint

drake_plan(
  small = simulate(48),
  large = simulate(64),
  regression1 = target(
    reg1(data),
    transform = map(data = c(small, large), .tag_out = reg)
  ),
  regression2 = target(
    reg2(data),
    transform = map(data, .tag_out = reg)
  ),
  summ = target(
    suppressWarnings(summary(reg$residuals)),
    transform = map(reg)
  )
  coef = target(
    suppressWarnings(summary(reg))$coefficients,
    transform = map(reg)
  )
)")
app$setInputs(update = "click")
app$snapshot()
