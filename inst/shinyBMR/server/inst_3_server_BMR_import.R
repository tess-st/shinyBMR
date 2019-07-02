output$import.ui <- renderUI({
  type = input$import.type;
  if (is.null(type))
    type = "examples"
  makeImportSideBar(type)
})

data <- reactiveValues(bmr = NULL, data = NULL, data.notagg = NULL, data.name = NULL)

observe({
  reqAndAssign(input$import.type, "import.type")
  if (is.null(import.type)) {
    data$data = NULL
  } 
  else if (import.type == "examples") {
    path_BMR <- paste(system.file("shinyBMR", package = "shinyBMR"), "examples/BMR", sep = "/")
    if(input$import.bmr.example == "Classif: BreastCancer"){
      f <- paste(path_BMR, "bmr_example_classif_BreastCancer.RDS", sep = "/")
    }
    if(input$import.bmr.example == "Regr: LongleysEconomic"){
      f <- paste(path_BMR, "bmr_example_regr_LongleysEconomic_2measures.RDS", sep = "/")
    }
    nam <- readRDS(f)
    data$bmr <- nam
    data$data <- getBMRAggrPerformances(nam, as.df = T)
    data$data.notagg <- getBMRPerformances(nam, as.df = T)
  } 
  else if (import.type == "RDS"){
    f = input$import.RDS$datapath
    if (is.null(f)) {
      data$data = NULL
    } 
    else{
      nam <- readRDS(f)
      data$bmr <- nam
      data$data <- getBMRAggrPerformances(nam, as.df = T)
      data$data.notagg <- getBMRPerformances(nam, as.df = T)
    }
  }
})

data.name = reactive({
  type = input$import.type
  if(type == "examples") {
    return(input$import.examples$name)
  } 
  else{
    if(type == "RDS") {
      return(input$import.RDS$name)
    }
  }
})

observe({
  reqAndAssign(input$import.type, "import.type")
  data$data.name = data.name()
})

output$import.analysis <- DT::renderDataTable({
  reqAndAssign(data$data, "data_agg")
  reqAndAssign(data$data.notagg, "data_unagg")
  
  if(input$aggregated == "On"){
    if(input$round == "Off"){
      tabImport(perfAggDf(data_agg))
    }
    else if(input$round == "On"){
      roundDf(tabImport(perfAggDf(data_agg)), digits = 3, nsmall = 3)
    }
  }
  else{
    if(input$round == "Off"){
      tabImportUnagg(perfAggDf(data_unagg))
    }
    else{
      roundDf(tabImportUnagg(perfAggDf(data_unagg)), digits = 3, nsmall = 3)
    }
  }
}, options = list(scrollX = TRUE), selection = 'none',
  caption = "The Data Set for the BMR Analysis has the following structure")
