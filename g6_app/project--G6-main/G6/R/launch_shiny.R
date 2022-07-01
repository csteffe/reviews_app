#' @title Launch shiny app
#' @description The function calls the shiny app once the package is loaded
#' @return shiny app UI
#' @export
#' @examples
#' launch_app

#source("server.R")
#file.path(getwd(), "Graphics", "graph1.R")

launch_app <- function(){

  shiny::runApp(system.file("shiny-examples","Sustshinability",package = "G6"))


}

