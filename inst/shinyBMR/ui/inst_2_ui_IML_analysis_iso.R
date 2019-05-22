tabpanel.iml = dashboardPage(
  dashboardHeader(),
  dashboardSidebar(sidebarMenu(
    menuItem("Basics", tabName = "basics", icon = icon("pencil-alt")),#gavel
    hr(),
    menuItem("Feature Importance", tabName = "importance", icon = icon("dice-one")),
    menuItem("Feature Effect", tabName = "effect", icon = icon("dice-two")),
    menuItem("Feature Interaction", tabName = "interaction", icon = icon("dice-three")),
    menuItem("Local Model (LIME)", tabName = "lime", icon = icon("dice-four")),
    menuItem("Shapley Values", tabName = "shapley", icon = icon("dice-five")),
    
    prettySwitch(inputId = 'imlInfo', "Show Information", value = FALSE),
    hr(),
    div(align = "center", uiOutput("iml.parallel.ui")),
    hr(),
    div(align = "center", downloadButton("imlDownload", "Download"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "basics",
              fluidRow(htmlOutput("iml_info"))
            #  uiOutput("iml.parallel.ui")
              ),

############### Feature Importance      
      tabItem(tabName = "importance",
              dropdownButton(
                fluidRow(
                  column(6,
                         h3("Further Settings"),
                         br(),
                         
                         conditionalPanel(condition = "output.modeltype == 'classif'",
                                          #"output$modeltype == 1",
                                          #"getTaskDesc(modiml$mod)$type == 'classif'",
                                          selectInput("impLossClassif", "Choose Loss",
                                                      choices = c("ce", "f1", "logLoss"), 
                                                      #"accuracy", "auc", "fbeta_score", "ll", "precision","recall"
                                                      selected = "ce")
                         ),
                         conditionalPanel(condition = "output.modeltype == 'regr'",
                                          #"output$modeltype == 2",
                                          #"getTaskDesc(modiml$mod)$type == 'regr'",
                                          selectInput("impLossRegr", "Choose Loss",
                                                      choices = c("mae", "mape", "mse", "msle", "percent_bias", 
                                                                  "rae", "rmse", "rmsle", "rse", "rrse", "smape"),
                                                      #"ae", "ape", "se", "sle",
                                                      selected = "mse")
                         ),
                         
                         selectInput("impCompare", "Compare by", 
                                     choices = c("ratio", "difference"), 
                                     selected = "ratio"),
                         
                         numericInput("impRep", "Repetition of Shuffling", value = 5, min = 1, max = Inf, step = 1),
                         
                         numericInput("impZoom", "Change Height of Plot", value = 0.25, 
                                      min = 0.05, max = 1, step = 0.05)
                  ),
                  
                  column(6,
                         h3("Information"),
                         br(),
                         h4("Loss"),
                         textOutput("impLossInfo"),
                         br(),
                         h4("Comparison"),
                         textOutput("impCompareInfo"),
                         br(),
                         h4("Repetitions"),
                         textOutput("impRepInfo")
                         )
                  
                ),
                circle = TRUE, status = "info", icon = icon("gear"), #width = "300px",
                tooltip = tooltipOptions(title = "Click for Settings")
              ),
              br(),
              
              tabsetPanel(
                tabPanel("Plot: Feature Importance",
                         fluidRow(fillPage(plotOutput("importance_plot"))),
                         #fluidRow(fillPage(withSpinner(plotOutput("importance_plot")))),
                         conditionalPanel(condition = "input.imlInfo == true",
                                          fluidRow(htmlOutput("imp_info")))
                         
                        # conditionalPanel(condition = "input.iml.info == false",
                         #                  fluidRow(fillPage(plotOutput("importance_plot")))
                         #                  ),
                         # conditionalPanel(condition = "input.iml.info == true",
                         #                  fluidRow(fillPage(plotOutput("importance_plot"))),
                         #                  fluidRow(htmlOutput("imp_info")))
                )
              ,
              
              tabPanel("Summary: Feature Importance",
                       verbatimTextOutput("imp_summary"),
                       tags$head(tags$style("#imp_print{font-size:12px; font-style:italic; height:70vh !important;
                                            overflow-y:scroll; background: ghostwhite;}"))
              ),

              tabPanel("Results: Feature Importance",
                       verbatimTextOutput("imp_results"),
                       tags$head(tags$style("#imp_print{font-size:12px; font-style:italic; height:70vh !important;
                                            overflow-y:scroll; background: ghostwhite;}"))
                       )

             )
              
            ),

############### Feature Effect
      tabItem(tabName = "effect",
              dropdownButton(
                fluidRow(
                  column(6,
                         h3("Further Settings"),
                         br(),

                      htmlOutput("effectFeature1"),
                      htmlOutput("effectFeature2"),
                      
                      numericInput("effGrid", "Size of Grid for evaluating Predictions", 
                                   value = 20, min = 1, max = Inf, step = 1),
                      
                      numericInput("effZoom", "Change Height of Plot", value = 0.25, 
                                   min = 0.05, max = 1, step = 0.05)
                      # conditionalPanel(condition = "output.modeltype == 'classif'",
                      #                  numericInput("effCenterRegr", "Center at", value = NULL, min = 0, max = 1, step = 0.5)
                      # ),
                      # conditionalPanel(condition = "output.modeltype == 'regr'",
                      #                  numericInput("effCenterRegr", "Center at", value = NULL, min = -Inf, max = Inf, step = 0.5)
                      # )
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
              ),
              br(),
              
              tabsetPanel(
                tabPanel("Plot: PDP",
                         fluidRow(fillPage(withSpinner(plotOutput("pdp_plot")))),
                         conditionalPanel(condition = "input.imlInfo == true",
                                          fluidRow(htmlOutput("pdp_info")))
                ),
                tabPanel("Plot: ICE",
                         fluidRow(fillPage(withSpinner(plotOutput("ice_plot")))),
                         conditionalPanel(condition = "input.imlInfo == true",
                                          fluidRow(htmlOutput("ice_info")))
                ),
                tabPanel("Plot: PDP + ICE",
                         fluidRow(fillPage(withSpinner(plotOutput("pdp_ice_plot"))))
                ),
                tabPanel("Plot: ALE",
                         fluidRow(fillPage(withSpinner(plotOutput("ale_plot")))),
                         conditionalPanel(condition = "input.imlInfo == true",
                                          fluidRow(htmlOutput("ale_info")))
                )
              )
              
              ),

############### Feature Interaction  
tabItem(tabName = "interaction",
        dropdownButton(
          fluidRow(
            column(6,
                   h3("Further Settings"),
                   br(),
                   
                   htmlOutput("interactionFeature"),
                   
                   numericInput("interactionGrid", "Grid Size: NO. of Values per Feature", 
                                value = 20, min = 1, max = Inf, step = 1),
                   numericInput("interactionZoom", "Change Height of Plot", value = 0.25, 
                                min = 0.05, max = 1, step = 0.05)
                   #htmlOutput("limeMaxFeatures"),
                   
                   # htmlOutput("limeDistance")
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
        ),
        br(),
        
        tabsetPanel(
          tabPanel("Plot: Feature Interaction",
                   fluidRow(fillPage(withSpinner(plotOutput("interaction_plot")))),
                   conditionalPanel(condition = "input.imlInfo == true",
                                    fluidRow(htmlOutput("interaction_info")))
          )
        )
),

############### LIME     
tabItem(tabName = "lime",
        dropdownButton(
          fluidRow(
            column(6,
                   h3("Further Settings"),
                   br(),
                   
                   htmlOutput("limeInterest"),
                   
                   htmlOutput("limeMaxFeatures"),
                   
                   htmlOutput("limeDistance")
        #            
        #            conditionalPanel(condition = "output.modeltype == 'classif'",
        #                             #"output$modeltype == 1",
        #                             #"getTaskDesc(modiml$mod)$type == 'classif'",
        #                             selectInput("impLossClassif", "Choose Loss",
        #                                         choices = c("ce", "f1", "logLoss"), 
        #                                         #"accuracy", "auc", "fbeta_score", "ll", "precision","recall"
        #                                         selected = "ce")
        #            ),
        #            conditionalPanel(condition = "output.modeltype == 'regr'",
        #                             #"output$modeltype == 2",
        #                             #"getTaskDesc(modiml$mod)$type == 'regr'",
        #                             selectInput("impLossRegr", "Choose Loss",
        #                                         choices = c("mae", "mape", "mse", "msle", "percent_bias", 
        #                                                     "rae", "rmse", "rmsle", "rse", "rrse", "smape"),
        #                                         #"ae", "ape", "se", "sle",
        #                                         selected = "mse")
        #            ),
        #            
        #            selectInput("impCompare", "Compare by", 
        #                        choices = c("ratio", "difference"), 
        #                        selected = "ratio"),
        #            
        #            numericInput("impRep", "Repetition of Shuffling", value = 5, min = 1, max = Inf, step = 1),
        #            
        #            numericInput("impZoom", "Change Height of Plot", value = 0.25, 
        #                         min = 0.05, max = 1, step = 0.05)
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
        ),
        br(),

        tabsetPanel(
          tabPanel("Plot: LIME",
                   fluidRow(fillPage(withSpinner(plotOutput("lime_plot")))),
                   conditionalPanel(condition = "input.imlInfo == true",
                                    fluidRow(htmlOutput("lime_info")))
          )
        #   ,
        #   
        #   tabPanel("Summary: Feature Importance",
        #            verbatimTextOutput("imp_summary"),
        #            tags$head(tags$style("#imp_print{font-size:12px; font-style:italic; height:70vh !important;
        #                                 overflow-y:scroll; background: ghostwhite;}"))
        #            ),
        #   
        #   tabPanel("Results: Feature Importance",
        #            verbatimTextOutput("imp_results"),
        #            tags$head(tags$style("#imp_print{font-size:12px; font-style:italic; height:70vh !important;
        #                                 overflow-y:scroll; background: ghostwhite;}"))
        #            )
        #   
          )
        
        ),
############### Shapley Values   
tabItem(tabName = "shapley",
        dropdownButton(
          fluidRow(
            column(6,
                   h3("Further Settings"),
                   br(),
                   
                   htmlOutput("shapleyInterest"),
                   
                   numericInput("shapleySample", "No. Monte Carlo Samples", 
                                value = 100, min = 1, max = Inf, step = 1)
                   #htmlOutput("limeMaxFeatures"),
                   
                  # htmlOutput("limeDistance")
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
        ),
        br(),
        
        tabsetPanel(
          tabPanel("Plot: Shapley Values",
                   fluidRow(fillPage(withSpinner(plotOutput("shapley_plot")))),
                   conditionalPanel(condition = "input.imlInfo == true",
                                    fluidRow(htmlOutput("shapley_info")))
          )
        )
        )



      
    )
  )
)
