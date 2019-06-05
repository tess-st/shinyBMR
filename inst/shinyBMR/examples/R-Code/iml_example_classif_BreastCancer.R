#########################################################################################################################
############################################### Examples for Benchmarking ###############################################
#########################################################################################################################


################################################### Install Packages ####################################################

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

# set a working directory 
# setwd()


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

set.seed(1234)

# Define Task
task <- makeClassifTask(data = cancer, target = "Class", positive = "malignant")

# Additional Settings for Tuning
resampling <- makeResampleDesc("CV", iters= 10L)
ctrl <- makeTuneControlGrid(resolution = 10L)
measure <- mlr::auc

lrn_ps_ada <- getDefaultParConfig("classif.ada")$par.set
lrn_ps_svm <- getDefaultParConfig("classif.svm")$par.set
lrn_ps_ranger <- getDefaultParConfig("classif.ranger")$par.set
lrn_ps_ranger$pars$mtry$upper <- sum(task$task.desc$n.feat)

# Learners
learner_ada <- makeLearner("classif.ada", fix.factors.prediction = T, predict.type = "prob")
learner_ada_tuned <- makeTuneWrapper(learner = learner_ada, resampling = resampling, par.set = lrn_ps_ada,
  control = ctrl, measures = measure)
learner_svm <- makeLearner("classif.svm", fix.factors.prediction = T, predict.type = "prob")
learner_svm_tuned <- makeTuneWrapper(learner = learner_svm, resampling = resampling, par.set = lrn_ps_svm,
  control = ctrl, measures = measure)
learner_ranger <- makeLearner("classif.ranger", fix.factors.prediction = T, predict.type = "prob")
learner_ranger_tuned <- makeTuneWrapper(learner = learner_ranger, resampling = resampling, par.set = lrn_ps_ranger,
  control = ctrl, measures = measure)


##################################################### Train Model ######################################################

# ada without Tuning
mod_ada <- train(learner_ada, task)
# ada with Tuning
mod_ada_tuned <- train(learner_ada_tuned, task)

# svm without Tuning
mod_svm <- train(learner_svm, task)
# svm with Tuning
mod_svm_tuned <- train(learner_svm_tuned, task)

# ranger without Tuning
mod_ranger <- train(learner_ranger, task)
# ranger with Tuning
mod_ranger_tuned <- train(learner_ranger_tuned, task)


# save Models
#saveRDS(mod_ada, "iml_example_regr_BreastCancer_ada_untuned.RDS")
saveRDS(mod_ada_tuned, "new_examples/iml_example_regr_BreastCancer_ada_tuned.RDS")
#saveRDS(mod_svm, "iml_example_regr_BreastCancer_svm_untuned.RDS")
#saveRDS(mod_svm_tuned, "iml_example_regr_BreastCancer_svm_tuned.RDS")
#saveRDS(mod_ranger, "iml_example_regr_BreastCancer_ranger_untuned.RDS")
#saveRDS(mod_ranger_tuned, "iml_example_regr_BreastCancer_ranger_tuned.RDS")