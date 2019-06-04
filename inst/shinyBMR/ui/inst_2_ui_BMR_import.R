tabpanel.import = dashboardPage(
  dashboardHeader(),
  dashboardSidebar(sidebarMenu(id = "sidebarmenu", 
    uiOutput("import.ui"),
    
    hr(),
    
    tags$div(title = "Show aggregated Data of the BMR",
      selectInput("aggregated", "Aggregated BMR",
        choices = c("On", "Off"), selected = "On", multiple=F, selectize=TRUE,
        width = '98%')),
    tags$div(title="Choose 'On' for only showing 4 decimal places", 
      selectInput("round", "Round Values",
        choices = c("On", "Off"), selected = "On", multiple = FALSE, selectize = TRUE,
        width = '98%'))
  )
  ),
  
  dashboardBody(
    box(width = 12, DT::dataTableOutput("import.analysis"))
  )
)
