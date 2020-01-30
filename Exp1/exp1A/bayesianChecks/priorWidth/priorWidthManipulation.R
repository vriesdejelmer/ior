#################################################
############## GENERAL SETUP

#clear workspace:
rm(list=ls()) 

#set working directory
setwd("~/Dropbox/academia/experimentals/processing/analyse-process/ISA/mainExp/")

#load libraries
library(R2jags)
library(polspline)
library(stats)
library(plyr)
library(LaplacesDemon)
library(gridExtra)
library(ggplot2)

figName <- "outputs/figure6"
load('outputs/jagsOutput1A.rdata')

print(bayesFactors)

#determine number of bins
numbBins <- 10

#set vars
priorWidth <- 0.707
largerPriorWidth <- priorWidth * 2
smallerPriorWidth <- priorWidth * 0.5

#################################################
############## Bayes Factors are also computed and stored in jagsComparison but we can play with them here without having to repeat the MCMC algorithm

bayesFactors <- function(priorScale) {
    #compute Bayes factors in favor of H-SacReadiness
  prior_dalphaSR <- dcauchy(0,scale=priorScale)
  post_dalphaSR  <- dlogspline(0, logspline(jagsRawData$mu.delta.alpha))
  BF_dalphaSR    <- post_dalphaSR/prior_dalphaSR
  
    #compute Bayes factors in favor of H-VisProcessing
  prior_dalphaVP  <- dcauchy(alphaOffset,location=alphaOffset,scale=priorScale)
  post_dalphaVP   <- dlogspline(alphaOffset, logspline(jagsRawData$mu.delta.alpha))
  BF_dalphaVP     <- post_dalphaVP/prior_dalphaVP
  
    #bayes factor comparing one against the other
  BF_dalphaSRVP <- BF_dalphaSR / BF_dalphaVP
  
  return(c(BF_dalphaSRVP, BF_dalphaSR, BF_dalphaVP))
}

regularBFlist <- bayesFactors(priorWidth)
widerBFlist <- bayesFactors(largerPriorWidth)
narrowerBFlist <- bayesFactors(smallerPriorWidth)
#(regularBF, regularSR, regularVP) <- bayesFactors(jagsRawData, 0.707)

#bayesFactors(jagsRawData, 0.707)