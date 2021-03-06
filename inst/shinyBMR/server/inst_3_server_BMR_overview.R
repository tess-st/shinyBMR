#####################################################################################################################
# Preparation Overview
#####################################################################################################################

# Show/hide elements with Info Text
observe({
  if(!is.null(data$data)){
    shinyjs::hide("help_summary", animType = "fade")
    shinyjs::hide("help_tuning", animType = "fade")
    shinyjs::hide("help_tables", animType = "fade")
    # InfoBox
    shinyjs::show("Data_Names", anim = TRUE)
    shinyjs::show("Methods", anim = TRUE)
    shinyjs::show("Tasks", anim = TRUE)
    shinyjs::show("Measures", anim = TRUE)
    shinyjs::show("Tunings", anim = TRUE)
    shinyjs::show("SMOTEs", anim = TRUE)
    shinyjs::show("Values", anim = TRUE)
    # ValueBox
    shinyjs::show("Data_Names_Lev", anim = TRUE)
    shinyjs::show("Methods_Lev", anim = TRUE)
    shinyjs::show("Tasks_Lev", anim = TRUE)
    shinyjs::show("Measures_Lev", anim = TRUE)
    shinyjs::show("Tunings_Lev", anim = TRUE)
    shinyjs::show("SMOTEs_Lev", anim = TRUE)
    shinyjs::show("Values_Lev", anim = TRUE)
    # Tuning
    shinyjs::show("summary.tune", anim = TRUE)
    # Cross Tables
    shinyjs::show("crossTables", anim = TRUE)
  }
  else{
    shinyjs::show("help_summary", anim = TRUE)
    shinyjs::show("help_tuning", anim = TRUE)
    shinyjs::show("help_tables", anim = TRUE)
    # InfoBox
    shinyjs::hide("Data_Names", animType = "fade")
    shinyjs::hide("Methods", animType = "fade")
    shinyjs::hide("Tasks", animType = "fade")
    shinyjs::hide("Measures", animType = "fade")
    shinyjs::hide("Tunings", animType = "fade")
    shinyjs::hide("SMOTEs", animType = "fade")
    shinyjs::hide("Values", animType = "fade")
    # ValueBox
    shinyjs::hide("Data_Names_Lev", animType = "fade")
    shinyjs::hide("Methods_Lev", animType = "fade")
    shinyjs::hide("Tasks_Lev", animType = "fade")
    shinyjs::hide("Measures_Lev", animType = "fade")
    shinyjs::hide("Tunings_Lev", animType = "fade")
    shinyjs::hide("SMOTEs_Lev", animType = "fade")
    shinyjs::hide("Values_Lev", animType = "fade")
    # Tuning
    shinyjs::hide("summary.tune", animType = "fade")
    # Cross Tables
    shinyjs::hide("crossTables", animType = "fade")
  }
})

# Global Settings for BMR Overview
observeEvent(input$tabs_overview, {
  if(input$tabs_bmr == "basicsOverview"){
    shinyjs::hide("selected.measure", animType = "fade")
    shinyjs::hide("paretoMeasure1", animType = "fade")
    shinyjs::hide("paretoMeasure2", animType = "fade")
    shinyjs::hide("allLevels", animType = "fade")
    shinyjs::hide("paretoPlotly", animType = "fade")
    shinyjs::hide("orderBest", animType = "fade")
    shinyjs::hide("paretoType", animType = "fade")
    shinyjs::hide("roundOverview", animType = "fade")
  }
  else if(input$tabs_bmr == "summaryBMR"){  
    shinyjs::show("selected.measure", anim = TRUE)
    shinyjs::hide("paretoMeasure1", animType = "fade")
    shinyjs::hide("paretoMeasure2", animType = "fade")
    shinyjs::hide("allLevels", animType = "fade")
    shinyjs::hide("paretoPlotly", animType = "fade")
    shinyjs::hide("orderBest", animType = "fade")
    shinyjs::hide("paretoType", animType = "fade")
    shinyjs::hide("roundOverview", animType = "fade")
  }
  else if(input$tabs_bmr == "pareto"){
    shinyjs::hide("selected.measure", animType = "fade")
    shinyjs::show("paretoMeasure1", anim = TRUE)
    shinyjs::show("paretoMeasure2", anim = TRUE)
    shinyjs::show("allLevels", anim = TRUE)
    shinyjs::show("paretoPlotly", anim = TRUE)
    shinyjs::show("orderBest", anim = TRUE)
    shinyjs::show("paretoType", anim = TRUE)
    shinyjs::show("roundOverview", anim = TRUE)
  }
})

