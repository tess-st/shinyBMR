tabpanel.bmr = dashboardPage(
  dashboardHeader(),
  dashboardSidebar(sidebarMenu(id = "sidebarmenu",
    menuItem("Settings", tabName = "bmr_settings", icon = icon("pencil-alt")),
    
    hr(),
    
    menuItem("Boxplot", tabName = "boxplot", icon = icon("mortar-board")),
    menuItem("Heatmap", tabName = "heatmap", icon = icon("thermometer-2")),
    menuItem("PCP", tabName = "pcp", icon = icon("connectdevelop")),
    tags$div(title = "Use aggregated Data of the BMR",
      selectInput("aggregate", "Aggregated BMR",
        choices = c("On", "Off"), selected = "On", multiple=F, selectize=TRUE,
        width = '98%')),
    prettySwitch(inputId = 'type', "Interactive (use Plotly)", value = FALSE),
    
    hr(),
    
    menuItem("mlr: Implemented Plots", tabName = "plotMLR"),
    
    hr(),
    
    tags$div(title = "Select one of the Measures you performed the Benchmark-Study on",
      htmlOutput("selected.measure.ana")),
    tags$div(title = "Order Means of Value for grouping by Learner and Learner.Info",
      selectInput("ordering", "Ordering",
        choices = c("Off", "On"), selected = "Off", multiple=F, selectize=TRUE,
        width = '98%')),
    #h6("~ not for plots implemented in 'mlr' ~"),
    hr(),
    
    div(align = "center", downloadButton("download", "Download"))
  )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "boxplot",
        h2("Boxplots for Performance Comparison"),
        dropdownButton(
          fluidRow(
            column(4,
              h4("Change Plotting Options"),
              br(),
              selectInput("colPaletteB", "Color Palette", 
                choices = c("Default", "Pastel1", "Dark2", "Dark3", "Set2", "Set3",
                  "Warm", "Cold", "Harmonic", "Dynamic", 
                  "Coolwarm", "Parula", "Viridis", "Tol.Rainbow"), 
                #https://cran.r-project.org/web/packages/pals/vignettes/pals_examples.html
                selected = "Default"),
              numericInput("sizeSymbolsB", "Change Size of Symbols", value = 5, min = 1, max = 10, step = 1),
              selectInput("jitterSymbols", "Add random Variation (Points)",
                choices = c("Off", "On"), selected = "Off"),
              selectInput("addLines", "Add Line per Group of Learner Information",
                choices = c("On", "Off"), selected = "On"),
              uiOutput("sliderBoxplot")
              
              #sliderInput("rangeYaxisB", "Range y-Axis", value = c(0,1), min = 0, max = 10, step = 0.05)
              #htmlOutput("rangeEndB")
              #numericInput("rangeEndB", "Choose the upper Limit of the selected Value",
              #  value = 10, min = 0, max = Inf, step = 1)
            ),
            column(4,
              h4("Change Labels"), 
              br(),
              textInput("labelXlabB", "Label of x-Axis", value = "Learner"),
              textInput("labelYlabB", "Label of y-Axis", value = "Value"),
              textInput("labelSymbolB", "Label of Symbol Legend", value = "Value")
            ),
            column(4, 
              h4("Change Size (not for interactive Plot)"),
              numericInput("sizeTextB", "Change Size of Text", value = 2, min = 1, max = 5, step = 0.5),
              numericInput("zoomB", "Change Height of Plot", value = 0.4, 
                min = 0.05, max = 1, step = 0.05)
            )
            
          ),
          circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
          tooltip = tooltipOptions(title = "Click for Plot Settings")
        ),
        
        br(),
        
        conditionalPanel(condition = "input.type == false",
          fluidRow(fillPage(plotOutput("ggplot")))),
        conditionalPanel(condition = "input.type == true",
          fluidRow(fillPage(plotlyOutput("plotly", height = "100%"))))
      ),
      
      tabItem(tabName = "heatmap",
        h2("Heatmap for Performance Comparison"),
        dropdownButton(
          fluidRow(
            column(4, 
              h4("Change Colors"),
              br(),
              colourInput("colTextH", "Colour of Value in Plot", "grey", showColour = "background"),
              colourInput("colMaxH", "Maximum Colour", "#56B1F7", showColour = "background"),
              colourInput("colMinH", "Minimum Colour", "#132B43", showColour = "background"),
              uiOutput("rangeHeatmap")
            ),
            column(4,
              h4("Change Labels"), 
              br(),
              textInput("labelValueH", "Label of Value/Legend", value = "Value"),
              textInput("labelXlabH", "Label of x-Axis", value = "Learner Info"),
              textInput("labelYlabH", "Label of y-Axis", value = "Learner")
            ),
            column(4, 
              h4("Change Size (not for interactive Plot)"),
              numericInput("sizeTextH", "Change Size of Text", value = 2, min = 1, max = 5, step = 0.5),
              numericInput("zoomH", "Change Height of Plot", value = 0.4, 
                min = 0.05, max = 1, step = 0.05)
            )
          ),
          circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
          tooltip = tooltipOptions(title = "Click for Plot Settings")
        ),
        
        br(),
        
        conditionalPanel(condition = "input.type == false",
          fluidRow(fillPage(plotOutput("ggplot_heatmap")))),
        conditionalPanel(condition = "input.type == true",
          fluidRow(fillPage(plotlyOutput("plotly_heatmap"))))
      ),
      
      tabItem(tabName = "pcp",
        h2("Parallel Coordinates Plot"),
        dropdownButton(
          fluidRow(
            column(4,
              h4("Change Plotting Options"),
              br(),
              selectInput("colPalettePcp", "Color Palette", 
                choices = c("Default", "Pastel1", "Dark2", "Dark3", "Set2", "Set3",
                  "Warm", "Cold", "Harmonic", "Dynamic", 
                  "Coolwarm", "Parula", "Viridis", "Tol.Rainbow"), 
                #https://cran.r-project.org/web/packages/pals/vignettes/pals_examples.html
                selected = "Default")
              # numericInput("sizeSymbolsB", "Change Size of Symbols", value = 5, min = 1, max = 10, step = 1),
              # selectInput("jitterSymbols", "Add random Variation (Points)",
              #   choices = c("Off", "On"), selected = "Off"),
              # selectInput("addLines", "Add Line per Group of Learner Information",
              #   choices = c("On", "Off"), selected = "On"),
              # uiOutput("sliderBoxplot")
            ),
            column(4,
             h4("Change Labels"), 
             br(),
             textInput("labelXlabPcp", "Label of x-Axis", value = "Measure"),
             textInput("labelYlabPcp", "Label of y-Axis", value = "Value")
            #   textInput("labelSymbolB", "Label of Symbol Legend", value = "Value")
           ), 
            column(4, 
             h4("Change Size (not for interactive Plot)"),
             numericInput("sizeTextPcp", "Change Size of Text", value = 2, min = 1, max = 5, step = 0.5),
             numericInput("zoomPcp", "Change Height of Plot", value = 0.4, 
               min = 0.05, max = 1, step = 0.05)
            )
            
          ),
          circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
          tooltip = tooltipOptions(title = "Click for Plot Settings")
        ),
        
        br(),
        
        conditionalPanel(condition = "output.disable_pcp",
          fluidRow(fillPage(plotOutput("ggplot_pcp")))
          )
        ),
      
      tabItem(tabName = "plotMLR",
        h2("Boxplots: Distribution of Performance Values across Resampling Iterations (unagg. data)"),
        
        dropdownButton(
          fluidRow(
            column(4,
              h4("Change Plotting Options"),
              br(),
              selectInput("colPaletteMlr", "Color Palette",
                choices = c("Default", "Pastel1", "Dark2", "Dark3", "Set2", "Set3",
                  "Warm", "Cold", "Harmonic", "Dynamic",
                  "Coolwarm", "Parula", "Viridis", "Tol.Rainbow"),
                selected = "Default"),
              selectInput("stylePlot", "Type of Plot",
                choices = c("box", "violin"), selected = "box")
            ),
            
            column(4, 
              h4("Change Size (not for interactive Plot)"),
              numericInput("sizeTextMlr", "Change Size of Text", value = 3, min = 1, max = 10, step = 1),
              numericInput("zoomMlr", "Change Height of Plot", value = 0.4, 
                min = 0.05, max = 1, step = 0.05)
            )
            
          ),
          circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
          tooltip = tooltipOptions(title = "Click for Plot Settings")
        ),
        
        br(),
        tabsetPanel(
          tabPanel("Boxplot mlr", 
            fluidRow(fillPage(plotOutput("mlr_boxplot")))
          )
        )
      )
    )
  )
)