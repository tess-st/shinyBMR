tabpanel.overview =  dashboardPage(
  
  dashboardHeader(),
  
  dashboardSidebar(sidebarMenu(id = "sidebarmenu",
    menuItem("Summary BMR", tabName = "summaryBMR", icon = icon("cubes")),
    menuItem("Best BMR-Modell", tabName = "bestMod", icon = icon("cube")),
    
    hr(),
    
    tags$div(title = "Select one of the Measures you performed the Benchmark-Study on",
      htmlOutput("selected.measure")),
    tags$div(title = "Is the better Performance marked by high (max.) or low (min.) Values of your selected Measure",
      htmlOutput("selected.minmax")),
    
    hr(),
    
    tags$div(title="Choose 'On' for only showing 4 decimal places", 
      selectInput("roundOverview", "Round Values",
        choices = c("Off", "On"), selected = "Off", multiple=F, selectize=TRUE,
        width = '98%'))
  )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "summaryBMR",
        h4("Summary of the Benchmark Analysis"),
        tabsetPanel(
          tabPanel("Categories/Levels",
            fluidRow(infoBoxOutput("Data_Names"),
              infoBoxOutput("Methods"),
              infoBoxOutput("Tasks"),
              
              valueBoxOutput("Data_Names_Lev"),
              valueBoxOutput("Methods_Lev"),
              valueBoxOutput("Tasks_Lev")),
            
            hr(),
            
            fluidRow(infoBoxOutput("Measures"),
              infoBoxOutput("Tunings"),
              infoBoxOutput("SMOTEs"),
              
              valueBoxOutput("Measures_Lev"),
              valueBoxOutput("Tunings_Lev"),
              valueBoxOutput("SMOTEs_Lev")
              
            ),
            
            hr(),
            
            fluidRow(infoBoxOutput("Values")),
            fluidRow(valueBoxOutput("Values_Lev"))
          ),
          
          tabPanel("Cross Tables",
            fluidRow(column(3, htmlOutput("selectionTable1")),
              column(3,htmlOutput("selectionTable2")),
              column(3,htmlOutput("selectionTable3"))),
            
            verbatimTextOutput("crossTables"),
            tags$head(tags$style("#crossTables{font-size:12px; font-style:italic; height:60vh !important; 
overflow-y:scroll; background: ghostwhite;}"))#
          ),
          
          tabPanel("Summary of BMR-Data",
            verbatimTextOutput("summaryData")
          ),
          
          tabPanel("Tuning Results",
            verbatimTextOutput("tuneResults")
          #  tags$head(tags$style("#crossTables{font-size:12px; font-style:italic; height:70vh !important; 
#overflow-y:scroll; background: ghostwhite;}"))
          )
        )
      ),
      
      tabItem(tabName = "bestMod",
        h4("Best Modell/Learner in BMR Analysis"),
        fluidRow(infoBoxOutput("Data_Name"),
          infoBoxOutput("Method"),
          infoBoxOutput("Task")),
        #hr(),
        fluidRow(infoBoxOutput("Measure"),
          infoBoxOutput("Tuning"),
          infoBoxOutput("SMOTE")),
        #hr(),
        fluidRow(valueBoxOutput("Value")
        )
      )
    )
  )
)