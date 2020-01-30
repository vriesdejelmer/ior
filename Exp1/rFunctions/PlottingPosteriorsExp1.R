#################################################
############## GENERAL SETUP

#load libraries
library(polspline) #1.1.17
library(stats)
library(plyr) #1.8.4
library(LaplacesDemon) #16.1.1
library(gridExtra) #2.3
library(ggplot2) #3.2.1
library(HDInterval) #0.2.0

priorWidth <- 0.707

plotPosteriors <- function(jagsRawData, expData) {
  print("PlotPosteriors start")
  #################################################
  ############## GO-GO GGPLOT
  medianLatDif    <- median(with(expData,latency[condition==CONDITION_IRR]))-median(with(expData,latency[condition==CONDITION_REL]))
  alphaOffset     <- medianLatDif * median(jagsRawData$mu.beta)
  legendSize  <- 12

  alphaRange <- seq(-3.2,2,0.01) #create range for plotting
  
  ypriorSR    <- dcauchy(alphaRange, location = 0, scale = priorWidth)
  ypriorVP    <- dcauchy(alphaRange, location = alphaOffset, scale = priorWidth)
  yposterior  <- dlogspline(alphaRange, logspline(jagsRawData$mu.delta.alpha) )
  
  prior.dalphaSR    <- dcauchy(0,scale=priorWidth)
  post.dalphaSR     <- dlogspline(0, logspline(jagsRawData$mu.delta.alpha))
  prior.dalphaVP    <- dcauchy(alphaOffset, location=alphaOffset,scale=priorWidth)
  post.dalphaVP     <- dlogspline(alphaOffset, logspline(jagsRawData$mu.delta.alpha))
  
  #data frame for plotting
  xList       <- as.double(c(alphaRange,alphaRange,alphaRange))
  yList       <- c(ypriorSR, ypriorVP, yposterior)
  coding      <- as.factor(c(rep(1,length(alphaRange)),rep(2,length(alphaRange)),rep(3,length(alphaRange))))
  resultFrame <- data.frame(x=xList,y=yList,coding=coding)
  
  pointsFrame <- data.frame(xPoints=c(0, 0, alphaOffset, alphaOffset), yPoints=c(post.dalphaSR, prior.dalphaSR, post.dalphaVP, prior.dalphaVP))
  print(pointsFrame)
  bayesLabels <- c("Readiness Prior", "Visual Prior", "Posterior")
  
  hdiHeight <- 0.025
  hdiRange <- hdi(jagsRawData$mu.delta.alpha,credMass=0.95)
  
  (posteriorPlot <- ggplot(resultFrame,aes(y=y, x=x, color=coding))
   + geom_vline(xintercept=alphaOffset, color="grey", linetype="dashed", size=0.75, show.legend=F)
   + geom_vline(xintercept=0, color="grey", linetype="dashed", size=0.75, show.legend=F)
   
   + geom_line(aes(linetype=coding,group=coding),size=1.5)
   + scale_linetype_manual(name=NULL, values=c("dotdash","longdash","solid"), labels=bayesLabels)
   + scale_color_manual(name=NULL, values = c("grey20", "grey80", "grey50"), labels=bayesLabels)
   + xlim(min(alphaRange), max(alphaRange))
   + geom_point(data=pointsFrame, aes(x=xPoints,y=yPoints), colour="grey", size=2.5)
   + labs(x="Delta Alpha",y="Density")
   + theme_bw() + theme(
     legend.key.size = unit(1.5, "line"), legend.key.width = unit(0.4,"in"),
     legend.position = c(0.215, 0.8),  legend.text = element_text(size=legendSize),
     legend.box.background = element_rect(colour="black"),
     axis.line.y = element_line(), axis.text = element_text(size=10),
     axis.line.x = element_line(), axis.title =element_text(size=14),
     axis.title.x = element_text(margin = unit(c(5, 0, 0, 0), "mm")),
     axis.title.y = element_text(margin = unit(c(0, 5, 0, 0), "mm")),
     panel.border = element_blank(), panel.grid.major = element_blank(),
     panel.grid.minor = element_blank() )
    + geom_segment(aes(x=hdiRange['lower'], y=hdiHeight, xend = hdiRange['upper'], yend=hdiHeight),size=2, colour="black")
  )
  print("PlotPosteriors end")
  return(posteriorPlot)
}

