#####################################################################################################################
# UI: Loading Info
#####################################################################################################################

loading.info = list(
  div(class = "loading", id = "loading-content", h1("Loading shinyBenchmark...")),
  hidden(div(class = "loading", id = "loading-openBenchmark", h1("Loading Open-Benchmark-Datasets...")))
  #div(class = "loading", id = "loading-iml", h1("Calculating..."))
)
