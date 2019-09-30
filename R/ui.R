ui <- function() {
  ui_plan <- bs4Dash::bs4TabItem(
    tabName = "plan",
    shinyalert::useShinyalert(),
    htmltools::tags$head(
      htmltools::tags$style("#source{overflow-y:scroll; max-height: 400px;}")
    ),
    shiny::fluidRow(
      shiny::column(
        6,
        bs4Dash::bs4Sortable(
          width = 12,
          bs4Dash::bs4Card(
            title = "Control",
            width = 12,
            status = "primary",
            closable = FALSE,
            shiny::actionButton(
              "update",
              "Update",
              icon = shiny::icon("redo-alt")
            ),
            shiny::downloadButton("download", "Download")
          ),
          bs4Dash::bs4Card(
            title = "Plan",
            width = 12,
            status = "primary",
            closable = FALSE,
            shinyAce::aceEditor(
              "plan",
              default_text("plan.R"),
              fontSize = 14,
              tabSize = 2
            ),
            shiny::textOutput("plan_warnings")
          ),
          bs4Dash::bs4Card(
            title = "Functions",
            width = 12,
            status = "primary",
            closable = FALSE,
            shinyAce::aceEditor(
              "functions",
              default_text("functions.R"),
              fontSize = 14,
              tabSize = 2
            )
          )
        )
      ),
      shiny::column(
        6,
        bs4Dash::bs4Sortable(
          width = 12,
          bs4Dash::bs4Card(
            title = "Graph",
            width = 12,
            status = "success",
            closable = FALSE,
            shinycssloaders::withSpinner(visNetwork::visNetworkOutput("graph"))
          ),
          bs4Dash::bs4Card(
            title = "Table",
            width = 12,
            status = "success",
            closable = FALSE,
            shinycssloaders::withSpinner(DT::dataTableOutput("table"))
          ),
          bs4Dash::bs4Card(
            title = "Source",
            width = 12,
            status = "success",
            closable = FALSE,
            shinycssloaders::withSpinner(shiny::verbatimTextOutput("source"))
          )
        )
      )
    )
  )

  ui_usage <- bs4Dash::bs4TabItem(
    tabName = "usage",
    bs4Dash::bs4Card(
      title = "Usage",
      width = 12,
      status = "success",
      closable = FALSE,
      shiny::includeMarkdown(
        system.file("README.md", package = "drakeplanner", mustWork = TRUE)
      )
    )
  )

  ui_body <- bs4Dash::bs4DashBody(
    bs4Dash::bs4TabItems(
      ui_plan,
      ui_usage
    )
  )

  ui_sidebar <- bs4Dash::bs4DashSidebar(
    skin = "light",
    status = "primary",
    brandColor = "primary",
    title = "drakeplanner",
    bs4Dash::bs4SidebarMenu(
      bs4Dash::bs4SidebarMenuItem(
        "Plan",
        tabName = "plan",
        icon = "project-diagram"
      ),
      bs4Dash::bs4SidebarMenuItem(
        "Usage",
        tabName = "usage",
        icon = "book-reader"
      )
    )
  )

  bs4Dash::bs4DashPage(
    title = " drakeplanner",
    body = ui_body,
    navbar = bs4Dash::bs4DashNavbar(controlbarIcon = NULL),
    sidebar = ui_sidebar
  )
}
