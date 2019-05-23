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


# source("prep/inst_1_prep_ui.R", local = TRUE)$value

#Connection to ui.files
ui.files <- list.files(path = "./ui", pattern = "*_2_ui_")
ui.files <- paste0("ui/", ui.files)

for (i in seq_along(ui.files)) {
  source(ui.files[i], local = TRUE)
}


ui <- shinyUI(
  tagList(
    useShinyjs(),
    loading.info,
    #change font size only of menuItems
    tags$style(HTML(".sidebar-menu li a { font-size: 18px; }")),
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
       # tabPanel("IML Analysis", tabpanel.iml,
        #  icon = icon("glasses")),
        tabPanel("Test", tabpanel.iml.test),
        # ), value = "https://github.com/mlr-org/mlr"),
        # tabPanel(title = "", icon = icon("github", "fa-lg"),
        #          value = "https://github.com/mlr-org/mlr"),
        # 
        # footer = tagList(
        #   includeScript("scripts/top-nav-links.js"),
        #   includeScript("scripts/app.js"),
        #   tags$link(rel = "stylesheet", type = "text/css",
        #             href = "custom.css"),
        #   tags$link(rel = "stylesheet", type = "text/css",
        #             href = "https://fonts.googleapis.com/css?family=Roboto"),
        #   tags$link(rel = "stylesheet", type = "text/css",
        #             href = "AdminLTE.css"),
        #   tags$footer(title = "", # align = "right",
        #               # tags$a(id = "show_help",
        #               # href = "https://github.com/mlr-org/mlr_shiny", target = "_blank",
        #               # div(id = "copyright-container",
        #               #   column(width = 6, align = "left",
        #               tags$p(id = "copyright",
        #                      tags$img(icon("copyright")),
        #                      2017,
        #                      tags$a(href = "https://github.com/Coorsaa",
        #                             target = "_blank", "Stefan Coors, "),
        #                      tags$a(href = "https://github.com/florianfendt",
        #                             target = "_blank", "Florian Fendt"),
        #                      " (members of the mlr-organization)"
        #               ),
        #               tags$p(id = "help_toggler",
        #                      bsButton(inputId = "show_help", label = "show help",
        #                               type = "toggle", icon = icon("question-circle"))
        #               )
        #   )
        # ), 
        windowTitle = "MlrBMR"
      )
    )
  )
)
