tabpanel.import = dashboardPage(
  dashboardHeader(),
  dashboardSidebar(sidebarMenu(id = "sidebarmenu", 
    uiOutput("import.ui"),
    
    hr(),
    
    tags$div(title="Choose 'On' for only showing 4 decimal places", 
      selectInput("round", "Round Values",
        choices = c("Off", "On"), selected = "Off", multiple=F, selectize=TRUE,
        width = '98%'))
  )
  ),
  
  dashboardBody(
    tabsetPanel(id = "dataset",
      tabPanel("Imported Dataset",
        htmlOutput("import.text"),
        box(width = 12, DT::dataTableOutput("import.preview")),
        uiOutput("tabpanel.browse.openml"),
        checkboxInput("aggregatedBMR", "Show aggregated Benchmark Results", value = TRUE)
      ),
      
      tabPanel("Dataset BMR Analysis",
        box(width = 12, DT::dataTableOutput("import.analysis"))
      )
    )
  )
)