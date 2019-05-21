#Import (final) Model
makeIMLImportModSideBar = function(mod.type) {
  imptype.sel.iml.mod.input = sidebarMenu(
    menuItem("Type of Model"),
    selectInput("imlimportmod.type", "", selected = "RDS", #"mod.type"
                choices = c("RDS", "examples", "Rdata")) #"CSV", , "OpenML", "ARFF"))
  )
  switch(mod.type,
         RDS = list(
           imptype.sel.iml.mod.input,
           sidebarMenu(
             menuItem("Import Model"),
             fileInput("imlimportmod.RDS", "Choose RDS File",
                       accept = c("text/RDS", ".RDS"))
           )
         ),

         examples = list(
           imptype.sel.iml.mod.input,
           sidebarMenu(
             menuItem("Choose example model"),
             selectInput("imlimport.mlr", "", choices = c("iris.task", "bh.task", "sonar.task"))
           )
         ),

         Rdata = list(
           imptype.sel.iml.mod.input,
           sidebarMenu(
             menuItem("Choose Rdata Model"),
             fileInput("imlimportmod.Rdata", "Choose RDdata File",
                       accept = c("text/RDA", "text/rda", ".RDA", ".rda", ".Rdata"))
             # textInput("rda.name", "Type in the Name of you Data Frame")
           )

         )
         # ,
         # OpenML = list(
         #   imptype.sel.iml.mod.input,
         #   sidebarMenu(
         #     menuItem("Choose OpenML Data ID"),
         #     selectInput("imlimport.OpenML", "", selected = 61L,
         #                 choices = listOMLDataSets()[,1], multiple = FALSE)
         #   )
         # ),
         # CSV = list(
         #   imptype.sel.iml.mod.input,
         #   sidebarMenu(
         #     menuItem("Import .csv Model"),
         #     fileInput("imlimportmod.csv", "Choose CSV File",
         #               accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
         #     checkboxInput("imlimport.header", "Header", TRUE),
         #     selectInput("imlimport.sep", "Separator", selected = ",",
         #                 choices = c(Comma = ",", Semicolon = ";", Tab = "\t")),
         #     selectInput("imlimport.quote", "Quote", selected = '"',
         #                 choices = c(None = "", "Double Quote" = '"', "Single Quote" = "'"))
         #   )
         # ),
         # ARFF = list(
         #   imptype.sel.iml.input,
         #   sidebarMenu(
         #     menuItem("Choose ARFF File"),
         #     fileInput("imlimport.arff", "", accept = c(".arff"))
         #   )
         # )
  )
}
