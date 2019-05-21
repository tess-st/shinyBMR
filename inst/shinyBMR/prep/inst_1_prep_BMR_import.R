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
      )
    ),
    
    examples = list(
      imptype.sel.input,
      sidebarMenu(
        menuItem("Choose example data"),
        selectInput("import.bmr.example", "", choices = c("Not Selected",
"Classif: BreastCancer", "Regr: LongleysEconomic"))
      )
    )
  )
}