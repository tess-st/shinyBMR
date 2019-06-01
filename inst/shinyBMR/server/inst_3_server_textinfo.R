########### Landing Page
observeEvent(once = TRUE,ignoreNULL = FALSE, ignoreInit = FALSE, eventExpr = data, { 
  # event will be called when histdata changes, which only happens once, when it is initially calculated
  showModal(modalDialog(
    title = "shinyBMR", 
    h1('What this App is able to do'),
    p("~ Based on the 'mlr' and 'iml' package ~"),
    hr(),
    p("BMR: Analyse Results from the benchmark()-function in 'mlr'"),
    p("IML: Make Models (Blackbox-Methods) interpretable with help of the 'iml' package")
    # actionLink("link_to_tabpanel_a", "Link to panel A")
  ))
})


########### Summary Import IML Data
output$summary_info <- renderUI({
  widgetUserBox(
    title = "Information Summary",
    subtitle = "Interpretabel Machine Learning in R",
    type = NULL,
    width = 12,
    background = TRUE,
    backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/BlueGalaxy.jpg",
    closable = FALSE,
    p("NAME ~ Name of column,"),
    p("TYPE ~ Data type of column,"), 
    p("NA ~ Number of NAs in column"),
    p("DISP ~ Measure of dispersion, for numerics and integers [sd] is used, for categorical columns the 
      qualitative variation,"),
    p("MEAN ~ Mean value of column, NA for categorical columns,"),
    p("MEDIAN ~ Median value of column, NA for categorical columns,"),
    p("MAD ~ MAD of column, NA for categorical columns,"),
    p("MIN ~ Minimal value of column, for categorical columns the size of the smallest category,"),
    p("MAX ~ Maximal value of column, for categorical columns the size of the largest category,"),
    p("NLEVELS ~ For categorical columns, the number of factor levels, NA else."),
    footer = tags$div(
      tagList(a("R Documentation: summarizeColumns()", 
        href="https://www.rdocumentation.org/packages/mlr/versions/2.13/topics/summarizeColumns")),
      tags$br(),
      p("provided by Bischl B., Lang M., Kotthoff L., Schiffner J., Richter J., Studerus E., 
        Casalicchio G.,Jones Z. (2016). 'mlr: Machine Learning in R.' Journal of Machine Learning 
        Research, 17(170), 1-5. http://jmlr.org/papers/v17/15-066.html."),
      tagList(a("R Code: Summary Plots", 
        href="https://github.com/mlr-org/shinyMlr/blob/master/inst/shinyMlr/server/summary.R")),
      tags$br(),
      p("provided by Florian Fendt, Stefan Coors. 'shinyMlr: Integration of the mlr package into shiny'. 
        https://github.com/mlr-org/shinyMlr." ),
      tags$hr(),
      "Image Source: https://wallpapersafari.com/w/q8koJO"
    )
  )
})


########### Feature Importance
output$iml_info <- renderUI({
  widgetUserBox(
    title = "IML",
    subtitle = "Interpretabel Machine Learning in R",
    type = NULL,
    width = 12,
    background = TRUE,
    backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/BlueGalaxy.jpg",
    closable = FALSE,
    p("Machine learning models usually perform really well for predictions, but are not interpretable. The 'iml' package 
      provides tools for analysing any black box machine learning model:"),
    p("* Feature Importance: Which were the most important features?"),
    p("* Feature Effects: How does a feature influence the prediction? (Accumulated Local Effects, Partial Dependence Plots 
      and Individual Conditional Expectation Curves)"),
    p("* Explanations for single Predictions: How did the feature values of a single data point affect its prediction? (LIME 
      and Shapley Value)"),
    p("* Surrogate Trees: Can we approximate the underlying black box model with a short decision tree?"),
    p("The 'iml' package works for any classification and regression machine learning model: random forests, linear models, 
      neural networks, xgboost, etc."),
    footer = tags$div(
      tagList(a("CRAN: IML Package - FeatureImp", href="https://rdrr.io/cran/iml/man/FeatureImp.html#heading-7")),
      tags$br(),
      tagList(a("Book IML: Model-agnostic Methods - Feature Importance", 
        href="https://christophm.github.io/interpretable-ml-book/feature-importance.html")),
      tags$br(),
      p("provided by Molnar C., Bischl B., Casalicchio G. (2018). 'iml: An R package 
        for Interpretable Machine Learning.' JOSS, 3(26), 786. doi: 10.21105/joss.00786, 
        http://joss.theoj.org/papers/10.21105/joss.00786."),
      tags$hr(),
      "Image Source: https://wallpapersafari.com/w/q8koJO"
    )
  )
})


########### Feature Importance
output$imp_info <- renderUI({
  widgetUserBox(
    title = "IML",
    subtitle = "Information about Feature Importance",
    type = NULL,
    width = 12,
    background = TRUE,
    backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/BlueGalaxy.jpg",
    closable = FALSE,
    p("The importance of a feature is the increase in the prediction error of the model after we permuted the feature's 
      values, which breaks the relationship between the feature and the true outcome."),
    p("To compute the feature importance for a single feature, the model prediction loss (error) is measured before and 
      after shuffling the values of the feature. By shuffling the feature values, the association between the outcome and 
      the feature is destroyed. The larger the increase in prediction error, the more important the feature was. The 
      shuffling is repeated to get more accurate results, since the permutation feature importance tends to be quite 
      instable."),
    footer = tags$div(
      tagList(a("CRAN: IML Package - FeatureImp", href="https://rdrr.io/cran/iml/man/FeatureImp.html#heading-7")),
      tags$br(),
      tagList(a("Book IML: Model-agnostic Methods - Feature Importance", 
        href="https://christophm.github.io/interpretable-ml-book/feature-importance.html")),
      tags$br(),
      p("provided by Molnar C., Bischl B., Casalicchio G. (2018). 'iml: An R package 
            for Interpretable Machine Learning.' JOSS, 3(26), 786. doi: 10.21105/joss.00786, 
        http://joss.theoj.org/papers/10.21105/joss.00786."),
      tags$hr(),
      "Image Source: https://wallpapersafari.com/w/q8koJO"
    )
  )
})


########### Feature Effect
#PDP
output$pdp_info <- renderUI({
  widgetUserBox(
    title = "IML",
    subtitle = "Information about Feature Effect: PDP",
    type = NULL,
    width = 12,
    background = TRUE,
    backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/BlueGalaxy.jpg",
    closable = FALSE,
    p("The FeatureEffect class compute the effect a feature has on the prediction. Different methods are implemented:
      Accumulated Local Effect (ALE) plots, Partial Dependence Plots (PDPs), Individual Conditional Expectation (ICE) curves"),
    p("Accumuluated local effects and partial dependence plots both show the average model prediction over the feature. The 
      difference is that ALE are computed as accumulated differences over the conditional distribution and partial dependence 
      plots over the marginal distribution. ALE plots preferable to PDPs, because they are faster and unbiased when features 
      are correlated."),
    p("The partial dependence plot (short PDP or PD plot) shows the marginal effect one or two features have on the 
      predicted outcome of a machine learning model (J. H. Friedman, 2001). A partial dependence plot can show whether the 
      relationship between the target and a feature is linear, monotonous or more complex. For example, when applied to a 
      linear regression model, partial dependence plots always show a linear relationship."),
    footer = tags$div(
      tagList(a("CRAN: IML Package - FeatureEffect", href="https://rdrr.io/cran/iml/man/FeatureEffect.html")),
      tags$br(),
      tagList(a("Book IML: Model-agnostic Methods - Partial Dependence Plot", 
        href="https://christophm.github.io/interpretable-ml-book/pdp.html")),
      tags$br(),
      p("provided by Molnar C., Bischl B., Casalicchio G. (2018). 'iml: An R package 
        for Interpretable Machine Learning.' JOSS, 3(26), 786. doi: 10.21105/joss.00786, 
        http://joss.theoj.org/papers/10.21105/joss.00786."),
      tags$hr(),
      "Image Source: https://wallpapersafari.com/w/q8koJO"
    )
  )
})

#ICE
output$ice_info <- renderUI({
  widgetUserBox(
    title = "IML",
    subtitle = "Information about Feature Effect: ICE",
    type = NULL,
    width = 12,
    background = TRUE,
    backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/BlueGalaxy.jpg",
    closable = FALSE,
    p("The FeatureEffect class compute the effect a feature has on the prediction. Different methods are implemented:
      Accumulated Local Effect (ALE) plots, Partial Dependence Plots (PDPs), Individual Conditional Expectation (ICE) curves"),
    p("Accumuluated local effects and partial dependence plots both show the average model prediction over the feature. The 
      difference is that ALE are computed as accumulated differences over the conditional distribution and partial dependence 
      plots over the marginal distribution. ALE plots preferable to PDPs, because they are faster and unbiased when features 
      are correlated."),
    p("Individual Conditional Expectation (ICE) plots display one line per instance that shows how the instance's prediction 
      changes when a feature changes.The partial dependence plot for the average effect of a feature is a global method 
      because it does not focus on specific instances, but on an overall average. The equivalent to a PDP for individual data 
      instances is called individual conditional expectation (ICE) plot (Goldstein et al., 2017). An ICE plot visualizes the 
      dependence of the prediction on a feature for each instance separately, resulting in one line per instance, compared to 
      one line overall in partial dependence plots."),
    footer = tags$div(
      tagList(a("CRAN: IML Package - FeatureEffect", href="https://rdrr.io/cran/iml/man/FeatureEffect.html")),
      tags$br(),
      tagList(a("Book IML: Model-agnostic Methods - Individual Conditional Expectation", 
        href="https://christophm.github.io/interpretable-ml-book/ice.html")),
      tags$br(),
      p("provided by Molnar C., Bischl B., Casalicchio G. (2018). 'iml: An R package 
        for Interpretable Machine Learning.' JOSS, 3(26), 786. doi: 10.21105/joss.00786, 
        http://joss.theoj.org/papers/10.21105/joss.00786."),
      tags$hr(),
      "Image Source: https://wallpapersafari.com/w/q8koJO"
    )
  )
})

#ALE
output$ale_info <- renderUI({
  widgetUserBox(
    title = "IML",
    subtitle = "Information about Feature Effect: ALE",
    type = NULL,
    width = 12,
    background = TRUE,
    backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/BlueGalaxy.jpg",
    closable = FALSE,
    p("The FeatureEffect class compute the effect a feature has on the prediction. Different methods are implemented:
      Accumulated Local Effect (ALE) plots, Partial Dependence Plots (PDPs), Individual Conditional Expectation (ICE) curves"),
    p("Accumuluated local effects and partial dependence plots both show the average model prediction over the feature. The 
      difference is that ALE are computed as accumulated differences over the conditional distribution and partial dependence 
      plots over the marginal distribution. ALE plots preferable to PDPs, because they are faster and unbiased when features 
      are correlated."),
    p("Accumulated local effects describe how features influence the prediction of a machine learning model on average. ALE 
      plots are a faster and unbiased alternative to partial dependence plots (PDPs)."),
    footer = tags$div(
      tagList(a("CRAN: IML Package - FeatureEffect", href="https://rdrr.io/cran/iml/man/FeatureEffect.html")),
      tags$br(),
      tagList(a("Book IML: Model-agnostic Methods - Accumulated Local Effects", 
        href="https://christophm.github.io/interpretable-ml-book/ale.html")),
      tags$br(),
      p("provided by Molnar C., Bischl B., Casalicchio G. (2018). 'iml: An R package 
        for Interpretable Machine Learning.' JOSS, 3(26), 786. doi: 10.21105/joss.00786, 
        http://joss.theoj.org/papers/10.21105/joss.00786."),
      tags$hr(),
      "Image Source: https://wallpapersafari.com/w/q8koJO"
    )
  )
})


########### Feature Interaction
output$interaction_info <- renderUI({
  widgetUserBox(
    title = "IML",
    subtitle = "Information about Feature Interaction",
    type = NULL,
    width = 12,
    background = TRUE,
    backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/BlueGalaxy.jpg",
    closable = FALSE,   
    p("If a machine learning model makes a prediction based on two features, we can decompose the prediction into four 
      terms: a constant term, a term for the first feature, a term for the second feature and a term for the interaction 
      between the two features.The interaction between two features is the change in the prediction that occurs by varying 
      the features after considering the individual feature effects."),
    p("Interactions between features are measured via the decomposition of the prediction function: If a feature j has no 
      interaction with any other feature, the prediction function can be expressed as the sum of the partial function that 
      depends only on j and the partial function that only depends on features other than j. If the variance of the full 
      function is completely explained by the sum of the partial functions, there is no interaction between feature j and 
      the other features. Any variance that is not explained can be attributed to the interaction and is used as a measure 
      of interaction strength."),
    p("The interaction strength between two features is the proportion of the variance of the 2-dimensional partial 
      dependence function that is not explained by the sum of the two 1-dimensional partial dependence functions. The 
      interaction is measured by Friedman's H-statistic (square root of the H-squared test statistic) and takes on values 
      between 0 (no interaction) to 1."),
    footer = tags$div(
      tagList(a("CRAN: IML Package - Feature Interactions", href="https://rdrr.io/cran/iml/man/Interaction.html")),
      tags$br(),
      tagList(a("Book IML: Model-agnostic Methods - Feature Interaction", 
        href="https://christophm.github.io/interpretable-ml-book/interaction.html")),
      tags$br(),
      p("provided by Molnar C., Bischl B., Casalicchio G. (2018). 'iml: An R package 
        for Interpretable Machine Learning.' JOSS, 3(26), 786. doi: 10.21105/joss.00786, 
        http://joss.theoj.org/papers/10.21105/joss.00786."),
      tags$hr(),
      "Image Source: https://wallpapersafari.com/w/q8koJO"
      )
    )
})



########### LIME
output$lime_info <- renderUI({
  widgetUserBox(
    title = "IML",
    subtitle = "Information about Local Model (LIME)",
    type = NULL,
    width = 12,
    background = TRUE,
    backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/BlueGalaxy.jpg",
    closable = FALSE,   
    p("Local surrogate models are interpretable models that are used to explain individual predictions of black box 
      machine learning models. Local interpretable model-agnostic explanations (LIME)37 is a paper in which the authors 
      propose a concrete implementation of local surrogate models. Surrogate models are trained to approximate the 
      predictions of the underlying black box model. Instead of training a global surrogate model, LIME focuses on 
      training local surrogate models to explain individual predictions."),
    p("A weighted glm is fitted with the machine learning model prediction as target. Data points are weighted by their 
      proximity to the instance to be explained, using the gower proximity measure. L1-regularisation is used to make the 
      results sparse. The resulting model can be seen as a surrogate for the machine learning model, which is only valid 
      for that one point. Categorical features are binarized, depending on the category of the instance to be explained: 
      1 if the category is the same, 0 otherwise."),
    footer = tags$div(
      tagList(a("CRAN: IML Package - Local Model", href="https://rdrr.io/cran/iml/man/LocalModel.html")),
      tags$br(),
      tagList(a("Book IML: Model-agnostic Methods - Accumulated Local Effects", 
        href="https://christophm.github.io/interpretable-ml-book/lime.html")),
      tags$br(),
      p("provided by Molnar C., Bischl B., Casalicchio G. (2018). 'iml: An R package 
        for Interpretable Machine Learning.' JOSS, 3(26), 786. doi: 10.21105/joss.00786, 
        http://joss.theoj.org/papers/10.21105/joss.00786."),
      tags$hr(),
      "Image Source: https://wallpapersafari.com/w/q8koJO"
    )
  )
})


########### Shapley
output$shapley_info <- renderUI({
  widgetUserBox(
    title = "IML",
    subtitle = "Information about Shapley Values",
    type = NULL,
    width = 12,
    background = TRUE,
    backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/BlueGalaxy.jpg",
    closable = FALSE,   
    p("A prediction can be explained by assuming that each feature value of the instance is a 'player' in a game where 
      the prediction is the payout. The Shapley value - a method from coalitional game theory - tells us how to fairly 
      distribute the 'payout' among the features."),
    p("This function computes feature contributions for single predictions with the Shapley value, an approach from 
      cooperative game theory. The features values of an instance cooperate to achieve the prediction. The Shapley value 
      fairly distributes the difference of the instance's prediction and the datasets average prediction among the 
      features."),
    footer = tags$div(
      tagList(a("CRAN: IML Package - Shapley", href="https://rdrr.io/cran/iml/man/Shapley.html")),
      tags$br(),
      tagList(a("Book IML: Model-agnostic Methods - Shapley Values", 
        href="https://christophm.github.io/interpretable-ml-book/shapley.html")),
      tags$br(),
      p("provided by Molnar C., Bischl B., Casalicchio G. (2018). 'iml: An R package 
        for Interpretable Machine Learning.' JOSS, 3(26), 786. doi: 10.21105/joss.00786, 
        http://joss.theoj.org/papers/10.21105/joss.00786."),
      tags$hr(),
      "Image Source: https://wallpapersafari.com/w/q8koJO"
    )
  )
})


########### Surrogate
output$surrogate_info <- renderUI({
  widgetUserBox(
    title = "IML",
    subtitle = "Information about Surrogate Trees",
    type = NULL,
    width = 12,
    background = TRUE,
    backgroundUrl = "https://raw.githubusercontent.com/tess-st/shinyBMR/master/www/BlueGalaxy.jpg",
    closable = FALSE,   
    p("A global surrogate model is an interpretable model that is trained to approximate the predictions of a black box 
      model. We can draw conclusions about the black box model by interpreting the surrogate model. Solving machine 
      learning interpretability by using more machine learning!"),
    p("Surrogate models are also used in engineering: If an outcome of interest is expensive, time-consuming or otherwise 
      difficult to measure (e.g. because it comes from a complex computer simulation), a cheap and fast surrogate model of 
      the outcome can be used instead. "),
    p("A conditional inference tree is fitted on the predicted y from the machine learning model and the
      data. The 'partykit' package and function are used to fit the tree."),
    footer = tags$div(
      tagList(a("CRAN: IML Package - Tree Surrogate", href="https://rdrr.io/cran/iml/man/TreeSurrogate.html")),
      tags$br(),
      tagList(a("Book IML: Model-agnostic Methods - Global Surrogate", 
        href="https://christophm.github.io/interpretable-ml-book/global.html")),
      tags$br(),
      p("provided by Molnar C., Bischl B., Casalicchio G. (2018). 'iml: An R package 
        for Interpretable Machine Learning.' JOSS, 3(26), 786. doi: 10.21105/joss.00786, 
        http://joss.theoj.org/papers/10.21105/joss.00786."),
      tags$hr(),
      "Image Source: https://wallpapersafari.com/w/q8koJO"
    )
  )
})