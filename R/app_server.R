#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom dplyr filter
#' @importFrom rlang sym
#' @importFrom plotly renderPlotly ggplotly
#' @importFrom ggplot2 ggplot geom_bar theme_bw
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  my_habitatdata <- reactive({
    SpatialData |>
      dplyr::filter(!!sym("MajorHabName") == input$filter_majhab)
  })
  output$plot_myhab <- plotly::renderPlotly({
    g <- ggplot2::ggplot(data = my_habitatdata(), ggplot2::aes(x = habitat_name)) + ggplot2::geom_bar()
    plotly::ggplotly(g)
    })
  output$tbl_myhab <- shiny::renderTable({my_habitatdata()})
}
