default_plan_text <- c(
  "# From https://github.com/wlandau/drake-examples/blob/master/mtcars/R/plan.R", # nolint
  "",
  "drake_plan(",
  "  small = simulate(48),",
  "  large = simulate(64),",
  "  regression1 = target(",
  "    reg1(data),",
  "    transform = map(data = c(small, large), .tag_out = reg)",
  "  ),",
  "  regression2 = target(",
  "    reg2(data),",
  "    transform = map(data, .tag_out = reg)",
  "  ),",
  "  summ = target(",
  "    suppressWarnings(summary(reg$residuals)),",
  "    transform = map(reg)",
  "  ),",
  "  coef = target(",
  "    suppressWarnings(summary(reg))$coefficients,",
  "    transform = map(reg)",
  "  )",
  ")"
)
default_plan_text <- paste(default_plan_text, collapse = "\n")

default_function_text <- c(
  "# From https://github.com/wlandau/drake-examples/blob/master/mtcars/R/functions.R", # nolint
  "",
  "# Pick a random subset of n rows from a dataset",
  "random_rows <- function(data, n) {",
  "  data[sample.int(n = nrow(data), size = n, replace = TRUE), ]",
  "}",
  "",
  "# Bootstrapped datasets from mtcars.",
  "simulate <- function(n) {",
  "  # Pick a random set of cars to bootstrap from the mtcars data.",
  "  data <- random_rows(data = mtcars, n = n)",
  "",
  "  # x is the car's weight, and y is the fuel efficiency.",
  "  data.frame(",
  "    x = data$wt,",
  "    y = data$mpg",
  "  )",
  "}",
  "",
  "# Try a couple different regression models.",
  "",
  "# Is fuel efficiency linearly related to weight?",
  "reg1 <- function(d) {",
  "  lm(y ~ + x, data = d)",
  "}",
  "",
  "# Is fuel efficiency related to the SQUARE of the weight?",
  "reg2 <- function(d) {",
  "  d$x2 <- d$x ^ 2",
  "  lm(y ~ x2, data = d)",
  "}"
)
default_function_text <- paste(default_function_text, collapse = "\n")

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
            default_plan_text,
            fontSize = 14,
            tabSize = 2
          )
        ),
        bs4Dash::bs4Card(
          title = "Functions",
          width = 12,
          status = "primary",
          closable = FALSE,
          shinyAce::aceEditor(
            "functions",
            default_function_text,
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
    shiny::includeMarkdown("README.md")
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
  title = "drake planner",
  bs4Dash::bs4SidebarMenu(
    bs4Dash::bs4SidebarMenuItem(
      "Plan",
      tabName = "plan",
      icon = "project-diagram"
    ),
    bs4Dash::bs4SidebarMenuItem(
      "usage",
      tabName = "usage",
      icon = "book-reader"
    )
  )
)

ui <- bs4Dash::bs4DashPage(
  title = " drake planner",
  body = ui_body,
  navbar = bs4Dash::bs4DashNavbar(controlbarIcon = NULL),
  sidebar = ui_sidebar
)
