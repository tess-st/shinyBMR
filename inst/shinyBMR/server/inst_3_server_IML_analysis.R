#####################################################################################################################
# General Settings
#####################################################################################################################

# Global 
output$iml.set = renderUI({
  list(
    numericInput("iml_seed", "Set Seed", min = 1L, max = Inf, value = 123L),
    bsButton("iml_sets", "Set Selections", icon = icon("flag")),
    hr()
  )
})

iml_zoom <- reactive({
  req(input$imlZoom)
})

observe({
  req(dataiml$data)
  req(modiml$mod)
  if(is.null(dataiml$data) || is.null(modiml$mod)){
    shinyjs::show("imlDataInfo", anim = TRUE)
  }
  else{
    shinyjs::hide("imlDataInfo", animType = "fade")
  }
})

observeEvent(input$tabs, {
  if(input$tabs == "iml_plots"){
    shinyjs::show("imlPlotType", anim = TRUE)
    shinyjs::show("iml.set", anim = TRUE)
    shinyjs::show("imlZoom", anim = TRUE)
    shinyjs::show("imlDownload", anim = TRUE)
  }
  else{
    shinyjs::hide("imlPlotType", animType = "fade")
    shinyjs::hide("iml.set", animType = "fade")
    shinyjs::hide("imlZoom", anim = "fade")
    shinyjs::hide("imlDownload", animType = "fade")
  }
})

observe({
  if(input$imlPlotType == "Not Selected"){
    shinyjs::hide("iml_plotted", animType = "fade")
    shinyjs::show("imlStartInfo", anim = TRUE)
  }
  else{
    shinyjs::show("iml_plotted", anim = TRUE)
    shinyjs::hide("imlStartInfo", animType = "fade")
  }
})

predictor <- reactive({
  makePredictor(data = dataiml$data, model = modiml$mod)
})


# Feature Importance

output$modeltype <- renderText({
  t <- modiml$type
  t
})
outputOptions(output, "modeltype", suspendWhenHidden = FALSE)


# Feature Effects

observeEvent(input$effMeth, {
  if(input$effMeth == "ICE"){
    shinyjs::hide("effFeature2", animType = "fade")
  }
})

output$effectFeature1 <- renderUI({
  selectizeInput("effFeature1", "Select Feature 1 (necessary)",
    choices = c('Not Selected', as.list(modiml$mod$features)),
    selected = NULL, multiple = FALSE)
})

output$effectFeature2 <- renderUI({
  selectizeInput("effFeature2", "Select Feature 2 (optional)",
    choices = c('Not Selected', as.list(modiml$mod$features)),
    selected = NULL, multiple = FALSE)
})

eff_feature1 <- reactive({
  validate(
    need(input$effFeature1 != "Not Selected", "Please choose the Feature you want to analyze")
  )
  if(input$effFeature1 == "Not Selected"){
    NULL
  }
  else{
    req(input$effFeature1)
  }
})

eff_feature2 <- reactive({
  if(input$effFeature2 == "Not Selected"){
    NULL
  }
  else{
    req(input$effFeature2)
  }
})


# Feature Interaction

output$interactionFeature <- renderUI({
  selectizeInput("intFeature", "Select Feature",
    choices = c('Not Selected', 'All', as.list(modiml$mod$features)),
    selected = NULL, multiple = FALSE)
})

int_feature <- reactive({
  validate(
    need(input$intFeature != "Not Selected", "Please choose the Feature you want to analyze")
  )
  if(input$intFeature == "Not Selected"){
    NULL
  }
  else{
    req(input$intFeature)
  }
})


# LIME

output$limeInterest <- renderUI({
  selectizeInput("limeInstance", "Select Instance you are intrested in",
    choices = c("Not Selected", as.list(as.numeric(rownames(dataiml$data)))),
    selected = NULL, multiple = FALSE)
})

data_instance_lime <- reactive({
  validate(
    need(input$limeInstance != "Not Selected", "Please choose the Instance to be explained")
  )
  if(input$limeInstance == "Not Selected"){
    NULL
  }else{
    subset(DataWithoutY(dataiml$data, modiml$mod), rownames(dataiml$data) %in% input$limeInstance)
  }
})

max_features <- reactive({
  validate(need(!is.null(dataiml$data), "Data"))
  if(is.null(dataiml$data)){
    NULL
  }else{
    ncol(dataiml$data) - 1
  }
})

output$limeMaxFeatures <- renderUI({
  numericInput("limeK", "Number of Features for Surrogate Model",
    value = 3, min = 1, max = max_features(),
    step = 1)
})

output$limeDistance <- renderUI({
  list(
    selectInput("limeDist", "Distance Function",
      choices = c("gower","euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski"),
      selected = "gower", multiple = FALSE),
    numericInput("kernelWidth", "Kernel Width", value = 0.75, min = 0, max = Inf, step = 0.05)
  )
})

observeEvent(input$limeDist, {
  if(input$limeDist == "gower"){
    shinyjs::hide("kernelWidth", animType = "fade")
  } else{
    shinyjs::show("kernelWidth", anim = TRUE)
  }
})

kernel_width <- reactive({
  if(input$limeDist == "gower"){
    NULL
  }else{
    req(input$kernelWidth)
  }
})


# Shapley

output$shapleyInterest <- renderUI({
  selectizeInput("shapleyInstance", "Select Instance you are intrested in",
    choices = c('Not Selected', as.list(as.numeric(rownames(dataiml$data)))),
    selected = NULL, multiple = FALSE)
})

data_instance_shapley <- reactive({
  validate(
    need(input$shapleyInstance != "Not Selected", "Please choose the Instance to be explained")
  )
  if(input$shapleyInstance == "Not Selected"){
    NULL
  }else{
    subset(DataWithoutY(dataiml$data, modiml$mod), rownames(dataiml$data) %in% input$shapleyInstance)
  }
})