plotData <- function(fullPath, dataSets, i=0) {
  pdf(fullPath)
  nSubjects <- unique(dataSets$mix$subject)
  for( subj in nSubjects ) {
    mixList <- getBinMeasures(dataSets$mix, subj)
    srList <- getBinMeasures(dataSets$sr, subj)
    vtdList <- getBinMeasures(dataSets$vtd, subj)
    par(mfrow=c(3, 1))
    p1 <- plotBinList(srList, srList$delta_alpha)
    p2 <- plotBinList(mixList, mixList$delta_alpha)
    p3 <- plotBinList(vtdList, vtdList$delta_alpha)  
  }
  dev.off()
}

determineXRangeAndAxis <- function(performanceFrame, subjectMeans, xMinAxis, xMaxAxis) { 
  
  if( xMinAxis == -1 ) {
    xMinAxis <- min(performanceFrame$latBins)-20
  }
  if( xMaxAxis == -1 ) {
    xMaxAxis <- max(performanceFrame$latBins)+20
  }

  xRange <- seq(xMinAxis-mean(subjectMeans),xMaxAxis-mean(subjectMeans),0.1)
  return(list(xMinAxis=xMinAxis, xMaxAxis=xMaxAxis, xRange=xRange))
}

plotFits <- function(jagsRawData, performanceFrame, subjectMeans, xMinAxis=-1, xMaxAxis=-1) {
  legendSize  <- 12
  labelList   <- c("Irr. Cue Cond","Rel. Cue Cond")
  
  performanceFrame$latBins <- performanceFrame$latBins + mean(subjectMeans)
  axisRange <- determineXRangeAndAxis(performanceFrame, subjectMeans, xMinAxis, xMaxAxis)
  
  expr1 <- function(x) 1/(1+exp( -( (median(jagsRawData$mu.alpha)-median(jagsRawData$mu.delta.alpha)/2) + (median(jagsRawData$mu.beta) * x) ) ) )
  expr2 <- function(x) 1/(1+exp( -( (median(jagsRawData$mu.alpha)+median(jagsRawData$mu.delta.alpha)/2) + (median(jagsRawData$mu.beta) * x) ) ) )
  
  fittedData <- data.frame(x=c(axisRange$xRange,axisRange$xRange),y=c(expr1(axisRange$xRange),expr2(axisRange$xRange)),coding=c(rep(1,length(axisRange$xRange)),rep(2,length(axisRange$xRange))))
  fittedData$x <- fittedData$x + mean(subjectMeans)
  

  #ggplot component
  (fitPlot <- ggplot(fittedData,aes(y=y,x=x,color=as.factor(coding)))
    + geom_line(aes(linetype=as.factor(coding)),size=1.5)
    + geom_point(data=performanceFrame,aes(x=latBins,y=perfBins,color=as.factor(coding),shape=as.factor(coding)),size=2.5)
    
    + scale_linetype_manual(name=NULL,values=c("solid", "dotdash"),labels=labelList)
    + scale_shape_manual(name=NULL,values = c(16,17), labels=labelList)
    + scale_color_manual(name=NULL,values = c("grey65", "grey45"),labels=labelList)
    + xlim(axisRange$xMinAxis, axisRange$xMaxAxis) + ylim(0.2, 1.01)
    
    + labs(x="Latency (ms)",y="Accuracy")
    + theme_bw() + theme(
      legend.key.size = unit(1.5,"line"), legend.key.width = unit(0.4,"in"),
      legend.position = c(0.7, 0.2),  legend.text = element_text(size=legendSize),
      legend.box.background = element_rect(colour="black"),
      axis.line.y = element_line(), axis.text = element_text(size=14),
      axis.line.x = element_line(), axis.title =element_text(size=15),
      axis.title.x = element_text(margin = unit(c(5, 0, 0, 0), "mm")),
      axis.title.y = element_text(margin = unit(c(0, 5, 0, 0), "mm")),
      panel.border = element_blank(), panel.grid.major = element_blank(),
      panel.grid.minor = element_blank() )
  )
  return(fitPlot)
}

