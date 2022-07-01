# Test sustainability

# Test whether the map is visible
test_that("The outcome is a barplot displaying our sustainability measure", {
  sust <- G6::sustainability("France")
  expect_visible(sust)
})
