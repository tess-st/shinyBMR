output$iml.parallel.ui = renderUI({
  list(
    radioButtons("iml.parallel", "Parallelization ?", choices = c("No","Yes"), selected = "No"),#, inline = TRUE),
    numericInput("iml.parallel.cores", "Number of Cores", min = 1L, max = Inf, value = 2L, step = 1L),
    numericInput("iml.seed", "Set Seed", min = 1L, max = Inf, value = 123L),
    #div(align = "center", 
    bsButton("iml_settings", "Set Selections & Plot", icon = icon("flag"))#)
  )
})

observeEvent(input$iml_settings, {
  req(dataiml$data)
  req(modiml$mod)
})

observeEvent(input$iml.parallel, {
  if(input$iml.parallel == "No"){
    shinyjs::hide("iml.parallel.cores", animType = "fade")
  } else{
    shinyjs::show("iml.parallel.cores", anim = TRUE)
  }
})

seed <- reactive({
  req(input$iml.seed)
})


############### Feature Importance   
output$modeltype <- renderText({
  t <- modiml$type
  t
})
outputOptions(output, "modeltype", suspendWhenHidden = FALSE)

output$impCompareInfo <- renderText({
  req(input$impCompare)
  if(input$impCompare == "ratio"){
    "Ratio: error.permutation/error.orig."
  }
  else{
    "Difference: error.permutation - error.orig."
  }
})

output$impRepInfo <- renderText({
  req(input$impRep)
  "How often should the shuffling of the feature be repeated? The higher the number of repetitions the more stable and 
  accurate the results become."
})

output$impLossInfo <- renderText({
  "Choose one of the listed loss functions (selection depending on the type of your task)."
})

observeEvent(input$iml_settings, {
  req(input$impCompare)
  req(input$impRep)
  req(input$impLossClassif)
  req(input$impLossRegr)
  req(input$impZoom)
  
  comp <- isolate(input$impCompare)
  rep <- isolate(input$impRep)
  zoom <- isolate(input$impZoom)

  output$importance_plot <- renderPlot({
    if(modiml$type == "classif"){
      loss <- input$impLossClassif
    }
    if(modiml$type == "regr"){
      loss <-  input$impLossRegr
    }
    
    set.seed(seed())
    predictor <- makePredictor(data = dataiml$data, model = modiml$mod)
    reqAndAssign(input$iml.parallel, "iml_parallel")
    
    if(iml_parallel == "No"){ 
      importance <<- FeatureImp$new(predictor, loss = loss, compare = comp, n.repetitions = rep)
    }
    if(iml_parallel == "Yes"){
      cl = makePSOCKcluster(input$iml.parallel.cores)
      registerDoParallel(cl)
      importance <<- FeatureImp$new(predictor, loss = loss, compare = comp, n.repetitions = rep,
                                    parallel = TRUE)
      stopCluster(cl)
    }
    
    plot(importance)
    
    
  },height = function() {
    zoom * session$clientData$output_importance_plot_width
  })
  
})



# output$importance_plot <- renderPlot({
#   if(modiml$type == "classif"){
#     imp_loss <- imp_loss_classif()
#   }
#   if(modiml$type == "regr"){
#     imp_loss <- imp_loss_regr
#   }
#   
#   set.seed(seed())
#   predictor <- makePredictor(data = dataiml$data, model = modiml$mod)
#   reqAndAssign(input$iml.parallel, "iml_parallel")
#   
#   if(iml_parallel == "No"){ # || is.null(iml_parallel)
#     importance <<- FeatureImp$new(predictor, loss = imp_loss, compare = input$impCompare, n.repetitions = imp_rep())#imp_compare()
#   }
#   if(iml_parallel == "Yes"){
#     cl = makePSOCKcluster(input$iml.parallel.cores)
#     registerDoParallel(cl)
#     importance <<- FeatureImp$new(predictor, loss = imp_loss, compare = input$impCompare, n.repetitions = imp_rep(),#imp_compare()
#                                   parallel = TRUE)
#     stopCluster(cl)
#   }
#   
#   plot(importance)
# },height = function() {
#   imp_zoom() * session$clientData$output_importance_plot_width
# })


