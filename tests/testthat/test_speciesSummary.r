context("Evaluating speciesSummary() calcuations")

suppressWarnings(library(dplyr))
suppressWarnings(library(tidyr))

data(testdb)

bluebird_summary_order = speciesSummary("Bluebird", by = "Order", db = testdb)

test_that("Calculating mean fraction diet across studies, any season", {
  expect_equal(bluebird_summary_order$recordsPerSeason$n, c(10, 15))
  expect_equal(bluebird_summary_order$recordsPerPreyIDLevel$n, c(0, 0, 0, 10, 15, 0, 0))
  expect_equal(bluebird_summary_order$recordsPerType$n, c(10, 5, 10))
  expect_equal(bluebird_summary_order$analysesPerDietType$n, c(2, 1, 2))
  expect_equal(bluebird_summary_order$preySummary$Items, c(.385, .25, .175, .125, .065))
  expect_equal(bluebird_summary_order$preySummary$Wt_or_Vol, c(.36, .13, .185, .175, .15))
  expect_equal(bluebird_summary_order$preySummary$Occurrence, c(.7, .2, NA, .6, .1))
})


