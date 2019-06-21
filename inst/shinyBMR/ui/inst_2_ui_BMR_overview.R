tabpanel.overview =  dashboardPage(
  
  dashboardHeader(),
  
  dashboardSidebar(sidebarMenu(id = "sidebarmenu",
    menuItem("Summary BMR", tabName = "summaryBMR", icon = icon("cubes")),
    menuItem("Best BMR-Modell", tabName = "bestMod", icon = icon("cube")),
    menuItem("Pareto", tabName = "pareto"),
    
    hr(),
    
    tags$div(title = "Select one of the Measures you performed the Benchmark-Study on",
      htmlOutput("selected.measure")),
    tags$div(title="Choose 'On' for only showing 4 decimal places", 
      selectInput("roundOverview", "Round Values",
        choices = c("Off", "On"), selected = "On", multiple=F, selectize=TRUE,
        width = '98%'))
  )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "summaryBMR",
        h2("Summary of the Benchmark Analysis"),
        br(),
        tabsetPanel(
          tabPanel("Categories/Levels",
            textOutput("help_summary"),
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
          
          tabPanel("Tuning Results",
            textOutput("help_tuning"),
            uiOutput("summary.tune"),
            br(),
            fluidRow(
              column(12,
                uiOutput("hyperPars")),
              column(12,
                plotOutput("plot.hyperPars")
              )
            )
          ),
          
          # tabPanel("Tuning Results",
          #   verbatimTextOutput("tuneResults")
          #  tags$head(tags$style("#crossTables{font-size:12px; font-style:italic; height:70vh !important; 
          #overflow-y:scroll; background: ghostwhite;}"))
          # )
          
          tabPanel("Cross Tables",
            textOutput("help_tables"),
            br(),
            fluidRow(column(3, htmlOutput("selectionTable1")),
              column(3,htmlOutput("selectionTable2")),
              column(3,htmlOutput("selectionTable3"))),
            
            verbatimTextOutput("crossTables"),
            tags$head(tags$style("#crossTables{font-size:12px; font-style:italic; height:60vh !important; 
overflow-y:scroll; background: ghostwhite;}"))#
          )
          # tabPanel("Summary of BMR-Data",
          #   verbatimTextOutput("summaryData")
          # ),
          
        )
      ),
      
      tabItem(tabName = "bestMod",
        h2("Best Modell/Learner in BMR Analysis"),
        br(),
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
      ),
      
      tabItem(tabName = "pareto",
        h2("Pareto"),
        htmlOutput("paretoMeasure1"), 
        htmlOutput("paretoMeasure2"),
        htmlOutput("paretoType"),
        box(width = 12, DT::dataTableOutput("paretoTab")),
        #conditionalPanel(condition = "input.type == false",
          fluidRow(fillPage(plotOutput("ggplot_pareto")))
        #),
        #conditionalPanel(condition = "input.type == true",
         # fluidRow(fillPage(plotlyOutput("plotly_heatmap"))))
        )
    )
  )
)