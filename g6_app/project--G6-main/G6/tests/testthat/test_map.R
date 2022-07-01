# Test worldoverview_map

# Test whether the map is visible
test_that("The outcome is a map of the world", {
  worldmap <- G6::worldmap_overview("AreaPerCap")
  expect_visible(worldmap)
})
