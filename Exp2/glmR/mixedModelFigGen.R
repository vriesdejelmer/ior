rm( list=ls() )

library(lme4) #1.1-21
library(boot) #1.3-22
library(ggplot2) #3.2.1
library(LaplacesDemon) #16.1.1
library(plyr) #1.8.4

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

  #to obtain the same random sequence
set.seed(12345)

COND_TARGET_IOR   <- 21
COND_DIST_IOR     <- 22

#####################
###   DATA INIT   ###
#####################

  #load data
expData <- read.table( "../data/dataForR.dat", as.is=TRUE )
names(expData) <- c('obs','trialNum','condition','subCondition','latency','selection')

  #parameter settings
minValue        <- 0.7; maxValue    <- 2.3
rangeValues     <- seq(minValue,maxValue,0.1)
numbBins        <- 20
latencyScalar   <- 150
bootIterations  <- 100

  #ensure proper data-types and ranges
expData$obs        <- as.factor(expData$obs)
expData$condition  <- as.factor(expData$condition)
expData$trialNum   <- as.double(expData$trialNum)
expData$latency    <- (as.double(expData$latency))/latencyScalar  #to avoid scaling warning
expData$selection  <- as.factor(expData$selection)
expData$selection  <- mapvalues(expData$selection, from = c("1", "3"), to = c("1", "0"))  #relevel to 1 and 0 (1=TARGET,3=DISTRACTOR)
expData$selection   <- relevel(expData$selection,ref="0")

##########################################
#####################
####  BOOTSTRAP   ###
#####################

iboot       <<- 0   #global progress tracker

  #bootstrap function
glmer_boot  <- function(formula, data, indices, predictionRange) {
  
    #progress tracking
  iboot <<- iboot + 1
  print(iboot)
  
    #perform data selection and fit model
  d             <- data[indices,]   #bootstrap-iteration data
  targetModel   <- glmer(formula,data=d,family="binomial", control=glmerControl(optimizer="bobyqa"))
  
    #create predictions, based on alternative input
  newFrame      <- data.frame(latency=as.double(c(predictionRange,predictionRange)),condition = as.factor(c(rep(COND_TARGET_IOR,length(predictionRange)),rep(COND_DIST_IOR,length(predictionRange)))))
  predictions   <- predict(targetModel,newFrame, type="response", re.form = NA)

    #create data-structure and return, mean is actually not necesarry
  meanModel <- tapply(predictions,list(newFrame$latency,newFrame$condition),mean)
  return( meanModel )
}

  #create stratified list, only based on observers
for (i in 1:nrow(expData) ) {
    #strata based on obs and condition only
  expData$strata[i] = paste( toString(expData$obs[i]), toString(expData$condition[i]), sep="_" )
}

  #perform the bootstrap
expData.glmer_boot <- boot(data=expData,  statistic=glmer_boot,  strata=as.factor(expData$strata), R=bootIterations,
                           formula = selection ~ latency * condition + (1|obs), predictionRange = rangeValues)


  #calculate 95% confidence intervals
expData.boot_output <- matrix(0, ncol( expData.glmer_boot$t ), 3)
for (i in 1:ncol( expData.glmer_boot$t ) ){
  tmp <- 0
  tmp <- boot.ci( expData.glmer_boot, index=i, type="perc")
  expData.boot_output[i,] <- c( tmp$t0, tmp$percent[,c(4,5) ])
}

#create predictions, based on alternative input
dataFit     <- glmer(selection ~ latency * condition + (1|obs),data=expData,family="binomial", control=glmerControl(optimizer="bobyqa"))
newFrame    <- data.frame(latency=as.double(c(rangeValues,rangeValues)),condition = as.factor(c(rep(COND_TARGET_IOR,length(rangeValues)),rep(COND_DIST_IOR,length(rangeValues)))))
predictions <- predict(dataFit,newFrame, type="response", re.form = NA)


  #create data frame for plotting with ggplot
avgData <- data.frame(x=c(rangeValues,rangeValues),
                      y=c(predictions),
                      lowerEst=c(expData.boot_output[,2]),
                      upperEst=c(expData.boot_output[,3]),
                      iorLocation=factor(c(rep(1,length(rangeValues)),rep(2,length(rangeValues))))
)

