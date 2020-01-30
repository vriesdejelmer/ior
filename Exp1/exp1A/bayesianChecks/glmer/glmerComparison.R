rm( list=ls() )

library(lme4)
library(boot)
library(ggplot2)
library(LaplacesDemon)
library(plyr)

#####################
###  BASIC PARAM  ###
#####################

numbBins        <- 10
latencyFactor   <- 150 #scaling for glmer
minValue        <- 0.8; maxValue    <- 1.8
rangeValues     <- seq(minValue,maxValue,0.1)
bootIterations  <- 20
lineColors      <- c("orange","blue","cyan")
lineLabels      <- c("IOR Fit","Visual Prediction","Motor Prediction")
lineTypes       <- c("solid","dashed","dotdash")
saveOn          <- FALSE  #determines whether the output is saved

#####################
###   LOAD DATA   ###
#####################

setwd('~/Dropbox/academia/experimentals/processing/analyse-process/ISA/exp1A/bayesianR')

expData <- read.table( "../outputs/dataForR.dat", as.is=TRUE )
names(expData) <- c('obs','condition','latency','selection')

expData$obs           <- as.factor(expData$obs)
expData$condition     <- as.factor(expData$condition)
expData$latency       <- (as.double(expData$latency)/latencyFactor)
expData$selection     <- as.factor(expData$selection)
expData$selection     <- mapvalues(expData$selection, from = c("1", "3"), to = c("1", "0"))
expData$selection     <- relevel(expData$selection,ref="0")

#####################
####  BOOTSTRAP   ###
#####################

iboot <<- 0
glmer_boot <- function(formula, data, indices, predictionRange) {
  
  iboot <<- iboot + 1	#keep count of iterations
  
  print(iboot)
  
    #perform data selection and fit model
  d           <- data[indices,]
  targetModel  <- glmer(formula,data=d,family="binomial", control=glmerControl(optimizer="bobyqa"))
  
    #create predictions, based on alternative input
  newFrame    <- data.frame(latency=as.double(c(predictionRange,predictionRange)),condition = as.factor(c(rep(22,length(predictionRange)),rep(24,length(predictionRange)))))
  predictions <- predict(targetModel,newFrame, type="response", re.form = NA)
  
    #create data-structure and return, mean is actually not necesarry
  meanModel <- tapply(predictions,list(newFrame$latency,newFrame$condition),mean)
  
  return( meanModel )
}

#create stratified list, only based on observers
for (i in 1:nrow(expData) ) {
  expData$strata[i] = paste( toString(expData$obs[i]), toString(expData$condition[i]), sep="_" )
}

  #perform the bootstrap
expData.glmer_boot <- boot( data=expData,  statistic=glmer_boot,  strata=as.factor(expData$strata), R=bootIterations,
                            formula = selection ~ latency + condition + (1|obs), predictionRange = rangeValues)

  #calculate 95% confidence intervals
expData.boot_output <- matrix(0, ncol( expData.glmer_boot$t ), 3)
for (i in 1:ncol( expData.glmer_boot$t ) ){
  tmp <- 0
  tmp <- boot.ci( expData.glmer_boot, index=i, type="perc")
  expData.boot_output[i,] <- c( tmp$t0, tmp$percent[,c(4,5)])
}

  #huup huup huup, lelijke truuk
  #ik pik hier het gemiddelde van de observer latencies en gebruik dat om de hele curve te verschuiven
medianDif <- vector()
for(obs in unique(expData$obs)) {
  medianDif[obs] <- median(expData[(expData$condition==24 & expData$obs==obs),]$latency) - median(expData[(expData$condition==22 & expData$obs==obs),]$latency)
}

  #put data in frame for easy ggplot
avgData <- data.frame(x=c(rangeValues,rangeValues+mean(medianDif),rangeValues),
                      y=c(expData.boot_output[1:length(rangeValues),1],expData.boot_output[,1]),
                      lowerEst=c(expData.boot_output[1:length(rangeValues),2],expData.boot_output[,2]),
                      upperEst=c(expData.boot_output[1:length(rangeValues),3],expData.boot_output[,3]),
                      iorLocation=factor(c(rep(1,length(rangeValues)),rep(2,length(rangeValues)),rep(3,length(rangeValues))))
)


##############################
####   PLOT-LO_SHIZZLO     ###
##############################

  #xticks
xTicks <- seq(minValue,maxValue,0.2)
xTicksLabels <- as.character(round(xTicks*latencyFactor))

  #do the ggplot
(ggplot(avgData,aes(y=y,x=x,color=iorLocation))
  + geom_line(aes(linetype=iorLocation,group=iorLocation),size=1.5)
  + geom_ribbon(aes(ymax=upperEst,ymin=lowerEst,fill=iorLocation),alpha=0.3,colour=NA,show.legend=F)
  + scale_x_continuous(breaks=xTicks, labels=xTicksLabels)
  + ylim(0, 1) + labs(x="Latency (ms)") 
  + scale_color_manual(name=NULL, values=lineColors, labels=lineLabels)
  + scale_linetype_manual(name=NULL,values=lineTypes, labels=lineLabels)
  + scale_fill_manual(name=NULL, values=lineColors, labels=lineLabels)
  + guides(shape=guide_legend(override.aes=list(alpha=1)))
  + theme_bw() )
  #+ theme(plot.title = element_text(hjust = 0.5), legend.key.size = unit(2,"line"), legend.key.width = unit(0.8,"in"),
   #   legend.position = c(0.6, 0.3), text = element_text(size=18), legend.text = element_text(margin = 18),
  #    panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
   #   axis.line = element_line(colour = "black")))

ggsave('experiment1A.png')
