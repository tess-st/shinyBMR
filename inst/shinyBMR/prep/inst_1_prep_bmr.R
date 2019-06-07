#Get relevant informations from the data.frame provided by getBMRAggrPerformances
perfAggDf = function(df){
  if(!any(names(df) == "iter")){
    sub <- gsub("*.test.*", "", names(df)[grep("*.test.*", names(df))])
    for(i in 1:length(sub)){
      df$measure <- sub[i]
      names(df)[names(df)== "measure"] <- paste("measure", i, sep="_")
      names(df)[grep("*.test.*", names(df))[1]] <- paste("value", i, sep = "_")
    }
  }
  else{
    pos <- grep("iter*", names(df))
    for(i in (pos+1):length(df)){
      df$measure <- names(df[i])
      names(df)[names(df)== "measure"] <- paste("measure", i-pos, sep="_")
      names(df)[i] <- paste("value", i-pos, sep = "_") 
    }
  }
  
  df$classif.reg <- NA
  df$learner <- NA
  df$learner.info <- NA
  df$tuning <- NA
  df$smote <- NA
  if(any(names(df) == "iter")){
    df$learner.info.iter <- NA
  }
  
  for(i in 1:nrow(df)){
    locate_task <- gregexpr("\\.", as.character(df$learner.id[i]))[[1]][1]
    locate_learner <- gregexpr("\\.", as.character(df$learner.id[i]))[[1]][2]
    locate_info <- gregexpr("\\.", as.character(df$learner.id[i]))[[1]][3]
    
    df$classif.reg[i] <- substr(as.character(df$learner.id[i]), 1, locate_task-1)
    if(df$classif.reg[i] == "classif"){
      df$classif.reg[i] <- "classification"
    }
    if(df$classif.reg[i] == "regr"){
      df$classif.reg[i] <- "regression"
    }
    
    if(!is.na(locate_learner)){
      df$learner.info[i] <- substr(as.character(df$learner.id[i]), locate_learner+1, nchar(as.character(df$learner.id[i])))
      df$learner[i] <- substr(as.character(df$learner.id[i]), locate_task+1, locate_learner-1)
      if(!is.na(locate_info)){
        df$smote[i] <- substr(as.character(df$learner.id[i]), locate_learner+1, locate_info-1)
        df$tuning[i] <- substr(as.character(df$learner.id[i]), locate_info+1, nchar(as.character(df$learner.id[i])))
      }
      else{
        df$smote[i] <- "unsmoted"
        df$tuning[i] <- "tuned"
      }
      df$learner.id[i] <- substr(as.character(df$learner.id[i]), 1, locate_learner-1)
    } 
    else{
      df$learner.info[i] <- "untuned"
      df$learner[i] <- substr(as.character(df$learner.id[i]), locate_task+1, nchar(as.character(df$learner.id[i])))
      df$smote[i] <- "unsmoted"
      df$tuning[i] <- "untuned"
    }
    
    if(any(names(df) == "iter")){
      df$learner.info.iter[i] <- paste(df$learner.info[i], df$iter[i], sep = ".")
    }
    
    locate_task <- locate_learner <- locate_info <- 0
  }
  
  df$tuning <- droplevels(factor(df$tuning, levels = c("untuned", "tuned")))
  df$smote <- droplevels(factor(df$smote, levels = c("unsmoted", "smoted")))
  df$learner <- droplevels(factor(df$learner))
  
  for(i in 1:nrow(df)){
    if(any(levels(df$smote) == "smoted")){
      df$learner.info[i] <- paste(df$tuning[i], df$smote[i], sep = ".")
    }
    else{
      df$learner.info[i] <- paste(df$tuning[i])
    }
  }
  
  if(any(levels(df$smote) == "smoted")){
    df$learner.info <- droplevels(factor(df$learner.info, levels = c("untuned.unsmoted", "untuned.smoted", 
      "tuned.unsmoted", "tuned.smoted")))
  }
  else{
    df$learner.info <- droplevels(factor(df$learner.info, levels = c("untuned", "tuned")))
  }
  
  return(df)
}

