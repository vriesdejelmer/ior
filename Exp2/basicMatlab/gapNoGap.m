    %perform cleanup
clear all;
close all;

toolboxFolder = [cd '/../../../../toolboxJV'];
addpath(genpath(toolboxFolder));

constantsSacExp_JV; %load constants

%    experiment params
expRun      = 101;
expName     = 'RDI';
pp          = {'me' 'mt' 'ke' 'st' 'se' 'za' 'rw' 'sj' 'yt' 'ep' 'ml' 'cj' 'kr'};
expVersion  = 9;

iorColor    = [0.45 0.45 0.45];
noIorColor  = [0.7 0.7 0.7];

CONDITION_GAP       = 941;
CONDITION_OVERLAP   = 942;

    %for each observer
for( t = 1:length(pp) )
    
        %load individuals data
    inputDir = ['../data/selectionData/' expName num2str(expRun) pp{t} num2str(expVersion) '/']
    load([inputDir 'selectionData']);
    load(['../data/stimulusData/' pp{t} num2str(expVersion) '/propertyFile.mat']);
            
    gapLatencies        = []; gapSelection = [];
    overlapLatencies    = []; overlapSelection = [];
     
            %get the dimensions of the data and go through conditions and subcondition
    [dimX dimY] = size(selectionData);
    for( u =1:dimX )
        for( v =1:dimY )
                %get the data for this condition
            conditionData       = selectionData(u,v);
            trialInf            = conditionData.trialInf;      %get the corresponding trial inf files
            selectedEls         = [conditionData.selectedEl]; 
            latencies           = conditionData.latencies; 
            succesfulTrialList  = conditionData.succesFullTrials;

                %calculate the angles between the elements on the screen
            latencies       = latencies(succesfulTrialList);
            selectedEls     = selectedEls(succesfulTrialList);
            
            if conditionData.subCondition == CONDITION_GAP
                gapLatencies    = [gapLatencies; latencies];
                gapSelection    = [gapSelection; selectedEls];
            elseif conditionData.subCondition == CONDITION_OVERLAP
                overlapLatencies    = [overlapLatencies; latencies];
                overlapSelection    = [overlapSelection; selectedEls];
            end
        end
    end
    
    gapLatObs(t)        = median(gapLatencies);
    overlapLatObs(t)    = median(overlapLatencies);

    gapSelObs(t)        = sum(gapSelection == TARGET)/length(gapSelection);
    overlapSelObs(t)    = sum(overlapSelection == TARGET)/length(overlapSelection);
end

figure;
subplot(1,2,1);
bar([1,2], [mean(gapLatObs) mean(overlapLatObs)]);
hold on;
errorbar([1 2], [mean(gapLatObs) mean(overlapLatObs)],[std(gapLatObs)./sqrt(length(pp)-1) std(overlapLatObs)./sqrt(length(pp)-1)],'.','Color',[0.3,0.3,0.3], 'LineWidth',2);
xlabel('Fixation Offset Condition');
ylabel('Median Latency (ms)');
title('Latencies');
set(gca,'XTick',[1 2],'XTickLabel',{'Gap', 'Overlap'},'FontSize',18);
axis([0 3 0 300]);
subplot(1,2,2);
bar([1,2], [mean(gapSelObs) mean(overlapSelObs)]);
hold on;
errorbar([1 2], [mean(gapSelObs) mean(overlapSelObs)],[std(gapSelObs)./sqrt(length(pp)-1) std(overlapSelObs)./sqrt(length(pp)-1)],'.','Color',[0.3,0.3,0.3], 'LineWidth',2);
xlabel('Fixation Offset Condition');
ylabel('Accuracy');
title('Accuracy');
set(gca,'XTick',[1 2],'XTickLabel',{'Gap', 'Overlap'},'FontSize',18);
axis([0 3 0 1]);

[mean(gapLatObs) mean(overlapLatObs) mean(gapLatObs)-mean(overlapLatObs)]
[gapLatObs' overlapLatObs']
[h p ci stats] = ttest(gapLatObs, overlapLatObs)

[mean(gapSelObs) mean(overlapSelObs) mean(gapSelObs)-mean(overlapSelObs)]
[gapSelObs' overlapSelObs']
[h p ci stats] = ttest(gapSelObs, overlapSelObs)
