context("Evaluating dietSummaryByPrey() calcuations")

suppressWarnings(library(dplyr))

data(testdb)

Lepidoptera_any = dietSummaryByPrey("Lepidoptera", preyLevel = "Order", preyStage = "any", db = testdb)

test_that("Aggregating low level prey to order for any Prey_Stage", {
  expect_equal(Lepidoptera_any$Fraction_Diet[Lepidoptera_any$Diet_Type == 'Items'], c(.75, .62, .52))
  expect_equal(Lepidoptera_any$Fraction_Diet[Lepidoptera_any$Diet_Type == 'Wt_or_Vol'], c(.65, .57, .33))
  expect_equal(Lepidoptera_any$Fraction_Diet[Lepidoptera_any$Diet_Type == 'Occurrence'], c(.7, .6))
})


Lepidoptera_larva = dietSummaryByPrey("Lepidoptera", preyLevel = "Order", preyStage = "larva", db = testdb)

test_that("Aggregating low level prey to order for larva", {
  expect_equal(Lepidoptera_larva$Fraction_Diet[Lepidoptera_larva$Diet_Type == 'Items'], c(.5, .5, .27))
  expect_equal(Lepidoptera_larva$Fraction_Diet[Lepidoptera_larva$Diet_Type == 'Wt_or_Vol'], c(.52, .52, .2))
  expect_equal(Lepidoptera_larva$Fraction_Diet[Lepidoptera_larva$Diet_Type == 'Occurrence'], c(.7, .5))
})


Lepidoptera_any_mean = dietSummaryByPrey("Lepidoptera", preyLevel = "Order", preyStage = "any", db = testdb, speciesMean = TRUE)

test_that("Aggregating low level prey to order for any Prey_Stage, then calculating means by bird species", {
  expect_equal(Lepidoptera_any_mean$Fraction_Diet[Lepidoptera_any_mean$Diet_Type == 'Items'], c(.635, .62))
  expect_equal(Lepidoptera_any_mean$Fraction_Diet[Lepidoptera_any_mean$Diet_Type == 'Wt_or_Vol'], c(.57, .49))
  expect_equal(Lepidoptera_any_mean$Fraction_Diet[Lepidoptera_any_mean$Diet_Type == 'Occurrence'], c(.7, .6))
})


Lepidoptera_larva_mean = dietSummaryByPrey("Lepidoptera", preyLevel = "Order", preyStage = "larva", db = testdb, speciesMean = TRUE)

test_that("Aggregating low level prey to order for larva, then calculating means by bird species", {
  expect_equal(Lepidoptera_larva_mean$Fraction_Diet[Lepidoptera_larva_mean$Diet_Type == 'Items'], c(.5, .385))
  expect_equal(Lepidoptera_larva_mean$Fraction_Diet[Lepidoptera_larva_mean$Diet_Type == 'Wt_or_Vol'], c(.52, .36))
  expect_equal(Lepidoptera_larva_mean$Fraction_Diet[Lepidoptera_larva_mean$Diet_Type == 'Occurrence'], c(.7, .5))
})


Insecta_any = dietSummaryByPrey("Insecta", preyLevel = "Class", preyStage = "any", db = testdb)

test_that("Aggregating low level prey to Class for any Prey_Stage", {
  expect_equal(Insecta_any$Fraction_Diet[Insecta_any$Diet_Type == 'Items'], c(1, 1, 1))
  expect_equal(Insecta_any$Fraction_Diet[Insecta_any$Diet_Type == 'Wt_or_Vol'], c(1, 1, 1))
  expect_equal(Insecta_any$Fraction_Diet[Insecta_any$Diet_Type == 'Occurrence'], c(.8, .7))
})
