# Test G6_timeseries

# Test whether the timeseries is visible
test_that("The outcome is a line plot of the evolution of EF", {
  timeseries_plot <- G6::G6_timeseries("Argentina", "EFProdTotGHA", "fishing_ground")
  expect_visible(timeseries_plot)
})

# Test another the timeseries
test_that("The outcome is a line plot of the evolution of EF", {
  timeseries_forecast <- G6::G6_timeseries(c("Argentina","France"), "EFConsPerCap", "carbon")
  expect_visible(timeseries_forecast)
})
