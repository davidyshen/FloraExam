#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom plotly plotlyOutput
#' @importFrom stats na.omit na.omit
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      titlePanel("TestExamapp"),
      sidebarLayout(
        shiny::sidebarPanel(
          actionButton("update", "Pick random plot",
                       class = "btn-primary",style='padding:4px; font-size:120%'),
          shiny::radioButtons(inputId = "Answer",
                              label = "Choose the possible habitat",
                              choices = sort(as.character(stats::na.omit(unique(FloraExam::SpatialData$MajorHabName)))))
        ),
        shiny::mainPanel(
          plotly::plotlyOutput("plot_ellenberg"),
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
