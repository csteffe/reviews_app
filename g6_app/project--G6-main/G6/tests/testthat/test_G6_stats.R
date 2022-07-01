# Test G6_stats

# Test whether the result of G6_stats is visible
test_that("The outcome is a table of stats", {
  stats_table <- G6::G6_stats(c("France", "Switzerland", "World"), "AreaPerCap", "crop_land", (1990:2010))
  expect_visible(stats_table)
})
