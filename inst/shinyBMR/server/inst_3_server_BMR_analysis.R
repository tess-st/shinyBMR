#####################################################################################################################
# Settings
#####################################################################################################################

# Show/hide elements with Info Text
observe({
  if(!is.null(data$data)){
    shinyjs::hide("help_bmrBoxplot", animType = "fade")
    shinyjs::hide("help_bmrHeatmap", animType = "fade")
    shinyjs::hide("help_bmrPcp", animType = "fade")
    shinyjs::hide("help_bmrMlr", animType = "fade")
  }
  else{
    shinyjs::show("help_bmrBoxplot", anim = TRUE)
    shinyjs::show("help_bmrHeatmap", anim = TRUE)
    shinyjs::show("help_bmrPcp", anim = TRUE)
    shinyjs::show("help_bmrMlr", anim = TRUE)
  }
})

observeEvent(input$rangeYaxisB, {
  if(is.null(input$rangeYaxisB)){
    shinyjs::show("bmrBoxplotInfo", anim = TRUE)
  }
  else{
    shinyjs::hide("bmrBoxplotInfo", animType = "fade")
  }
})

observeEvent(input$rangeValueH, {
  if(is.null(input$rangeValueH)){
    shinyjs::show("bmrHeatmapInfo", anim = TRUE)
  }
  else{
    shinyjs::hide("bmrHeatmapInfo", animType = "fade")
  }
})

observeEvent(input$rangeYaxisPcp, {
  if(is.null(input$rangeYaxisPcp)){
    shinyjs::show("bmrPcpInfo", anim = TRUE)
  }
  else{
    shinyjs::hide("bmrPcpInfo", animType = "fade")
  }
})

output$selected.measure.ana <- renderUI({
  selectizeInput("select.measure.ana", "Choose Measure to be focused", 
    choices = as.list(measure()),
    multiple = FALSE)
})

# Global Settings for BMR Analysis
observeEvent(input$tabs_bmr, {
  shinyjs::show("selected.measure.ana", anim = TRUE)
  if(input$tabs_bmr == "plotMLR"){
    shinyjs::hide("ordering", animType = "fade")
    shinyjs::hide("aggregate", animType = "fade")
    shinyjs::hide("type", animType = "fade")
  }
  else if(input$tabs_bmr == "pcp"){
    shinyjs::hide("selected.measure.ana", animType = "fade")
    shinyjs::hide("ordering", animType = "fade")
    shinyjs::show("aggregate", anim = TRUE)
    shinyjs::show("type", anim = TRUE)
  }
  else{
    shinyjs::show("selected.measure.ana", anim = TRUE)
    shinyjs::show("ordering", anim = TRUE)
    shinyjs::show("aggregate", anim = TRUE)
    shinyjs::show("type", anim = TRUE)
  }
})

aggregation <- reactive({
  req(input$aggregate)
})

dat_plot <- reactive({
  req(input$ordering)
  req(input$select.measure.ana)
  if(input$aggregate == "On"){
    dataset <- isolate(data$data)
  }
  if(input$aggregate == "Off"){
    dataset <- isolate(data$data.notagg)
  }
  
  if(input$ordering == "Off"){
    dat <- (perfAggDf(dataset))
  }
  else if(input$ordering == "On"){
    dat <- (perfAggOrderDf(dataset, value = input$select.measure.ana))
  }
  
  return(subsetAnalysis(dat, input$select.measure.ana))
})

dat_plot_agg <- reactive({
  req(input$ordering)
  req(input$select.measure.ana)
  
  dataset <- isolate(data$data)
  
  if(input$ordering == "Off"){
    dat <- (perfAggDf(dataset))
  }
  else if(input$ordering == "On"){
    dat <- (perfAggOrderDf(dataset, value = input$select.measure.ana))
  }
  
  return(subsetAnalysis(dat, input$select.measure.ana))
})

