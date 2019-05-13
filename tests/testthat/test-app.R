context("app")

test_that("drakeplanner()", {
  skip_on_cran()
  shinytest::expect_pass(
    shinytest::testApp("../apps/drakeplanner/", compareImages = FALSE)
  )
})
