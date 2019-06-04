require(tools)
require(httr)
require(mlr)
require(stringi)
require(readr)
require(RWeka)
require(BBmisc)
require(Metrics)
require(ParamHelpers)
require(devtools)
require(DT)
require(parallelMap)
require(xtable)
require(plyr)
require(ggplot2)
require(GGally)
require(plotly)
require(gridExtra)
require(party)
require(partykit)
require(mlrHyperopt)
require(iml)
require(gower)
require(doParallel)
require(reshape2)


#Connection to prep.files
prep.files <- list.files(path = "./prep", pattern = "*_prep_")
prep.files = paste0("prep/", prep.files)


for (i in seq_along(prep.files)) {
  source(prep.files[i], local = TRUE)
}

# By default, the file size limit is 5MB. It can be changed by
# setting this option, so that every size of the file can be uploaded
options(shiny.maxRequestSize = -1) #400*1024^2

server <- shinyServer(function(input, output, session) {
  shinyjs::addClass(id = "mlrlink", class = "navbar-right")
  
  server.files <- list.files(path = "./server", pattern = "*_3_server_")
  server.files <- paste0("server/", server.files)
  
  for (i in seq_along(server.files)) {
    source(server.files[i], local = TRUE)
    hide(id = "loading-content", anim = TRUE, animType = "fade")    
    show("app-content")
  }
  
  session$onSessionEnded(stopApp)
})