##########################################
##############################
####   BINNING REAL DATA   ###
##############################

  #initiate empty matrices
latencyTarIOR   <- matrix(nrow = numbBins, ncol = length(unique(expData$obs)))
latencyDistIOR  <- matrix(nrow = numbBins, ncol = length(unique(expData$obs)))
correctTarIOR   <- matrix(nrow = numbBins, ncol = length(unique(expData$obs)))
correctDistIOR  <- matrix(nrow = numbBins, ncol = length(unique(expData$obs)))

  #calculate bin proportions
for( obsNum in as.double(unique(expData$obs)) ) {
  for( cond in unique(expData$condition) ) {
    obsSubset <- expData[expData$obs == obsNum & expData$condition == cond,]
    orderList <- order(obsSubset$latency)
    
    latList   <- obsSubset$latency[orderList]
    corList   <- obsSubset$selection[orderList] == 1
      
    binSize  <- floor(length(latList)/numbBins)   #may lead to some excluded values, but only the longest latency saccades
    for( bin in 1:numbBins ){
      if( cond == COND_TARGET_IOR ) {
        latencyTarIOR[bin,obsNum]   <- median(latList[((bin-1)*binSize+1):(bin*binSize)])
        correctTarIOR[bin,obsNum]   <- mean(corList[((bin-1)*binSize+1):(bin*binSize)])
      } else if( cond == COND_DIST_IOR ) {
        latencyDistIOR[bin,obsNum]  <- median(latList[((bin-1)*binSize+1):(bin*binSize)])
        correctDistIOR[bin,obsNum]  <- mean(corList[((bin-1)*binSize+1):(bin*binSize)])
      }
    }
  }
} 

  #calculate observer means
latTarIORBins   <- rowMeans(latencyTarIOR) 
corTarIORBins   <- rowMeans(correctTarIOR) 
latDistIORBins  <- rowMeans(latencyDistIOR) 
corDistIORBins  <- rowMeans(correctDistIOR)


  #create data frame for ggplot
xbins <- c(latTarIORBins,latDistIORBins)
ybins <- c(corTarIORBins,corDistIORBins)
iorCond <- c(rep(1,length(latTarIORBins)),rep(2,length(latDistIORBins)))
binData <- data.frame(xbins=xbins,ybins=ybins,iorLocation=iorCond)


  #create appropriate ticks (undo scaling and the likes)
xTicks <- seq(minValue,maxValue,0.2)
xTicksLabels <- as.character(round(xTicks*latencyScalar))

labelList <- c("Target-Cued","Distractor-Cued")

  #finally ggplot.....
(plot1 <- ggplot(avgData,aes(y=y,x=x,color=iorLocation))
  + geom_ribbon(aes(ymax=upperEst,ymin=lowerEst,fill=iorLocation),alpha=0.3,colour=NA,show.legend=F)
  + geom_line(aes(linetype=iorLocation,group=iorLocation),size=1.5)
  + scale_x_continuous(breaks=xTicks, labels=xTicksLabels)
  + ylim(0, 1) + labs(x="Latency (ms)",y="Accuracy") 
  + geom_point(data=binData,aes(x=xbins,y=ybins,color=factor(iorLocation),shape=factor(iorLocation)),size=4, alpha=0)
  + geom_point(data=binData,aes(x=xbins,y=ybins,color=factor(iorLocation),shape=factor(iorLocation)),size=2,show.legend=FALSE)
  + scale_color_manual(name=NULL,values = c("grey40", "grey75"),labels=labelList)
  + scale_linetype_manual(name=NULL,values=c("dotdash","solid"),labels=labelList)
  + scale_fill_manual(name=NULL,values = c("grey40", "grey75"),labels=labelList)
  + scale_shape_manual(name=NULL,values = c(16,17),labels=labelList)
  + guides(shape=guide_legend(override.aes=list(alpha=1)))
  + theme_bw() + theme(legend.key.size = unit(2,"line"), legend.key.width = unit(0.8,"in"),legend.position = c(0.7, 0.2), text = element_text(size=18), panel.border = element_blank(), panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")))
  
  #....and save
ggsave('../outputs/manuscriptFigures/modelFitsExp2.png')
