#####################################################################################################################
# Import (final) Model
#####################################################################################################################

output$imlimportmod.ui <- renderUI({
  type = input$imlimportmod.type;
  if (is.null(type))
    type = "examples"
  makeIMLImportModSideBar(type)
})

modiml <- reactiveValues(mod = NULL, mod.name = NA, type = NA)

# #
# output$imlimport.example <- renderUI({
#   reqAndAssign(input$import.iml.example, "example")
#   reqAndAssign(input$imlimport.type, "imlimport.type")
#   if (imlimport.type == "examples"){
#     if(example == "Classif: BreastCancer"){
#     choices <- c("BreastCancer: gbm, notuning_nosmote", "BreastCancer: rpart, notuning_nosmote")
#   }
#   else if(example == "Regr: LongleysEconomic"){
#     choices <- c("LongleysEconomic: glmnet, untuned", "LongleysEconomic: rpart tuned")
#   }
#   selectInput("imlimport.example", "", choices = choices)}
#   #, "BreastCancer: rpart, notuning_smote",
#   # "LongleysEconomic: glmnet, untuned", "LongleysEconomic: rpart tuned"))
# }) 


observe({
  reqAndAssign(input$imlimportmod.type, "imlimportmod.type")
  if (is.null(imlimportmod.type)){
    modiml$mod = NULL
  } else if (imlimportmod.type == "examples"){
    path_mod <- paste(system.file("shinyBMR", package = "shinyBMR"), "examples/IML_mod", sep = "/")
    if(input$imlimport.example == "BreastCancer: gbm, notuning_nosmote"){
      f <- paste(path_mod, "iml_example_classif_BreastCancer_gbm_notuning_nosmote.RDS", sep = "/")
    }
    else if(input$imlimport.example == "BreastCancer: ada, untuned_nosmote"){
      f <- paste(path_mod, "iml_example_classif_BreastCancer_ada_untuned.RDS", sep = "/")
    }
    else if(input$imlimport.example == "BreastCancer: ada, tuned_nosmote"){
      f <- paste(path_mod, "iml_example_classif_BreastCancer_ada_tuned.RDS", sep = "/")
    }
    else if(input$imlimport.example == "BreastCancer: ranger, untuned_nosmote"){
      f <- paste(path_mod, "iml_example_classif_BreastCancer_ranger_untuned.RDS", sep = "/")
    }
    else if(input$imlimport.example == "BreastCancer: ranger, tuned_nosmote"){
      f <- paste(path_mod, "iml_example_classif_BreastCancer_ranger_tuned.RDS", sep = "/")
    }
    else if(input$imlimport.example == "BreastCancer: svm, untuned_nosmote"){
      f <- paste(path_mod, "iml_example_classif_BreastCancer_svm_untuned.RDS", sep = "/")
    }
    else if(input$imlimport.example == "BreastCancer: svm, tuned_nosmote"){
      f <- paste(path_mod, "iml_example_classif_BreastCancer_svm_tuned.RDS", sep = "/")
    }
    
    else if(input$imlimport.example == "LongleysEconomic: ranger, untuned"){
      f <- paste(path_mod, "iml_example_regr_LongleysEconomic_ranger_untuned.RDS", sep = "/")
    }
    else if(input$imlimport.example == "LongleysEconomic: ranger, tuned"){
      f <- paste(path_mod, "iml_example_regr_LongleysEconomic_ranger_tuned.RDS", sep = "/")
    }
    else if(input$imlimport.example == "LongleysEconomic: svm, untuned"){
      f <- paste(path_mod, "iml_example_regr_LongleysEconomic_svm_untuned.RDS", sep = "/")
    }
    else if(input$imlimport.example == "LongleysEconomic: svm, tuned"){
      f <- paste(path_mod, "iml_example_regr_LongleysEconomic_svm_tuned.RDS", sep = "/")
    }
    ##
    # if(input$imlimport.example == "BreastCancer: rpart, notuning_smote"){
    #   f <- paste(path_IML, "iml_example_classif_BreastCancer_rpart_notuning_smote.RDS", sep = "/")
    # }
    # if(input$imlimport.example == "LongleysEconomic: glmnet, untuned"){
    #   f <- paste(path_IML, "iml_example_regr_LongleysEconomic_glmnet_untuned.RDS", sep = "/")
    # }
    # if(input$imlimport.example == "LongleysEconomic: glmnet, untuned"){
    #   f <- paste(path_IML, "iml_example_regr_LongleysEconomic_rpart_tuned.RDS", sep = "/")
    # }
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
    modiml$mod.name = modiml$mod$learner$id
    modiml$type = modiml$mod$learner$type
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

output$listTask <-renderJsonedit({
  validate(need(!is.null(modiml$mod), "Choose the (final) Model for your IML Analysis"))
  if(!is.null(modiml$mod)){
  jsonedit(getTaskDesc(modiml$mod), mode = "view")
  }
})