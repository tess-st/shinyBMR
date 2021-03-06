#####################################################################################################################
# UI: Import Model
#####################################################################################################################

tabpanel.imlimportmod = dashboardPage(
  dashboardHeader(),
  dashboardSidebar(sidebarMenu(uiOutput("imlimportmod.ui"))),
  
  dashboardBody(
    h2("Imported Model for IML Analysis"),
    textOutput("bmrImportModelInfo"),
    
    br(),
    
    tabsetPanel(id = "model",
      
      tabPanel("Imported (Tuned) Model",
        box(width = 12, verbatimTextOutput("learnerModel"))),
      
      tabPanel("Overview Task",
        jsoneditOutput("listTask")
      )
    )
  )
)