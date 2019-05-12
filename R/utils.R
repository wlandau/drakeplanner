drake_source <- function(plan) {
  paste(drake::drake_plan_source(plan), collapse = "\n")
}

deparse_commands <- function (x) {
  unlist(lapply(x, safe_deparse, collapse = " "))
}

deparse_plan <- function(plan) {
  plan$command <- deparse_commands(plan$command)
  plan
}

drake_script <- function(input) {
  plan_text <- input$plan
  plan_text[1] <- paste("plan <-", plan_text[1])
  c(
    "# This R script sets up and runs a drake workflow.",
    "# Visit https://ropenscilabs.github.io/drake-manual/projects.html",
    "# for advice on splitting the code into multiple files.",
    "",
    "# First, load your packages. Feel free to add more.",
    "library(drake)",
    "",
    "# Next, define your functions.",
    input$functions,
    "",
    "# And create your drake plan.",
    plan_text,
    "",
    "# Finally, run your workflow.",
    "make(plan)",
    "",
    "# You can visualize your plan and workflow.",
    "config <- drake_config(plan)",
    "vis_drake_graph(config)",
    "",
    "# And you can load targets from the cache with loadd() and readd()."
  )
}

parse_input <- function(text, envir, error) {
  tryCatch(
    eval(parse(text = text), envir = envir),
    error = function(e) {
      shinyalert::shinyalert(error, e$message, type = "error")
      "error"
    }
  )
}

resolve_graph <- function(plan, envir) {
  config <- drake::drake_config(
    plan,
    envir = envir,
    cache = storr::storr_environment(),
    session_info = FALSE
  )
  info <- drake::drake_graph_info(config)
  relabel <- info$nodes$status == "missing"
  info$nodes$status[relabel] <- "imported"
  info$nodes$color[relabel] <- "#1874CD"
  info$legend_nodes <- info$legend_nodes[info$legend_nodes$label != "Missing", ]
  drake::render_drake_graph(
    info,
    main = "",
    hover = TRUE,
    width = "100%"
  )
}

safe_deparse <- function (x, collapse = "\n") {
  paste(deparse(x, control = c("keepInteger", "keepNA")), collapse = collapse)
}

update_values <- function(values, input) {
  envir <- new.env(parent = globalenv())
  plan <- parse_input(input$plan, envir, "Plan error")
  if (identical(plan, "error")) {
    return()
  }
  values$plan <- plan
  out <- parse_input(input$functions, envir, "Functions error")
  if (identical(out, "error")) {
    return()
  }
  values$graph <- resolve_graph(values$plan, envir)
  invisible()
}
