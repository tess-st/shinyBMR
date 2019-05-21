makeImportSideBar = function(type) {
  imptype.sel.input = sidebarMenu(
    menuItem("Type"),
    selectInput("import.type", "", selected = type,
      choices = c("examples", "RDS"))#c("RDS", "examples", "OpenML", "CSV", "ARFF"))
  )
  switch(type,
    RDS = list(
      imptype.sel.input,
      sidebarMenu(
        menuItem("Import"),
        fileInput("import.RDS", "Choose RDS File",
          accept = c("text/RDS", ".RDS"))
        #checkboxInput("import.header", "Header", TRUE),
        #selectInput("import.sep", "Separator", selected = ",",
        #           choices = c(Comma = ",", Semicolon = ";", Tab = "\t")),
        #selectInput("import.quote", "Quote", selected = '"',
        #             choices = c(None = "", "Double Quote" = '"', "Single Quote" = "'"))
      )
    ),
    
    examples = list(
      imptype.sel.input,
      sidebarMenu(
        menuItem("Choose example data"),
        selectInput("import.mlr", "", choices = c("iris.task", "bh.task", "sonar.task"))
      )
    )
  )
}