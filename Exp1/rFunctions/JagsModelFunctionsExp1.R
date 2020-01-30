library(R2jags) #0.5-7
library(polspline) #1.1.17
library(stats) #
library(plyr) #1.8.4
library(LaplacesDemon) #16.1.1
library(gridExtra) #2.3
library(ggplot2) #3.2.1
library(lattice) #0.20-38
library(coda) #0.19-3
library(superdiag) #1.1

#################################################
############## Recode responses from experiment constants to (0, 1) for regression
recodeResponses <- function(expData) {
  expData$response <- mapvalues(expData$response, from = c("1", "2", "3"), to = c("1", "0", "0"))
  return(expData)
}

#################################################
############## Run a simulation on the sublist
analyseSublist <- function(subjectOrder, subCount, expData, modelFile, iterations, credInterval, init) {
  subList <- subjectOrder[1:subCount]
    subData <- expData[expData$subject  %in% subList,]
  jagsFormat <- prepareData(subData)
  samples <- jagsSimulation(jagsFormat, modelFile, nIter=iterations, init=init)
  muSamples <- fetchMetaSamples(samples)
  delta.alpha <- median(muSamples$mu.delta.alpha)
  bayesFactors <- calculateBayesFactors(muSamples, subData)
  hdiObject <- hdi(muSamples$mu.delta.alpha, credMass = credInterval)
  return(list(hdiUpper=hdiObject[[2]], hdiLower=hdiObject[[1]], bayesFactors=bayesFactors$bfSRVP, delta.alpha=delta.alpha))
}

#################################################
############## Run the Jags simulation
jagsSimulation <- function(dataList, modelFile, nChains=3, nIter=50000, nBurn=-1, nThin=3, init) {

    #If no burn rate is given we determine one (nBurn == -1)
  if( nBurn == -1 ) {
    chainLength <- nIter/nThin
    nBurn <- round(chainLength/10)
  }
  
    #create list with (randomized) initial values
  myInits <- replicate(nChains,
                       list( mu.delta.alpha = rnorm(1, mean=init.delta.alpha,sd=init.delta.alpha.sd), 
                             mu.alpha = rnorm(1, mean=init.alpha,sd=init.alpha.sd),
                             mu.beta = rnorm(1, mean=init.beta,sd=init.beta.sd), 
                             sigma.delta.alpha = 0.1,
                             sigma.alpha = 0.1,
                             sigma.beta = 0.1),
                       simplify =F)
  
    #parameters to be monitored:	
  parameters <- c( "mu.delta.alpha",  "mu.alpha", "mu.beta", #global estimates
                   "delta.alpha", "alpha", "beta") #individual estimates
  
    #run the Gibbs sampler!
  samples <- jags(dataList, inits = myInits, parameters, model.file = modelFile,
                   n.chains = nChains, n.iter = nIter, n.burnin = nBurn, n.thin = nThin)
  return(samples)
}

#################################################
############## Create a list with just meta samples
collectMetaSamples <- function(samples) {
  mu.delta.alpha  <- samples$BUGSoutput$sims.list$mu.delta.alpha
  mu.alpha        <- samples$BUGSoutput$sims.list$mu.alpha
  mu.beta         <- samples$BUGSoutput$sims.list$mu.beta
  return(list(mu.alpha=mu.alpha, mu.delta.alpha=mu.delta.alpha, mu.beta=mu.beta))
}

#################################################
############## GO-GO BAYES FACTORS
calculateBayesFactors <- function(samples, expData, priorWidth = 0.707) {

  #compute Bayes factors in favor of H-SacReadiness
  prior.dalphaSR <- dcauchy(0,scale=priorWidth)
  post.dalphaSR  <- dlogspline(0, logspline(samples$mu.delta.alpha))
  BF.dalphaSR    <- post.dalphaSR/prior.dalphaSR
  
  #compute Bayes factors in favor of H-VisProcessing
  medianLatDif    <- median(with(expData,latency[condition==CONDITION_IRR]))-median(with(expData,latency[condition==CONDITION_REL]))
  alphaOffset     <- medianLatDif * median(samples$mu.beta)
  prior.dalphaVP  <- dcauchy(alphaOffset,location=alphaOffset,scale=priorWidth)
  post.dalphaVP   <- dlogspline(alphaOffset, logspline(samples$mu.delta.alpha))
  BF.dalphaVP     <- post.dalphaVP/prior.dalphaVP
  
  #bayes factor comparing one against the other
  BF.dalphaSRVP <- BF.dalphaSR / BF.dalphaVP
  
  #for storing
  bayesFactors <- list(bfSR=BF.dalphaSR, bfVP=BF.dalphaVP, bfSRVP=BF.dalphaSRVP, alphaOffset=alphaOffset)
  
  return(bayesFactors)
}

