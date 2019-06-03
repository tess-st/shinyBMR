#Import (final) Model
makeIMLImportModSideBar = function(mod.type) {
  imptype.sel.iml.mod.input = sidebarMenu(
    menuItem("Type of Model"),
    selectInput("imlimportmod.type", "", selected = "RDS",
      choices = c("RDS", "examples", "Rdata"))
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
        menuItem("Choose Example Model"),
        selectInput("import.iml.example", "", choices = c("BreastCancer: gbm, notuning_nosmote", 
          "BreastCancer: rpart, notuning_nosmote", "BreastCancer: rpart, notuning_smote",
          "LongleysEconomic: glmnet, untuned", "LongleysEconomic: rpart tuned"))
      )
    ),
    
    Rdata = list(
      imptype.sel.iml.mod.input,
      sidebarMenu(
        menuItem("Choose Rdata Model"),
        fileInput("imlimportmod.Rdata", "Choose RDdata File",
          accept = c("text/RDA", "text/rda", ".RDA", ".rda", ".Rdata"))
      )
    )
  )
}
