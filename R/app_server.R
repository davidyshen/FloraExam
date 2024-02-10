#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom Artscore Artscore
#' @importFrom dplyr filter slice_sample left_join select mutate starts_with mutate_if group_by summarise
#' @importFrom stringr str_remove_all str_to_sentence str_replace_all
#' @importFrom tidyr pivot_longer everything
#' @importFrom rlang sym
#' @importFrom stats median
#' @importFrom plotly renderPlotly ggplotly plot_ly add_trace layout
#' @importFrom ggplot2 ggplot theme_bw geom_boxplot coord_flip ylim xlab aes
#' @importFrom ggrepel geom_text_repel
#' @importFrom leaflet renderLeaflet leaflet addCircles addProviderTiles leafletOutput
#' @importFrom rmarkdown render
#' @importFrom DT datatable formatStyle styleEqual renderDataTable
#' @noRd
#'

resetForm<-function(session){
  updateSelectInput(session, "Answer",selected = "")
}

app_server <- function(input, output, session) {
  Median <- MajorHabName <- habitat_name <- NavnDansk <- value <- Ellenberg <- canonicalName <- species <- rank <- C <- R <- S <- NULL

  # Initialize object to store reactive values

  rvs <- reactiveValues(Artscore = NULL,
                        SpeciesList = NULL,
                        Histogram = NULL,
                        Ternary = NULL,
                        Dataset = NULL)

  # Your application server logic
  my_habitatdata <- eventReactive(input$update, {
    resetForm(session)
    if(input$HabFilter){
      FloraExam::SpatialData |>
        dplyr::filter(MajorHabName %in% input$HabChoice) |>
        dplyr::slice_sample(n = 1) |>
        dplyr::left_join(FloraExam::Final_Frequency) |>
        dplyr::left_join(FloraExam::Ellenberg_CSR) |>
        dplyr::left_join(FloraExam::Characteristic_Species)
    } else {
      FloraExam::SpatialData |>
        dplyr::slice_sample(n = 1) |>
        dplyr::left_join(FloraExam::Final_Frequency) |>
        dplyr::left_join(FloraExam::Ellenberg_CSR) |>
        dplyr::left_join(FloraExam::Characteristic_Species)
    }
    })

  output$Artscore <- renderText({
    Index <- Artscore::Artscore(ScientificName = my_habitatdata()$species, Habitat_code = unique(my_habitatdata()$habtype))$Artsindex
    rvs$Artscore <- paste("The artscore for this site is", round(Index, 3), "and the number of species in this plot is", length(unique(my_habitatdata()$species)))
    rvs$Artscore
  })

  # output$Test <- shiny::renderText({
  #   my_habitatdata()$MajorHabName[1]
  # })
  output$Rightwrong <- shiny::renderUI({
    if (req(input$Answer) == my_habitatdata()$MajorHabName[1]) {
      shiny::HTML(paste("<h2>You are correct! the precise habitat type was", my_habitatdata()$habitat_name[1], ". Try another plot by clicking on the <em>Pick random plot</em> button<h2>"))
    } else if (req(input$Answer) != my_habitatdata()$MajorHabName[1]) {
      shiny::HTML("<h2>Try again!<h2>")
    }
  })

  output$Leaflet <- leaflet::renderLeaflet({
    if (req(input$Answer) == my_habitatdata()$MajorHabName[1]) {
      leaflet::leaflet(data = my_habitatdata()) |>
        leaflet::addProviderTiles("Esri.WorldImagery") |>
        leaflet::addCircles(lng = ~Long, lat = ~Lat)
    }
  })


  output$Map <- renderUI({
    if (req(input$Answer) == my_habitatdata()$MajorHabName[1]) {
      leaflet::leafletOutput("Leaflet")
    }
  })

  # output$major_hint <- shiny::renderText({
  #   if(req(input$Hint)){
  #     paste("The habitat type is within the", my_habitatdata()$MajorHabName[1],"major habitat")
  #   }
  # })

  output$plot_ellenberg <- plotly::renderPlotly({
    Medians <- my_habitatdata() |> dplyr::select(dplyr::starts_with("eiv_eres")) |> tidyr::pivot_longer(tidyr::everything(), names_to = "Ellenberg") |> dplyr::group_by(Ellenberg) |> dplyr::summarise(Median = median(value)) |> dplyr::mutate(Ellenberg = stringr::str_to_sentence(stringr::str_remove_all(Ellenberg, "eiv_eres_")))

    G <- my_habitatdata() |> dplyr::select(dplyr::starts_with("eiv_eres")) |> tidyr::pivot_longer(tidyr::everything(), names_to = "Ellenberg") |> dplyr::mutate(Ellenberg = stringr::str_to_sentence(stringr::str_remove_all(Ellenberg, "eiv_eres_"))) |> ggplot2::ggplot(ggplot2::aes(x = Ellenberg, y = value)) + ggplot2::geom_boxplot() + ggplot2::coord_flip() + ggplot2::theme_bw() + ylim(c(0,10)) + ggplot2::xlab("Ecological indicator value") + ggplot2::xlab("Ecological indicator value") + ggrepel::geom_text_repel(data = Medians, aes(x = Ellenberg, y = Median, label = round(Median, 2)))
    rvs$Histogram <- G
    plotly::ggplotly(G)
  })
  output$plot_csr <- plotly::renderPlotly({

    rvs$Dataset <- my_habitatdata() |>
      dplyr::select(C, R, S) |>
      dplyr::filter(!is.na(C))

    message(nrow(rvs$Dataset))

    Tern <- plotly::plot_ly(my_habitatdata()) |>
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
              title = "Competitor"
            ),
            baxis = list(
              title = "Ruderal"
            ),
            caxis = list(
              title = "Stress tolerator"
            )
          ))

    Tern
    rvs$Ternary <- Tern

  })

  output$tbl_myhab <- DT::renderDataTable({
    Table <- my_habitatdata() |>
      dplyr::select(NavnDansk,
                    canonicalName,
                    dplyr::starts_with("eiv"), C, S , R, characteristic) |>
      dplyr::mutate_if(is.numeric, round)

    colnames(Table) <- stringr::str_replace_all(colnames(Table), "eiv_eres_", "Ellenberg_")
    rvs$SpeciesList <- Table
    Table  |>
      DT::datatable() %>%
      DT::formatStyle(
       'characteristic',
       target = 'row',
        backgroundColor = DT::styleEqual(c(NA, "I", "C"), c('white', 'green', 'green'))
      )
      })
  output$report <- downloadHandler(
    filename = paste0("Exam_Test", format(Sys.time(), "%Y-%m-%d"), ".pdf"),
    content = function(file) {
      shiny::withProgress(message = 'Preparing the report',
                   detail = NULL,
                   value = 0, {
                     shiny::incProgress(amount = 0.1, message = 'Recovering all data')

                     tempReport <- file.path(tempdir(), "report.Rmd")
                     file.copy(from = system.file("rmarkdown/templates/mock_exam/skeleton/skeleton.Rmd", package="FloraExam"), to = tempReport, overwrite = TRUE)

                     # Set up parameters to pass to Rmd document
                     params <- list(
                       Artscore = rvs$Artscore,
                       SpeciesList = rvs$SpeciesList,
                       Histogram = rvs$Histogram,
                       Ternary = rvs$Ternary,
                       Dataset = rvs$Dataset
                     )

                     shiny::incProgress(amount = 0.3, message = 'Printing the pdf')
                     rmarkdown::render(tempReport, output_file = file,
                                       params = params,
                                       envir = new.env(parent = globalenv()))
                   })
    }
  )

}
