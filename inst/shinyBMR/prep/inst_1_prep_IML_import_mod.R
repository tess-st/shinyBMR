#####################################################################################################################
# IML Import Model
#####################################################################################################################

#Import (final) Model
makeIMLImportModSideBar = function(mod.type) {
  imptype.sel.iml.mod.input = sidebarMenu(
    menuItem("Type of Model"),
    selectInput("imlimportmod.type", "", selected = mod.type,
      choices = c("examples", "Rdata", "RDS"))
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
          selectInput("imlimport.example", "", choices = c("BreastCancer: gbm, notuning_nosmote",
          "BreastCancer: ada, untuned_nosmote", "BreastCancer: ada, tuned_nosmote",
            "BreastCancer: ranger, untuned_nosmote", "BreastCancer: ranger, tuned_nosmote", 
            "BreastCancer: svm, untuned_nosmote", "BreastCancer: svm, tuned_nosmote",  
            "LongleysEconomic: ranger, untuned", "LongleysEconomic: ranger, tuned", 
            "LongleysEconomic: svm, untuned", "LongleysEconomic: svm, tuned"))
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