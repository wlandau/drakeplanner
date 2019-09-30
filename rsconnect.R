library(rsconnect)
remotes::install_github("wlandau/drakeplanner")
cat("Setting account info.")
setAccountInfo(
  name   = Sys.getenv("shinyapps_name"),
  token  = Sys.getenv("shinyapps_token"),
  secret = Sys.getenv("shinyapps_secret")
)
cat("Deploying to shinyapps.io.")
deployApp(
  appDir = file.path("tests", "apps", "drakeplanner"),
  appName = "drakeplanner"
)
