#########################################################################################################################
############################################### Examples for Benchmarking ###############################################
#########################################################################################################################


################################################### Install Packages ####################################################

#install.packages("mlr")
library(mlr)

#install.packages("rpart")
library(rpart)
#install.packages("glmnet")
library(glmnet)
#install.packages("mboost")
library(mboost)
#install.packages("ranger")
library(ranger)
#install.packages("e1071")
library(e1071)

#install.packages("devtools")
devtools::install_github("berndbischl/ParamHelpers")
devtools::install_github("jakob-r/mlrHyperopt", dependencies = TRUE)
library(mlrHyperopt)

# set a working directory 
# setwd()


#########################################################################################################################
# Regression: Loneley's Economic 
#########################################################################################################################

# Longley's Economic Regression Data
data(longley)
dim(longley)
head(longley)
summary(longley)

# save data as .RData
# save(longley, file = "data_LongleysEconomic.RData")


################################################### Define Settings #####################################################

set.seed(1234)

# Define Task
task <- makeRegrTask(id= "eco", data = longley, target = "Employed")

# Additional Settings for Tuning
resampling <- makeResampleDesc("CV", iters= 10L)
ctrl <- makeTuneControlGrid(resolution = 10L)
measure <- rmse

lrn_ps_svm <- getDefaultParConfig("regr.svm")$par.set
lrn_ps_ranger <- getDefaultParConfig("regr.ranger")$par.set
lrn_ps_ranger$pars$mtry$upper <- sum(task$task.desc$n.feat)

# Learners
learner_svm <- makeLearner("regr.svm")
learner_svm_tuned <- makeTuneWrapper(learner = learner_svm, resampling = resampling, par.set = lrn_ps_svm,
  control = ctrl, measures = measure)
learner_ranger <- makeLearner("regr.ranger")
learner_ranger_tuned <- makeTuneWrapper(learner = learner_ranger, resampling = resampling, par.set = lrn_ps_ranger,
  control = ctrl, measures = measure)


##################################################### Train Model ######################################################

# svm without Tuning
mod_svm <- train(learner_svm, task)
# svm with Tuning
mod_svm_tuned <- train(learner_svm_tuned, task)

# ranger without Tuning
mod_ranger <- train(learner_ranger, task)
# ranger with Tuning
mod_ranger_tuned <- train(learner_ranger_tuned, task)


# save Models
#saveRDS(mod_svm, "iml_example_regr_LongleysEconomic_svm_untuned.RDS")
#saveRDS(mod_svm_tuned, "iml_example_regr_LongleysEconomic_svm_tuned.RDS")
#saveRDS(mod_ranger, "iml_example_regr_LongleysEconomic_ranger_untuned.RDS")
#saveRDS(mod_ranger_tuned, "iml_example_regr_LongleysEconomic_ranger_tuned.RDS")
