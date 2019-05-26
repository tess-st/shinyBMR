tabpanel.imlimportdat = dashboardPage(
  dashboardHeader(),
  dashboardSidebar(sidebarMenu(uiOutput("imlimport.ui"))),
  
  dashboardBody(
    tabsetPanel(id = "dataset",
      tabPanel("Imported Data Set",
        box(width = 12,  DT::dataTableOutput("imlimport.preview", height = "auto", width = "100%"))
      ),
      
      tabPanel("Summary Data Set",
        #verbatimTextOutput("summaryDataSet"))
        uiOutput("summary.dat"),
        prettySwitch("summaryInfo", "Show Information about the Summary Table", value = FALSE),
        conditionalPanel(condition = "input.summaryInfo == true",
          fluidRow(htmlOutput("summary_info")))
      )
    )
  )
)