# #Get relevant informations from the data.frame provided by getBMRAggrPerformances
# perfAggDf = function(df){
#   if(!any(names(df) == "iter")){
#     sub <- gsub("*.test.*", "", names(df)[grep("*.test.*", names(df))])
#     for(i in 1:length(sub)){
#       df$measure <- sub[i]
#       names(df)[names(df)== "measure"] <- paste("measure", i, sep="_")
#       names(df)[grep("*.test.*", names(df))[1]] <- paste("value", i, sep = "_")
#     }
#   }
#   else{
#     pos <- grep("iter*", names(df))
#     for(i in (pos+1):length(df)){
#       df$measure <- names(df[i])
#       names(df)[names(df)== "measure"] <- paste("measure", i-pos, sep="_")
#       names(df)[i] <- paste("value", i-pos, sep = "_") 
#     }
#   }
#   
#   df$classif.reg <- NA
#   df$learner <- NA
#   df$learner.info <- NA
#   df$tuning <- NA
#   df$smote <- NA
#   if(any(names(df) == "iter")){
#     df$learner.info.iter <- NA
#   }
#   
#   for(i in 1:nrow(df)){
#     locate_task <- gregexpr("\\.", as.character(df$learner.id[i]))[[1]][1]
#     locate_learner <- gregexpr("\\.", as.character(df$learner.id[i]))[[1]][2]
#     locate_info <- gregexpr("\\.", as.character(df$learner.id[i]))[[1]][3]
#     
#     df$classif.reg[i] <- substr(as.character(df$learner.id[i]), 1, locate_task-1)
#     if(df$classif.reg[i] == "classif"){
#       df$classif.reg[i] <- "classification"
#     }
#     if(df$classif.reg[i] == "regr"){
#       df$classif.reg[i] <- "regression"
#     }
#     
#     if(!is.na(locate_learner)){
#       df$learner.info[i] <- substr(as.character(df$learner.id[i]), locate_learner+1, nchar(as.character(df$learner.id[i])))
#       df$learner[i] <- substr(as.character(df$learner.id[i]), locate_task+1, locate_learner-1)
#       if(!is.na(locate_info)){
#         df$smote[i] <- substr(as.character(df$learner.id[i]), locate_learner+1, locate_info-1)
#         df$tuning[i] <- substr(as.character(df$learner.id[i]), locate_info+1, nchar(as.character(df$learner.id[i])))
#       }
#       else{
#         df$smote[i] <- "unsmoted"
#         df$tuning[i] <- "tuned"
#       }
#       df$learner.id[i] <- substr(as.character(df$learner.id[i]), 1, locate_learner-1)
#     } 
#     else{
#       df$learner.info[i] <- "untuned"
#       df$learner[i] <- substr(as.character(df$learner.id[i]), locate_task+1, nchar(as.character(df$learner.id[i])))
#       df$smote[i] <- "unsmoted"
#       df$tuning[i] <- "untuned"
#     }
#     
#     df$learner.info[i] <- paste(df$tuning[i], df$smote[i], sep = ".")
#     
#     if(any(names(df) == "iter")){
#       df$learner.info.iter[i] <- paste(df$learner.info[i], df$iter[i], sep = ".")
#     }
#     
#     locate_task <- locate_learner <- locate_info <- 0
#   }
#   
#   df$learner.info <- droplevels(factor(df$learner.info, levels = c("untuned.unsmoted", "untuned.smoted", 
#     "tuned.unsmoted", "tuned.smoted")))
#   df$tuning <- droplevels(factor(df$tuning, levels = c("untuned", "tuned")))
#   df$smote <- droplevels(factor(df$smote, levels = c("unsmoted", "smoted")))
#   df$learner <- droplevels(factor(df$learner))
#   
#   return(df)
# }

perfAggOrderDf = function(df, value){
  df <- perfAggDf(df)
  value <- findValue(df, value)
  order_learner <- aggregate(df[,value], list(df$learner),
    mean)$Group.1[order(aggregate(df[,value], list(df$learner), mean)$x)]
  
  order_learner.info <- aggregate(df[,value], list(df$learner.info),
    mean)$Group.1[order(aggregate(df[,value], list(df$learner.info), mean)$x)]
  
  df$learner <- factor(df$learner, levels(df$learner)[order_learner])
  #df$learner.info <- factor(df$learner.info, levels(df$learner.info)[order_learner.info])
  
  return(df)
}