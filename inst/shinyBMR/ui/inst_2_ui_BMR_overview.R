tabpanel.overview =  dashboardPage(
  
  dashboardHeader(),
  
  dashboardSidebar(sidebarMenu(id = "tabs_overview",
    menuItem("Basics", tabName = "basicsOverview", icon = icon("pencil-alt"), selected = TRUE),
    menuItem("Summary BMR", tabName = "summaryBMR", icon = icon("cubes")),
    #  menuItem("Best BMR-Modell", tabName = "bestMod", icon = icon("cube")),
    menuItem("'Best' BMR-Modell", tabName = "pareto", icon = icon("cube")),
    
    hr(),
    
    tags$div(title = "Select one of the Measures you performed the Benchmark-Study on",
      htmlOutput("selected.measure")),
    
    conditionalPanel(condition = "output.disable_pareto == 1",
      htmlOutput("paretoMeasure1"),
      htmlOutput("paretoHighLow1"),
      # selectInput("highLowMeasure1", "Base Preference: Should the selected Value be preferably High or Low",
      #   choices = c("High", "Low"), selected = NULL),#"High"),
      htmlOutput("paretoMeasure2"),
      htmlOutput("paretoHighLow2"),
      # selectInput("highLowMeasure2", "Base Preference: Should the selected Value be preferably High or Low",
      #   choices = c("High", "Low"), selected = NULL),#"High"),
      htmlOutput("paretoType"),
      tags$div(title="Choose 'On' for showing all Pareto Levels, not only the first one", 
        selectInput("allLevels", "Show all Pareto Levels", choices = c("Off", "On"), selected = "Off", 
          multiple = FALSE, selectize = TRUE, width = '98%'))
      #prettySwitch(inputId = 'paretoPlotly', "Interactive (use Plotly)", value = FALSE)
    ),
    conditionalPanel(condition = "output.disable_pareto == 0",
      tags$div(title = "Order Values of the given Measure",
        selectInput("orderBest", "Ordering", choices = c("Off", "On"), selected = "Off", 
          multiple = FALSE, selectize = TRUE, width = '98%')),
      prettySwitch(inputId = 'paretoPlotly', "Interactive (use Plotly)", value = FALSE)
    ),
    
    hr(),
    
    tags$div(title="Choose 'On' for only showing 4 decimal places", 
      selectInput("roundOverview", "Round Values", choices = c("Off", "On"), selected = "On",
        multiple = FALSE, selectize = TRUE, width = '98%'))
  )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "basicsOverview",
        fluidRow(htmlOutput("overview_info"))
      ),
      
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
      
      # tabItem(tabName = "bestMod",
      # h2("Best Modell/Learner in BMR Analysis"),
      # br(),
      # fluidRow(infoBoxOutput("Data_Name"),
      #   infoBoxOutput("Method"),
      #   infoBoxOutput("Task")),
      # #hr(),
      # fluidRow(infoBoxOutput("Measure"),
      #   infoBoxOutput("Tuning"),
      #   infoBoxOutput("SMOTE")),
      # #hr(),
      # fluidRow(valueBoxOutput("Value")
      # )
      #   ),
      
      tabItem(tabName = "pareto",
        h2("Best Modell/Learner in BMR Analysis"),
        br(),
        conditionalPanel(condition = "output.disable_pareto == 1",
          br(),
          fluidRow(fillPage(box(width = 12, DT::dataTableOutput("paretoTab")))),
          br(),
          dropdownButton(
            fluidRow(
              column(12,
                h4("Change Plotting Options"),
                br(),
                numericInput("sizeSymbolsPareto", "Change Size of Symbols", value = 4, min = 1, max = 10, step = 1),
                br(),
                h4("Only when not interactive (Plotly):"),
                numericInput("sizeTextPareto", "Change Size of Text", value = 2, min = 1, max = 4, step = 0.5),
                numericInput("zoomPareto", "Change Height of Plot", value = 0.4, 
                  min = 0.05, max = 1, step = 0.05)
              )
              
            ),
            circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
            tooltip = tooltipOptions(title = "Click for Plot Settings")
          ),
          
          br(),
          
          conditionalPanel(condition = "input.paretoPlotly == false",
            fluidRow(fillPage(plotOutput("ggplot_pareto")))
          ),
          conditionalPanel(condition = "input.paretoPlotly == true",
            fluidRow(fillPage(plotlyOutput("plotly_pareto")))
          ),
          
          br(),
          br(),
          br(),
          br(),
          br(),
          br(),
          br(),
          
          prettySwitch(inputId = 'paretoInfo', "Show Information", value = FALSE),
          conditionalPanel(condition = "input.paretoInfo == true",
            fluidRow(htmlOutput("pareto_info")))
        ),
        
        conditionalPanel(condition = "output.disable_pareto == 0",
          h5("The following Method achieved the 'best' Value for the given Method (blue marked Point in Plot)."),
          h5("According to interpretational, computational or similar issues one may prefer one of the other Methods 
            shown in the Plot."),
          br(),
          fluidRow(infoBoxOutput("Data_Name"),
            infoBoxOutput("Method"),
            infoBoxOutput("Task")),
          # #hr(),
          fluidRow(infoBoxOutput("Measure"),
            infoBoxOutput("Tuning"),
            infoBoxOutput("SMOTE")),
          # #hr(),
          fluidRow(valueBoxOutput("Value")),
          
          br(),
          
          dropdownButton(
            fluidRow(
              column(12,
                h4("Change Plotting Options"),
                br(),
                numericInput("sizeSymbolsBest", "Change Size of Symbols", value = 4, min = 1, max = 10, step = 1),
                br(),
                h4("Only when not interactive (Plotly):"),
                numericInput("sizeTextBest", "Change Size of Text", value = 2, min = 1, max = 5, step = 0.5),
                numericInput("zoomBest", "Change Height of Plot", value = 0.4, 
                  min = 0.05, max = 1, step = 0.05)
              )
              
            ),
            circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
            tooltip = tooltipOptions(title = "Click for Plot Settings")
          ),
          
          br(),
          
          conditionalPanel(condition = "input.paretoPlotly == false",
            fluidRow(fillPage(plotOutput("ggplot_plot_bestMod")))
          ),
          conditionalPanel(condition = "input.paretoPlotly == true",
            fluidRow(fillPage(plotlyOutput("plotly_plot_bestMod")))
          )
          
        )
      )
    )
  )
)