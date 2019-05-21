#Import Data
output$imlimport.ui = renderUI({
  type = input$imlimport.type;
  if (is.null(type))
    type = "examples"
  makeIMLImportSideBar(type)
})

dataiml = reactiveValues(data = NULL, data.test = NULL, data.name = NULL)


observe({
  reqAndAssign(input$imlimport.type, "imlimport.type")
  if (is.null(imlimport.type)) {
    dataiml$data = NULL
  } else if (imlimport.type == "examples") {
    dataiml$data = getTaskData(get(input$imlimport.mlr))
  } 
  # else if (imlimport.type == "OpenML") {
  #   show("loading-openml")
  #   imp.status = need(!is.null(input$imlimport.OpenML), "")
  #   if (is.null(imp.status)) {
  #     data.id = as.integer(input$imlimport.OpenML)
  #   } else {
  #     data.id = 61L
  #   }
  #   t = getOMLDataSet(data.id = data.id)
  #   hide("loading-openml", anim = TRUE, animType = "fade")
  #   data$data = t$data
  # } 
  else if (imlimport.type == "CSV") {
    f = input$imlimport.csv$datapath
    if (is.null(f)) {
      dataiml$data = NULL
    } 
    else {
      dataiml$data = read.csv(f, header = input$imlimport.header, sep = input$imlimport.sep,
                           quote = input$imlimport.quote)
    }
  }

  else if (imlimport.type == "RDS") {
    f = input$imlimport.RDS$datapath
    if (is.null(f)) {
      dataiml$data = NULL
    } else {
      nam <- readRDS(f)
      dataiml$data <- getBMRAggrPerformances(nam, as.df = T)
    }
  }
  
  else if (imlimport.type == "Rdata") {
    f = input$imlimport.Rdata$datapath
    sessionEnvir <- sys.frame()
    if (is.null(f)) {
      dataiml$data = NULL
    } else {
      # #load(f, envir=environment())
      # eval(parse(text = load(f, sessionEnvir)))
      # nam <- "dat_imp"
      # #nam <- input$rda.name
      # dataiml$data <- get(nam)
      
      # # Use a reactiveFileReader to read the file on change, and load the content into a new environment
      # env <- reactiveFileReader(1000, session, f, LoadToEnvironment)
      # # Access the first item in the new environment, assuming that the Rdata contains only 1 item which is a data frame
      # dataiml$data <- env()[[names(env())[1]]]
      
      #file <- "C:\\Users\\Tess\\Dropbox\\Masterarbeit\\Sicherungen\\Daten_imp.rda"
      # load the file into new environment and get it from there
      e = new.env()
      load(f, envir = e)
      for (obj in ls(e)) { 
        if(class(get(obj, envir = e)) == "data.frame")
          name <- obj
      }
      dataiml$data <- e[[name]]
    }
  }
  # else if (imlimport.type == "ARFF") {
  #   f = input$imlimport.arff$datapath
  #   if (is.null(f)) {
  #     dataiml$data = NULL
  #   } else {
  #     dataiml$data = foreign::read.arff(f)
  #     # data$data = readARFF(f)
  #   }
  # }
})

df.name = reactive({
  type = input$imlimport.type
  if (type == "examples") {
    return(getTaskId(get(input$imlimport.mlr)))
  } 
  # else {
  #   if (type == "OpenML") {
  #     return(as.character(input$imlimport.OpenML))
  #   } 
    else {
      if (type == "CSV") {
        return(input$imlimport.csv$name)
      }
      else{
        if(type == "RDS") {
          return(input$imlimport.RDS$name)
        }else{
          if(type == "Rdata"){
            return(input$imlimport.Rdata$name)
            } else{
          return(input$imlimport.arff$name)
            }
        }

      }

    }
  #}
})

observe({
  reqAndAssign(input$imlimport.type, "imlimport.type")
  dataiml$data.name = df.name()
})

