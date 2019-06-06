reqAndAssign <- function(obj, name){
  req(obj)
  assign(name, obj, pos = 1L)
}

# informationBox = function(info){
#   div(class = "helptext",
#       box(width = 12, status = "warning", collapsible = TRUE,
#           span(icon("info-circle")), span(info)
#       )
#   )
# }

# round to nearest .5 value
mround <- function(x, base){
  base*round(x/base)
}

# round data frame
roundDf <- function(df, digits, nsmall){
  double_cols <- sapply(df, is.double)
  df[double_cols] <- apply(df[double_cols], 2, 
    FUN = function(x) {ifelse(!is.na(x), format(round(x, digits), nsmall = nsmall), "")})
  # df[is.na(df)] <- ""
  df
}