# Initialize InfoBox and ValueBox
measure <- reactive({
  req(data$data)
  if(is.null(data$data)){
    names <- NULL
  }
  else{
    data <- perfAggDf(data$data)
    pos <- grep("measure_*", names(data))
    names <- NA
    for(i in 1:length(pos)){
      names[i] <- data[1,pos[i]]
    }
  }
  return(names)
})

measure2 <- reactive({
  req(data$data)
  if(is.null(data$data)){
    names <- NULL
  }
  else{
    data <- perfAggDf(data$data)
    pos <- grep("measure_*", names(data))
    names <- NA
    for(i in 1:length(pos)){
      names[i] <- data[1,pos[i]]
    }
  }
  return(names)
})

output$selected.measure <- renderUI({
  selectizeInput("select.measure", "Choose Measure to be focused", 
    choices = as.list(measure()),
    multiple = FALSE)#, selected = NULL)
})

measureName <- reactive({
  req(input$select.measure) 
  best <- bestPerfMod(perfAggDf(data$data))
  if(input$select.measure == "Not Selected"){
    NULL
  }
  else{
    return(best$value_1)
    pos <- findValue(data = perfAggDf(data$data), measure = input$select.measure)
    name <- names(perfAggDf(data$data))[pos]
    return(paste(input$select.measure," (",name,")", sep = ""))
  }
})

valuesOfMeasure <- reactive({
  req(input$select.measure) 
  if(input$select.measure == "Not Selected"){
    return("No Measure Selected")
  }
  else{
    pos <- findValue(data = perfAggDf(data$data), measure = input$select.measure)
    if(input$roundOverview == "Off"){
      min <- min(perfAggDf(data$data)[,pos])
      max <- max(perfAggDf(data$data)[,pos])
    }
    else{
      min <- format(round(min(perfAggDf(data$data)[,pos]), digits = 3), nsmall = 3)
      max <- format(round(max(perfAggDf(data$data)[,pos]), digits = 3), nsmall = 3)
    }
    return(paste(min, max, sep = " - "))
  }
})

bestValueOfMeasure <- reactive({
  best <- bestPerfMod(perfAggDf(data$data))
  value <- best[1, "value_1"]
  if(input$roundOverview == "Off"){
    return(value)
  }
  else if(input$roundOverview == "On"){
    return(format(round(value, digits = 3), nsmall = 3))
  }
})


#####################################################################################################################
# Summary
#####################################################################################################################

# InfoBox
output$Data_Names <- renderInfoBox({
  infoBox("Data Set(s)", textInfobox(perfAggDf(data$data)$task.id), icon = icon ("address-card"),
    color = "navy")
})

output$Methods <- renderInfoBox({
  infoBox("Method(s)", textInfobox(perfAggDf(data$data)$learner), icon = icon ("cut"),
    color = "blue")
})

output$Tasks <- renderInfoBox({
  infoBox("Task(s)", textInfobox(perfAggDf(data$data)$classif.reg), icon = icon ("pen-fancy"),
    color = "aqua")
})

output$Measures <- renderInfoBox({
  infoBox("Measure(s)", textInfoboxMeasure(perfAggDf(data$data)), icon = icon ("chart-bar"),
    color = "navy")
})

output$Tunings <- renderInfoBox({
  infoBox("Tuning Levels", textInfobox(perfAggDf(data$data)$tuning), icon = icon ("chart-line"),
    color = "blue")
})

output$SMOTEs <- renderInfoBox({
  infoBox("SMOTE Levels", textInfobox(perfAggDf(data$data)$smote), icon = icon ("search-plus"),
    color = "aqua")
})

output$Values <- renderInfoBox({
  infoBox("Values of selected Measure (min-max)", measureName(), icon = icon ("battery-three-quarters"),
    color = "navy")
})


# ValueBox
output$Data_Names_Lev <- renderValueBox({
  valueBox(tags$p("DATA SET(S)", style = "font-size: 55%;"), 
    tags$p(nlevels(perfAggDf(data$data)$task.id), style = "font-size: 150%;"), 
    icon = icon("address-card"), color = "navy")
})

output$Methods_Lev <- renderValueBox({
  valueBox(tags$p("METHOD(S)", style = "font-size: 55%;"), 
    tags$p(nlevels(perfAggDf(data$data)$learner), style = "font-size: 150%;"),
    icon = icon("cut"), color = "blue")
})

output$Tasks_Lev <- renderValueBox({
  valueBox(tags$p("TASK(S)", style = "font-size: 55%;"), 
    tags$p(length(unique(perfAggDf(data$data)$classif.reg)), style = "font-size: 150%;"),
    icon = icon("pen-fancy"), color = "aqua")
})

