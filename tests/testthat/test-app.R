context("app")

test_that("drakeplanner()", {
  skip_on_cran()
  skip("stderr is not a pipe errors likely from shinytest")
  shinytest::expect_pass(
    shinytest::testApp("../apps/drakeplanner/", compareImages = FALSE)
  )
})
