default_text <- function(file) {
  path <- file.path("defaults", file)
  path <- system.file(path, package = "drakeplanner", mustWork = TRUE)
  lines <- readLines(path)
  paste(lines, collapse = "\n")
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
    "# config <- drake_config(plan)",
    "# vis_drake_graph(config, hover = TRUE)",
    "",
    "# And you can load targets from the cache with loadd() and readd()."
  )
}

drake_source <- function(plan) {
  paste(drake::drake_plan_source(plan), collapse = "\n")
}

parse_input <- function(text, envir, type) {
  tryCatch(
    withCallingHandlers(
      eval(parse(text = text), envir = envir),
      warning = function(w) {
        shinyalert::shinyalert(
          paste(type, "warning"),
          w$message,
          type = "warning"
        )
        "warning"
      }
    ),
    error = function(e) {
      shinyalert::shinyalert(
        paste(type, "error"),
        e$message,
        type = "error"
      )
      "error"
    }
  )
}

resolve_graph <- function(plan, envir) {
  config <- drake::drake_config(
    plan,
    envir = envir,
    cache = storr::storr_environment(),
    session_info = FALSE,
    history = FALSE
  )
  info <- drake::drake_graph_info(config, hover = TRUE)
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
  for (pkg in c("drake", "tidyverse")) {
    parse_input(sprintf("require(%s)", pkg), envir) #"Depends:" is not enough.
  }
  plan <- parse_input(input$plan, envir, "Plan")
  if (identical(plan, "error")) {
    return()
  }
  values$plan <- plan
  out <- parse_input(input$functions, envir, "Functions")
  if (identical(out, "error")) {
    return()
  }
  values$graph <- resolve_graph(values$plan, envir)
  invisible()
}
