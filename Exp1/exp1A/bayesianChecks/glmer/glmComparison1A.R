#################################################
############## GENERAL SETUP

  #clear workspace:  
rm(list=ls()) 

  #set working directories
setwd("~/Dropbox/academia/experimentals/processing/analyse-process/ISA/mainExp/")

  #load libraries
library(lme4)
library(LaplacesDemon)
library(plyr)
library(gridExtra)
library(ggplot2)

  #init constants coding (copied from matlab files)
CONDITION_REL <- 24
CONDITION_IRR <- 22

  #load data
expData <- read.table( "dataForR.dat", as.is=TRUE )
names(expData) <- c('obs','condition','latency','selection')
#parameter settings
minValue    <- 0.75; maxValue    <- 2.1
rangeValues <- seq(minValue,maxValue,0.1)
numbBins        <- 10
latencyScalar   <- 150

#ensure proper data-types and ranges
expData$obs         <- as.factor(expData$obs)
expData$condition   <- as.factor(expData$condition)
for( obsI in unique(expData$obs) ){
  obsSel <- expData$obs==obsI
  expData$latency[obsSel] <- expData$latency[obsSel] - mean(expData$latency[obsSel])
}
expData$selection   <- as.factor(expData$selection)
expData$selection   <- mapvalues(expData$selection, from = c("1", "3"), to = c("1", "0"))  #relevel to 1 and 0 (1=TARGET,3=DISTRACTOR)
expData$selection   <- relevel(expData$selection,ref="0")

set.seed(12345)

#create predictions, based on alternative input
dataFit     <- glmer(selection ~ latency + condition + (1|obs),data=expData,family=binomial(link="logit"), control=glmerControl(optimizer="bobyqa"))

summary(dataFit)
newFrame    <- data.frame(latency=as.double(c(rangeValues,rangeValues)),condition = as.factor(c(rep(CONDITION_REL,length(rangeValues)),rep(CONDITION_IRR,length(rangeValues)))))
predictions <- predict(dataFit,newFrame, type="response", re.form = NA)


#create data frame for plotting with ggplot
avgData <- data.frame(x=c(rangeValues,rangeValues),
                      y=c(predictions),
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
      if( cond == CONDITION_REL ) {
        latencyTarIOR[bin,obsNum]   <- median(latList[((bin-1)*binSize+1):(bin*binSize)])
        correctTarIOR[bin,obsNum]   <- mean(corList[((bin-1)*binSize+1):(bin*binSize)])
      } else if( cond == CONDITION_IRR) {
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

labelList <- c("Relevant Cue Condition","Irrelevant Cue Condition")

#finally ggplot.....
(plot1 <- ggplot(avgData,aes(y=y,x=x,color=iorLocation))
  + geom_line(aes(linetype=iorLocation,group=iorLocation),size=1.5)
  + scale_x_continuous(breaks=xTicks, labels=xTicksLabels)
  + ylim(0.2, 1.01) + labs(x="Latency (ms)",y="Accuracy") 
  + geom_point(data=binData,aes(x=xbins,y=ybins,color=factor(iorLocation),shape=factor(iorLocation)),size=4, alpha=0)
  + geom_point(data=binData,aes(x=xbins,y=ybins,color=factor(iorLocation),shape=factor(iorLocation)),size=2,show.legend=FALSE)
  + scale_color_manual(name=NULL,values = c("grey40", "grey75"),labels=labelList)
  + scale_linetype_manual(name=NULL,values=c("dotdash","solid"),labels=labelList)
  + scale_fill_manual(name=NULL,values = c("grey40", "grey75"),labels=labelList)
  + scale_shape_manual(name=NULL,values = c(16,17),labels=labelList)
  + guides(shape=guide_legend(override.aes=list(alpha=1)))
  + theme_bw() + theme(legend.key.size = unit(2,"line"), legend.key.width = unit(0.8,"in"),legend.position = c(0.7, 0.2), text = element_text(size=18), legend.text = element_text(margin = 18), panel.border = element_blank(), panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")))

#....and save
ggsave('glmerCheck.png')
