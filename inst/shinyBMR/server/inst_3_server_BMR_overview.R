#UI
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

output$selected.measure <- renderUI({
  selectizeInput("select.measure", "Choose Measure to be focused", 
    choices = as.list(measure()),
    multiple = FALSE)#, selected = NULL)
})

# output$selected.minmax <- renderUI({
#   selectizeInput("select.minmax", "Best Performance Value signified by",
#     choices = c("Minimum", "Maximum"),
#     multiple = FALSE, selected = "Minimum")
# })

measureName <- reactive({
  req(input$select.measure) 
  if(input$select.measure == "Not Selected"){
    NULL
  }
  else{
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
      min <- min(perfAggDf(data$data)[pos])
      max <- max(perfAggDf(data$data)[pos])
    }
    else{
      min <- format(min(perfAggDf(data$data)[pos]), digits = 3, nsmall = 3)
      max <- format(max(perfAggDf(data$data)[pos]), digits = 3, nsmall = 3)
    }
    return(paste(min, max, sep = " - "))
  }
})

bestValueOfMeasure <- reactive({
  if(input$select.measure == "Not Selected"){
    NULL
  }
  else{
    best <- bestPerfMod(perfAggDf(data$data), measure = input$select.measure)
    pos <- findValue(best, measure = input$select.measure)
    value <- best[1, pos]
    # pos <- findValue(data = perfAggDf(data$data), measure = input$select.measure)
    # if(input$select.minmax == "Minimum"){
    #   value <- min(perfAggDf(data$data)[pos])
    # }
    # if(input$select.minmax == "Maximum"){
    #   value <- max(perfAggDf(data$data)[pos])
    # } 
    
    if(input$roundOverview == "Off"){
      return(value)
    }
    else{
      return(format(value, digits = 3, nsmall = 3))
    }
  }
})

# observeEvent(data$data, {
#   if(sapply(strsplit(textInfoboxMeasure(perfAggDf(data$data)), ", "), length) > 1){
#     shinyjs::show("selected.measure", anim = TRUE)
#   }else{
#     shinyjs::hide("selected.measure", animType = "fade")
#   }
# })

#####################################################################################################################
##################################################### Summary #######################################################
#####################################################################################################################

#InfoBox
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

# output$Measures <- renderInfoBox({
#   infoBox("Measure(s)", textInfobox(perfAggDf(data$data)$measure), icon = icon ("chart-bar"),
#           color = "navy")
# })
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
  infoBox("Value of selected Measure", measureName(), icon = icon ("battery-three-quarters"),
    color = "navy")
})




#ValueBox
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

# output$Measures_Lev <- renderValueBox({
#   valueBox(tags$p("MEASURE(S)", style = "font-size: 55%;"), 
#            tags$p(length(unique(perfAggDf(data$data)$measure)), style = "font-size: 150%;"),
#            icon = icon("chart-bar"), color = "navy")
# })
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
  # if(input$roundOverview == "Off"){
  #   min <- min(perfAggDf(data$data)$value)
  #   max <- max(perfAggDf(data$data)$value)
  # }
  # else{
  #   min <- format(min(perfAggDf(data$data)$value), digits = 3, nsmall = 3)
  #   max <- format(max(perfAggDf(data$data)$value), digits = 3, nsmall = 3)
  #   
  # }
  valueBox(tags$p("Value of selected Measure", style = "font-size: 55%;"),
    tags$p(valuesOfMeasure(), #paste(min, max, sep = " - ")
      #min(perfAggDf(data$data)$value), max(perfAggDf(data$data)$value)
      style = "font-size: 150%;"),
    icon = icon ("battery-three-quarters"), color = "navy")
})


output$selectionTable1 <- renderUI({
  # selectizeInput("select", "Select:", 
  #                choices = as.list(levels(dat_plot()$learner)), 
  #                multiple = TRUE)
  selectizeInput("table1", "First Table Element", 
    choices = c('Not Selected', as.list(names(perfAggDf(data$data)))),
    multiple = FALSE, selected = NULL)
})

output$selectionTable2 <- renderUI({
  selectizeInput("table2", "Second Table Element", 
    choices = c('Not Selected', as.list(names(perfAggDf(data$data)))),
    multiple = FALSE, selected = NULL)
})

output$selectionTable3 <- renderUI({
  selectizeInput("table3", "Third Table Element", 
    choices = c('Not Selected', as.list(names(perfAggDf(data$data)))),
    multiple = FALSE, selected = NULL)
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
  dataset <- perfAggDf(data$data)
  var1 <- var1()
  var2 <- var2()
  var3 <- var3()
  vec <- c(var1, var2, var3)
  position <- c(NULL, NULL)
  
  crossTab(dataset, vec, position)
})




output$summaryData <- renderPrint({
  summary(perfAggDf(data$data))
})


# Tuning
summarize.tune = reactive({
  if(is.null(data$bmr)){
    NULL
  }
  else{
    d = getBMRTuneResults(data$bmr, as.df = TRUE) 
    
    validate(need(class(d) == "data.frame", "You didn't import any Data."))
    colnames(d) = make.names(colnames(d))
    pos.x = colnames(Filter(function(x) "POSIXt" %in% class(x) , d))
    d = dropNamed(d, drop = pos.x)    
    d
  }
})

output$summary.tune = renderUI({
  ui = box(width = 12, title = "Summary Tuning",
    br(),
    DT::dataTableOutput("summary.tuning")
  )
  ui
})

output$summary.tuning = DT::renderDataTable({
  summarize.tune()
}, options = list(scrollX = TRUE))


# output$tuneResults <- renderPrint({
#   getBMRTuneResults(data$bmr)
# })



# output$crossTables <- renderPrint({
#   dataset <- perfAggDf(data$data)
#   table(dataset$learner, dataset$tuning)
# })



#####################################################################################################################
#################################################### Best Modell ####################################################
#####################################################################################################################
best <- reactive({
  req(input$select.measure)
  #req(input$select.minmax)
  if(input$select.measure == "Not Selected"){
    NULL
  }
  else{
    bestPerfMod(dat = perfAggDf(data$data), measure = input$select.measure)#, min_max = input$select.minmax)
  }
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
  infoBox("Measure", measureName(), icon = icon("chart-bar"),
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
    tags$p(bestValueOfMeasure(), style = "font-size: 150%;"), 
    icon = icon("battery-three-quarters"), color = "navy") #light-blue
})