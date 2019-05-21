TaskFromMod = function(data, model){
  desc <- getTaskDesc(model)
  if(getTaskDesc(model)$type == "classif"){
    target <- desc$target
    # if(desc$has.weights == F){
    #   weights <- NULL
    # }
    task <- makeClassifTask(data = data, target = target, positive = "ja",#NA_character_,
                            #weights = weights, blocking = blocking, coordinates = NULL,
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