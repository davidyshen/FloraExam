#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom dplyr filter slice_sample left_join select mutate
#' @importFrom stringr str_remove_all str_to_sentence
#' @importFrom tidyr pivot_longer everything
#' @importFrom rlang sym
#' @importFrom plotly renderPlotly ggplotly
#' @importFrom ggplot2 ggplot theme_bw geom_boxplot coord_flip ylim
#' @noRd
app_server <- function(input, output, session) {
  habitat_name <- NavnDansk <- value <- Ellenberg <- canonicalName <- species <- rank <- NULL
  # Your application server logic
  my_habitatdata <- eventReactive(input$update, {
    FloraExam::SpatialData |>
      dplyr::slice_sample(n = 1) |>
      dplyr::left_join(FloraExam::Final_Frequency) |>
      dplyr::left_join(FloraExam::Ellenberg_CSR)
    })

  output$plot_ellenberg <- plotly::renderPlotly({
    G <- my_habitatdata() |> dplyr::select(dplyr::starts_with("eiv_eres")) |> tidyr::pivot_longer(tidyr::everything(), names_to = "Ellenberg") |> dplyr::mutate(Ellenberg = stringr::str_to_sentence(stringr::str_remove_all(Ellenberg, "eiv_eres_"))) |> ggplot2::ggplot(ggplot2::aes(x = Ellenberg, y = value)) + ggplot2::geom_boxplot() + ggplot2::coord_flip() + ggplot2::theme_bw() + ylim(c(0,10))
    plotly::ggplotly(G)
  })

  output$tbl_myhab <- shiny::renderDataTable({my_habitatdata() |>
      dplyr::select(NavnDansk,
                    canonicalName,
                    species,
                    rank)})
}
