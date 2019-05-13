app <- ShinyDriver$new("../")
app$snapshotInit("update-functions")

app$setInputs(table_rows_current = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10), allowInputNoBinding_ = TRUE)
app$setInputs(table_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14), allowInputNoBinding_ = TRUE)
app$snapshot()
app$setInputs(functions = "# From https://github.com/wlandau/drake-examples/blob/master/mtcars/R/functions.R # nolint

# Pick a random subset of n rows from a dataset
random_rows <- function(data, n) {
  data[base::sample.int(n = nrow(data), size = n, replace = TRUE), ]
}

# Bootstrapped datasets from mtcars.
simulate <- function(n) {
  # Pick a random set of cars to bootstrap from the mtcars data.
  data <- random_rows(data = mtcars, n = n)

  # x is the car's weight, and y is the fuel efficiency.
  data.frame(
    x = data$wt,
    y = data$mpg
  )
}

# Try a couple different regression models.

# Is fuel efficiency linearly related to weight?
reg1 <- function(d) {
  lm(y ~ + x, data = d)
}

# Is fuel efficiency related to the SQUARE of the weight?
reg2 <- function(d) {
  d$x2 <- d$x ^ 2
  lm(y ~ x2, data = d)
}")
app$setInputs(update = "click")
app$snapshot()
