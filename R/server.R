server <- function(input, output, session) {
  values <- shiny::reactiveValues()
  shiny::observeEvent(
    input$update,
    values <- update_values(values, input),
    ignoreNULL = FALSE
  )
  output$table <- DT::renderDataTable(
    deparse_plan(values$plan),
    rownames = FALSE
  )
  output$source <- shiny::renderText(drake_source(values$plan))
  output$graph <- visNetwork::renderVisNetwork(values$graph)
  output$download <- shiny::downloadHandler(
    filename = function() {
      paste("drake-", Sys.Date(), ".R", sep = "")
    },
    content = function(con) {
      writeLines(drake_script(input), con)
    }
  )
}
