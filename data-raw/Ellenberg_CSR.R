## code to prepare `Ellenberg_CSR` dataset goes here
library(tidyverse)

Ellenberg_CSR <- readRDS("data-raw/CRS_Ellenberg_Dataset.rds")

usethis::use_data(Ellenberg_CSR, overwrite = TRUE)

