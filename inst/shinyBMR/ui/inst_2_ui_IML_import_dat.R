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
        #checkboxInput("iml_dat_round", label = "Round shown numeric values", value = TRUE),
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
