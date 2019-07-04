#####################################################################################################################
# UI: Loading Info
#####################################################################################################################

loading.info = list(
  div(class = "loading", id = "loading-content", h1("Loading shinyBenchmark...")),
  hidden(div(class = "loading", id = "loading-openBenchmark", h1("Loading Open-Benchmark-Datasets..."))),
  hidden(div(class = "loading", id = "loading-iml", h1("Calculating..."))),
  hidden(div(class = "loading", id = "loading-measure", h1("Running Benchmark Experiment..."))),
  hidden(div(class = "loading", id = "loading-paretoTab", h1("Running Benchmark Experiment..."))),
  hidden(div(class = "loading", id = "loading-paretoPlot", h1("Running Benchmark Experiment...")))
)
