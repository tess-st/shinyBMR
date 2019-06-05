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

# imp_zoom <- reactive({
#   req(input$impZoom)
# })


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
    # if(!is.null(feature)){
    if(!is.null(feature_int)){
      if(feature_int == "All"){
        feature <- NULL
      }
      else{
        feature <- feature_int
      }
      # }
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
  output$iml_plotted <- renderPlot({isolate(plot(iml_plot_obj()))},
    height = function() {
      iml_zoom() * session$clientData$output_iml_plotted_width
    }
  )
  # output$iml_results <- renderPrint({isolate(iml_plot_obj())$results})
  output$iml_results <- DT::renderDataTable({
    results <- isolate(iml_plot_obj())$results
    tab <- data.frame(results)
    if(input$iml_round == TRUE){
      tab <- round_df_num(tab, 3)
    }
    tab
  }, options = list(scrollX = TRUE), selection = "none",
    caption = "Results of your choosen IML Method")
}, ignoreNULL = T, ignoreInit = T)


#####################################################################################################################
# Info Text
#####################################################################################################################

# Dat Info
output$imlDataInfo <- renderText({
  "But first of all you have to select the Data and the belonging Model you want to analyze.
  Therefore go to 'IML Import Data' and 'IML Import Model' and make your selections.
  "
})

# Start Info
output$imlStartInfo <- renderText({
  "Here you can now choose the IML Method you want to use for making your Blackbox interpretabel."
})

# Feature Importance
output$impCompInfo <- renderText({
  req(input$impComp)
  if(input$impComp == "ratio"){
    "Ratio: error.permutation/error.orig."
  }
  else{
    "Difference: error.permutation - error.orig."
  }
})

output$impRepInfo <- renderText({
  req(input$impRep)
  "How often should the shuffling of the feature be repeated? The higher the number of repetitions the more stable 
  and accurate the results become."
})

output$impLossInfo <- renderText({
  "Choose one of the listed loss functions (selection depending on the type of your task)."
})


# Feature Effects
output$effMethodInfo <- renderText({
  "'pdp' for partial dependence plot, 'ice' for individual conditional expectation curves, 'pdp+ice' for partial dependence plot
  and ice curves within the same plot, 'ale' for accumulated local effects (the default). You can get more information
  about the different methods for measuring the feature effect by switching the 'Information-Button'."
})

output$effFeatureInfo <- renderText({
  "The names of the features for which the effects were computed."
})

output$effGridInfo <- renderText({
  "The size of the grid for evaluating the predictions."
})


# Feature Interaction
output$intFeatureInfo <- renderText({
  "If 'All', for each feature the interactions with all other features are estimated. If one feature name is selected,
  the 2-way interactions of this feature with all other features are estimated"
})

output$intGridInfo <- renderText({
  "The number of values per feature that should be used to estimate the interaction strength. A larger grid.size means more
  accurate the results but longer the computation time. For each of the grid points, the partial dependence functions have to
  be computed, which involves marginalizing over all data points."
})


# LIME
output$limeInstanceInfo <- renderText({
  "Single row with the instance to be explained."
})

output$limeMaxFeaturesInfo <- renderText({
  "The (maximum) number of features to be used for the surrogate model."
})

output$limeDistanceInfo <- renderText({
  "The name of the distance function for computing proximities (weights in the linear model). Defaults to 'gower'. Otherwise
  will be forwarded to [stats::dist]."
})

output$limeKernelInfo <- renderText({
  "The width of the kernel for the proximity computation. Only used if dist.fun is not 'gower'."
})


# Shapley
output$shapleyInstanceInfo <- renderText({
  "Single row with the instance to be explained."
})

output$shapleySampleInfo <- renderText({
  "The number of Monte Carlo samples for estimating the Shapley value."
})


# Tree Surrogate
output$surrogateMaxDepthInfo <- renderText({
  "The maximum depth of the tree."
})




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
