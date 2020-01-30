#################################################
############## GENERAL SETUP

  #clear workspace:
rm(list=ls()) 

  #set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

  #load libraries
source("../../rFunctions/DataProcessingExp1.R")
source("../../rFunctions/JagsModelFunctionsExp1.R")
source("../../rFunctions/PlottingPosteriorsExp1.R")

  #set constants (from matlabConstants)
CONDITION_REL <- 21; lockBinding("CONDITION_REL", globalenv())
CONDITION_IRR <- 22; lockBinding("CONDITION_IRR", globalenv())

CONDITION_SHORT <- 0.6; lockBinding("CONDITION_SHORT", globalenv())
CONDITION_LONG <- 1; lockBinding("CONDITION_LONG", globalenv())

  #chains, iterations, etc
nChains <- 15
nIter   <- 1000000
nBurn   <- 10000
nThin   <- 100

  #base values for chain initilization
init.delta.alpha        <- -0.5; init.delta.alpha.sd <- 0.1
init.alpha              <- -5; init.alpha.sd       <- 0.5
init.beta               <- 0;  init.beta.sd        <- 0.03

  #load data
expData <- read.table( "../data/dataForR.dat", as.is=TRUE )
names(expData) <- c('subject','condition','subCondition','latency','response')
expData <- recodeResponses(expData)

modelFile <- "../../rFunctions/jagsModel.txt"

#################################################
############## ANALYSIS LOOP

#run for both the short and long CTOA subcondition
subCondList <- unique(expData$subCondition)
for( subCond in subCondList ) {
  
  if( subCond==CONDITION_LONG ) {
    print('LONG')
    versionID       <- '1B_long'
  } else if( subCond==CONDITION_SHORT ) {
    print('SHORT')
    versionID       <- '1B_short'
  }
  
    #create subsection for the two subconditions
  conditionData <- expData[expData$subCondition==subCond,]
  
  jagsData <- prepareData(conditionData)
  set.seed(1234)
  samples <- jagsSimulation(jagsData, modelFile, nChains, nIter, nBurn, nThin)
  muSamples <- collectMetaSamples(samples)
  bayesFactors <- calculateBayesFactors(muSamples, conditionData)

  save(muSamples ,file=paste("../outputs/muSamples", versionID, ".rData", sep=""))
  #if we're running on the server we save the whole data-file for safekeeping
  if( dir.exists("../outputs/serverOnly/")) {
    save(samples, file=paste("../outputs/serverOnly/samples", versionID, ".rData", sep=""))
  }
  
  saveSamples(muSamples, bayesFactors, versionID)
  samplesMCMC <- as.mcmc(samples)
  saveChainPlots(samples, samplesMCMC, versionID)

}