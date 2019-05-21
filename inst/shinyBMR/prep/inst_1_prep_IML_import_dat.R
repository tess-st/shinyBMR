#Import Data
makeIMLImportSideBar = function(data.type, mod.type) {
  imptype.sel.iml.input = sidebarMenu(
    menuItem("Type"),
    selectInput("imlimport.type", "", selected = data.type,
                choices = c("examples","CSV", "Rdata", "RDS"))# , "OpenML", "ARFF"))
    # menuItem("Type of Model"),
    #   selectInput("imlimportmod.type", "", selected = mod.type,
    #               choices = c("RDS", "examples", "CSV", "Rdata", "OpenML", "ARFF"))
    
    #   selectInput("imlimportmod.type", "", selected = mod.type,
    #               choices = c("RDS", "examples", "CSV", "Rdata", "OpenML", "ARFF"))
    
    # ,
    # #
    # imptype.sel.iml.mod.input = sidebarMenu(
    #   menuItem("Type of Model"),
    #   selectInput("imlimportmod.type", "", selected = mod.type,
    #               choices = c("RDS", "examples", "CSV", "Rdata", "OpenML", "ARFF"))
    # )
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
             menuItem("Choose example data"),
             selectInput("imlimport.mlr", "", choices = c("iris.task", "bh.task", "sonar.task"))
           )
         ),
         
         Rdata = list(
           imptype.sel.iml.input,
           sidebarMenu(
             menuItem("Choose Rdata"),
             fileInput("imlimport.Rdata", "Choose RDdata File",
                       accept = c("text/RDA", "text/rda", ".RDA", ".rda", ".Rdata"))
            # textInput("rda.name", "Type in the Name of you Data Frame")
           )
         ),
         # OpenML = list(
         #   imptype.sel.iml.input,
         #   sidebarMenu(
         #     menuItem("Choose OpenML Data ID"),
         #     selectInput("imlimport.OpenML", "", selected = 61L,
         #                 choices = listOMLDataSets()[,1], multiple = FALSE)
         #   )
         # ),
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
         # ,
         # ARFF = list(
         #   imptype.sel.iml.input,
         #   sidebarMenu(
         #     menuItem("Choose ARFF File"),
         #     fileInput("imlimport.arff", "", accept = c(".arff"))
         #   )
         # )
  )
}