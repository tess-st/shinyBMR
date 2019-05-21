tabpanel.imlimportmod = dashboardPage(
  dashboardHeader(),
  dashboardSidebar(sidebarMenu(uiOutput("imlimportmod.ui"))),
  
  dashboardBody(
    tabsetPanel(id = "model",
      
      tabPanel("Imported (Tuned) Model",
        box(width = 12, verbatimTextOutput("learnerModel"))),
      
      tabPanel("Overview Task",
        #style = "overflow-y:scroll; max-height: 600px",
        box(width = 12, verbatimTextOutput("overviewTask")))
      # )
    )
  )
)