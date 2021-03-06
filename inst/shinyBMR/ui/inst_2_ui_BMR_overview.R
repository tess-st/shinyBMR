#####################################################################################################################
# UI: BMR Overview
#####################################################################################################################

tabpanel.overview =  dashboardPage(
  
  dashboardHeader(),
  
  dashboardSidebar(sidebarMenu(id = "tabs_overview",
    menuItem("Basics", tabName = "basicsOverview", icon = icon("pencil-alt"), selected = TRUE),
    hr(),
    menuItem("Summary BMR", tabName = "summaryBMR", icon = icon("cubes")),
    menuItem("'Best' BMR-Model", tabName = "pareto", icon = icon("cube")),
    
    hr(),
    
    tags$div(title = "Select one of the Measures you performed the Benchmark-Study on",
      htmlOutput("selected.measure")),
    
    conditionalPanel(condition = "output.disable_pareto == 1",
      htmlOutput("paretoMeasure1"),
      htmlOutput("paretoMeasure2"),
      htmlOutput("paretoType"),
      tags$div(title="Choose 'On' for showing all Pareto Levels, not only the first one", 
        selectInput("allLevels", "Show all Pareto Levels in Tab.", choices = c("Off", "On"), selected = "Off", 
          multiple = FALSE, selectize = TRUE, width = '98%'))
      #prettySwitch(inputId = 'paretoPlotly', "Interactive (use Plotly)", value = FALSE)
    ),
    conditionalPanel(condition = "output.disable_pareto == 0",
      tags$div(title = "Order Values of the given Measure",
        selectInput("orderBest", "Ordering", choices = c("Off", "On"), selected = "Off", 
          multiple = FALSE, selectize = TRUE, width = '98%'))
      #prettySwitch(inputId = 'paretoPlotly', "Interactive (use Plotly)", value = FALSE)
    ),
    
    hr(),
    
    tags$div(title="Choose 'On' for only showing 4 decimal places", 
      selectInput("roundOverview", "Round Values", choices = c("Off", "On"), selected = "On",
        multiple = FALSE, selectize = TRUE, width = '98%')),
    prettySwitch(inputId = 'paretoPlotly', "Interactive (use Plotly)", value = FALSE)
  )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "basicsOverview",
        fluidRow(htmlOutput("overview_info"))
      ),
      
      # Summary
      tabItem(tabName = "summaryBMR",
        h2("Summary of the Benchmark Analysis"),
        textOutput("bmrSummaryInfo"),
        
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
          
          # Tuning Results
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
          
          # Cross Tables
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
        )
      ),
      
      # Pareto
      tabItem(tabName = "pareto",
        h2("Best Modell/Learner in BMR Analysis"),
        textOutput("bmrModelInfo"),
        
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
            circle = TRUE, status = "info", icon = icon("gear"), 
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
          
          h5("Pareto Set by definition strict dominant in one dimension vs. Intersection Preference with strict
            dominance in both dimensions."),
          prettySwitch(inputId = 'paretoInfo', "Show more Information", value = FALSE),
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
          fluidRow(infoBoxOutput("Measure"),
            infoBoxOutput("Tuning"),
            infoBoxOutput("SMOTE")),
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
            circle = TRUE, status = "info", icon = icon("gear"),
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