output$imp_summary <- renderPrint({
  print(importance)
})

output$imp_results <- renderPrint({
  importance$results
})

############### Feature Effect
output$effMethodInfo <- renderText({
  "'pdp' for partial dependence plot, 'ice' for individual conditional expectation curves, 'pdp+ice' for partial dependence plot 
  and ice curves within the same plot, 'ale' for accumulated local effects (the default). You can get more information
  about the different methods for measuring the feature effect by switching the 'Information-Button'"
})

output$effectFeature1 <- renderUI({
  selectizeInput("effFeature1", "Select Feature 1 (necessary)", 
                 choices = c('Not Selected', as.list(getLearnerModel(modiml$mod)$features)),
                 selected = NULL, multiple = FALSE)
})

output$effectFeature2 <- renderUI({
  selectizeInput("effFeature2", "Select Feature 2 (optional)", 
                 choices = c('Not Selected', as.list(getLearnerModel(modiml$mod)$features)),
                 selected = NULL, multiple = FALSE)
})

# eff_feature1 <- reactive({
#   validate(
#     need(input$effFeature1 != "Not Selected", "Please choose the Feature you want to analyze")
#   )
#   if(input$effFeature1 == "Not Selected"){
#     NULL
#   }
#   else{
#     req(input$effFeature1)
#   }
# })

# eff_feature2 <- reactive({
#   if(input$effFeature2 == "Not Selected"){
#     NULL
#   }
#   else{
#     req(input$effFeature2)
#   }
# })

output$effFeatureInfo <- renderText({
  "The names of the features for which the effects were computed."
})

# eff_grid <- reactive({
#   req(input$effGrid)
# })

output$effGridInfo <- renderText({
  "The size of the grid for evaluating the predictions."
})

# eff_zoom <- reactive({
#   req(input$effZoom)
# })

# eff_center <- reactive({
#   if(is.null(input$effCenter)){
#     NULL
#   }else{
#     req(input$effCenter)
#   }
#   
# })
  validate(
    need(input$effFeature1 != "Not Selected", "Please choose the Feature you want to analyze")
  )
  