output$imlimport.preview = DT::renderDataTable({
  reqAndAssign(dataiml$data, "df_imp")
  colnames(df_imp) = make.names(colnames(df_imp))
  #dat_imp
  # if(is.null(df_imp)){
  #   return("Read in a Data Frame")
  # }
  if(input$round == "Off"){
    #return(perfAggDf(data$data))
    #DT::datatable(df_imp, selection = "none", options = list(scrollX = TRUE))
    df_imp
  }
  else{
    format(df_imp, digits = 3, nsmall = 3)
  }
}, options = list(scrollX = TRUE),#, scrollY = '300px'),
caption = "The following Data Set was imported")



output$summaryDataSet <- renderPrint({
  summary(dataiml$data)
})






#Import (final) Model
# output$imlimportmod.ui = renderUI({
#   type = input$imlimportmod.type;
#   if (is.null(type))
#     type = "examples"
#   makeIMLImportModSideBar(type)
# })
# 
# modiml = reactiveValues(mod = NULL, mod.name = NULL)
# 
# 
# observe({
#   reqAndAssign(input$imlimportmod.type, "imlimportmod.type")
#   if (is.null(imlimportmod.type)) {
#     modiml$mod = NULL
#   } else if (imlimportmod.type == "examples") {
#     modiml$mod = getTaskData(get(input$imlimportmod.mlr))
#   } else if (imlimportmod.type == "OpenML") {
#     show("loading-openml")
#     imp.status = need(!is.null(input$imlimportmod.OpenML), "")
#     if (is.null(imp.status)) {
#       data.id = as.integer(input$imlimportmod.OpenML)
#     } else {
#       data.id = 61L
#     }
#     t = getOMLDataSet(data.id = data.id)
#     hide("loading-openml", anim = TRUE, animType = "fade")
#     data$data = t$data
#   } else if (imlimportmod.type == "CSV") {
#     f = input$imlimportmod.csv$datapath
#     if (is.null(f)) {
#       modiml$mod = NULL
#     } else {
#       modiml$mod = read.csv(f, header = input$imlimportmod.header, sep = input$imlimportmod.sep,
#                               quote = input$imlimportmod.quote)
#     }
#   }
#   
#   else if (imlimportmod.type == "RDS") {
#     f = input$imlimportmod.RDS$datapath
#     if (is.null(f)) {
#       modiml$mod = NULL
#     } else {
#       modiml$mod <- readRDS(f)
#       #nam <- readRDS(f)
#       #modiml$mod <- getLearnerModel(nam)
#     }
#   }
#   
#   else if (imlimportmod.type == "Rdata") {
#     f = input$imlimportmod.Rdata$datapath
#     sessionEnvir <- sys.frame()
#     if (is.null(f)) {
#       modiml$mod = NULL
#     } else {
#       # #load(f, envir=environment())
#       # eval(parse(text = load(f, sessionEnvir)))
#       # nam <- "dat_imp"
#       # #nam <- input$rda.name
#       # modiml$mod <- get(nam)
#       
#       # # Use a reactiveFileReader to read the file on change, and load the content into a new environment
#       # env <- reactiveFileReader(1000, session, f, LoadToEnvironment)
#       # # Access the first item in the new environment, assuming that the Rdata contains only 1 item which is a data frame
#       # modiml$data <- env()[[names(env())[1]]]
#       
#       #file <- "C:\\Users\\Tess\\Dropbox\\Masterarbeit\\Sicherungen\\Daten_imp.rda"
#       # load the file into new environment and get it from there
#       e = new.env()
#       load(f, envir = e)
#       for (obj in ls(e)) { 
#         if(class(get(obj, envir = e)) == "data.frame")
#           name <- obj
#       }
#       modiml$mod <- e[[name]]
#     }
#   }
#   
#   
#   else if (imlimportmod.type == "ARFF") {
#     f = input$imlimportmod.arff$datapath
#     if (is.null(f)) {
#       modiml$mod = NULL
#     } else {
#       modiml$mod = foreign::read.arff(f)
#       # data$data = readARFF(f)
#     }
#   }
# })
# 
# 
# observe({
#   reqAndAssign(input$imlimportmod.type, "imlimportmod.type")
#   modiml$mod.name = getLearnerModel(modiml$mod)$learner$id
# })
# 
# output$imlimportmod.preview <- renderPrint({
#   getLearnerModel(modeliml$mod)
# })
