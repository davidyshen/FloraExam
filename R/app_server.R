#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom dplyr filter slice_sample
#' @importFrom rlang sym
#' @importFrom plotly renderPlotly ggplotly
#' @importFrom ggplot2 ggplot geom_bar theme_bw
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  my_habitatdata <- eventReactive(input$update, {
      SpatialData |>
        dplyr::slice_sample(n = 1)
    })
  output$plot_myhab <- plotly::renderPlotly({
    g <- ggplot2::ggplot(data = my_habitatdata(), ggplot2::aes(x = habitat_name)) + ggplot2::geom_bar()
    plotly::ggplotly(g)
    })
  output$tbl_myhab <- shiny::renderTable({my_habitatdata()})
}
