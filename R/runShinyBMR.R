#' @title Run shinyBMR
#'
#' @description
#' Run a local instance of shinyBMR.
#'
#' @param ... [\code{any}]\cr
#'   Additional arguments passed to shiny's
#'   \code{runApp()} function.
#' @examples
#' \dontrun{
#'   runShinyBMR()
#' }
#' @import shiny
#' @import shinythemes
#' @export
runshinyBMR = function(...) {
  appDir = system.file("shinyBMR", package = "shinyBMR")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `shinyBMR`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
