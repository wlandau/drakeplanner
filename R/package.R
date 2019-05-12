#' drakeplanner: An R/Shiny app to create and visualize `drake` workflows.
#' @docType package
#' @description `drakeplanner` is an package and R/Shiny app
#'   for creating and visualizing `drake` workflows.
#' @name drake-package
#' @aliases drake
#' @author William Michael Landau \email{will.landau@@gmail.com}
#' @examples
#' \dontrun{
#' drakeplanner()
#' }
#' @references <https://github.com/wlandau/drakeplanner>
#' @import drake styler
#' @importFrom bs4Dash bs4Card bs4DashBody bs4DashSidebar bs4SidebarMenu
#'   bs4DashNavbar bs4DashPage bs4SidebarMenu bs4SidebarMenuItem bs4Sortable
#'   bs4TabItem bs4TabItems
#' @importFrom DT dataTableOutput renderDataTable
#' @importFrom htmltools tags
#' @importFrom shiny actionButton column downloadHandler downloadButton fluidRow
#'   reactiveValues renderText shinyApp verbatimTextOutput
#' @importFrom shinyalert useShinyalert
#' @importFrom shinyAce aceEditor
#' @importFrom shinycssloaders withSpinner
#' @importFrom storr storr_environment
#' @importFrom visNetwork renderVisNetwork visNetworkOutput
NULL
