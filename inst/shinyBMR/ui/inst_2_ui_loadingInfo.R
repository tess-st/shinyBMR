loading.info = list(
  div(class = "loading", id = "loading-content", h1("Loading shinyBenchmark...")),
  hidden(div(class = "loading", id = "loading-openBenchmark", h1("Loading Open-Benchmark-Datasets...")))#,
  # hidden(div(class = "loading", id = "loading-task", h1("Creating Task..."))),
  # hidden(div(class = "loading", id = "loading-learners", h1("Loading Learners..."))),
  # hidden(div(class = "loading", id = "loading-tuning", h1("Tuning..."))),
  # hidden(div(class = "loading", id = "loading-training", h1("Training Model..."))),
  # hidden(div(class = "loading", id = "loading-predict", h1("Predicting..."))),
  # hidden(div(class = "loading", id = "loading-benchmark", h1("Running Benchmark Experiment...")))
)
