  #clear workspace:  
rm(list=ls()) 

  #set working directories
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#init constants coding (copied from matlab files)
CONDITION_REL <- 24; lockBinding("CONDITION_REL", globalenv())
CONDITION_IRR <- 22; lockBinding("CONDITION_IRR", globalenv())

source("../../rFunctions/DataProcessingExp1.R")
source("../../rFunctions/JagsModelFunctionsExp1.R")
source("../../rFunctions/PlottingPosteriorsExp1.R")

###### Loading and preparing DATA

expData <- read.table( "../data/dataForR.dat", as.is=TRUE )
names(expData) <- c('subject','condition','latency','response')
expData <- recodeResponses(expData)
jagsFormat <- prepareData(expData)

###### JAGS Parameters

nChains <- 15
nIter   <- 1000000
nBurn   <- 10000
nThin   <- 100

#################################################
############## Parameter priors

init.delta.alpha        <- -1; init.delta.alpha.sd <- 0.1
init.alpha              <- -5; init.alpha.sd       <- 0.5
init.beta               <- 0;  init.beta.sd        <- 0.05

###### JAGS Running

set.seed(1234)
modelFile <- "../../rFunctions/jagsModel.txt"
samples <- jagsSimulation(jagsFormat, modelFile, nChains, nIter, nBurn, nThin, init)
muSamples <- collectMetaSamples(samples)
bayesFactors <- calculateBayesFactors(muSamples, expData)

##### Saving Data

  #if we're running on the server we save the whole data-file for safekeeping
if( dir.exists("../outputs/serverOnly/")) {
  save(samples,file="../outputs/serverOnly/samples.rData")
}
saveSamples(muSamples, bayesFactors, '1A')
samplesMCMC <- as.mcmc(samples)

##### Save plots of parameters posteriors

saveChainPlots(samples, samplesMCMC, '1A')
  #for some reason this doesn't work in a function call......
pdf("../outputs/bayesianFigures/densityPlots.pdf")
densityplot(as.mcmc(samples), layout=c(2, 5), as.table=TRUE, aspect="fill")
dev.off()

##### Write LOG

sink("../outputs/data/output1A.log")
summary(samplesMCMC)
superdiag(samplesMCMC, burnin=10)
print(samples)
sink()


