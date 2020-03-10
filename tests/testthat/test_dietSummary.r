context("Evaluating dietSummary() calcuations")

suppressWarnings(library(dplyr))

data(testdb)

bluebird_items_any = dietSummary("Bluebird", by = "Order", season = NULL, dietType = 'Items', db = testdb)

test_that("Calculating mean fraction diet across studies, any season", {
  expect_equal(bluebird_items_any$Frac_Diet, c(.385, .25, .175, .125, .065))
})


bluebird_items_summer = dietSummary("Bluebird", by = "Order", season = 'summer', dietType = 'Items', db = testdb)

test_that("Calculating mean fraction diet across studies, any season", {
  expect_equal(bluebird_items_summer$Frac_Diet, c(.35, .27, .25, .13))
})


bluebird_items_any_family = dietSummary("Bluebird", by = "Family", season = NULL, dietType = 'Items', db = testdb)

test_that("Calculating mean fraction diet across studies, any season", {
  expect_equal(bluebird_items_any_family$Frac_Diet, c(.25, .235, .175, .125, .075, .075, .065))
})
