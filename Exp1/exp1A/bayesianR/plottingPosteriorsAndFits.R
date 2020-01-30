#clear workspace:
rm(list=ls()) 

#set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#init constants coding (copied from matlab files)
CONDITION_REL <- 24;
CONDITION_IRR <- 22;

library(ggplot2)
library(grid)
library(gridExtra)

source("../../rFunctions/DataProcessingExp1.R")
source("../../rFunctions/PlottingPosteriorsExp1.R")
source("../../rFunctions/JagsModelFunctionsExp1.R")

expData <- read.table( "../data/dataForR.dat", as.is=TRUE)
names(expData) <- c('subject','condition','latency','response')
expData <- recodeResponses(expData)

load('../outputs/data/jagsOutput1A.rData')

subjSumm <- getSubjectLatData(expData)
performanceFrame <- caclulateMeanCenteredPerformanceFrame(expData, 10)
posteriorPlot <- plotPosteriors(jagsRawData, expData)
fittingPlot <- plotFits(jagsRawData, performanceFrame, subjSumm$subjectMeans)

plot1 <- arrangeGrob(posteriorPlot, top = textGrob("A", x = unit(0.05, "npc") , y   = unit(0.95, "npc"), just=c("left","top"), gp=gpar(col="black", fontsize=18)))
plot2 <- arrangeGrob(fittingPlot, top = textGrob("B", x = unit(0.05, "npc") , y   = unit(0.95, "npc"), just=c("left","top"), gp=gpar(col="black", fontsize=18)))

grid.arrange(plot1,plot2,ncol=2)

figFileName <- "../outputs/manuscriptFigures/figure6.pdf"
ggsave(figFileName,arrangeGrob(plot1, plot2, ncol=2),width=15,height=5)

print(bayesFactors)