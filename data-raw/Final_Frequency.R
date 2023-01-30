## code to prepare `Final_Frequency` dataset goes here

library(tidyverse)

Final_Frequency <- read_csv("data-raw/Final_Frequency.csv") |>
  dplyr::filter(!is.na(species)) |>
  dplyr::mutate(plot = as.character(plot))

usethis::use_data(Final_Frequency, overwrite = TRUE)

