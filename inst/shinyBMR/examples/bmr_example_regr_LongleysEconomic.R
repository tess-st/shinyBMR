#########################################################################################################################
############################################### Examples for Benchmarking ###############################################
#########################################################################################################################

#https://machinelearningmastery.com/machine-learning-datasets-in-r/

################################################### Install Packages ####################################################

#install.packages("mlbench")
library(mlbench)
#install.packages("mlr")
library(mlr)

#install.packages("xgboost")
library(xgboost)
#install.packages("penalized")
library(penalized)


#install.packages("glmnet")
library(glmnet)
#install.packages("mboost")
library(mboost)
#install.packages("ranger")
library(ranger)


#install.packages("devtools")
devtools::install_github("berndbischl/ParamHelpers")
devtools::install_github("jakob-r/mlrHyperopt", dependencies = TRUE)
library(mlrHyperopt)


setwd("C:/Users/admin/Documents/Shiny/newest_4/examples")


#########################################################################################################################
# Regression: Loneley's Economic 
#########################################################################################################################

# Longley's Economic Regression Data
data(longley)
dim(longley)
head(longley)
summary(longley)


################################################### Define Settings #####################################################

task <- makeRegrTask(id= "eco", data = longley, target = "Employed")
measure <- rmse

# Class Imbalance
# plot(cancer$Class)


################################################## Nested Resampling ####################################################

set.seed(123)

inner <- makeResampleDesc("CV", iters= 5L)#, stratify = TRUE)
outer <- makeResampleDesc("CV", iters = 5L)#, stratify = TRUE)
ctrl <- makeTuneControlGrid(resolution = 5L)


################################################### Select Learners #####################################################

#examplary selection of learners
lrns_list_all <- list("regr.rpart", "regr.glmnet", "regr.glmboost", "regr.ranger")#"regr.xgboost"


#########################################################################################################################
# Without Tuning
#########################################################################################################################

lrns_untuned_all <- lapply(lrns_list_all, function(lrn_string){
  makeLearner(lrn_string)#, fix.factors.prediction = T, predict.type = "prob")
})


#########################################################################################################################
# With Tuning
#########################################################################################################################

#Get defaults for Tuning
default_lrns.tuned = lapply(lrns_list_all, function(lrn_string) {
  lrn <- makeLearner(lrn_string) #fix.factors.prediction = TRUE, predict.type = "prob")
  lrn_pc = getDefaultParConfig(learner = lrn)
})

for(i in 1:length(default_lrns.tuned)){
  names(default_lrns.tuned)[[i]] <- default_lrns.tuned[[i]]$associated.learner.class 
}

lrns_tuned_all = lapply(lrns_list_all, function(lrn_string) {
  lrn <- makeLearner(lrn_string)#, fix.factors.prediction = TRUE, predict.type = "prob")
  
  lrn_pc = default_lrns.tuned[lrn_string]
  lrn_ps = get(lrn_string, envir = as.environment(default_lrns.tuned))$par.set
  if(lrn_string == "regr.ranger"){
    lrn_ps$pars$mtry$upper <- sum(task$task.desc$n.feat)
    #ParamHelpers::makeParamSet(makeNumericParam("mtry",lower =1 , upper = 10))
  }
  makeTuneWrapper(learner = lrn, resampling = inner, par.set = lrn_ps, control = ctrl, measures = measure)
})


#########################################################################################################################
# Benchmark
#########################################################################################################################

bench_LongeleysEconomic <- benchmark(tasks = task, learners = c(lrns_untuned_all, #group 1
                                                           lrns_tuned_all), #group 4
                                resampling = outer, measures = measure, models = F)

saveRDS(bench_LongeleysEconomic, "bmr_example_regr_LoneleysEconomic.RDS")