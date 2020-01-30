##########################
#### Extract latency measures for subjects
getSubjectLatData <- function(expData) {
  subjects <- unique(expData$subject)
  nSubj <- length(subjects)
  subjectMeans <- rep(0, nSubj)
  for(k in subjects ){
    subjectMeans[k] <- mean(expData$latency[expData$subject==subjects[k]])
  }
  return(list(nSubj=nSubj, subjects=subjects, subjectMeans=subjectMeans))
}

##########################
#### Mean center latencies in the frame
meanCenterLatencies <- function(expData, subjSumm) {
  for( k in subjSumm$subjects ) {
    expData$latency[expData$subject==k] <- expData$latency[expData$subject==k] - subjSumm$subjectMeans[k]
  }
  return(expData)
}

##########################
#### Add bins of a condition to the frame
addBinsToFrame <- function(performanceFrame, latencyMatrix, performanceMatrix, subjSumm, condition) {
  
  latBins   <- apply(latencyMatrix, 1, mean)
  perfBins  <- apply(performanceMatrix, 1, mean)
  seBins    <- apply(performanceMatrix, 1, sd)/sqrt(subjSumm$nSubj-1)
  
  if( condition == CONDITION_REL ) {
    conditionCode = 2;
  } else if( condition == CONDITION_IRR ) {
    conditionCode = 1;
  }
  print(conditionCode)
  
  conditionFrame <- data.frame(latBins=latBins, perfBins=perfBins, coding=as.factor(rep(conditionCode, length(latBins))))

  return(rbind(performanceFrame, conditionFrame))
}

##########################
#### Caclulate the bins for a condition
calculateForCondition <- function(expData, subjSumm, cond, numbBins) {
  latencyMatrix   <- matrix(nrow = numbBins, ncol = subjSumm$nSubj)
  performance     <- matrix(nrow = numbBins, ncol = subjSumm$nSubj)
  
  for( obsNum in subjSumm$subjects ) {
    obsSubset <- expData[expData$subject == obsNum & expData$condition==cond,]
    orderList <- order(obsSubset$latency)
    latList   <- obsSubset$latency[orderList]
    perform   <- obsSubset$response[orderList] == 1
    
    binSize  <- floor(length(latList)/numbBins)
    for( bin in 1:numbBins ){
      binStart  <- ((bin-1)*binSize+1)
      binEnd    <- (bin*binSize)
      latencyMatrix[bin, obsNum]  <- median(latList[binStart:binEnd])
      performance[bin, obsNum]    <- mean(perform[binStart:binEnd])
    }
  }
  return(list(latencyMatrix=latencyMatrix, performance=performance))
}

##########################
#### Caclulate the performance frame
caclulateMeanCenteredPerformanceFrame <- function(expData, numbBins) {
  
  subjSumm <- getSubjectLatData(expData)
  expData <- meanCenterLatencies(expData, subjSumm)
  
  performanceFrame <- data.frame(latBins=double(), perfBins = double(), coding=factor())
    
  #for each condition
  conds <- c(CONDITION_IRR, CONDITION_REL)
  for( cond in conds) {
    listBins <- calculateForCondition(expData, subjSumm, cond, numbBins)
    performanceFrame <- addBinsToFrame(performanceFrame, listBins$latencyMatrix, listBins$performance, subjSumm, cond)
  }
  
  return(performanceFrame)
}

##########################
#### Prepare data for Jags
prepareData <- function(expData) {
  
  subjSumm <- getSubjectLatData(expData)
  
  #initialize list for trials per observer and condition
  nTrialsRel  <- rep(0, subjSumm$nSubj)
  nTrialsIrr  <- rep(0, subjSumm$nSubj)

  #fill with number of trials
  for(k in 1:subjSumm$nSubj){
    nTrialsRel[k] <- with(expData, sum( subject==subjSumm$subjects[k] & condition == CONDITION_REL ))
    nTrialsIrr[k] <- with(expData, sum( subject==subjSumm$subjects[k] & condition == CONDITION_IRR ))
  }
  
  latRespList <- createLatAndRespLists(expData, nTrialsRel, nTrialsIrr, subjSumm)
  latRespList$nSubj <- subjSumm$nSubj
  latRespList$subjectMeans <- subjSumm$subjectMeans
  return(latRespList)
}

