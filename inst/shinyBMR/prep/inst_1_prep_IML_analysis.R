#####################################################################################################################
# IML Analysis
#####################################################################################################################

TaskFromMod = function(data, model){
  desc <- getTaskDesc(model)
  if(getTaskDesc(model)$type == "classif"){
    target <- desc$target
    task <- makeClassifTask(data = data, target = target, positive = "ja",
                            fixup.data = "warn", check.data = TRUE
                            )  
  }
  if(getTaskDesc(model)$type == "regr"){
    task <- makeRegrTask(data = data, target = target, 
                         fixup.data = "warn", ceck.data = TRUE)
  }
  
  task
}

DataWithoutY = function(data, model){
  desc <- getTaskDesc(model)
  target <- desc$target
  data_without_y <- data[which(names(data) != target)]
  data_without_y
}

DataY = function(data, model){
  desc <- getTaskDesc(model)
  target <- desc$target
  data_y <- data[which(names(data) == target)]
  data_y
}

makePredictor = function(data, model){
  desc <- getTaskDesc(model)
  target <- desc$target
  data_without_y <- DataWithoutY(data = data, model = model) #data[which(names(data) != target)]
  data_y <- DataY(data = data, model = model) #data[which(names(data) == target)]
  if(getTaskDesc(model)$type == "classif"){  
    predictor <- Predictor$new(model, data = data_without_y, y = data_y, type = "prob")
  }
  if(getTaskDesc(model)$type == "regr"){
    predictor <- Predictor$new(model, data = data_without_y, y = data_y)
  }
  
  predictor
}

round_df_num <- function(x, digits) {
  # round all numeric variables
  # x: data frame 
  # digits: number of digits to round
  numeric_columns <- sapply(x, mode) == 'numeric'
  x[numeric_columns] <-  round(x[numeric_columns], digits)
  x
}