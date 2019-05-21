#########################################################################################################################
############################################### Examples for Benchmarking ###############################################
#########################################################################################################################

#https://machinelearningmastery.com/machine-learning-datasets-in-r/

################################################### Install Packages ####################################################

#install.packages("mlbench")
library(mlbench)
#install.packages("mlr")
library(mlr)

#install.packages("glmnet")
library(glmnet)
#install.packages("ada")
library(ada)
#install.packages("rpart")
library(rpart)
#install.packages("party")
library(party)
#install.packages("ranger")
library(ranger)
#install.packages("e1071")
library(e1071)

#install.packages("devtools")
devtools::install_github("berndbischl/ParamHelpers")
devtools::install_github("jakob-r/mlrHyperopt", dependencies = TRUE)
library(mlrHyperopt)


#########################################################################################################################
# Binary Classification: Breast Cancer
#########################################################################################################################

data("BreastCancer")
#remove variable "Id"
cancer <- subset(BreastCancer, select = -1)


################################################### Data Preperation ####################################################

#complete case analysis
for(i in nrow(cancer):1){
  if(anyNA(cancer[i,])){
    cancer <- cancer[-i,]
  }  
}

#ignore ordered factor inputs (handle as factors)
for(i in 1:ncol(cancer)){
  if(is.ordered(cancer[,i])){
    cancer[,i] <- factor(cancer[,i], ordered = F)
  }
}

#for variables "Marg.adhersion", "Cell.shape", "Cell.size", "Epith.c.size" match factor 9 and 10 together
for(i in c(2, 3, 4, 5)){
  levels(cancer[,i]) <- c(1:9, 9)
}

#"Mitoses": combine levels (1,2,3), (4,5,6), (7,8,10)
levels(cancer$Mitoses) <- c(1,1,1,2,2,2,3,3,3)

#"Bare.nuclei" combine levels (1,2), (3,4), (5,6), (7,8), (9,10)
levels(cancer$Bare.nuclei) <- c(1,1,2,2,3,3,4,4,5,5)

################################################### Define Settings #####################################################

task <- makeClassifTask(data = cancer, target = "Class", positive = "malignant")
measure <- mlr::auc

# Class Imbalance
# plot(cancer$Class)


################################################## Nested Resampling ####################################################

set.seed(123)

inner <- makeResampleDesc("CV", iters= 3L, stratify = TRUE)
outer <- makeResampleDesc("CV", iters = 3L, stratify = TRUE)
ctrl <- makeTuneControlRandom(maxit = 10L)


################################################### Select Learners #####################################################

# Examplary selection of learners
lrns_list_all <- list("classif.rpart", "classif.ada", "classif.glmnet", "classif.svm", "classif.ranger")


#########################################################################################################################
# Without Tuning, without SMOTE
#########################################################################################################################

lrns_untuned_all <- lapply(lrns_list_all, function(lrn_string){
  makeLearner(lrn_string, fix.factors.prediction = T, predict.type = "prob")
})


#########################################################################################################################
# Without Tuning, with SMOTE
#########################################################################################################################

lrns_untuned_smote_all <- lapply(lrns_list_all, function(lrn_string) {
  lrn <- makeLearner(lrn_string, fix.factors.prediction = TRUE, predict.type = "prob")
  lrn_smote <- makeSMOTEWrapper(lrn)
  lrn_smote_pars <- makeParamSet(makeNumericParam("sw.rate", lower = 1, upper = 2),
                                 makeIntegerParam("sw.nn", lower = 2, upper = 10))
  lrn_smote_ps <- evaluateParamExpressions(lrn_smote_pars, dict = getTaskDictionary(task = task))
  
  makeTuneWrapper(learner = lrn_smote, resampling = inner, par.set = lrn_smote_ps, control = ctrl, measures = measure)
})

#unique learner ids necessary for benchmarking
lrns_untuned_smote_all  <- lapply(lrns_untuned_smote_all, function(x){
  x$id <- gsub(".tuned", ".untuned", x$id)
  x
})


#########################################################################################################################
# With Tuning, without and with SMOTE
#########################################################################################################################

############################################### Get Defaults for Tuning #################################################

default_lrns.tuned = lapply(lrns_list_all, function(lrn_string) {
  lrn <- makeLearner(lrn_string, fix.factors.prediction = TRUE, predict.type = "prob")
  lrn_pc = getDefaultParConfig(learner = lrn)
})

for(i in 1:length(default_lrns.tuned)){
  names(default_lrns.tuned)[[i]] <- default_lrns.tuned[[i]]$associated.learner.class 
}


############################################# With Tuning, without SMOTE ################################################

lrns_tuned_unsmoted_all = lapply(lrns_list_all, function(lrn_string) {
  lrn <- makeLearner(lrn_string, fix.factors.prediction = TRUE, predict.type = "prob")
  
  lrn_pc = default_lrns.tuned[lrn_string]
  lrn_ps = get(lrn_string, envir = as.environment(default_lrns.tuned))$par.set
  
  #Probleme bei Initalisierung BMR
  if(lrn_string == "classif.ranger"){
    lrn_ps$pars$mtry$upper <- sum(task$task.desc$n.feat)
    #ParamHelpers::makeParamSet(makeNumericParam("mtry",lower =1 , upper = 10))
  }
  
  makeTuneWrapper(learner = lrn, resampling = inner, par.set = lrn_ps, control = ctrl, measures = measure)
})


############################################ Without Tuning, without SMOTE ##############################################
lrns_tuned_smoted_all = lapply(lrns_list_all, function(lrn_string) {
  lrn <- makeLearner(lrn_string, fix.factors.prediction = TRUE, predict.type = "prob")
  lrn_smote <- makeSMOTEWrapper(lrn)
  
  lrn_pc = default_lrns.tuned[lrn_string]
  lrn_ps = get(lrn_string, envir = as.environment(default_lrns.tuned))$par.set
  
  #Probleme bei Initalisierung BMR
  if(lrn_string == "classif.ranger"){
    lrn_ps$pars$mtry$upper <- sum(task$task.desc$n.feat)
    #ParamHelpers::makeParamSet(makeNumericParam("mtry",lower =1 , upper = 10))
  }
  
  lrn_smote_pars <- makeParamSet(makeNumericParam("sw.rate", lower = 1, upper = 2),
                                 makeIntegerParam("sw.nn", lower = 2, upper = 10))
  lrn_smote_ps <- evaluateParamExpressions(lrn_smote_pars, dict = getTaskDictionary(task = task))
  
  merged_pars <- list("pars" = do.call(c, list(lrn_ps$pars, lrn_smote_ps$pars)), "forbidden" = NULL)
  class(merged_pars) <- "ParamSet"
  
  makeTuneWrapper(learner = lrn_smote, resampling = inner, par.set = merged_pars, control = ctrl, measures = measure)
})


bench_BreastCancer <- benchmark(tasks = task, learners = c(lrns_untuned_all, #group 1
                                                           lrns_untuned_smote_all,  #group 2
                                                           lrns_tuned_unsmoted_all, #group 3
                                                           lrns_tuned_smoted_all), #group 4
                                resampling = outer, measures = measure, models = F)

#saveRDS(bench_BreastCancer , "bmr_example_classif_BreastCancer.RDS")
