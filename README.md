# shinyBMR: Analysis and Interpretation of Benchmark Studies (with mlr and iml)

[![CRAN Status Badge](http://www.r-pkg.org/badges/version/shinyMlr)](https://CRAN.R-project.org/package=shinyMlr)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/shinyMlr)](https://cran.rstudio.com/web/packages/shinyMlr/index.html)

This package should provide an interactive framework for the analysis of benchmark studies, which have been carried out based on the tools provided in [**mlr**](https://github.com/mlr-org/mlr#-machine-learning-in-r). 

As these Benchmark Studies tend to come up with a huge bandwidth of information **shinyBMR** should mainly offer a opportunity for users to get easy accessible, but highly informative overview of their enforced benchmark study based on **mlr**. This is basically done by the use of interactive, graphical tools as well as stctured and detailed summaries. 

Another point coming up when performing such analyses is the question about explainability and interperatbility. Many of the ML methods are so called blackbox methods, meaning there is not such an easy way - like for example in logistic regression - for calculating the output when the input/data and the focused model are provided. In this sense most of the ML methods return your results without eyplaining you the way the were ablt to come up with this output. But there is a way out of this situation: one can make use of so called model-agnostic methods provided in the **iml** package to offer the user a basis for understanding the causes of decision made by the machine. 

This ShinyApp **shinyBMR** focuses on the before mentioned aspects and its usage is explained in the latter documentation, that can be structiured as follows:  

I. Analysis of Benchmark Results (BMR)
  1. Import of the Benchmark Results (from [**mlr**](https://github.com/mlr-org/mlr#-machine-learning-in-r)
  2. Overview of the Information contained in the Benchmark Object
  3. Graphical Analysis of the competing Methods included in the Benachmark Study

II. Access to the Interpretation of Blackbox ML-Methods (IML)
  1. Import and Overview of the focused Data Set 
  2. Import and Overview of the (Blackbox) Model
  3. Acess to Interpretability provided by different tools of the [**iml**](https://github.com/christophM/iml) package

## Installation and starting shinyBMR

You can install this package from github with help of the **devtools** package:

```r
devtools::install_github("tess-st/shinyBMR")
```
Starting the ShinyApp:

```r
runShinyBMR()
```

If `rJava` fails to load, [**this link**](https://stackoverflow.com/questions/30738974/rjava-load-error-in-rstudio-r-after-upgrading-to-osx-yosemite) might be helpful!

## I. Analysis of Benchmark Results (BMR)
