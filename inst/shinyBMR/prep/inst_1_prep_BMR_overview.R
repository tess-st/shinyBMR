#####################################################################################################################
# Summary
#####################################################################################################################

textInfobox = function(levels){
  if(is.factor(levels)){
    names <- levels(levels)
    n <- nlevels(levels)
  }else{
    names <- unique(levels)
    n <- length(names)
  }
  
  if(n > 1){
    for(i in 1:(nlevels(levels)-1)){
      if(i == 1){
        text <- paste(names[i], names[i+1], sep = ", ")
      }else{
        text <- paste(text, names[i+1], sep = ", ")
      }
    }
  }
  
  if(n == 1){
    text <- names[1]
  }
  
  return(text)
}

textInfoboxMeasure = function(data){
  pos <- grep("measure_*", names(data))
  names <- NA
  for(i in 1:length(pos)){
    names[i] <- data[1,pos[i]]
    n <- length(names)
  }
  
  if(n > 1){
    for(i in 1:(n-1)){
      if(i == 1){
        text <- paste(names[i], names[i+1], sep = ", ")
      }else{
        text <- paste(text, names[i+1], sep = ", ")
      }
    }
  }
  
  if(n == 1){
    text <- names[1]
  }
  return(text)
}

crossTab <- function(dataset, vec, position){
  if(sum(vec == 'Not Selected') != 3){
    if(vec[1] == 'Not Selected'){
      message <- "You need to select the First Table Element"
      tab <- 0
    }else{
      if(vec[2] == 'Not Selected' && vec[3] != 'Not Selected'){
        message <- "You need to select the Second Table Element before the Third"
        tab <- 0
      }else{
        for(i in length(vec):1){
          if(vec[i] == 'Not Selected'){
            vec <- vec[-i]
          }
          vec_pos <- which(names(dataset) == vec[i])
          position <- append(vec_pos, position)
          tab <- 1
          crosstable <- dataset[position]
        }
      }
    }
    
    if(tab != 0){
      table(crosstable)
    } else{message}
    
  }
}


#####################################################################################################################
# Best Model/Pareto
#####################################################################################################################

# paretoPref <- function(dat, measure, highlow){
#   m <- listMeasures()
#   if(measure %in% m){
#     measure_mlr <- getFromNamespace(measure, "mlr")
#   }
#   #else if(!(measure %in% m)){
#   #  measure_mlr <- dat$measures[[2]]
#   #}
#     if(measure_mlr$minimize == FALSE){
#       pref <- high_(measure)
#     }
#     else if(measure_mlr$minimize == TRUE){
#       pref <- low_(measure)
#     }
#   #}
#   
#   
#     # if(is.null(highlow)){NULL}
#     # else if(highlow == "High"){
#     #   pref <- high_(measure)
#     # }
#     # else if(highlow == "Low"){
#     #   pref <- low_(measure)
#     # }
#  # }
#   pref
# }

paretoPref <- function(dat, measure = NULL){
  m <- mlr::listMeasures()
  if(is.null(measure)){NULL}
  else if(measure %in% m){
    measure_mlr <- getFromNamespace(measure, "mlr")
  }
  # else if(!(measure %in% m)){
  #  measure_mlr <- dat$measure
  # }
  if(measure == "pAUC"){
    pref <- high_(measure)
  }
  else{
    if(measure_mlr$minimize == FALSE){
      pref <- high_(measure)
    }
    else if(measure_mlr$minimize == TRUE){
      pref <- low_(measure)
    }
  } 
  
  pref
}

paretoOpt <- function(dat, measure1, measure2){
  df <- tabImport(perfAggDf(getBMRAggrPerformances(dat, as.df = T)))
  sel <- psel(df, paretoPref(dat, measure1) * paretoPref(dat, measure2), top = nrow(df))
  sel$.level <- as.factor(sel$.level)
  tab_pareto <- arrange(sel, sel$.level, sel[,measure1])
  tab_pareto
}