dat_plot_unagg <- reactive({
  req(input$ordering)
  req(input$select.measure.ana)
  
  dataset <- isolate(data$data.notagg)
  
  if(input$ordering == "Off"){
    dat <- (perfAggDf(dataset))
  }
  else if(input$ordering == "On"){
    dat <- (perfAggOrderDf(dataset, value = input$select.measure.ana))
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
    pos <- findValue(data = perfAggDf(data$data.notagg), measure = input$select.measure.ana)
    
    minimum <- min(perfAggDf(data$data.notagg)[pos])
    maximum <- max(perfAggDf(data$data.notagg)[pos])
    # if-loop necessary for in mlr undefined performance measures
    if(!is.null(getRange(input$select.measure.ana))){
          m <- getFromNamespace(input$select.measure.ana, "mlr")
    range <- c(m$best, m$worst)
    min <- getRange(input$select.measure.ana)[1]
    max <- getRange(input$select.measure.ana)[2]
    }
    else{
      min <- mround((minimum - 0.05* maximum), 0.05)
      max <- mround((maximum + 0.05* maximum), 0.05)
      
      range <- c(mround(minimum, 0.05), mround(maximum, 0.05))
    }
    
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
  vec <- c(range[1], range[2])
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
  if(input$aggregate == "On"){
    data_unagg <- NULL
  }
  else{
    data_unagg <- dat_plot_unagg()
  }
  boxplot <- PerfBoxplot(dat = dat_plot_agg(), dat_unagg = data_unagg,  
    size_text = size_text_B(), col_palette = col_Palette_B(), add_lines = input$addLines,
    range_yaxis = rangeB(),size_symbols = input$sizeSymbolsB, jitter_symbols = jitter_symbols(),
    label_xaxis = input$labelXlabB, label_yaxis = input$labelYlabB, label_symbol = input$labelSymbolB)
  boxplot
},height = function() {
  input$zoomB * session$clientData$output_ggplot_width
})

output$plotly <- renderPlotly({
  if(input$aggregate == "On"){
    data_unagg <- NULL
  }
  else{
    data_unagg <- dat_plot_unagg()
  }
  ggplotly(PerfBoxplot(dat = dat_plot_agg(), dat_unagg = data_unagg,  
    size_text = size_text_B(), col_palette = col_Palette_B(), add_lines = input$addLines,
    range_yaxis = rangeB(), size_symbols = input$sizeSymbolsB, jitter_symbols = jitter_symbols(),
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
        pos <- findValue(data = perfAggDf(data$data.notagg), measure = input$select.measure.ana)
         
        minimum <- min(perfAggDf(data$data.notagg)[pos])
    maximum <- max(perfAggDf(data$data.notagg)[pos])   
    # if-loop necessary for in mlr undefined performance measures
    if(!is.null(getRange(input$select.measure.ana))){
    m <- getFromNamespace(input$select.measure.ana, "mlr")
    range <- c(m$best, m$worst)
    
    min <- getRange(input$select.measure.ana)[1]
    max <- getRange(input$select.measure.ana)[2]
    }
    
    else{
      min <- mround((minimum - 0.05* maximum), 0.05)
      max <- mround((maximum + 0.05* maximum), 0.05)
      
      range <- c(mround(minimum, 0.05), mround(maximum, 0.05))
    }

    if(any(range == Inf)){
      max <- mround(maximum + 0.1* maximum, 0.001) 
    }
    if(round(minimum - 0.1* maximum, 2) < min){
      value <- c(min, mround(maximum + 0.05* maximum, 0.001))
    }
    else{
      value <- c(mround((minimum - 0.1* maximum), 0.001), mround(maximum + 0.1* maximum, 0.001))
    }
    sliderInput("rangeValueH", "Range Value", value = value, 
      min = min, max = max, step = 0.05)
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
    size_text = size_text_H(), range_value = rangeH(),
    aggregate = aggregation())
}, height = function() {
  input$zoomH * session$clientData$output_ggplot_heatmap_width
}) 

output$plotly_heatmap <- renderPlotly({
  PerfHeatmap_Def(dat_plot(), col_text = input$colTextH, col_min = input$colMinH, col_max = input$colMaxH, 
    label_value = input$labelValueH, label_xaxis = input$labelXlabH, label_yaxis = input$labelYlabH,
    size_text = size_text_H(), range_value = rangeH(),
    aggregate = aggregation())
})


#####################################################################################################################
# Parallel Coordinates Plot
#####################################################################################################################

output$disable_pcp <- reactive({
  req(data$data)
  length(grep("value", names(perfAggDf(getBMRAggrPerformances(data$bmr, as.df = T))))) > 1
})
outputOptions(output, "disable_pcp", suspendWhenHidden = FALSE)

# output$disable_pcp_2 <- reactive({
#   req(data$data)
#   length(grep("value", names(perfAggDf(getBMRAggrPerformances(data$bmr, as.df = T))))) = 1
# })
# outputOptions(output, "disable_pcp_2", suspendWhenHidden = FALSE)
# 
# output$unable_PCP <- renderText({
#   "PCP can not be displayed, when only one measure is used looking at the Performance of your BMR Object."
# })

size_text_Pcp <- reactive({
  size <- req(input$sizeTextPcp)
  if(input$type){
    size <- -1
  }
  return(size)
})

output$sliderPcp <- renderUI({
  if(!is.null(data$bmr)){
    long_unagg <- getLongUnagg(dat_agg = getBMRAggrPerformances(data$bmr, as.df = T), 
      dat_unagg = getBMRPerformances(data$bmr, as.df = T))
    levs <- levels(long_unagg$measure)
    
        minimum <- min(long_unagg$value)
    maximum <- max(long_unagg$value)
        range_list <- list()
    # if-loop necessary for in mlr undefined performance measures
    if(!is.null(getRange(input$select.measure.ana))){
    for(i in 1:length(levs)){
      m <- getFromNamespace(levs[i], "mlr")
      range_list[[i]] <- c(m$best, m$worst)
    }
    min <- min(unlist(range_list))
    max <- max(unlist(range_list))
    }
    else{
      range_list[[1]] <- c(mround(minimum, 0.05), mround(maximum, 0.05))
      min <- mround((minimum - 0.05* maximum), 0.05)
      max <- mround((maximum + 0.05* maximum), 0.05)
    }

    if(any(unlist(range_list) == Inf)){
      max <- mround(maximum + 0.1* maximum, 0.05) 
    }
    if(round(minimum - 0.05* maximum, 2) < min){
      value <- c(min, mround(maximum + 0.05* maximum, 0.05))
    }
    else{
      value <- c(mround((minimum - 0.05* maximum), 0.05), mround(maximum + 0.05* maximum, 0.05))
    }
    sliderInput("rangeYaxisPcp", "Range y-Axis", value = value, 
      min = min, max = max, step = 0.05)
  }
})

# solve problem of sliderInput, as the values are returned as list
rangePcp <- reactive({
  reqAndAssign(input$rangeYaxisPcp, "range")
  vec <- c(range[1], range[2])
  vec
})

col_Palette_Pcp <- reactive({
  req(input$colPalettePcp)
  n <- nrow(perfAggDf(getBMRAggrPerformances(data$bmr, as.df = T)))
  if(input$colPalettePcp == "Default"){
    pal <- qualitative_hcl(n) 
  }
  if(input$colPalettePcp == "Dark2"){
    pal <- qualitative_hcl(n, "Dark 2") 
  }
  if(input$colPalettePcp == "Dark3"){
    pal <- qualitative_hcl(n, "Dark 3") 
  }
  if(input$colPalettePcp == "Set2"){
    pal <- qualitative_hcl(n, "Set 2") 
  }
  if(input$colPalettePcp == "Set3"){
    pal <- qualitative_hcl(n, "Set 3") 
  }
  if(input$colPalettePcp == "Warm"){
    pal <- qualitative_hcl(n, "Warm") 
  }
  if(input$colPalettePcp == "Cold"){
    pal <- qualitative_hcl(n, "Cold") 
  }
  if(input$colPalettePcp == "Harmonic"){
    pal <- qualitative_hcl(n, "Harmonic") 
  }
  if(input$colPalettePcp == "Dynamic"){
    pal <- qualitative_hcl(n, "Dynamic") 
  }
  if(input$colPalettePcp == "Coolwarm"){
    pal <- coolwarm(n) 
  }
  if(input$colPalettePcp == "Parula"){
    pal <- parula(n) 
  }
  if(input$colPalettePcp == "Viridis"){
    pal <- viridis(n) 
  }
  if(input$colPalettePcp == "Tol.Rainbow"){
    pal <- tol.rainbow(n) 
  }
  return(pal)
})

output$ggplot_pcp <- renderPlot({
  PCP(dat_agg = getBMRAggrPerformances(data$bmr, as.df = T), dat_unagg = getBMRPerformances(data$bmr, as.df = T), 
    label_xaxis = input$labelXlabPcp, label_yaxis = input$labelYlabPcp, label_lines = input$labelLinesPcp,
    col_palette = col_Palette_Pcp(), range_yaxis = rangePcp(),
    size_text = size_text_Pcp(), size_symbols = input$sizeSymbolsPcp, aggregate = input$aggregate)
}, height = function() {
  input$zoomPcp * session$clientData$output_ggplot_pcp_width
})

output$plotly_pcp <- renderPlotly({
  PCP(dat_agg = getBMRAggrPerformances(data$bmr, as.df = T), dat_unagg = getBMRPerformances(data$bmr, as.df = T), 
    label_xaxis = input$labelXlabPcp, label_yaxis = input$labelYlabPcp, label_lines = input$labelLinesPcp,
    col_palette = col_Palette_Pcp(), range_yaxis = rangePcp(),
    size_text = size_text_Pcp(), size_symbols = input$sizeSymbolsPcp, aggregate = input$aggregate)
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
  req(data$data)
  MlrBoxplot(dat = data$bmr, measure = getFromNamespace(input$select.measure.ana, "mlr"), style = input$stylePlot, 
    size_text = input$sizeTextMlr, col_palette = col_Palette_mlr())
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