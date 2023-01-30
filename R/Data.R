#' A subset of data from a sampled dataset with habitat types and plot code
#' of sampling.
#'
#' @format ## A data frame with 46,536 rows and 5 columns:
#' \describe{
#'   \item{plot}{Code for the plot}
#'   \item{habtype}{Code for habitat type}
#'   \item{MajorHab}{Code for the major habitat type}
#'   \item{habitat_name}{Name for the habitat type}
#'   \item{MajorHabName}{Name for the major habitat type}
#' }
#'
"SpatialData"

#' A subset of data from from a sampled dataset with the sampled species
#'
#' @format A data frame with 723,101 rows and 5 columns:
#' \describe{
#'   \item{plot}{Code for the plot}
#'   \item{year}{The sampled year}
#'   \item{canonicalName}{name of the species subspecies or variety}
#'   \item{species}{name of the species, solved for synonyms}
#'   \item{rank}{Taxonomic level it has been solved to
#' }}

"Final_Frequency"

#' CSR values and Ellenberg values for different species
#'
#' @format A data frame with 2,827 rows and 36 columns:

"Ellenberg_CSR"
