#########################################################################################################################
############################################### Examples for Benchmarking ###############################################
#########################################################################################################################


################################################### Install Packages ####################################################

#install.packages("mlr")
library(mlr)
#install.packages("glmnet")
library(glmnet)
#install.packages("rpart")
library(rpart)

#install.packages("devtools")
devtools::install_github("berndbischl/ParamHelpers")
devtools::install_github("jakob-r/mlrHyperopt", dependencies = TRUE)
library(mlrHyperopt)

#setwd("C:/Users/admin/Documents/Shiny/newest_4/examples")
setwd("H:\\newest_4\\examples")

#########################################################################################################################
# Regression: Loneley's Economic 
#########################################################################################################################

# Longley's Economic Regression Data
data(longley)
dim(longley)
head(longley)
summary(longley)

# save data as .RData
#save(longley, file = "data_LongleysEconomic.RData")


################################################### Define Settings #####################################################

set.seed(1234)

# Define Task
task <- makeRegrTask(id= "eco", data = longley, target = "Employed")

# Additional Settings for Tuning, only rpart tuned
resampling <- makeResampleDesc("CV", iters= 5L)
ctrl <- makeTuneControlGrid(resolution = 5L)
measure <- rmse
lrn_ps <- getDefaultParConfig("regr.rpart")$par.set

# Learners
learner_glmnet <- makeLearner("regr.glmnet")
learner_rpart <- makeLearner("regr.rpart")
learner_rpart_tuned <- makeTuneWrapper(learner = learner_rpart, resampling = resampling, par.set = lrn_ps, 
                                   control = ctrl, measures = measure)

##################################################### Train Model ######################################################

# glmnet without Tuning
mod_glmnet <- train(learner_glmnet, task)
# rpart with Tuning
mod_rpart_tuned <- train(learner_rpart_tuned, task)

# save Models
#saveRDS(mod_glmnet, "iml_example_regr_LongleysEconomic_glmnet_untuned.RDS")
#saveRDS(mod_rpart_tuned, "iml_example_regr_LongleysEconomic_rpart_tuned.RDS")
