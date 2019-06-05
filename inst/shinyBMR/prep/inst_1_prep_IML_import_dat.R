#Import Data
makeIMLImportSideBar = function(data.type) {#, mod.type) {
  imptype.sel.iml.input = sidebarMenu(
    menuItem("Type"),
    selectInput("imlimport.type", "", selected = data.type,
      choices = c("examples","CSV", "Rdata", "RDS"))
  )
  
  
  switch(data.type,
    RDS = list(
      imptype.sel.iml.input,
      sidebarMenu(
        menuItem("Import"),
        fileInput("imlimport.RDS", "Choose RDS File",
          accept = c("text/RDS", ".RDS"))
      )
    ),
    
    examples = list(
      imptype.sel.iml.input,
      sidebarMenu(
        menuItem("Choose Example Data"),
        selectInput("import.iml.example", "", 
          choices = c("Classif: BreastCancer", "Regr: LongleysEconomic"))
      )
    ),
    
    Rdata = list(
      imptype.sel.iml.input,
      sidebarMenu(
        menuItem("Choose Rdata"),
        fileInput("imlimport.Rdata", "Choose RDdata File",
          accept = c("text/RDA", "text/rda", ".RDA", ".rda", ".Rdata"))
      )
    ),
    
    CSV = list(
      imptype.sel.iml.input,
      sidebarMenu(
        menuItem("Import"),
        fileInput("imlimport.csv", "Choose CSV File",
          accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
        checkboxInput("imlimport.header", "Header", TRUE),
        selectInput("imlimport.sep", "Separator", selected = ",",
          choices = c(Comma = ",", Semicolon = ";", Tab = "\t")),
        selectInput("imlimport.quote", "Quote", selected = '"',
          choices = c(None = "", "Double Quote" = '"', "Single Quote" = "'"))
      )
    )
  )
}