observeEvent(input$iml_settings, {
  req(input$effGrid)
  req(input$effZoom)

  if(input$effFeature1 == "Not Selected"){
    NULL
  }
  else{
    req(input$effFeature1)
  }
  if(input$effFeature2 == "Not Selected"){
    NULL
  }
  else{
    req(input$effFeature2)
  }
  
  grid <- isolate(input$effGrid)
  zoom <- isolate(input$effZoom)
  feat1 <- isolate(input$effFeature1)
  feat2 <- isolate(input$effFeature2)
  
  output$pdp_plot <- renderPlot({
    set.seed(seed())
    reqAndAssign(input$iml.parallel, "iml_parallel")
    
    predictor <- makePredictor(data = dataiml$data, model = modiml$mod)
    feature <- c(feat1, feat2)
    #center <- eff_center()
    
    #if(feature != "Not Selected"){
    if(!is.null(feature)){
      if(iml_parallel == "No"){
        effect.pdp <- FeatureEffect$new(predictor, feature = feature, grid.size = grid, #center.at = center,
                                        method = "pdp") 
      }
      if(iml_parallel == "Yes"){
        cl = makePSOCKcluster(input$iml.parallel.cores)
        registerDoParallel(cl)
        effect.pdp <- FeatureEffect$new(predictor, feature = feature, grid.size = grid, #center.at = center,
                                        method = "pdp", parallel = TRUE) 
        stopCluster(cl)
      }
      
      plot(effect.pdp)
    }
  },height = function() {
    zoom * session$clientData$output_pdp_plot_width
  })
  
  
  output$ice_plot <- renderPlot({
    set.seed(seed())
    reqAndAssign(input$iml.parallel, "iml_parallel")
    
    predictor <- makePredictor(data = dataiml$data, model = modiml$mod)
    #feature1 <- eff_feature1()
    feature <- eff_feature1()
    #center <- eff_center()
    
    if(feature != "Not Selected"){
      if(iml_parallel == "No"){
        effect.ice <- FeatureEffect$new(predictor, feature = feature, grid.size = grid, #center.at = center,
                                        method = "ice") 
      }
      if(iml_parallel == "Yes"){
        cl = makePSOCKcluster(input$iml.parallel.cores)
        registerDoParallel(cl)
        effect.ice <- FeatureEffect$new(predictor, feature = feature, grid.size = grid, #center.at = center,
                                        method = "ice", parallel = TRUE) 
        stopCluster(cl)
      }
      
      plot(effect.ice)
    }
  },height = function() {
    zoom * session$clientData$output_ice_plot_width
  })
  
  
  output$pdp_ice_plot <- renderPlot({
    set.seed(seed())
    reqAndAssign(input$iml.parallel, "iml_parallel")
    
    predictor <- makePredictor(data = dataiml$data, model = modiml$mod)
    feature <- eff_feature1()
    #center <- eff_center()
    
    #if(feature != "Not Selected"){
    if(feature != "Not Selected"){
      if(iml_parallel == "No"){
        effect.pdp_ice <- FeatureEffect$new(predictor, feature = feature, grid.size = grid, #center.at = center,
                                            method = "pdp+ice") 
      }
      if(iml_parallel == "Yes"){
        cl = makePSOCKcluster(input$iml.parallel.cores)
        registerDoParallel(cl)
        effect.pdp_ice <- FeatureEffect$new(predictor, feature = feature, grid.size = grid, #center.at = center,
                                            method = "pdp+ice", parallel = TRUE) 
        stopCluster(cl)
      }
      
      plot(effect.pdp_ice)
    }
  },height = function() {
    zoom * session$clientData$output_pdp_ice_plot_width
  })
  
  
  output$ale_plot <- renderPlot({
    set.seed(seed())
    reqAndAssign(input$iml.parallel, "iml_parallel")
    
    predictor <- makePredictor(data = dataiml$data, model = modiml$mod)
    feature <- c(eff_feature1(), eff_feature2())
    grid <- grid
    
    if(feature != "Not Selected"){
      if(iml_parallel == "No"){
        effect.ale <- FeatureEffect$new(predictor, feature = feature, grid.size = grid, #center.at = center,
                                        method = "ale") 
      }
      if(iml_parallel == "Yes"){
        cl = makePSOCKcluster(input$iml.parallel.cores)
        registerDoParallel(cl)
        effect.ale <- FeatureEffect$new(predictor, feature = feature, grid.size = grid, #center.at = center,
                                        method = "ale", parallel = TRUE) 
        stopCluster(cl)
      }
      
      plot(effect.ale)
    }
  },height = function() {
    zoom * session$clientData$output_ale_plot_width
  })
  
})









############### Feature Interaction
output$interactionFeature <- renderUI({
  selectizeInput("intFeature", "Select Feature", 
                 choices = c('Not Selected', 'All', as.list(getLearnerModel(modiml$mod)$features)),
                 selected = NULL, multiple = FALSE)
})

int_feature <- reactive({
  validate(
    need(input$intFeature != "Not Selected", "Please choose the Feature you want to analyze")
  )
  if(input$intFeature1 == "Not Selected"){
    NULL
  }
  else{
    req(input$effFeature1)
  }
})

output$intFeatureInfo <- renderText({
  "If 'NULL'All', for each feature the interactions with all other features are estimated. If one feature name is selected, 
  the 2-way interactions of this feature with all other features are estimated"
})

# interaction_grid <- reactive({
#   req(input$intGrid)
# })

