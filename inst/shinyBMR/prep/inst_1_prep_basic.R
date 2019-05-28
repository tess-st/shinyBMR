reqAndAssign = function(obj, name){
  req(obj)
  assign(name, obj, pos = 1L)
}

informationBox = function(info){
  div(class = "helptext",
      box(width = 12, status = "warning", collapsible = TRUE,
          span(icon("info-circle")), span(info)
      )
  )
}

# round to nearest .5 value
mround <- function(x,base){ 
  base*round(x/base) 
} 