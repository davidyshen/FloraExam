#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom plotly plotlyOutput
#' @importFrom stats na.omit na.omit
#' @importFrom shinyWidgets switchInput
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      titlePanel("Danish Flora Test Exam"),
      sidebarLayout(
        shiny::sidebarPanel(
          shiny::h5("Would you like to practice only some habitats? Turn on the filter"),
          shinyWidgets::switchInput("HabFilter", "filter"),
          shiny::conditionalPanel(
            condition = "input.HabFilter",
            shiny::selectizeInput(inputId = "HabChoice",
                                  label = "Which habitats would you like to practice with",
                                  choices = sort(as.character(stats::na.omit(unique(FloraExam::SpatialData$habitat_name)))),
                                  multiple = TRUE)
          ),
          actionButton("update", "Pick random plot",
                       class = "btn-primary",style='padding:4px; font-size:120%'),
          shiny::conditionalPanel(
            condition = "input.update != 0",
          shiny::selectizeInput(inputId = "Answer",
                              label = "What is this habitat type? choose it in the list",
                              choices = sort(as.character(stats::na.omit(unique(FloraExam::SpatialData$habitat_name)))),
                              multiple = TRUE,
                              options = list(maxItems = 1))
          ),
          shiny::conditionalPanel(
            condition = "input.update != 0",
          shiny::h5("Do you need a hint?")),
          shiny::conditionalPanel(
            condition = "input.update != 0",
          shinyWidgets::switchInput("Hint", "Hint")),
          shiny::textOutput("major_hint"),
          shiny::textOutput("Rightwrong")
        ),
        shiny::mainPanel(
          shiny::textOutput("Test"),
          plotly::plotlyOutput("plot_ellenberg"),
          plotly::plotlyOutput("plot_csr"),
          shiny::dataTableOutput("tbl_myhab")
        )

      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "TestExamapp"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
