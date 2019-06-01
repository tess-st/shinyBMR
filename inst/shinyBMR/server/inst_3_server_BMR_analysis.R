#####################################################################################################################
# Settings
#####################################################################################################################

output$selected.measure.ana <- renderUI({
  selectizeInput("select.measure.ana", "Choose Measure to be focused", 
    choices = as.list(measure()),
    multiple = FALSE)#, selected = NULL)
})

aggregation <- reactive({
  req(input$aggregate)
})

dat_plot <- reactive({
  req(input$ordering)
  if(input$aggregate == "On"){
    dataset <- isolate(data$data)
  }
  if(input$aggregate == "Off"){
    dataset <- isolate(data$data.notagg)
  }
  
  if(input$ordering == "Off"){
    dat <- (perfAggDf(dataset))
  }
  else{
    dat <- (perfAggOrderDf(dataset))
  }
  
  return(subsetAnalysis(dat, input$select.measure.ana))
})


#####################################################################################################################
# Boxplots
#####################################################################################################################

size_text_B <- reactive({
  size <- req(input$sizeTextB)
  if(input$type){
    size <- -1
  }
  return(size)
})

jitter_symbols <- reactive({
  req(input$jitterSymbols)
  if(input$jitterSymbols == "Off"){
    return("identity")
  }
  else{
    return("jitter")
  }
})

output$sliderBoxplot <- renderUI({
  req(input$select.measure.ana)
  if(!is.null(data$data)){
    m <- getFromNamespace(input$select.measure.ana, "mlr")
    range <- c(m$best, m$worst)
    pos <- findValue(data = perfAggDf(data$data.notagg), measure = input$select.measure.ana)
    min <- getRange(input$select.measure.ana)[1]
    max <- getRange(input$select.measure.ana)[2]
    minimum <- min(perfAggDf(data$data.notagg)[pos])
    maximum <- max(perfAggDf(data$data.notagg)[pos])
    if(any(range == Inf)){
      max <- mround(maximum + 0.1* maximum, 0.05) 
    }
    if(round(minimum - 0.05* maximum, 2) < min){
      value <- c(min, mround(maximum + 0.05* maximum, 0.05))
    }
    else{
      value <- c(mround((minimum - 0.05* maximum), 0.05), mround(maximum + 0.05* maximum, 0.05))
    }
    sliderInput("rangeYaxisB", "Range y-Axis", value = value, 
      min = min, max = max, step = 0.05)
  }
})

# solve problem of sliderInput, as the values are returned as list
rangeB <- reactive({
  reqAndAssign(input$rangeYaxisB, "range")
  vec <- c(input$rangeYaxisB[1], input$rangeYaxisB[2])
  vec
})

col_Palette_B <- reactive({
  req(input$colPaletteB)
  n <- nlevels(dat_plot()$learner)
  if(input$colPaletteB == "Default"){
    pal <- qualitative_hcl(n) 
  }
  if(input$colPaletteB == "Dark2"){
    pal <- qualitative_hcl(n, "Dark 2") 
  }
  if(input$colPaletteB == "Dark3"){
    pal <- qualitative_hcl(n, "Dark 3") 
  }
  if(input$colPaletteB == "Set2"){
    pal <- qualitative_hcl(n, "Set 2") 
  }
  if(input$colPaletteB == "Set3"){
    pal <- qualitative_hcl(n, "Set 3") 
  }
  if(input$colPaletteB == "Warm"){
    pal <- qualitative_hcl(n, "Warm") 
  }
  if(input$colPaletteB == "Cold"){
    pal <- qualitative_hcl(n, "Cold") 
  }
  if(input$colPaletteB == "Harmonic"){
    pal <- qualitative_hcl(n, "Harmonic") 
  }
  if(input$colPaletteB == "Dynamic"){
    pal <- qualitative_hcl(n, "Dynamic") 
  }
  if(input$colPaletteB == "Coolwarm"){
    pal <- coolwarm(n) 
  }
  if(input$colPaletteB == "Parula"){
    pal <- parula(n) 
  }
  if(input$colPaletteB == "Viridis"){
    pal <- viridis(n) 
  }
  if(input$colPaletteB == "Tol.Rainbow"){
    pal <- tol.rainbow(n) 
  }
  return(pal)
})


output$ggplot <- renderPlot({
  boxplot <- PerfBoxplot(dat_plot(), size_text = size_text_B(), col_palette = col_Palette_B(), add_lines = input$addLines,
    range_yaxis = rangeB(),#input$rangeYaxisB, 
    size_symbols = input$sizeSymbolsB, jitter_symbols = jitter_symbols(),
    label_xaxis = input$labelXlabB, label_yaxis = input$labelYlabB, label_symbol = input$labelSymbolB)
  boxplot
},height = function() {
  input$zoomB * session$clientData$output_ggplot_width
})#,  height = 200, width = 300)

output$plotly <- renderPlotly({
  ggplotly(PerfBoxplot(dat_plot(), size_text = size_text_B(), col_palette = col_Palette_B(), add_lines = input$addLines,
    range_yaxis = rangeB(),#input$rangeYaxisB, 
    size_symbols = input$sizeSymbolsB, jitter_symbols = jitter_symbols(),
    label_xaxis = input$labelXlabB, label_yaxis = input$labelYlabB, label_symbol = input$labelSymbolB))
})


#####################################################################################################################
# Heatmap
#####################################################################################################################

size_text_H <- reactive({
  size <- req(input$sizeTextH)
  if(input$type){
    size <- -1
  }
  return(size)
})

