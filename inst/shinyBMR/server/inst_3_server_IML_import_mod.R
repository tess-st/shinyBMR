#Import (final) Model
output$imlimportmod.ui <- renderUI({
  type = input$imlimportmod.type;
  if (is.null(type))
    type = "examples"
  makeIMLImportModSideBar(type)
})

modiml <- reactiveValues(mod = NULL, mod.name = NA, type = NA)


observe({
  reqAndAssign(input$imlimportmod.type, "imlimportmod.type")
  if (is.null(imlimportmod.type)){
    modiml$mod = NULL
  } else if (imlimportmod.type == "examples"){
    path_IML <- paste(system.file("shinyBMR", package = "shinyBMR"), "examples/BMR", sep = "/")
    if(input$import.iml.example == "BreastCancer: gbm, notuning_nosmote"){
      f <- paste(path_IML, "iml_example_classif_BreastCancer_gbm_notuning_nosmote.RDS", sep = "/")
    }
    if(input$import.iml.example == "BreastCancer: rpart, notuning_nosmote"){
      f <- paste(path_IML, "iml_example_classif_BreastCancer_rpart_notuning_nosmote.RDS", sep = "/")
    }
    if(input$import.iml.example == "BreastCancer: rpart, notuning_smote"){
      f <- paste(path_IML, "iml_example_classif_BreastCancer_rpart_notuning_smote.RDS", sep = "/")
    }
    if(input$import.iml.example == "LongleysEconomic: glmnet, untuned"){
      f <- paste(path_IML, "iml_example_regr_LongleysEconomic_glmnet_untuned.RDS", sep = "/")
    }
    if(input$import.iml.example == "LongleysEconomic: glmnet, untuned"){
      f <- paste(path_IML, "iml_example_regr_LongleysEconomic_rpart_tuned.RDS", sep = "/")
    }
    modiml$mod <- readRDS(f)
  } 
  
  else if(imlimportmod.type == "RDS"){
    f = input$imlimportmod.RDS$datapath
    if(is.null(f)){
      modiml$mod = NULL
    } else{
      modiml$mod <- readRDS(f)
    }
  }
  
  else if(imlimportmod.type == "Rdata"){
    f = input$imlimportmod.Rdata$datapath
    sessionEnvir <- sys.frame()
    if(is.null(f)){
      modiml$mod = NULL
    } 
    else{
      e = new.env()
      load(f, envir = e)
      for(obj in ls(e)){
        if(class(get(obj, envir = e)) == "data.frame")
          name <- obj
      }
      modiml$mod <- e[[name]]
    }
  }
  
  if(!is.null(modiml$mod)){
    modiml$mod.name = getLearnerModel(modiml$mod)$learner$id
    modiml$type = getLearnerModel(modiml$mod)$learner$type
  }
})


output$learnerModel <- renderPrint({
  validate(need(!is.null(modiml$mod), "Choose the (final) Model for your IML Analysis"))
  if(!is.null(modiml$mod)){
    if(!is.null(getLearnerModel(modiml$mod)$learner)){
      getLearnerModel(modiml$mod)$learner  
    }
    else{
      (modiml$mod)$learner
    }
  }
})


output$overviewTask <- renderPrint({
  validate(need(!is.null(modiml$mod), "Choose the (final) Model for your IML Analysis"))
  if(!is.null(modiml$mod)){
    (modiml$mod)$task.desc 
  }
})