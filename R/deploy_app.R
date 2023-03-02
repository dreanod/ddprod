#' @export
deploy_app <- function() {
  rstudioapi::sendToConsole('rsconnect::deployApp(forceUpdate = TRUE)')
}
