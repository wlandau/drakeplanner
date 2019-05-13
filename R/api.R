#' @title Launch the drake planner
#' @description Launch an interactive web application for
#'   creating and visualizing `drake` workflows.
#' @export
#' @examples
#' \dontrun{
#' drakeplanner()
#' }
drakeplanner <- function() {
  shiny::shinyApp(ui = ui(), server = server)
}