getBinMeasures <- function(dataSet, subj, numbBins = 5) {
  latRel <- with(dataSet, latency[condition == CONDITION_REL & subject == subj])
  respRel <- with(dataSet, response[condition == CONDITION_REL & subject == subj])
  latIrr <- with(dataSet, latency[condition == CONDITION_IRR & subject == subj])
  respIrr <- with(dataSet, response[condition == CONDITION_IRR & subject == subj])
  
  orderRel <- order(latRel)
  orderIrr <- order(latIrr)
  
  alpha <- with(dataSet, alpha[subject == subj])[1]
  beta <- with(dataSet, beta[subject == subj])[1]
  delta_alpha <- with(dataSet, delta_alpha[subject == subj])[1]
  
  ordLatIrr <- latIrr[orderIrr]
  ordRespIrr <- respIrr[orderIrr]
  ordLatRel <- latRel[orderRel]
  ordRespRel <- respRel[orderRel]
  
  meanLatRel <- rep(0, numbBins); meanRespRel <- rep(0, numbBins);
  meanLatIrr <- rep(0, numbBins); meanRespIrr <- rep(0, numbBins);
  bins <- 1:numbBins
  binSize <- floor(length(ordLatIrr)/numbBins)
  for( bin in bins ) {
    beginIndex <- (bin-1)*binSize+1
    endIndex <- bin*binSize
    meanLatRel[bin] <- mean(ordLatRel[beginIndex:endIndex])
    meanRespRel[bin] <- mean(ordRespRel[beginIndex:endIndex])
    meanLatIrr[bin] <- mean(ordLatIrr[beginIndex:endIndex])
    meanRespIrr[bin] <- mean(ordRespIrr[beginIndex:endIndex])
  }
  return( list(latRel=meanLatRel, latIrr=meanLatIrr, respRel=meanRespRel, respIrr=meanRespIrr, alpha=alpha, beta=beta, delta_alpha=delta_alpha) )
}

plotBinList <- function(listData, delta_alpha) {
  logistic <- function(x, beta, alpha, delta_alpha) 1/(1+exp(-(beta*x-alpha+delta_alpha/2)))
  p <- plot((100:400), logistic(100:400, listData$beta, listData$alpha, delta_alpha), xlim=c(100, 400), ylim=c(0,1), type="l")
  lines((100:400), logistic(100:400, listData$beta, listData$alpha, -delta_alpha))
  points(listData$latRel, listData$respRel, pch=2)
  points(listData$latIrr, listData$respIrr, pch=19)
  return(p)
}

create95PosteriorPlot <- function(dataDescription) {
  posterior95Plot <- (ggplot(data=dataDescription,aes(x=rows,y=medianAvg)) +
    geom_hline(yintercept=0, color="grey",linetype="dotdash",size=0.75,show.legend=F) +
    geom_hline(yintercept=-1.1, color="grey",linetype="longdash",size=0.75,show.legend=F) +
    geom_errorbar(aes(ymax=upperExtreme,ymin=lowerExtreme),width=0.25,size=1.1) +
    geom_segment(aes(x=rows, y=lowerAvg, xend=rows, yend=upperAvg), size=3) +
    geom_point(aes(x=rows, y=medianAvg),shape = 21, colour = "black", fill = "white", size = 5, stroke = 1) +
    scale_x_continuous(breaks=1:10) +
    scale_y_continuous(breaks=-5:6) +
    xlab("Observers") + ylab("delta alpha") +
    theme_bw())
  return(posterior95Plot)
}