##########################
#### Create latency and response lists
createLatAndRespLists <- function(expData, nTrialsRel, nTrialsIrr, subjSumm) {
  #get the maximum number of trials per condition/observer
  nMaxRel = max( nTrialsRel )
  nMaxIrr = max( nTrialsIrr )
  
  #create data array for JAGS
  latRel  <- array(dim=c(subjSumm$nSubj, nMaxRel))
  respRel <- array(dim=c(subjSumm$nSubj, nMaxRel))
  latIrr  <- array(dim=c(subjSumm$nSubj, nMaxIrr))
  respIrr <- array(dim=c(subjSumm$nSubj, nMaxIrr))
  for(k in 1:subjSumm$nSubj) {
    latRel[k, 1:nTrialsRel[k] ] <- with(expData, latency[condition == CONDITION_REL & subject == subjSumm$subjects[k]])
    respRel[k, 1:nTrialsRel[k] ] <- with(expData, response[condition == CONDITION_REL & subject == subjSumm$subjects[k]])
    
    latIrr[k, 1:nTrialsIrr[k] ] <- with(expData, latency[condition == CONDITION_IRR & subject == subjSumm$subjects[k]])
    respIrr[k, 1:nTrialsIrr[k] ] <- with(expData, response[condition == CONDITION_IRR & subject == subjSumm$subjects[k]])
  }
  return(list(latRel=latRel, latIrr=latIrr, respRel=respRel, respIrr=respIrr, nTrialsRel=nTrialsRel, nTrialsIrr=nTrialsIrr))
}


# binning <- function(expData, numbBins=10) {
#   
#   subjSumm <- getSubjectLatData(expData)
#   for( k in 1:nSubj ) {
#     expData$latency[expData$subject==k] <- expData$latency[expData$subject==k] - subjSumm$subjectMeans[k]
#   } 
# 
#   #for both conditions
#   conds <- c(CONDITION_IRR, CONDITION_REL)
#   for( cond in conds) {
#     
#     latencyMatrix   <- matrix(nrow = numbBins, ncol = nSubj)
#     performance     <- matrix(nrow = numbBins, ncol = nSubj)
#     
#     for( obsNum in as.double(unique(expData$subject)) ) {
#       obsSubset <- expData[expData$subject == obsNum & expData$condition==cond,]
#       orderList <- order(obsSubset$latency)
#       latList   <- obsSubset$latency[orderList]
#       perform   <- obsSubset$response[orderList] == 1
#       
#       binSize  <- floor(length(latList)/numbBins)
#       for( bin in 1:numbBins ){
#         binStart  <- ((bin-1)*binSize+1)
#         binEnd    <- (bin*binSize)
#         latencyMatrix[bin,obsNum]   <- median(latList[binStart:binEnd])
#         performance[bin,obsNum]  <- mean(perform[binStart:binEnd])
#       }
#     }
#     
#     if( cond == CONDITION_REL ) {
#       latBinsRel   <- apply(latencyMatrix, 1, mean)
#       perfBinsRel  <- apply(performance, 1, mean)
#       seBinsRel   <- apply(performance, 1, sd)/sqrt(nSubj-1)
#       
#       indLatBinsRel   <- latencyMatrix
#       indPerfBinsRel  <- performance
#     } else if( cond == CONDITION_IRR ) {
#       latBinsIrr   <- apply(latencyMatrix, 1, mean)
#       perfBinsIrr  <- apply(performance, 1, mean)
#       seBinsIrr   <- apply(performance, 1, sd)/sqrt(nSubj-1)
#       
#       indLatBinsIrr   <- latencyMatrix
#       indPerfBinsIrr  <- performance
#     }
#   }
#   
#   performanceFrame <- data.frame(latBins=c(latBinsIrr, latBinsRel),perfBins=c(perfBinsIrr, perfBinsRel),coding=as.factor(c(rep(1,length(latBinsRel)), rep(2,length(latBinsRel)))))
#   return(performanceFrame)
# }
