
simulateObservers <- function(count=10,...) {
  columnNames <- c("subject", "condition", "latency", "response", "alpha", "beta", "delta_alpha")
  observerSet_VTD <- data.frame(matrix(vector(), 0, length(columnNames),
                                     dimnames=list(c(), columnNames)),
                              stringsAsFactors=F)
  observerSet_SR <- data.frame(matrix(vector(), 0, length(columnNames),
                                  dimnames=list(c(), columnNames)),
                           stringsAsFactors=F)
  observerSet_MIX <- data.frame(matrix(vector(), 0, length(columnNames),
                                dimnames=list(c(), columnNames)),
                               stringsAsFactors=F)
  for( obsI in 1:count ) {
    observerData <- simulateObserverData()
    observerFrame_VTD <- createDataFrame(obsI, observerData$lat1, observerData$lat2, observerData$resp1_VTD, observerData$resp2_VTD, observerData$alpha, observerData$beta, observerData$delta_alpha_VTD)
    observerFrame_SR <- createDataFrame(obsI, observerData$lat1, observerData$lat2, observerData$resp1_SR, observerData$resp2_SR, observerData$alpha, observerData$beta, observerData$delta_alpha_SR)
    observerFrame_MIX <- createDataFrame(obsI, observerData$lat1, observerData$lat2, observerData$resp1_MIX, observerData$resp2_MIX, observerData$alpha, observerData$beta, observerData$delta_alpha_MIX)
    observerSet_VTD <- rbind(observerSet_VTD, observerFrame_VTD)
    observerSet_SR <- rbind(observerSet_SR, observerFrame_SR)
    observerSet_MIX <- rbind(observerSet_MIX, observerFrame_MIX)
  }
  return(list(vtd=observerSet_VTD, sr=observerSet_SR, mix=observerSet_MIX))
}

createDataFrame <- function(obsNum, lat1, lat2, resp1, resp2, alpha, beta, delta_alpha) {
  observerFrame <- data.frame(
    subject=rep(obsNum, each=length(resp1) + length(resp2)),
    condition=c(rep(22, each=length(resp1)), rep(24, each=length(resp2))),
    latency=c(lat1, lat2),
    response=c(resp1, resp2),
    alpha=rep(alpha, each=length(resp1) + length(resp2)),
    beta=rep(beta, each=length(resp1) + length(resp2)),
    delta_alpha=rep(delta_alpha, each=length(resp1) + length(resp2)))
  return(observerFrame)
}

simulateObserverData <- function(trialsPC=200,medLat=230,medIOR=25) {
  
  fastMean <- medLat + rnorm(1,0,20)
  slowMean <- fastMean + medIOR + rnorm(1,0,3)
  devProp <- 0.05
  meanSlope <- 0.03
  
  dist1 <- rlnorm(trialsPC,log(fastMean),0.3)
  dist2 <- rlnorm(trialsPC,log(slowMean),0.3)
  
  median1 <- median(dist1)
  median2 <- median(dist2)
  latOffset <- median2 - median1
  
  beta <- rbeta(1,2,2)/10
  alpha <- rnorm(1,median1,median1*devProp)*beta
  delta_alpha <- latOffset*beta 
  variation <- rnorm(1,0,0.1);
  print("The important")
  print(beta)
  print(alpha)
  print(delta_alpha)
  
  logistic <- function(x, beta, alpha, delta_alpha) 1/(1+exp(-(beta*x-alpha+delta_alpha/2)))
  
  resp1_VTD <- c(1:length(dist1))
  resp2_VTD <- c(1:length(dist2))
  resp1_SR <- c(1:length(dist1))
  resp2_SR <- c(1:length(dist2))
  resp1_MIX <- c(1:length(dist1))
  resp2_MIX <- c(1:length(dist2))
  
  for (i in 1:length(dist1)) {
    resp1_VTD[i] <- (logistic(dist1[i], beta, alpha, delta_alpha) > runif(1))
    resp2_VTD[i] <- (logistic(dist2[i], beta, alpha, -delta_alpha) > runif(1))
    resp1_MIX[i] <- (logistic(dist1[i], beta, alpha, delta_alpha/2) > runif(1))
    resp2_MIX[i] <- (logistic(dist2[i], beta, alpha, -delta_alpha/2) > runif(1))
    resp1_SR[i] <- (logistic(dist1[i], beta, alpha, variation) > runif(1))
    resp2_SR[i] <- (logistic(dist2[i], beta, alpha, variation) > runif(1))
  }  
  return(list(lat1=dist1,lat2=dist2,resp1_VTD=resp1_VTD,resp2_VTD=resp2_VTD,resp1_SR=resp1_SR,resp2_SR=resp2_SR,resp1_MIX=resp1_MIX,resp2_MIX=resp2_MIX, alpha=alpha, beta=beta, delta_alpha_MIX=delta_alpha/2, delta_alpha_SR=0, delta_alpha_VTD=delta_alpha))
}
