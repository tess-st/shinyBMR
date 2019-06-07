# Extraction of the model with the highest performance
bestPerfMod = function(dat, measure){
  pos <- findValue(data = dat, measure = measure)
  measure <- getFromNamespace(measure, "mlr")
  
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