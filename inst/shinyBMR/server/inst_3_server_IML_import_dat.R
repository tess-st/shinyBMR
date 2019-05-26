# Import Data
output$imlimport.ui <- renderUI({
  type = input$imlimport.type;
  if (is.null(type))
    type = "examples"
  makeIMLImportSideBar(type)
})


dataiml <- reactiveValues(data = NULL, data.test = NULL, data.name = NULL)


observe({
  reqAndAssign(input$imlimport.type, "imlimport.type")
  if (is.null(imlimport.type)){
    dataiml$data = NULL
  } else if (imlimport.type == "examples"){
    path_dat <- paste(system.file("shinyBMR", package = "shinyBMR"), "examples/IML_dat", sep = "/")
    if(input$import.iml.example == "Classif: BreastCancer"){
      f <- paste(path_dat, "data_BreastCancer.rda", sep = "/")
    }
    if(input$import.iml.example == "Regr: LongleysEconomic"){
      f <- paste(path_dat, "data_LongleysEconomic.RData", sep = "/")
    }
    
    sessionEnvir <- sys.frame()
    if (is.null(f)){
      dataiml$data = NULL
    }
    else{
      e = new.env()
      load(f, envir = e)
      for (obj in ls(e)){ 
        if(class(get(obj, envir = e)) == "data.frame")
          name <- obj
      }
      dataiml$data <- e[[name]]
    }
  } 
  
  else if (imlimport.type == "CSV"){
    f = input$imlimport.csv$datapath
    if (is.null(f)){
      dataiml$data = NULL
    } 
    else{
      dataiml$data = read.csv(f, header = input$imlimport.header, sep = input$imlimport.sep,
        quote = input$imlimport.quote)
    }
  }
  
  else if (imlimport.type == "RDS"){
    f = input$imlimport.RDS$datapath
    if (is.null(f)){
      dataiml$data = NULL
    } 
    else{
      nam <- readRDS(f)
      dataiml$data <- getBMRAggrPerformances(nam, as.df = T)
    }
  }
  
  else if (imlimport.type == "Rdata"){
    f = input$imlimport.Rdata$datapath
    sessionEnvir <- sys.frame()
    if (is.null(f)){
      dataiml$data = NULL
    } 
    else{
      e = new.env()
      load(f, envir = e)
      for (obj in ls(e)){ 
        if(class(get(obj, envir = e)) == "data.frame")
          name <- obj
      }
      dataiml$data <- e[[name]]
    }
  }
})


df.name <- reactive({
  type = input$imlimport.type
  if (type == "examples"){
    return(input$imlimport.examples$name)
  }  
  else{
    if (type == "CSV"){
      return(input$imlimport.csv$name)
    }
    else{
      if(type == "RDS"){
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
})


observe({
  reqAndAssign(input$imlimport.type, "imlimport.type")
  dataiml$data.name = df.name()
})


output$imlimport.preview <- DT::renderDataTable({
  reqAndAssign(dataiml$data, "df_imp")
  colnames(df_imp) = make.names(colnames(df_imp))
  if(input$round == "Off"){
    df_imp
  }
  else{
    format(df_imp, digits = 3, nsmall = 3)
  }
}, options = list(scrollX = TRUE),#, scrollY = '300px'),
  caption = "The following Data Set was imported")


# output$summaryDataSet <- renderPrint({
#   summary(dataiml$data)
# })


# Summary
summarize.data = reactive({
  if(is.null(dataiml$data)){
    NULL
  }
  else{
    d = dataiml$data
    
    validate(need(class(d) == "data.frame", "You didn't import any Data."))
    colnames(d) = make.names(colnames(d))
    pos.x = colnames(Filter(function(x) "POSIXt" %in% class(x) , d))
    d = dropNamed(d, drop = pos.x)    
    summarizeColumns(d)
  }
})

output$summary.dat = renderUI({
  # if (input$show_help)
  #   text = htmlOutput("summary.text")
  # else
  #   text = NULL
  
  ui = box(width = 12, title = "Summary",
    br(),
    DT::dataTableOutput("summary.datatable")
  )
  ui
})

output$summary.datatable = DT::renderDataTable({
  summarize.data()
}, options = list(scrollX = TRUE))