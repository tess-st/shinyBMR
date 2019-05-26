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


# Summary Plots
numericFeatures = reactive({
  d = dataiml$data
  return(colnames(Filter(is.numeric, d)))
})

factorFeatures = reactive({
  # req(data$data)
  d = dataiml$data
  return(colnames(Filter(is.factor, d)))
})

summary.vis.var = reactive({
  reqAndAssign(dataiml$data, "d")
  pos.x = colnames(Filter(function(x) "POSIXt" %in% class(x) , d))
  d = dropNamed(d, drop = pos.x)
  s = summarizeColumns(d)
  s$name[input$summary.datatable_rows_selected]
})

output$summary.vis.hist = renderUI({
  list(
    column(3,
      radioButtons("summary.vis.dens", "Plot type", choices = c("Histogram", "Density"),
        selected = "Histogram", inline = TRUE)
    ),
    column(9,
      sliderInput("summary.vis.hist.nbins", "Number of bins", min = 1L, max = 100L,
        value = 30L, step = 1L, width = "95%")
    )
  )
})

observeEvent(input$summary.vis.dens, {
  if (input$summary.vis.dens == "Density")
    shinyjs::hide("summary.vis.hist.nbins", animType = "fade")
  else
    shinyjs::show("summary.vis.hist.nbins", animType = "fade")
})

observeEvent(summary.vis.var(), {
  feature = summary.vis.var()
  if (length(feature) > 0L) {
    shinyjs::show("summary.vis.box", anim = TRUE)
    if (length(feature) == 1L) {
      if (feature %in% factorFeatures()) {
        shinyjs::hide("summary.vis.hist", animType = "fade")
      } else {
        shinyjs::show("summary.vis.hist", anim = TRUE)
      }
    } else
      shinyjs::hide("summary.vis.hist", animType = "fade")
  } else {
    shinyjs::hide("summary.vis.box", anim = TRUE)
  }
})

summary.vis.out = reactive({
  reqAndAssign(summary.vis.var(), "feature")
  d = na.omit(dataiml$data)
  req(all(feature %in% colnames(d)))
  #reqNFeat(feature, d)
  barfill = "#3c8dbc"
  barlines = "#1d5a92"
  if (length(feature) == 1L) {
    if (feature %in% numericFeatures()) {
      reqAndAssign(input$summary.vis.dens, "density")
      x = as.numeric(d[,feature])
      summary.plot = ggplot(data = d, aes(x = x))
      
      if (density == "Density")
        summary.plot = summary.plot + geom_density(fill = "blue", alpha = 0.1)
      else
        summary.plot = summary.plot + geom_histogram(colour = barlines, fill = barfill, stat = "bin", bins = input$summary.vis.hist.nbins)
      
      summary.plot = summary.plot + xlab(feature) +
        geom_vline(aes(xintercept = quantile(x, 0.05)), color = "blue", size = 0.5, linetype = "dashed") +
        geom_vline(aes(xintercept = quantile(x, 0.95)), color = "blue", size = 0.5, linetype = "dashed") +
        geom_vline(aes(xintercept = quantile(x, 0.5)), color = "blue", size = 1, linetype = "dashed")
      summary.plot #= addPlotTheme(summary.plot)
      summary.plot
    } else {
      class = d[,feature]
      summary.plot = ggplot(data = d, aes(x = class)) + 
        geom_bar(aes(fill = class), stat = "count") + xlab(feature) +
        guides(fill = FALSE)
      summary.plot #= addPlotTheme(summary.plot)
      summary.plot
    }
  } else if (length(feature) > 1L) {
    summary.plot = GGally::ggpairs(data = d, columns = feature,
      upper = list(continuous = GGally::wrap("cor", size = 10)), 
      lower = list(continuous = "smooth"))
    summary.plot
  }
})

output$summary.vis = renderPlotly({
  ggplotly(summary.vis.out())
})

summary.vis.collection = reactiveValues(var.plots = NULL)#var.names = NULL, var.plots = NULL)

observeEvent(summary.vis.out(), {
  q = summary.vis.out()
  feat = isolate(summary.vis.var())
  feat = paste(feat, collapse = ".x.")
  
  # summary.vis.collection$var.names = c(summary.vis.collection$var.names, feat)
  summary.vis.collection$var.plots[[feat]] = q
  
})