output$intGridInfo <- renderText({
  "The number of values per feature that should be used to estimate the interaction strength. A larger grid.size means more 
  accurate the results but longer the computation time. For each of the grid points, the partial dependence functions have to 
  be computed, which involves marginalizing over all data points"
})


observeEvent(input$iml_settings, {
  req(input$intGrid)
  req(input$interactionZoom)
  
  grid <- isolate(input$intGrid)
  zoom <- isolate(input$interactionZoom)
  
  output$interaction_plot <- renderPlot({
    set.seed(seed())
    reqAndAssign(input$iml.parallel, "iml_parallel")
    
    feature <- int_feature()
    if(feature == "All"){
      feature <- NULL
    }
    predictor <- makePredictor(data = dataiml$data, model = modiml$mod)
    
    if(feature != "Not Selected"){
      if(iml_parallel == "No"){ 
        interaction <<- Interaction$new(predictor, feature = feature, grid.size = grid)
      }
      if(iml_parallel == "Yes"){
        cl = makePSOCKcluster(input$iml.parallel.cores)
        registerDoParallel(cl)
        interaction <<- Interaction$new(predictor, feature = feature, grid.size = grid,
                                        parallel = TRUE)
        stopCluster(cl)
      }
      
      plot(interaction)
    }
  },height = function() {
    imp_zoom() * session$clientData$output_interaction_plot_width
  })
  
})




############### LIME   
output$limeInterest <- renderUI({
  selectizeInput("limeInstance", "Select Instance you are intrested in",
                 choices = c('Not Selected', as.list(as.numeric(rownames(dataiml$data)))),
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

output$limeInstanceInfo <- renderText({
  "Single row with the instance to be explained."
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

lime_k <-reactive({
  req(input$limeK)
})

output$limeMaxFeaturesInfo <- renderText({
  "The (maximum) number of features to be used for the surrogate model."
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

lime_dist <- reactive({
  req(input$limeDist)
})

output$limeDistanceInfo <- renderText({
  "The name of the distance function for computing proximities (weights in the linear model). Defaults to 'gower'. Otherwise 
  will be forwarded to [stats::dist]."
})

kernel_width <- reactive({
  if(input$limeDist == "gower"){
    NULL
  }else{
    req(input$kernelWidth)
  }
})

output$limeKernelInfo <- renderText({
  "The width of the kernel for the proximity computation. Only used if dist.fun is not 'gower'."
})

output$lime_plot <- renderPlot({
  #instance <- as.numeric(lime_instance())
  #interest <- DataWithoutY(dataiml$data)[instance,]
  interest <- data_instance_lime()
  k <- lime_k()
  predictor <- makePredictor(data = dataiml$data, model = modiml$mod)
  
  if(lime_dist() == "gower"){
    lime <- LocalModel$new(predictor, x.interest = interest, k = k,
                           dist.fun = "gower")
  }else{
    lime <- LocalModel$new(predictor, x.interest = interest, k = k,
                           dist.fun = lime_dist(), kernel.width = kernel_width())
  }
  
  plot(lime)
})


############### Shapley  
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

output$shapleyInstanceInfo <- renderText({
  "Single row with the instance to be explained."
})

shapley_sample <- reactive({
  req(input$shapleySample)
})

output$shapleySampleInfo <- renderText({
  "The number of Monte Carlo samples for estimating the Shapley value."
})


output$shapley_plot <- renderPlot({
  #instance <- as.numeric(lime_instance())
  #interest <- DataWithoutY(dataiml$data)[instance,]
  interest <- data_instance_shapley()
  sample <- shapley_sample()
  predictor <- makePredictor(data = dataiml$data, model = modiml$mod)
  
  shapley <- Shapley$new(predictor, x.interest = interest, sample.size = sample)
  
  plot(shapley)
})



################## Download
output$imlDownload <- downloadHandler(
  # height <- height_Plot(),
  filename = function() { paste("IMLPlot", Sys.Date(), '.png', sep='') },
  content = function(file) {
    device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
    ggsave(file, device = device)
  }
  # contentType = 'image/png'
)