#################################################
############## Save the samples
saveSamples <- function(samples, bayesFactors, expId) {
  jagsRawData   <- data.frame(mu.delta.alpha=samples$mu.delta.alpha,mu.alpha=samples$mu.alpha,mu.beta=samples$mu.beta)
  save(jagsRawData,bayesFactors, file=paste("../outputs/data/jagsOutput", expId ,".rData", sep=""))
}

#################################################
############## Save plots for inspecting chains
saveChainPlots <- function(samples, samplesMCMC, versionID) {
  
  pdf(paste("../outputs/bayesianFigures/markovChains", versionID, ".pdf", sep=""))
  plot(samplesMCMC)
  dev.off()

  pdf(paste("../outputs/bayesianFigures/chainPlots", versionID, ".pdf", sep=""))
  traceplot(samplesMCMC)
  dev.off()
  
  pdf(paste("../outputs/bayesianFigures/logSplineEst", versionID, ".pdf", sep=""))
  mu.delta.alpha <- samples$BUGSoutput$sims.list$mu.delta.alpha
  xDeltaAlphaRange <- seq(floor(min(mu.delta.alpha)), ceiling(max(mu.delta.alpha)),0.01)
  outH <- hist(mu.delta.alpha, breaks=xDeltaAlphaRange)
  distrDens  <- dlogspline(xDeltaAlphaRange, logspline(samples$BUGSoutput$sims.list$mu.delta.alpha))
  scalar <- max(outH$counts)/max(distrDens)
  lines(xDeltaAlphaRange,distrDens*scalar,col="red",lwd=3)
  
  mu.alpha <- samples$BUGSoutput$sims.list$mu.alpha
  xAlphaRange <- seq(floor(min(mu.alpha)), ceiling(max(mu.alpha)),0.01)
  outH <- hist(mu.alpha,breaks=xAlphaRange)
  distrDens  <- dlogspline(xAlphaRange, logspline(mu.alpha))
  scalar <- max(outH$counts)/max(distrDens)
  lines(xAlphaRange,distrDens*scalar,col="red",lwd=3)
  
  mu.beta <- samples$BUGSoutput$sims.list$mu.beta
  xBetaRange <- seq(floor(min(mu.beta)), ceiling(max(mu.beta)),0.01)
  outH <- hist(samples$BUGSoutput$sims.list$mu.beta,breaks=xBetaRange)
  distrDens  <- dlogspline(xBetaRange, logspline(samples$BUGSoutput$sims.list$mu.beta))
  scalar <- max(outH$counts)/max(distrDens)
  lines(xBetaRange,distrDens*scalar,col="red",lwd=3)
  dev.off()
}

createDataFrame <- function(subjects, upperBounds, lowerBounds, medianDAlpha) {
  rows <- 1:length(subjects)
  upperExtreme <- apply(upperBounds, 2, function(x) max(x))
  lowerExtreme <- apply(lowerBounds, 2, function(x) min(x))
  upperAvg <- apply(upperBounds, 2, function(x) mean(x))
  lowerAvg <- apply(lowerBounds, 2, function(x) median(x))
  medianAvg <- apply(medianDAlpha, 2, function(x) mean(x))
  
  dataDescription <- data.frame(rows=rows,upperExtreme=upperExtreme, lowerExtreme=lowerExtreme, upperAvg=upperAvg, lowerAvg, medianAvg=medianAvg);
  return(dataDescription)
}