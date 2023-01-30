## code to prepare `SpatialData` dataset goes here
library(terra)
library(dplyr)

SpatialData <- terra::vect("data-raw/Spatial.shp") |>
  as.data.frame() |>
  dplyr::rename(habitat_name  = habitat_na,
                MajorHabName = MajorHabNa)



usethis::use_data(SpatialData, overwrite = TRUE)
