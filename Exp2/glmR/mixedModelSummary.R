rm( list=ls() )

library(lme4) #1.1-21
library(boot) #1.3-22
library(ggplot2) #3.2.1
library(LaplacesDemon) #16.1.1
library(plyr) #1.8.4
library(devtools) #2.2.1
library(piecewiseSEM) #2.1.0

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#####################
###   DATA INIT   ###
#####################

  #to obtain the same random sequence
set.seed(12345)

  #load data
expData <- read.table( "../data/dataForR.dat", as.is=TRUE )
names(expData) <- c('obs','trialNum','condition','subCondition','latency','selection')

latencyScalar <- 150

  #ensure proper data-types and ranges
expData$obs        <- as.factor(expData$obs)
expData$condition  <- as.factor(expData$condition)
expData$trialNum   <- as.double(expData$trialNum)
expData$latency    <- (as.double(expData$latency))/latencyScalar  #to avoid scaling warning
expData$selection  <- as.factor(expData$selection)
expData$selection  <- mapvalues(expData$selection, from = c("1", "3"), to = c("1", "0"))  #recode to 1 and 0 (1=TARGET,3=DISTRACTOR)
expData$selection   <- relevel(expData$selection,ref="0")

#####################
###   MODEL FIT   ###
#####################

  #complete model
expData.completeModel <- glmer(selection ~ latency + condition + latency * condition + (1|obs),data=expData,family="binomial", control=glmerControl(optimizer="bobyqa"))
summary(expData.completeModel)

###comparisons fixed effects

  #leave out interaction 
expData.withoutInteraction <- glmer(selection ~ latency + condition + (1|obs),data=expData,family="binomial", control=glmerControl(optimizer="bobyqa"))
anova(expData.withoutInteraction,expData.completeModel)

  #leave out condition
expData.withoutCondition <- glmer(selection ~ latency + (1|obs),data=expData,family="binomial", control=glmerControl(optimizer="bobyqa"))
anova(expData.withoutCondition,expData.withoutInteraction)

  #leave out latency
expData.withoutLatency <- glmer(selection ~ condition + (1|obs),data=expData,family="binomial", control=glmerControl(optimizer="bobyqa"))
anova(expData.withoutLatency,expData.withoutInteraction)

expData.variabilityOnAll <- glmer(selection ~ latency + condition + latency * condition + (1 + latency + condition + latency*condition|obs), data=expData,family="binomial", control=glmerControl(optimizer="bobyqa"))
summary(expData.variabilityOnAll)