output$Measures_Lev <- renderValueBox({
  valueBox(tags$p("MEASURE(S)", style = "font-size: 55%;"), 
    tags$p(sapply(strsplit(textInfoboxMeasure(perfAggDf(data$data)), ", "), length), style = "font-size: 150%;"),
    icon = icon("chart-bar"), color = "navy")
})

output$Tunings_Lev <- renderValueBox({
  valueBox(tags$p("TUNING LEVELS", style = "font-size: 55%;"), 
    tags$p(nlevels(perfAggDf(data$data)$tuning), style = "font-size: 150%;"),
    icon = icon ("chart-line"), color = "blue")
})

output$SMOTEs_Lev <- renderValueBox({
  valueBox(tags$p("SMOTE LEVELS", style = "font-size: 55%;"),
    tags$p(nlevels(perfAggDf(data$data)$smote), style = "font-size: 150%;"),
    icon = icon ("search-plus"), color = "aqua")
})

output$Values_Lev <- renderValueBox({
  valueBox(tags$p("Values of selected Measure (min-max)", style = "font-size: 55%;"),
    tags$p(valuesOfMeasure(), 
      style = "font-size: 150%;"),
    icon = icon ("battery-three-quarters"), color = "navy")
})


#####################################################################################################################
# Tuning Results
#####################################################################################################################

# Tuning Summary
summarize.tune = reactive({
  if(is.null(data$bmr)){
    NULL
  }
  else{
    d = getBMRTuneResults(data$bmr, as.df = TRUE) 
    
    validate(need(class(d) == "data.frame", "You didn't import any Data yet."))
    colnames(d) = make.names(colnames(d))
    pos.x = colnames(Filter(function(x) "POSIXt" %in% class(x) , d))
    d = dropNamed(d, drop = pos.x)    
    if(input$roundOverview == "Off"){
      tuning <- d
    }
    else{
      tuning <- roundDf(d, digits = 3, nsmall = 3)
    }
    
    tuning
  }
})

output$summary.tune = renderUI({
  # validate(need(data$bmr, "You didn't import any Data yet."))
  ui = box(width = 12, title = "Summary Tuning",
    br(),
    DT::dataTableOutput("summary.tuning")
  )
  ui
})

output$summary.tuning = DT::renderDataTable({
  summarize.tune()
}, options = list(scrollX = TRUE), server = F, selection = "single")


# Tuning Plots
selected.learner = eventReactive(input$summary.tuning_rows_selected, {
  #reqAndAssign(data$bmr, "d")
  # if(is.null(data$bmr)){
  #   NULL
  # }
  #  else{
  #  d = getBMRTuneResults(data$bmr, as.df = TRUE) 
  #d = getBMRTuneResults(d, as.df = T)
  #pos.x = colnames(Filter(function(x) "POSIXt" %in% class(x) , d))
  #d = dropNamed(d, drop = pos.x)
  # if(input$par.dep == "On"){
  #   partial.dep <- TRUE
  # }
  # else{
  #   partial.dep <- FALSE
  # }
  
  l = getBMRTuneResults(data$bmr) #data$bmr
  unlist <- unlist(l, recursive = FALSE)
  l2 <- Filter(Negate(is.null), unlist)
  unlist2 <- unlist(l2, recursive = FALSE)
  element <- unlist2[input$summary.tuning_rows_selected][[1]]
  eff <- generateHyperParsEffectData(element, partial.dep = T)#partial.dep())
  # Because of bug in function generateHyperParsEffectData
  if(any(names(eff) == "rmse.test.rmse")){
    names(eff$data)[names(eff$data)=="rmse.test.rmse"] <- "rmse.test.mean"
    t1$measures[eff$measures=="rmse.test.rmse"] <- "rmse.test.mean"
  }
  eff
})

output$hyperPars <- renderUI({
  list(
    column(3,
      selectizeInput("xAxisT", "Specify x-Axis (necessary)",
        choices = c('Not Selected', as.list(names(selected.learner()$data))),
        selected = NULL, multiple = FALSE)
    ),
    column(3,
      selectizeInput("yAxisT", "Specify y-Axis (necessary)",
        choices = c('Not Selected', as.list(names(selected.learner()$data))),
        selected = NULL, multiple = FALSE)
    ),
    column(3,
      selectizeInput("zAxisT", "Specify z-Axis (optional)",
        choices = c('Not Selected', as.list(names(selected.learner()$data))),
        selected = NULL, multiple = FALSE)
    )
    # column(3,
    #   selectInput("par.dep", "Partial Dependence", choices = c("On", "Off"), selected = "On")
    # )
  )
})