# paretoFront <- function(dat, measure1, measure2, highlow1, highlow2, type, size_text, size_symbols){
#   sel <- paretoOpt(dat, measure1, measure2, highlow1, highlow2)
#   sky <- psel(dat, paretoPref(measure1, highlow1) * paretoPref(measure2, highlow2))#, top_level = level)
#   sky <- sky[order(sky[,measure1]),]
#   
#   if(size_text == -1){
#     t <- theme()
#   }else{
#     t <- theme(text = element_text(size = rel(size_text+2)), 
#       legend.text = element_text(size = 0.6*rel(size_text+3)), 
#       legend.key.height = unit(0.25*rel(size_text+3), "cm"))
#   }
#   
#   if(is.null(type)){NULL}
#   
#   else if(type == "Skyline Plot"){
#     s <- ggplot(sel, aes(x = sel[,measure1], y = sel[,measure2])) + #aes(x = get(measure1), y = get(measure2)))
#       geom_point(shape = 21, size = size_symbols) + 
#       geom_point(data = sky, aes(x = sky[,measure1], y = sky[,measure2]), size = size_symbols + 1, 
#         color = "deepskyblue3", alpha = 0.8) + 
#       geom_step(data = sky,  aes(x = sky[,measure1], y = sky[,measure2]), direction = "vh", color = "deepskyblue3") 
#   }
#   else if(type == "Skyline Level Plot (Dom. in 1 Dimension)"){
#     s <- ggplot(sel, aes(x = sel[,measure1], y = sel[,measure2], color = factor(sel$.level))) +
#       geom_point(shape = 21, size = size_symbols) +
#       geom_point(size = size_symbols+ 1) + geom_step(direction = "vh") +
#       labs(color = "Pareto Level")
#   }
#   else if(type == "Skyline Level Plot (Dom. in 2 Dimensions)"){
#     sel2 <- dat %>% psel(paretoPref(dat,measure1) | paretoPref(dat,measure2), top = nrow(dat)) %>%
#       arrange(get(measure1), -get(measure2))
#     s <- ggplot(sel2, aes(x = get(measure1), y = get(measure2), color = factor(.level))) +
#       geom_point(size = size_symbols+ 1) + geom_step(direction = "vh") +
#       labs(color = "Pareto Level")
#   }
#   s + xlab(measure1) + ylab(measure2) + t
# }

paretoFront <- function(dat, measure1, measure2, type, size_text, size_symbols){
  df <- tabImport(perfAggDf(getBMRAggrPerformances(dat, as.df = T)))
  sel <- paretoOpt(dat, measure1, measure2)
  sky <- psel(df, paretoPref(dat, measure1) * paretoPref(dat, measure2))#, top_level = level)
  sky <- sky[order(sky[,measure1]),]
  
  if(size_text == -1){
    t <- theme()
  }else{
    t <- theme(text = element_text(size = rel(size_text+2)), 
      legend.text = element_text(size = 0.6*rel(size_text+3)), 
      legend.key.height = unit(0.25*rel(size_text+3), "cm"))
  }
  
  if(is.null(type)){NULL}
  
  else if(type == "Skyline Plot"){
    s <- ggplot(sel, aes(x = sel[,measure1], y = sel[,measure2])) + #aes(x = get(measure1), y = get(measure2)))
      geom_point(shape = 21, size = size_symbols) + 
      geom_point(data = sky, aes(x = sky[,measure1], y = sky[,measure2]), size = size_symbols + 1, 
        color = "deepskyblue3", alpha = 0.8) + 
      geom_step(data = sky,  aes(x = sky[,measure1], y = sky[,measure2]), direction = "vh", color = "deepskyblue3") 
  }
  else if(type == "Skyline Level Plot (Dom. in 1 Dimension)"){
    s <- ggplot(sel, aes(x = sel[,measure1], y = sel[,measure2], color = factor(sel$.level))) +
      geom_point(shape = 21, size = size_symbols) +
      geom_point(size = size_symbols+ 1) + geom_step(direction = "vh") +
      labs(color = "Pareto Level")
  }
  else if(type == "Skyline Level Plot (Dom. in 2 Dimensions)"){
    sel2 <- df %>% psel(paretoPref(dat,measure1) | paretoPref(dat,measure2), top = nrow(dat)) %>%
      arrange(get(measure1), -get(measure2))
    s <- ggplot(sel2, aes(x = get(measure1), y = get(measure2), color = factor(.level))) +
      geom_point(size = size_symbols+ 1) + geom_step(direction = "vh") +
      labs(color = "Pareto Level")
  }
  s + xlab(measure1) + ylab(measure2) + t
}

# Extraction of the model with the highest performance
bestPerfMod = function(dat){#, measure
  t <- grep("*._1", names(dat))
  measure <- dat[1,names(dat)[t[2]]]
  measure <- getFromNamespace(measure, "mlr")
  pos <- t[1]
  
  if(measure$minimize == FALSE){
    min_max <- "Maximum"
  }
  else{
    min_max <- "Minimum"
  }
  
  if(min_max == "Minimum"){
    min <- min(dat[pos])
    row <- dat[dat[,pos] == min,]
  }
  if(min_max == "Maximum"){
    max <- max(dat[pos])
    row <- dat[dat[,pos] == max,]
  }
  
  return(row)
} 

bestModPlot <- function(dat, size_text, size_symbols){
  if(size_text == -1){
    t <- theme()
  }else{
    t <- theme(text = element_text(size = rel(size_text+2)), 
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.text = element_text(size = 0.6*rel(size_text+3)), 
      legend.key.height = unit(0.25*rel(size_text+3), "cm"))
  }
  
  best <- bestPerfMod(dat)
  
  ggplot(dat, aes(x = complete, y = value_1)) +
    geom_point(best, mapping = aes(x = complete, y = value_1), color = "deepskyblue3", 
      shape = 19, size = size_symbols) +
    geom_point(size = size_symbols, shape = 1) + 
    xlab("Method/Learner with additional Information") +
    ylab(dat$measure_1[1]) + 
    t
}
