################################################## Create Subset ####################################################

subsetAnalysis = function(data, measure){
  pos <- findValue(data, measure)
  value_ana <- names(data)[pos]
  focus <- as.numeric(gsub("value_", "", x = value_ana))
  measure_ana <- paste("measure_", focus, sep = "")
  values <- names(data[,grep("value_", names(data))])
  measures <- names(data[,grep("measure_", names(data))])
  rem <- c(values[!(values %in% value_ana)], measures[!(measures %in% measure_ana)])
  dataset <- data[, !names(data) %in% rem, drop = F]
  names(dataset) <- gsub("\\_[0-9]", "", names(dataset))
  return(dataset)
}


getRange = function(measure){
  m <- getFromNamespace(measure, "mlr")#, as.environment(system.file(package = "mlr")))
  if(m$minimize == TRUE){
    range <- c(m$best, m$worst)
  }
  else{
    range <- c(m$worst, m$best) 
  }
  range
}

##################################################### Boxplot #######################################################

PerfBoxplot = function(dat, size_text, col_palette, range_yaxis, size_symbols, label_symbol, jitter_symbols,
  label_xaxis, label_yaxis, add_lines){
  if(size_text == -1){
    t <- theme()
  }else{
    t <- theme(text = element_text(size = rel(size_text+2)), 
      legend.text = element_text(size = 0.6*rel(size_text+3)), 
      legend.key.height = unit(0.25*rel(size_text+3), "cm"))
  }
  
  boxplot <- ggplot(dat, aes(x = learner, y = value)) +
    geom_point(mapping = aes(color = learner, shape = learner.info), size = size_symbols, position = jitter_symbols) +
    ylim(range_yaxis) +
    xlab(label_xaxis) + 
    ylab(label_yaxis) +
    labs(color = label_xaxis, shape = label_symbol, linetype = label_symbol) +
    t +
    scale_colour_manual(values = col_palette)
  
  if(nrow(dat)/nlevels(dat$learner)>= 4){
    boxplot <- boxplot +  geom_boxplot(alpha = .25)
  }
  
  if(add_lines == "On"){
    boxplot <- boxplot + stat_summary(aes(group = learner.info, linetype = learner.info), 
      fun.y = mean, geom = "line")
  }
  
  return(boxplot)
}


##################################################### Heatmap #######################################################

PerfHeatmap_Def = function(dat, col_min, col_max, col_text, range_value, size_text, label_value, label_xaxis, 
  label_yaxis, aggregate){
  if(size_text == -1){
    g <- geom_text(color = col_text, size = 4)
    t <- theme()
  }else{
    g <- geom_text(color = col_text, size = rel(size_text+2))
    t <- theme(text = element_text(size = rel(size_text+2)), 
      legend.text = element_text(size = 0.6*rel(size_text+3)), 
      legend.key.height = unit(0.25*rel(size_text+3), "cm")
    )
  }
  
  if(aggregate == "On"){
    heatmap <- ggplot(dat, aes(x = learner.info, y = learner, fill = value, label = paste(round(value,3)))) +
      geom_tile() +
      scale_fill_gradient2(label_value, mid = col_min, midpoint = 0, high = col_max, limit = range_value, space = "Lab") +
      geom_text(color = col_text, size = rel(size_text+2)) +
      xlab(label_xaxis) + 
      ylab(label_yaxis) +
      g +
      t
  }
  if(aggregate == "Off"){
    xpos <- 0
    ypos <- 0
    linepos <- 0
    for(i in 1:nlevels(dat$learner.info)){
      xpos[i] <- (max(dat$iter)/2) + 0.5 + (i-1)*max(dat$iter)
      ypos[i] <- 0.45
      linepos[i] <- max(dat$iter)*i + 0.5
    }
    linepos <- head(linepos, -1)
    
    heatmap <- ggplot(dat, aes(x = learner.info.iter, y = learner, fill = value, label = paste(round(value,3)))) + 
      geom_tile() +
      scale_fill_gradient2(label_value, mid = col_min, midpoint = 0, high = col_max, limit = range_value, space = "Lab") +
      geom_text(color = col_text, size = rel(size_text+2)) +
      xlab(label_xaxis) + 
      scale_x_discrete(labels = paste("Iter", rep(1:max(dat$iter), times = nlevels(dat$learner.info)), sep = " ")) + 
      ylab(label_yaxis) +
      geom_vline(xintercept = linepos, size = 1.1) +
      #geom_text(aes(label = c("a", "a"), x = 2, y = 3), hjust = 3)+# + 0.95) +levels(dat$learner.info)
      annotate("text", label = levels(dat$learner.info), x = xpos, y = ypos, size = rel(size_text+2)) +
      g +
      t  
  }
  
  return(heatmap)
}


################################################### Plots in mlr ####################################################

MlrBoxplot = function(dat, style, size_text, col_palette){# , size_symbols, label_symbol, label_xaxis, label_yaxis){
  # if(size_text == -1){
  #   # g <- geom_text(color = col_text, size = 4)
  #   t <- theme()
  # }else{
  #   # g <- geom_text(color = col_text, size = rel(size_text+2))
  #   t <- theme(text = element_text(size = rel(size_text+2)), 
  #              legend.text = element_text(size = 0.6*rel(size_text+3)), 
  #              legend.key.height = unit(0.25*rel(size_text+3), "cm"))
  # }
  # 
  # boxplot_mlr <- plotBMRBoxplots(dat, aes(x = learner, y = value)) +
  #   geom_point(mapping = aes(color = learner, shape = learner.info), size = size_symbols) + #, position = "jitter"
  #   geom_boxplot(alpha = .25)+ #, outlier.alpha = 0
  #   #guides(colour = guide_legend(order = 1), shape = guide_legend(order = 2))
  #   geom_line(aes(group = learner.info, linetype = learner.info)) +#+  guides(size = guide_legend(), shape = guide_legend())
  #   xlab(label_xaxis) + 
  #   ylab(label_yaxis) +
  #   labs(color = label_xaxis, shape = label_symbol, linetype = label_symbol) +
  #   t +
  #   scale_colour_manual(values = col_palette)
  # 
  boxplot_mlr <- plotBMRBoxplots(dat, style = style) +
    aes(color = learner.id) +
    theme(text = element_text(size = rel(size_text+1.5)), 
      legend.text = element_text(size = 0.6*rel(size_text+2)), 
      legend.key.height = unit(0.25*rel(size_text+1), "cm"),
      strip.text.x = element_text(size = rel(size_text+1.5))) +
    scale_colour_manual(values = col_palette)
  #theme(strip.text.x = element_text(size = 8))
  
  return(boxplot_mlr)
}

# boxplot_mlr <- plotBMRBoxplots(bench) +
#   aes(color = learner.id) +
#   theme(text = element_text(size = rel(1+2)), 
#         legend.text = element_text(size = 0.6*rel(1+3)), 
#         legend.key.height = unit(0.25*rel(1+3), "cm")) +
#   scale_colour_manual(values = tol.rainbow(22))
