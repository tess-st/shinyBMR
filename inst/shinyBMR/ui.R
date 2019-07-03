require(shiny)
require(shinydashboard)
require(shinythemes)
require(shinyjs)
require(shinyBS)
require(shinydashboardPlus)
require(DT)
require(rlang)
require(plotly)
require(colourpicker)
require(shinyWidgets)
require(colorspace)
require(RColorBrewer)
require(Rcpp)
require(pals)
require(shinycssloaders)
require(listviewer)


# source("prep/inst_1_prep_ui.R", local = TRUE)$value

#Connection to ui.files
ui.files <- list.files(path = "./ui", pattern = "*_2_ui_")
ui.files <- paste0("ui/", ui.files)

for (i in seq_along(ui.files)) {
  source(ui.files[i], local = TRUE)
}
# Call this function with all the regular navbarPage() parameters, plus a text parameter,
# if you want to add text to the navbar
navbarPageWithText <- function(..., text) {
  navbar <- navbarPage(...)
  textEl <- tags$p(class = "navbar-text", text)
  navbar[[3]][[1]]$children[[1]] <- htmltools::tagAppendChild(
    navbar[[3]][[1]]$children[[1]], textEl)
  navbar
}


ui <- shinyUI(
  tagList(
    useShinyjs(),
    loading.info,
    #change font size only of menuItems
    tags$style(HTML(".sidebar-menu li a { font-size: 18px; }")), 
    #; .navbar ul li:nth-child(7) { float: right; } .navbar ul li:nth-child(8) { float: right; } 
    div(id = "app-content",
      navbarPage(
        title=div("Analysis and Interpretation of Benchmark Studies (with mlr & iml)"),
        #img(src="cup.png", height = 35)
        theme = shinytheme("flatly"), id = "navigation",
        tabPanel("Welcome", tabpanel.welcome),
        tabPanel("BMR Import", tabpanel.import,
          icon = icon("folder-open")),
        tabPanel("BMR Overview", tabpanel.overview,
          icon = icon("compass")),
        tabPanel("BMR Analysis", tabpanel.bmr,
          icon = icon("tachometer-alt")),
        tabPanel("IML Import Data", tabpanel.imlimportdat,
          icon = icon("indent")),
        tabPanel("IML Import Model", tabpanel.imlimportmod,
          icon = icon("file-upload")),
        tabPanel("IML Analysis", tabpanel.iml,
          icon = icon("glasses")),
        #tabPanel(title = "", icon = icon("copyright"), align = "right"), 
        # ), value = "https://github.com/mlr-org/mlr"),
        #tabPanel(title = "", icon = icon("github", "fa-lg"),
        #         value = "https://github.com/mlr-org/mlr"),
        # 
        footer = tagList(
          includeScript("scripts/top-nav-links.js"),
          includeScript("scripts/app.js"),
          tags$link(rel = "stylesheet", type = "text/css",
                    href = "custom.css"),
          tags$link(rel = "stylesheet", type = "text/css",
                    href = "https://fonts.googleapis.com/css?family=Roboto"),
          tags$link(rel = "stylesheet", type = "text/css",
                    href = "AdminLTE.css"),
          tags$footer(title = "", # align = "right",
                      # tags$a(id = "show_help",
                      # href = "https://github.com/mlr-org/mlr_shiny", target = "_blank",
                      # div(id = "copyright-container",
                      #   column(width = 6, align = "left",
                      tags$p(id = "copyright",
                             tags$img(icon("copyright")),
                             2019,
                             tags$a(href = "https://github.com/tess-st",
                                    target = "_blank", "Anna Theresa Stüber"),
                             " (Shiny App as part of my Master Thesis at LMU)"
                      )
          )
         ), 
        windowTitle = "shinyBMR"
      )
    )
  )
)
