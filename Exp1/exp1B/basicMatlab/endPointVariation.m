    %perform cleanup
clear all;
close all;

    %zet JV toolboxes in het path
toolboxFolder = [cd '../../toolboxJV']
addpath(genpath(toolboxFolder));

constantsSacExp_JV; %load constants

    %experiment params
expName     = 'ISA';
expRun      = 102;
expVersion  = 7;
pp          = {'ep' 'gs' 'js' 'jw' 'km' 'mh' 'mj' 'sm' 'ul' 'ke'};

distanceFig = figure;        %initiate observer figure
endPointFig = figure;        %initiate observer figure

meanDeviation = []; medianDeviation = []; fifetyRange = []; sixetyEightRange = []; ninetyFiveRange = [];

    %for each observer
for( t = 1:length(pp) )
    
        %load individuals data
    inputDir = ['../data/selectionData/' expName num2str(expRun) pp{t} num2str(expVersion) '/']
    load([inputDir 'selectionData']);
    load(['../data/stimulusData/' pp{t} num2str(expVersion) '/propertyFile.mat']);
            
    pixPerDeg_JV;
    
    distanceList = [];
    distanceListA = [];
    
    %get the dimensions of the data and go through conditions and subcondition
    [dimX dimY] = size(selectionData);
    for( u =1:dimX )
        for( v =1:dimY )
            
                %get the data for this condition
            conditionData       = selectionData(u,v);
            trialInf            = conditionData.trialInf;      %get the corresponding trial inf files
            selectedEls         = conditionData.selectedEl;
            xEndPoints          = conditionData.xEndPoints; 
            yEndPoints          = conditionData.yEndPoints; 
            succesfulTrialList  = conditionData.succesFullTrials;

                %filter based on trial that fullfill criteria
            angularDeviation = conditionData.distanceToEl/pixPerDeg;
            distanceListA = [distanceListA; angularDeviation];
            
            figure(endPointFig);
            subplot(5,2,t);
            plot(xEndPoints, yEndPoints, '+');
            hold on;
            
        end
    end

    figure(distanceFig);
    subplot(5,2,t);
    hist(distanceListA, [0:0.25:5]);
    axis([0 5 0 140]);
    [freq bins] = hist(distanceListA, [0:0.01:5]);
    cumList = cumsum(freq/sum(freq));
    indices50 = find(cumList > .5);
    indices68 = find(cumList > .68);
    indices95 = find(cumList > .95);
    fivetyRange(t) = bins(min(indices50)); 
    sixetyEightRange(t) = bins(min(indices68)); 
    ninetyFiveRange(t) = bins(min(indices95)); 
    meanDeviation(t) = mean(distanceListA);
    medianDeviation(t) = median(distanceListA);
    hold on;
    plot([ninetyFiveRange(t) ninetyFiveRange(t)], [0 140], 'r-.', 'LineWidth', 2);
        if t == 10,
        xlabel('Landing point distance (degrees)', 'FontSize', 18)
    elseif t == 5,
        ylabel('Saccade count', 'FontSize', 18)
    end
    
end

mean(fivetyRange)
mean(sixetyEightRange)
mean(ninetyFiveRange)
mean(meanDeviation)
mean(medianDeviation)
print(distanceFig, '-depsc','-r300','../outputs/generalFigures/distanceHistExp1B.eps');