# partial.dependence <- reactive({
#   req(input$par.dep)
#   if(input$par.dep == "On"){
#     partial.dep <- TRUE
#   }
#   else{
#     partial.dep <- FALSE
#   }
# })

xaxis_T <- reactive({
  validate(
    need(input$xAxisT != "Not Selected", "Please choose what should be plotted on the x-Axis for showing 
      the Tuning Results")
    )
  if(input$xAxisT == "Not Selected"){
    NULL
  }
  else{
    req(input$xAxisT)
  }
})

yaxis_T <- reactive({
  validate(
    need(input$yAxisT != "Not Selected", "Please choose what should be plotted on the y-Axis for showing 
      the Tuning Results")
    )
  if(input$yAxisT == "Not Selected"){
    NULL
  }
  else{
    req(input$yAxisT)
  }
})

zaxis_T <- reactive({
  if(input$zAxisT == "Not Selected"){
    NULL
  }
  else{
    req(input$zAxisT)
  }
})

output$plot.hyperPars <- renderPlot({
  req(input$summary.tuning_rows_selected)
  
  plotHyperParsEffect(selected.learner(), x = xaxis_T(), y = yaxis_T(), z = zaxis_T(),
    partial.dep.learn = "regr.bst")
})

# output$tuneResults <- renderPrint({
#   getBMRTuneResults(data$bmr)
# })


#####################################################################################################################
# Cross Tables
#####################################################################################################################

output$selectionTable1 <- renderUI({
  if(is.null(data$data)){
    NULL
  }
  else{
    selectizeInput("table1", "First Table Element", 
      choices = c('Not Selected', as.list(names(tabImport(perfAggDf(data$data))))),
      multiple = FALSE, selected = NULL)
  }
})

output$selectionTable2 <- renderUI({
  if(is.null(data$data)){
    NULL
  }
  else{
    selectizeInput("table2", "Second Table Element", 
      choices = c('Not Selected', as.list(names(tabImport(perfAggDf(data$data))))),
      multiple = FALSE, selected = NULL)
  }
})

output$selectionTable3 <- renderUI({
  if(is.null(data$data)){
    NULL
  }
  else{
    selectizeInput("table3", "Third Table Element", 
      choices = c('Not Selected', as.list(names(tabImport(perfAggDf(data$data))))),
      multiple = FALSE, selected = NULL)
  }
})

var1 <- reactive({
  req(input$table1)
})

var2 <- reactive({
  req(input$table2)
})

var3 <- reactive({
  req(input$table3)
})

output$crossTables <- renderPrint({
  validate(need(data$data, "You didn't import any Data yet."))
  dataset <- tabImport(perfAggDf(data$data))
  var1 <- var1()
  var2 <- var2()
  var3 <- var3()
  vec <- c(var1, var2, var3)
  position <- c(NULL, NULL)
  
  crossTab(dataset, vec, position)
})



#####################################################################################################################
#################################################### Best Model #####################################################
#####################################################################################################################

# Best Model Listing
best <- reactive({
  req(data$data)
  bestPerfMod(dat = perfAggDf(data$data))
})

output$Data_Name <- renderInfoBox({
  infoBox("Name of Data", best()$task.id, icon = icon("address-card"),
    color = "navy")
})

output$Method <- renderInfoBox({
  infoBox("Method", best()$learner, icon = icon("cut"),
    color = "blue")
})

output$Task <- renderInfoBox({
  infoBox("Task", best()$classif.reg, icon = icon("pen-fancy"),
    color = "aqua")
})

output$Measure <- renderInfoBox({
  infoBox("Measure", bestPerfMod(perfAggDf(data$data))$measure_1, icon = icon("chart-bar"), 
    color = "navy")
})

output$Tuning <- renderInfoBox({
  infoBox("Tuning", best()$tuning, icon = icon ("chart-line"),
    color = "blue")
})

output$SMOTE <- renderInfoBox({
  infoBox("SMOTE", best()$smote, icon = icon ("search-plus"),
    color = "aqua")
})

output$Value <- renderValueBox({
  valueBox(tags$p("Value of selected Measure", style = "font-size: 55%;"), 
    tags$p(bestValueOfMeasure(),
      style = "font-size: 150%;"), 
    icon = icon("battery-three-quarters"), color = "navy") 
})

# Best Model Plot
size_text_Best <- reactive({
  size <- req(input$sizeTextBest)
  if(input$paretoPlotly){
    size <- -1
  }
  return(size)
})

dat_best <- reactive({
  req(data$data)
  req(input$orderBest)
  dat <- perfAggDf(data$data)
  if(input$orderBest == "On"){
    data <- dat[order(dat$value_1, dat$complete), ]
    data$complete <- as.factor(data$complete)
    data$complete <- ordered(data$complete, levels = data$complete)
  }
  else if(input$orderBest == "Off"){
    data <- dat
    data$complete <- as.factor(data$complete)
  }
  return(data)
})

output$ggplot_plot_bestMod <- renderPlot({
  dat <- dat_best()
  bestModPlot(dat, size_text = size_text_Best(), size_symbols = input$sizeSymbolsBest)
},height = function() {
  input$zoomBest * session$clientData$output_ggplot_plot_bestMod_width
})

output$plotly_plot_bestMod <- renderPlotly({
  dat <- dat_best()
  ggplotly(bestModPlot(dat, size_text = size_text_Best(), size_symbols = input$sizeSymbolsBest))
})


#####################################################################################################################
# Pareto 
#####################################################################################################################

output$disable_pareto <- reactive({
  req(data$data)
  if(length(grep("value", names(perfAggDf(getBMRAggrPerformances(data$bmr, as.df = T))))) > 1) 1 else 0
})
outputOptions(output, "disable_pareto", suspendWhenHidden = FALSE)

measure <- reactive({
  req(data$data)
  if(is.null(data$data)){
    names <- NULL
  }
  else{
    data <- perfAggDf(data$data)
    pos <- grep("measure_*", names(data))
    names <- NA
    for(i in 1:length(pos)){
      names[i] <- data[1,pos[i]]
    }
  }
  return(names)
})

output$paretoMeasure1 <- renderUI({
  req(measure())
  if(is.null(measure())){NULL}
  else{
    
    selectizeInput("pareto.measure1", "Choose Measure to be focused", 
      choices = measure(),
      multiple = FALSE)
  }
})

output$paretoMeasure2 <- renderUI({
  req(measure())
  if(is.null(measure())){NULL}
  else{
    selectizeInput("pareto.measure2", "Choose Measure to be focused", 
      choices = measure2(),
      multiple = FALSE)
  }
})

observeEvent(input$pareto.measure1,{
  req(input$pareto.measure1)
  updateSelectInput(session,'pareto.measure2',
    choices=as.list(measure2())[-c(as.list(measure2())== input$pareto.measure1)]
  )
})

output$paretoType <- renderUI({
  selectizeInput("pareto.type", "Choose Type of Plot",
    choices = c("Skyline Plot", "Skyline Level Plot (Dom. in 1 Dimension)", "Skyline Level Plot (Dom. in 2 Dimensions)"), 
    multiple = FALSE)
})

output$paretoTab <- DT::renderDataTable({
  req(data$bmr)
  req(input$pareto.measure1)
  req(input$pareto.measure2)
  
  if(input$roundOverview == "Off"){
    opt <- paretoOpt(dat = data$bmr, measure1 = input$pareto.measure1, measure2 = input$pareto.measure2, 
      type = input$pareto.type)
  }
  else if(input$roundOverview == "On"){
    opt <- roundDf(paretoOpt(dat = data$bmr, measure1 = input$pareto.measure1, measure2 = input$pareto.measure2,
      input$pareto.type), digits = 3, nsmall = 3)
  }
  if(input$allLevels == "Off"){
    opt <- opt[opt$.level == 1,]
  }
  
  keep <- c("Name and Art of Task", input$pareto.measure1, input$pareto.measure2, "Learner", "Tuning", "SMOTE", ".level")
  opt <- opt[,keep]
  names(opt)[names(opt) == ".level"] <- "Pareto Level"
  opt
})

size_text_pareto <- reactive({
  size <- req(input$sizeTextPareto)
  if(input$paretoPlotly){
    size <- -1
  }
  return(size)
})

output$ggplot_pareto <- renderPlot({
  req(data$bmr)
  req(input$pareto.measure1)
  req(input$pareto.measure2)
  
  paretoFront(dat = data$bmr, measure1 = input$pareto.measure1, measure2 = input$pareto.measure2, 
    type = input$pareto.type,
    size_text = size_text_pareto(), size_symbols = input$sizeSymbolsPareto)
},height = function() {
  input$zoomPareto * session$clientData$output_ggplot_pareto_width
})

output$plotly_pareto <- renderPlotly({
  req(data$bmr)
  req(input$pareto.measure1)
  req(input$pareto.measure2)
  
  paretoFront(dat = data$bmr, measure1 = input$pareto.measure1, measure2 = input$pareto.measure2, 
    type = input$pareto.type,
    size_text = size_text_pareto(), size_symbols = input$sizeSymbolsPareto)
})