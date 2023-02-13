#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom Artscore Artscore
#' @importFrom dplyr filter slice_sample left_join select mutate starts_with mutate_if
#' @importFrom stringr str_remove_all str_to_sentence str_replace_all
#' @importFrom tidyr pivot_longer everything
#' @importFrom rlang sym
#' @importFrom plotly renderPlotly ggplotly plot_ly add_trace layout
#' @importFrom ggplot2 ggplot theme_bw geom_boxplot coord_flip ylim xlab
#' @importFrom leaflet renderLeaflet leaflet addCircles addTiles leafletOutput
#' @noRd
app_server <- function(input, output, session) {
  habitat_name <- NavnDansk <- value <- Ellenberg <- canonicalName <- species <- rank <- C <- R <- S <- NULL
  # Your application server logic
  my_habitatdata <- eventReactive(input$update, {
    if(input$HabFilter){
      FloraExam::SpatialData |>
        dplyr::filter(habitat_name %in% input$HabChoice) |>
        dplyr::slice_sample(n = 1) |>
        dplyr::left_join(FloraExam::Final_Frequency) |>
        dplyr::left_join(FloraExam::Ellenberg_CSR)
    } else {
      FloraExam::SpatialData |>
        dplyr::slice_sample(n = 1) |>
        dplyr::left_join(FloraExam::Final_Frequency) |>
        dplyr::left_join(FloraExam::Ellenberg_CSR)
    }
    })

  output$Artscore <- renderText({
    Index <- Artscore::Artscore(ScientificName = my_habitatdata()$species, Habitat_code = unique(my_habitatdata()$habtype))$Artsindex
    paste("The artscore for this site is", round(Index, 3), "and the number of species in this plot is", length(unique(my_habitatdata()$species)))
  })

  output$Test <- shiny::renderText({
    my_habitatdata()$habitat_name[1]
  })
  output$Rightwrong <- shiny::renderUI({
    if (req(input$Answer) == my_habitatdata()$habitat_name[1]) {
      shiny::HTML("<h2>You are correct! try another plot by clicking on the <em>Pick random plot</em> button<h2>")
    } else if (req(input$Answer) != my_habitatdata()$habitat_name[1]) {
      shiny::HTML("<h2>Try again!<h2>")
    }
  })

  output$Leaflet <- leaflet::renderLeaflet({
    if (req(input$Answer) == my_habitatdata()$habitat_name[1]) {
      leaflet::leaflet(data = my_habitatdata()) |>
        leaflet::addTiles() |>
        leaflet::addCircles(lng = ~Long, lat = ~Lat)
    }
  })


  output$Map <- renderUI({
    if (req(input$Answer) == my_habitatdata()$habitat_name[1]) {
      leaflet::leafletOutput("Leaflet")
    }
  })

  output$major_hint <- shiny::renderText({
    if(req(input$Hint)){
      paste("The habitat type is within the", my_habitatdata()$MajorHabName[1],"major habitat")
    }
  })

  output$plot_ellenberg <- plotly::renderPlotly({
    G <- my_habitatdata() |> dplyr::select(dplyr::starts_with("eiv_eres")) |> tidyr::pivot_longer(tidyr::everything(), names_to = "Ellenberg") |> dplyr::mutate(Ellenberg = stringr::str_to_sentence(stringr::str_remove_all(Ellenberg, "eiv_eres_"))) |> ggplot2::ggplot(ggplot2::aes(x = Ellenberg, y = value)) + ggplot2::geom_boxplot() + ggplot2::coord_flip() + ggplot2::theme_bw() + ylim(c(0,10)) + ggplot2::xlab("Ecological indicator value")
    plotly::ggplotly(G)
  })
  output$plot_csr <- plotly::renderPlotly({
    plotly::plot_ly(my_habitatdata()) |>
      plotly::add_trace(
        type = 'scatterternary',
        mode = 'markers',
        a = ~C,
        b = ~R,
        c = ~S,
        text = ~Label,
        marker = list(
          symbol = "100",
          color = my_habitatdata()$RGB,
          size = 5,
          line = list('width' = 2)
        ))  |>  plotly::layout(
          title = "",
          ternary = list(
            sum = 100,
            aaxis = list(
              title = "Competitor",
              titlefont = list(
                size = 20
              ),
              tickfont = list(
                size = 15
              ),
              tickcolor = 'rgba(0,0,0,0)',
              ticklen = 5
            ),
            baxis = list(
              title = "Ruderal",
              titlefont = list(
                size = 20
              ),
              tickfont = list(
                size = 15
              ),
              tickcolor = 'rgba(0,0,0,0)',
              ticklen = 5
            ),
            caxis = list(
              title = "Stress tolerator",
              titlefont = list(
                size = 20
              ),
              tickfont = list(
                size = 15
              ),
              tickcolor = 'rgba(0,0,0,0)',
              ticklen = 5
            )
          ))

  })

  output$tbl_myhab <- shiny::renderDataTable({
    Table <- my_habitatdata() |>
      dplyr::select(NavnDansk,
                    canonicalName,
                    dplyr::starts_with("eiv"), C, S , R) |>
      dplyr::mutate_if(is.numeric, round)

    colnames(Table) <- stringr::str_replace_all(colnames(Table), "eiv_eres_", "Ellenberg_")
    Table
      })
}
