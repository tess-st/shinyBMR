#####################################################################################################################
# UI: Import Data
#####################################################################################################################

tabpanel.imlimportdat = dashboardPage(
  dashboardHeader(),
  dashboardSidebar(sidebarMenu(uiOutput("imlimport.ui"),
    
    hr(),
    
    tags$div(title="Choose 'On' for only showing 3 decimal places", 
      selectInput("iml.round", "Round Values",
        choices = c("On", "Off"), selected = "On", multiple = FALSE, selectize = TRUE,
        width = '98%'))
  )),
  
  dashboardBody(
    h2("Imported Data for IML Analysis"),
    
    br(),
    
    tabsetPanel(id = "dataset",
      tabPanel("Imported Data Set",
        box(width = 12,  DT::dataTableOutput("imlimport.preview", height = "auto", width = "100%"))
      ),
      
      tabPanel("Summary Data Set",
        uiOutput("summary.dat"),
        fluidRow(
          column(12,
            uiOutput("summary.vis.hist")),
          column(12,
            plotlyOutput("summary.vis"),
            br(),
            br()
          )
        ),
        
        prettySwitch("summaryInfo", "Show Information about the Summary Table", value = FALSE),
        
        conditionalPanel(condition = "input.summaryInfo == true",
          fluidRow(htmlOutput("summary_info")))
      )
    )
  )
)
