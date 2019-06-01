tabpanel.iml = dashboardPage(
  dashboardHeader(),
  
  dashboardSidebar(
    sidebarMenu(id = "tabs",
      menuItem("Basics", tabName = "basics", icon = icon("pencil-alt")),
      menuItem("IML Methods", tabName = "iml_plots", icon = icon("map-marked-alt")),
      
      hr(),
      
      tags$div(title = "Select a Method for Interpretation of your Model", align = "center",
        selectInput("imlPlotType", "Select IML-Method", choices = c("Not Selected", "Feature Importance",
        "Feature Effect", "Feature Interaction", "Local Model (LIME)", "Shapley Values", "Tree Surrogate"))
        ),
      
      tags$div(title= "Plotting the Method with your selected Options",
        align = "center", uiOutput("iml.set")),
      
      tags$div(title= "Download the latest Plot",
        align = "center", downloadButton("imlDownload", "Download"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "basics",
        fluidRow(htmlOutput("iml_info"))
      ),
      
      tabItem(tabName = "iml_plots",
        
        textOutput("imlStartInfo"),
        br(),
        textOutput("imlDataInfo"),
        
        # Not Selected
        conditionalPanel("input.imlPlotType == 'Not Selected'",
          NULL
          ),
        
        # Feature Importance
        conditionalPanel("input.imlPlotType == 'Feature Importance'",
          dropdownButton(
            fluidRow(
              column(6,
                h3("Further Settings"),
                br(),
                
                conditionalPanel(condition = "output.modeltype == 'classif'",
                  selectInput("impLossClassif", "Choose Loss",
                    choices = c("ce", "f1", "logLoss"), 
                    #"accuracy", "auc", "fbeta_score", "ll", "precision","recall"
                    selected = "ce")
                ),
                conditionalPanel(condition = "output.modeltype == 'regr'",
                  selectInput("impLossRegr", "Choose Loss",
                    choices = c("mae", "mape", "mse", "msle", "percent_bias", 
                      "rae", "rmse", "rmsle", "rse", "rrse", "smape"),
                    #"ae", "ape", "se", "sle"
                    selected = "mse")
                ),
                
                selectInput("impComp", "Compare by", choices = c("ratio", "difference"), selected = "ratio"),
                
                numericInput("impRep", "Repetition of Shuffling", value = 5, min = 1, max = Inf, step = 1)#,
                
               # numericInput("impZoom", "Change Height of Plot", value = 0.25, 
                #  min = 0.05, max = 1, step = 0.05)
              ),
              
              column(6,
                h3("Information"),
                br(),
                h4("Loss"),
                textOutput("impLossInfo"),
                br(),
                h4("Comparison"),
                textOutput("impCompInfo"),
                br(),
                h4("Repetitions"),
                textOutput("impRepInfo")
              )
              
            ),
            circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
            tooltip = tooltipOptions(title = "Click for Settings")
          )
          ),
        
        # Feature Effect
        conditionalPanel("input.imlPlotType == 'Feature Effect'",
          dropdownButton(
            fluidRow(
              column(6,
                h3("Further Settings"),
                br(),
                
                htmlOutput("effectFeature1"),
                htmlOutput("effectFeature2"),
                
                selectInput("effMeth", "Select Method", 
                  choices = c("PDP", "ICE", "PDP + ICE", "ALE")),
                
                numericInput("effGrid", "Size of Grid for evaluating Predictions", 
                  value = 20, min = 1, max = Inf, step = 1),
                
                numericInput("effZoom", "Change Height of Plot", value = 0.25, 
                  min = 0.05, max = 1, step = 0.05)
                #numericInput("effCenter", "Center at", value = NULL, min = -Inf, max = Inf, step = 1)
              ),
              column(6,
                h3("Information"),
                br(),
                h4("Method"),
                textOutput("effMethodInfo"),
                br(),
                h4("Features"),
                textOutput("effFeatureInfo"),
                br(),
                h4("Grid Size"),
                textOutput("effGridInfo")
              )
            ),
            circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
            tooltip = tooltipOptions(title = "Click for Settings")
          )
          ),
        
        # Feature Interaction
        conditionalPanel("input.imlPlotType == 'Feature Interaction'",
          dropdownButton(
            fluidRow(
              column(6,
                h3("Further Settings"),
                br(),
                
                htmlOutput("interactionFeature"),
                
                numericInput("interactionGrid", "Grid Size: NO. of Values per Feature", 
                  value = 20, min = 1, max = Inf, step = 1)
              ),
              
              column(6,
                h3("Information"),
                br(),
                h4("Feature"),
                textOutput("intFeatureInfo"),
                br(),
                h4("Grid Size"),
                textOutput("intGridInfo")
              )
            ),
            circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
            tooltip = tooltipOptions(title = "Click for Settings")
          )
          ),
        
        # LIME
        conditionalPanel("input.imlPlotType == 'Local Model (LIME)'",
          dropdownButton(
            fluidRow(
              column(6,
                h3("Further Settings"),
                br(),
                
                htmlOutput("limeInterest"),
                
                htmlOutput("limeMaxFeatures"),
                
                htmlOutput("limeDistance")
              ),
              
              column(6,
                h3("Information"),
                br(),
                h4("Instance"),
                textOutput("limeInstanceInfo"),
                br(),
                h4("Max. Features"),
                textOutput("limeMaxFeaturesInfo"),
                br(),
                h4("Distance Function"),
                textOutput("limeDistanceInfo"),
                br(),
                h4("Kernel Width"),
                textOutput("limeKernelInfo")
              )   
            ),
            circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
            tooltip = tooltipOptions(title = "Click for Settings")
          )
          ),
        
        
        # Shapley
        conditionalPanel("input.imlPlotType == 'Shapley Values'",
          dropdownButton(
            fluidRow(
              column(6,
                h3("Further Settings"),
                br(),

                htmlOutput("shapleyInterest"),

                numericInput("shapleySample", "No. Monte Carlo Samples",
                  value = 100, min = 1, max = Inf, step = 1)
              ),

              column(6,
                h3("Information"),
                br(),
                h4("Instance"),
                textOutput("shapleyInstanceInfo"),
                br(),
                h4("Sample Size"),
                textOutput("shapleySampleInfo")
              )
            ),
            circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
            tooltip = tooltipOptions(title = "Click for Settings")
          )
          ),
        
        # Tree Surrogate
        conditionalPanel("input.imlPlotType == 'Tree Surrogate'",
          dropdownButton(
            fluidRow(
              column(6,
                h3("Further Settings"),
                br(),
                
                # htmlOutput("shapleyInterest"),
                
                numericInput("surrogateMaxDepth", "Max. Depth of Tree",
                  value = 5, min = 1, max = Inf, step = 1)
              ),
              
              column(6,
                h3("Information"),
                br(),
                h4("Instance"),
                textOutput("surrogateMaxDepthInfo"),
                br()
                # h4("Sample Size"),
                # textOutput("shapleySampleInfo")
              )
            ),
            circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
            tooltip = tooltipOptions(title = "Click for Settings")
          )
          ),
        
        br(),
        fluidRow(fillPage(addSpinner(plotOutput("iml_plotted")))), #or withSpinner()
        br(),
        prettySwitch(inputId = 'imlInfo', "Show Information", value = FALSE),
        conditionalPanel(condition = "input.imlInfo == true && input.imlPlotType == 'Feature Importance'",
          fluidRow(htmlOutput("imp_info"))),
        conditionalPanel(condition = "input.imlInfo == true && input.imlPlotType == 'Feature Effect' && input.effMeth == 'PDP'",
          fluidRow(htmlOutput("pdp_info"))),
        conditionalPanel(condition = "input.imlInfo == true && input.imlPlotType == 'Feature Effect' && input.effMeth == 'ICE'",
          fluidRow(htmlOutput("ice_info"))),
        conditionalPanel(condition = "input.imlInfo == true && input.imlPlotType == 'Feature Effect' && input.effMeth == 'ALE'",
          fluidRow(htmlOutput("ale_info"))),
        conditionalPanel(condition = "input.imlInfo == true && input.imlPlotType == 'Feature Interaction'",
          fluidRow(htmlOutput("interaction_info"))),
        conditionalPanel(condition = "input.imlInfo == true && input.imlPlotType == 'Local Model (LIME)'",
          fluidRow(htmlOutput("lime_info"))),
        conditionalPanel(condition = "input.imlInfo == true && input.imlPlotType == 'Shapley Values'",
          fluidRow(htmlOutput("shapley_info"))),
        conditionalPanel(condition = "input.imlInfo == true && input.imlPlotType == 'Tree Surrogate'",
          fluidRow(htmlOutput("surrogate_info")))
      )
    )
  )
)