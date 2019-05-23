tabpanel.welcome = dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  
  dashboardBody(tags$head(tags$style(
    HTML('.wrapper {height: auto !important; position:relative; overflow-x:hidden; overflow-y:auto; max-height:90vh}'))),#680px
    tags$head(tags$style(HTML('
        a[href="#shiny-tab-widgets"] {
      z-index: -99999;
      }
      a[href="#"] {
      z-index: -99999;
      }
      '))),
    #for global Plotting Window
    setShadow("card"),
    fluidRow(
      column(
        width = 8,
        align = "center",
        widgetUserBox(
          title = "shinyBMR",
          subtitle = "Analyse Benchmark-Results",
          type = NULL,
          width = 12,
          background = TRUE,
          backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/bench.jpg",
          
          #Resize and upload:
          #http://picresize.com/results
          #https://www.directupload.net/
          
          closable = FALSE,
          p("This ShinyApp is provided for the Analysis of Benchmark-Results (BMR) created with the help of the 'mlr' Package
            from B. Bischl et al. [1]. As it is normally unknown, how to rank different learning methods based on
            their performance when applied to one or more data sets, it is common to carry out so called Benchmark Experiments.
            Note that these rankings could also been done based on different performance measures and therefore yield different
            results."),
          p("An easy way to perform Benchmark Experiments would be the usage of the benchmark()-function in the 'mlr'
        package. This function especially expects the arguments learners, tasks, resamplings and measures.
        If you are not used to the functionalities and usage of the package, I would
        recommend the tutorial page of the 'mlr' package to you. Another way to easily get your BMR is the usage of the additional 
        package 'shinyMlr' [2], where one can make use of most of the functions implemented in 'mlr' step by
        step and in an interactive way as this package comes up with a ShinyApp."),
          # br(),
          p("Having finally figured out your 'best' perfoming model, you probably will fit it to your data set(s) again for yielding 
        your final model. This model could be hardly interpretable, as the used method may is a so called Blackbox. For getting to
        know your model better or for understanding the predictions it offers you one can highly recommend the 'iml' package [3]."),
          #An implementation of the iml-functions can be find in this ShinyApp. 
          #br(),
          p("This ShinyApp is part of my Master Thesis at the Institut of Statistics,
        Ludwig-Maximilians-University (LMU) of Munich. I tried to provide a framework for analysing and visualizing the most
        important aspects of the BMRs resulting from the 'benchmark'-function of the 'mlr'-package. Furthermore should methods of
        interpretability be offered for (the best) models with help of the 'iml'-package. Main focus is here on model-agnostic 
        methods")
        )),
      
      column(width = 4,
        widgetUserBox(
          title = "Useful Links",
          subtitle = "Help & ShinyApps towards Construction of BMR",
          type = NULL,
          width = 12,
          color = "light-blue", #"navy", #"aqua-active",
          h5("Everything about the 'mlr' Package ..."),
          tagList(a("CRAN: mlr", href="https://CRAN.R-project.org/package=mlr")),
          br(),
          tagList(a("GitHub: mlr", href="https://github.com/mlr-org/mlr")),
          br(),
          tagList(a("Manual: mlr", href="https://cran.r-project.org/web/packages/mlr/mlr.pdf")),
          br(),
          tagList(a("Tutorial: mlr", href="https://mlr.mlr-org.com/")),
          br(),
          h5("Make Use of the provided ShinyApp for 'mlr' ..."),
          tagList(a("shinyMlr", href="https://github.com/mlr-org/shinyMlr")),
          br(),
          h5("Make your BlackBox-Methods interpretable ..."),
          tagList(a("CRAN: iml", href=" https://CRAN.R-project.org/package=iml")),
          br(),
          tagList(a("GitHub: iml", href="	https://github.com/christophM/iml")),
          br(),
          tagList(a("Book: iml", href="https://christophm.github.io/interpretable-ml-book/")),
          br(),
          tagList(a("Introdution: iml", href="https://cran.r-project.org/web/packages/iml/vignettes/intro.html"))
        ))
    ),
    
    fluidRow(column(width = 12, title = "References",
      gradientBox(width = 12, title = NULL, p("[1] Bischl B., Lang M., Kotthoff L., Schiffner J., Richter J., 
            Studerus E., Casalicchio G.,Jones Z. (2016). 'mlr: Machine Learning in R.' Journal of Machine Learning 
            Research, 17(170), 1-5. http://jmlr.org/papers/v17/15-066.html."),
        
        p("[2] Coors S., Fendt F., Probst P., Bischl B., Richter J.  (2016). 
            'A graphical user interface for machine learning in R'. URL: https://github.com/mlr-org/shinyMlr"),
        
        p("[3] Molnar C., Bischl B., Casalicchio G. (2018). 'iml: An R package 
            for Interpretable Machine Learning.' JOSS, 3(26), 786. doi: 10.21105/joss.00786, 
            http://joss.theoj.org/papers/10.21105/joss.00786."),
        
        hr(),
        
        p("Image Source: http://tapety.joe.pl/na-pulpit/ziemia/woda/biale-laweczki-na-molo/")
      ))
    )
  )
)

# box(h1("shinyBMR"), background = "navy",
#     p("This ShinyApp is provided for the Analysis of Benchmark-Results (BMR) created with the help of the 'mlr' Package 
#       from B. Bischl et al. [1]. As it is normally unknown, how tho rank different learning methods based on 
#       their performance when applied to one or more data sets, it is common to carry out so called Benchmark Experiments.
#       Note that these rankings could also been done based on different performance measures and therefore yield different
#       results."),
# p("An easy way to perform Bernchmark Experiments would be the usage of the benchmark()-function in the 'mlr' 
#   package. This function especially expects the arguments learners, tasks, resamplings and measures. 
#   If you are not used to the functionalities and usage of the package, as well as it's functions, I would 
#   recommend the tutorial page of the 'mlr' package to you. Another way to easily get your BMR is 
#   the usage of the additional package 'shinyMlr' [2], where one can make use of most of the mlr-functions step by 
#   step and in an interactive way as this package comes up with a ShinyApp."),
# 
# p("This ShinyApp is part of my Master Thesis at the Institut of Statistics, 
#   Ludwig-Maximilians-Universit?t M?nchen (LMU)."),
# br()

# p("p creates a paragraph of text."),
#                    p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph.", style = "font-family: 'times'; font-si16pt"),
#                    strong("strong() makes bold text."),
#                    em("em() creates italicized (i.e, emphasized) text."),
#                    br(),
#                    code("code displays your text similar to computer code"),
#                    div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
#                    br(),
#                    p("span does the same thing as div, but it works with",
#                      span("groups of words", style = "color:blue"),
#                      "that appear inside a paragraph.")
# ),
# box(h1("Links"), background = "light-blue",
#     tagList(a("CRAN: mlr", href="https://CRAN.R-project.org/package=mlr")),
#     br(),
#     tagList(a("GitHub: mlr", href="https://github.com/mlr-org/mlr")),
#     br(),
#     tagList(a("Manual: mlr", href="https://cran.r-project.org/web/packages/mlr/mlr.pdf")),
#     br(),
#     br(),
#     tagList(a("Tutorial: mlr", href="https://mlr.mlr-org.com/")),
#     br(),
#     tagList(a("shinyMlr", href="https://github.com/mlr-org/shinyMlr"))
#     #footer = "hallo"
#     ),
# box(p("[1] Bischl B, Lang M, Kotthoff L, Schiffner J, Richter J, Studerus E, Casalicchio G, Jones Z (2016).
#       "mlr: Machine Learning in R." Journal of Machine Learning Research, 17(170), 1-5."))# http://jmlr.org/papers/v17/15-066.html.