output$rangeHeatmap <- renderUI({
  req(input$select.measure.ana)
  if(!is.null(data$data)){
    m <- getFromNamespace(input$select.measure.ana, "mlr")
    range <- c(m$best, m$worst)
    pos <- findValue(data = perfAggDf(data$data.notagg), measure = input$select.measure.ana)
    min <- getRange(input$select.measure.ana)[1]
    max <- getRange(input$select.measure.ana)[2]
    minimum <- min(perfAggDf(data$data.notagg)[pos])
    maximum <- max(perfAggDf(data$data.notagg)[pos])
    if(any(range == Inf)){
      max <- mround(maximum + 0.1* maximum, 0.05) 
    }
    if(round(minimum - 0.05* maximum, 2) < min){
      value <- c(min, mround(maximum + 0.05* maximum, 0.05))
    }
    else{
      value <- c(mround((minimum - 0.05* maximum), 0.05), mround(maximum + 0.05* maximum, 0.05))
    }
    sliderInput("rangeValueH", "Range Value", value = value, 
      min = min, max = max, step = 0.05)
    # sliderInput("rangeValueH", "Range Value", 
    #   min = 0, max = 10, value = c(0, 1), step = 0.01)
  }
})

# solve problem of sliderInput, as the values are returned as list
rangeH <- reactive({
  reqAndAssign(input$rangeValueH, "range")
  vec <- c(input$rangeValueH[1], input$rangeValueH[2])
  vec
})

output$ggplot_heatmap <- renderPlot({
  PerfHeatmap_Def(dat_plot(), col_text = input$colTextH, col_min = input$colMinH, col_max = input$colMaxH, 
    label_value = input$labelValueH, label_xaxis = input$labelXlabH, label_yaxis = input$labelYlabH,
    size_text = size_text_H(), range_value = rangeH(),#range_value = input$rangeValueH, 
    aggregate = aggregation())
}, height = function() {
  input$zoomH * session$clientData$output_ggplot_heatmap_width
}) 

output$plotly_heatmap <- renderPlotly({
  PerfHeatmap_Def(dat_plot(), col_text = input$colTextH, col_min = input$colMinH, col_max = input$colMaxH, 
    label_value = input$labelValueH, label_xaxis = input$labelXlabH, label_yaxis = input$labelYlabH,
    size_text = size_text_H(), range_value = rangeH(),#range_value = input$rangeValueH, 
    aggregate = aggregation())
})


#####################################################################################################################
# PCP: Parallel Coordinate Plot
#####################################################################################################################

output$disable_pcp <- reactive({
  req(data$data)
  length(grep("value", names(perfAggDf(getBMRAggrPerformances(data$bmr, as.df = T))))) > 1
})
outputOptions(output, "disable_pcp", suspendWhenHidden = FALSE)

output$ggplot_pcp <- renderPlot({
  ggparcoord(perfAggDf(getBMRAggrPerformances(data$bmr, as.df = T)), columns = c(3,4), 
    groupColumn = "learner.id", showPoints = TRUE)
})


#####################################################################################################################
# mlr Plots
#####################################################################################################################

col_Palette_mlr <- reactive({
  req(input$colPaletteMlr)
  n <- nrow(perfAggDf(getBMRAggrPerformances(data$bmr, as.df = T)))
  if(input$colPaletteMlr == "Default"){
    pal <- qualitative_hcl(n) 
  }
  if(input$colPaletteMlr == "Dark2"){
    pal <- qualitative_hcl(n, "Dark 2") 
  }
  if(input$colPaletteMlr == "Dark3"){
    pal <- qualitative_hcl(n, "Dark 3") 
  }
  if(input$colPaletteMlr == "Set2"){
    pal <- qualitative_hcl(n, "Set 2") 
  }
  if(input$colPaletteMlr == "Set3"){
    pal <- qualitative_hcl(n, "Set 3") 
  }
  if(input$colPaletteMlr == "Warm"){
    pal <- qualitative_hcl(n, "Warm") 
  }
  if(input$colPaletteMlr == "Cold"){
    pal <- qualitative_hcl(n, "Cold") 
  }
  if(input$colPaletteMlr == "Harmonic"){
    pal <- qualitative_hcl(n, "Harmonic") 
  }
  if(input$colPaletteMlr == "Dynamic"){
    pal <- qualitative_hcl(n, "Dynamic") 
  }
  if(input$colPaletteMlr == "Coolwarm"){
    pal <- coolwarm(n) 
  }
  if(input$colPaletteMlr == "Parula"){
    pal <- parula(n) 
  }
  if(input$colPaletteMlr == "Viridis"){
    pal <- viridis(n) 
  }
  if(input$colPaletteMlr == "Tol.Rainbow"){
    pal <- tol.rainbow(n) 
  }
  return(pal)
})


output$mlr_boxplot <- renderPlot({
  MlrBoxplot(dat = data$bmr, style = input$stylePlot, size_text = input$sizeTextMlr, col_palette = col_Palette_mlr())
}, height = function() {
  input$zoomMlr * session$clientData$output_mlr_boxplot_width
})


#####################################################################################################################
# Download
#####################################################################################################################

output$download <- downloadHandler(
  filename = function() { paste("BMRPlot", Sys.Date(), '.png', sep='') },
  content = function(file) {
    device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, 
      units = "in")
    ggsave(file, device = device)
  }
  # contentType = 'image/png'
)

#Switch between png and pdf
#https://gist.github.com/aagarw30/87c14725be815f9fd038