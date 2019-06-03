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
        menuItem("Choose Example Data"),
        selectInput("import.bmr.example", "", choices = c("Classif: BreastCancer", "Regr: LongleysEconomic"))
      )
    )
  )
}

# Visualization of the imported Data
tabImport <- function(data){
  measures <- grep("measure_", names(data))
  values <- grep("value_", names(data))
  names <- NA
  for(i in 1:length(measures)){
    names[i] <- data[1,measures[i]] 
    names(data)[values[i]] <- names[i]
  }
  data$task.id <- with(data, paste(task.id, classif.reg, sep = ", "))
  data_tab <- subset(data, select = -c(measures, learner.id, classif.reg, learner.info))
  names(data_tab)[1] <- "Name and Art of Task"
  names(data_tab)[names(data_tab) == "learner"] <- "Learner"
  names(data_tab)[names(data_tab) == "tuning"] <- "Tuning"
  names(data_tab)[names(data_tab) == "smote"] <- "SMOTE"
  
  return(data_tab)
}

tabImportUnagg <- function(data){
  data <- tabImport(data)
  data_tab <- subset(data, select = -c(learner.info.iter))
  
  return(data_tab)
}
