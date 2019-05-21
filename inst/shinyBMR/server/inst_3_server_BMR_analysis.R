#####################################################################################################################
##################################################### Settings ######################################################
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
##################################################### Boxplots ######################################################
#####################################################################################################################

size_text_B <- reactive({
  size <- req(input$sizeTextB)
  if(input$type){
    size <- -1
  }
  return(size)
})

zoom_B <- reactive({
  req(input$zoomB)
})

size_symbols_B <- reactive({
  req(input$sizeSymbolsB)
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

add_lines <- reactive({
  req(input$addLines)  
})

range_yaxis_B <- reactive({
  req(input$rangeYaxisB)
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

label_symbol_B <- reactive({
  req(input$labelSymbolB)
})

label_xaxis_B <- reactive({
  req(input$labelXlabB)
})

label_yaxis_B <- reactive({
  req(input$labelYlabB)
})


output$ggplot <- renderPlot({
  boxplot <- PerfBoxplot(dat_plot(), size_text = size_text_B(), col_palette = col_Palette_B(), add_lines = add_lines(),
    range_yaxis = range_yaxis_B(), size_symbols = size_symbols_B(), jitter_symbols = jitter_symbols(),
    label_xaxis = label_xaxis_B(), label_yaxis = label_yaxis_B(), label_symbol = label_symbol_B())
  boxplot
},height = function() {
  zoom_B() * session$clientData$output_ggplot_width
})#,  height = 200, width = 300)

output$plotly <- renderPlotly({
  ggplotly(PerfBoxplot(dat_plot(), size_text = size_text_B(), col_palette = col_Palette_B(), add_lines = add_lines(),
    range_yaxis = range_y_axis_B(), size_symbols = size_symbols_B(), jitter_symbols = jitter_symbols(),
    label_xaxis = label_xaxis_B(), label_yaxis = label_yaxis_B(), label_symbol = label_symbol_B()))
})


#####################################################################################################################
###################################################### Heatmap ######################################################
#####################################################################################################################

col_min_H <- reactive({
  req(input$colMinH)
})

col_max_H <- reactive({
  req(input$colMaxH)
})

col_text_H <- reactive({
  req(input$colTextH)
})

range_value_H <- reactive({
  req(input$rangeValueH)
})

size_text_H <- reactive({
  size <- req(input$sizeTextH)
  if(input$type){
    size <- -1
  }
  return(size)
})

zoom_H <- reactive({
  req(input$zoomH)
})

label_value_H <- reactive({
  req(input$labelValueH)
})

label_xaxis_H <- reactive({
  req(input$labelXlabH)
})

label_yaxis_H <- reactive({
  req(input$labelYlabH)
})


output$ggplot_heatmap <- renderPlot({
  PerfHeatmap_Def(dat_plot(), col_text = col_text_H(), col_min = col_min_H(), col_max = col_max_H(), 
    label_value = label_value_H(), label_xaxis = label_xaxis_H(), label_yaxis = label_yaxis_H(),
    size_text = size_text_H(),range_value = range_value_H(), aggregate = aggregation())
}, height = function() {
  zoom_H() * session$clientData$output_ggplot_heatmap_width
}) 

output$plotly_heatmap <- renderPlotly({
  PerfHeatmap_Def(dat_plot(), col_text = col_text_H(), col_min = col_min_H(), col_max = col_max_H(), 
    label_value = label_value_H(), label_xaxis = label_xaxis_H(), label_yaxis = label_yaxis_H(),
    size_text = size_text_H(),range_value = range_value_H(), aggregate = aggregation())
})


#####################################################################################################################
##################################################### mlr Plots #####################################################
#####################################################################################################################

style_plot_mlr <- reactive({
  req(input$stylePlot)
})

size_text_mlr <- reactive({
  req(input$sizeTextMlr)
})

zoom_mlr <- reactive({
  req(input$zoomMlr)
})

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
  MlrBoxplot(dat = data$bmr, style = style_plot_mlr(), size_text = size_text_mlr(), col_palette = col_Palette_mlr())
}, height = function() {
  zoom_mlr() * session$clientData$output_mlr_boxplot_width
})


#####################################################################################################################
###################################################### Download #####################################################
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