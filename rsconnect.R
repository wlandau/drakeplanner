library(rsconnect)
devtools::install_github("wlandau/drakeplanner")
setAccountInfo(
  name   = Sys.getenv("shinyapps_name"),
  token  = Sys.getenv("shinyapps_token"),
  secret = Sys.getenv("shinyapps_secret")
)
deployApp(
  appDir = file.path("tests", "apps", "drakeplanner"),
  appName = "drakeplanner"
)