# Tree Surrogate





#####################################################################################################################
# Plot Object
#####################################################################################################################

iml_plot_obj <- reactive({
  #show("loading-iml")
  set.seed(input$iml_seed)
  
  #Not Selected
  if(input$imlPlotType == "Not Selected"){
    NULL
  }
  #Feature Importance
  else if(input$imlPlotType == "Feature Importance"){
    if(modiml$type == "classif"){
      loss <- input$impLossClassif
    }
    else if(modiml$type == "regr"){
      loss <-  input$impLossRegr
    }
    
    #cl = makePSOCKcluster(detectCores() - 1)
    #registerDoParallel(cl)
    importance <- FeatureImp$new(predictor(), loss = loss, compare = input$impComp, n.repetitions = input$impRep)#,
    #   parallel = TRUE)
    #stopCluster(cl)
    
    importance
  }
  
  # Feature Effects
  else if(input$imlPlotType == "Feature Effect"){
    feature <- c(eff_feature1(), eff_feature2())
    if(!is.null(feature)){ 
      if(input$effMeth == "PDP"){
        
        # cl = makePSOCKcluster(detectCores() - 1)
        # registerDoParallel(cl)
        # effect.pdp <- FeatureEffect$new(predictor(), feature = feature, grid.size = input$effGrid, #center.at = center,
        #   method = "pdp") 
        # parallel = TRUE)
        # stopCluster(cl)
        # 
        # effect.pdp
        method <- "pdp"
      }
      else if(input$effMeth == "ICE"){
        # cl = makePSOCKcluster(detectCores() - 1)
        # registerDoParallel(cl)
        # effect.ice <- FeatureEffect$new(predictor(), feature = feature, grid.size = input$effGrid, #center.at = center,
        #   method = "ice") 
        # parallel = TRUE)
        # stopCluster(cl)
        
        # effect.ice
        method <- "ice"
      }
      else if(input$effMeth == "PDP + ICE"){
        # cl = makePSOCKcluster(detectCores() - 1)
        # registerDoParallel(cl)
        # effect.pdp_ice <- FeatureEffect$new(predictor(), feature = feature, grid.size = input$effGrid, #center.at = center,
        #   method = "pdp+ice") 
        # parallel = TRUE)
        # stopCluster(cl)
        
        # effect.pdp_ice
        method <- "pdp+ice"
      }
      else if(input$effMeth == "ALE"){
        # cl = makePSOCKcluster(detectCores() - 1)
        # registerDoParallel(cl)
        # effect.ale <- FeatureEffect$new(predictor(), feature = feature, grid.size = input$effGrid, #center.at = center,
        #   method = "ale", parallel = TRUE)
        # stopCluster(cl)
        # 
        # effect.ale
        method <- "ale"
      }
    }
    effect <- FeatureEffect$new(predictor(), feature = feature, grid.size = input$effGrid, #center.at = center,
      method = method) 
    effect
  }
  
  # Feature Interaction
  else if(input$imlPlotType == "Feature Interaction"){
    feature_int <- int_feature()
    if(!is.null(feature_int)){
      if(feature_int == "All"){
        feature <- NULL
      }
      else{
        feature <- feature_int
      }
      # cl = makePSOCKcluster(detectCores() - 1)
      # registerDoParallel(cl)
      interaction <- Interaction$new(predictor(), feature = feature, grid.size = input$interactionGrid)
      #   parallel = TRUE)
      # stopCluster(cl)
    }
    interaction
  }
  
  # LIME
  
  else if(input$imlPlotType == "Local Model (LIME)"){
    if(input$limeDist == "gower"){
      dist <- "gower"
      kernel <- NULL
    }else{
      dist <- input$limeDist
      kernel <- kernel_width()
    }
    lime <- LocalModel$new(predictor(), x.interest = data_instance_lime(), k = input$limeK,
      dist.fun = dist, kernel.width = kernel)
    lime
  }
  
  
  # Shapley
  
  else if(input$imlPlotType == "Shapley Values"){
    shapley <- Shapley$new(predictor(), x.interest = data_instance_shapley(), sample.size = input$shapleySample)
    shapley
  }
  
  
  # Tree Surrogate
  
  else if(input$imlPlotType == "Tree Surrogate"){
    surrogate <- TreeSurrogate$new(predictor(), maxdepth = input$surrogateMaxDepth)
    surrogate
  }
})

observeEvent(input$iml_sets, {
  show_waiter(spin_fading_circles())
 # session$sendCustomMessage(type = 'testmessage',
  #  message = 'Thank you for clicking')
 # showModal(modalDialog("Calculations for your choosen iml methods running...", footer=NULL, size = "l", fade = T))
  output$iml_plotted <- renderPlot({isolate(plot(iml_plot_obj()))},
    height = function() {
      iml_zoom() * session$clientData$output_iml_plotted_width
    }
  )
  output$iml_results <- DT::renderDataTable({
    results <- isolate(iml_plot_obj())$results
    tab <- data.frame(results)
    if(input$iml_round == TRUE){
      tab <- round_df_num(tab, 3)
    }
    tab
  }, options = list(scrollX = TRUE), selection = "none",
    caption = "Results of your choosen IML Method")
  hide_waiter()
 # removeModal()
}, ignoreNULL = T, ignoreInit = T)


#####################################################################################################################
# Download
#####################################################################################################################

output$imlDownload <- downloadHandler(
  # height <- height_Plot(),
  filename = function() { paste("IMLPlot", Sys.Date(), '.png', sep='') },
  content = function(file) {
    device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
    ggsave(file, device = device)
  }
  # contentType = 'image/png'
)