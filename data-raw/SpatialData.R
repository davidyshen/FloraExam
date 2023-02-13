## code to prepare `SpatialData` dataset goes here
library(terra)
library(tidyverse)

Coords <- terra::vect("data-raw/Spatial.shp") |>
  terra::geom() |>
  as.data.frame() |>
  dplyr::select(x, y)

SpatialData <- terra::vect("data-raw/Spatial.shp") |>
  as.data.frame() |>
  dplyr::bind_cols(Coords) |>
  dplyr::rename(habitat_name  = habitat_na,
                MajorHabName = MajorHabNa,
                Lat = y,
                Long = x) |>
  dplyr::mutate(plot = as.character(plot)) |>
  dplyr::filter(habitat_name != "Enekrat")


Ellenberg_CSR <- readRDS("data-raw/CRS_Ellenberg_Dataset.rds")


Final_Frequency <- read_csv("data-raw/Final_Frequency.csv") |>
  dplyr::filter(!is.na(species)) |>
  dplyr::mutate(plot = as.character(plot))

Plots <- SpatialData |>
  dplyr::full_join(FloraExam::Final_Frequency) |>
  dplyr::full_join(FloraExam::Ellenberg_CSR) |>
  dplyr::filter(!is.na(habitat_name)) |>
  group_by(plot, habitat_name) |>
  dplyr::summarize(non_na_eiv = sum(!is.na(eiv_eres_n)),
                   na_eiv = sum(is.na(eiv_eres_n)),
                   non_na_csr = sum(!is.na(C)),
                   na_csr = sum(is.na(C))) |>
  mutate(prop_eiv = non_na_eiv/(na_eiv + non_na_eiv),
         total_eiv = na_eiv + non_na_eiv,
         prop_csr = non_na_csr/(na_csr + non_na_csr),
         total_csr = na_csr + non_na_csr) |>
  dplyr::filter(non_na_csr > 2) |>
  ungroup() |>
  group_by(habitat_name) |>
  dplyr::slice_max(order_by = prop_csr, n = 30) |>
  dplyr::slice_max(order_by = non_na_csr, n = 20) |>
  pull(plot) |>
  unique()

SpatialData <- SpatialData |>
  dplyr::filter(plot %in% Plots) |>
  dplyr::mutate(habitat_name = paste0(habitat_name, " (", habtype, ")"))

Final_Frequency <- Final_Frequency |>
  dplyr::filter(plot %in% Plots)

usethis::use_data(SpatialData, overwrite = TRUE)

usethis::use_data(Final_Frequency, overwrite = TRUE)
