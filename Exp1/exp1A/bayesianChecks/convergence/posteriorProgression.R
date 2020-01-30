#clear workspace and close previous graphics  
rm(list=ls()) 

setwd("~/Dropbox/academia/experimentals/processing/analyse-process/ISA/Exp1A/bayesianChecks/convergence/")

library(HDInterval)
library(ggplot2)

#init constants coding (copied from matlab files)
CONDITION_REL <- 24; lockBinding("CONDITION_REL", globalenv())
CONDITION_IRR <- 22; lockBinding("CONDITION_IRR", globalenv())

source("../../../rFunctions/JagsModelFunctionsExp1.R")
source("../../../rFunctions/PlottingPosteriorsExp1.R")

set.seed(1234)

modelFile <- "../../../rFunctions/jagsModel1A.txt"

#load data
expData <- read.table( "../../outputs/data/dataForR.dat", as.is=TRUE )
names(expData) <- c('subject','condition','latency','response')
expData <- recodeResponses(expData)

subjects <- unique(expData$subject)
totalCount <- length(subjects)

repeats       <- 100
iterations    <- 25000
credInterval  <- 0.95
init.delta.alpha        <- -0.5; init.delta.alpha.sd  <- 0.1
init.alpha              <- 1; init.alpha.sd           <- 0.1
init.beta               <- 0.1;  init.beta.sd         <- 0.05

lowerBounds <- matrix(nrow=repeats,ncol=totalCount)
upperBounds <- matrix(nrow=repeats,ncol=totalCount)
medianDAlpha <- matrix(nrow=repeats,ncol=totalCount)
finalBayesFactors <- matrix(nrow=repeats,ncol=totalCount)

for( i in 1:repeats) {
  subjectOrder <- sample(subjects, length(subjects))
  for( subCount in 1:totalCount ) {
    subSelData <- analyseSublist(subjectOrder, subCount, expData, modelFile, iterations, credInterval, init)
    lowerBounds[i, subCount] <- subSelData$hdiLower
    upperBounds[i, subCount] <- subSelData$hdiUpper
    finalBayesFactors[i, subCount] <- subSelData$bayesFactor
    medianDAlpha[i, subCount] <- subSelData$delta.alpha
  }
}

dataDescription <- createDataFrame(subjects, upperBounds, lowerBounds, medianDAlpha)
posterior95Plot <- create95PosteriorPlot(dataDescription)

figFileName <- paste("../../outputs/bayesianFigures/progessionFig", repeats, "_", iterations, ".pdf", sep="");
ggsave(figFileName, posterior95Plot, width=15, height=7)
