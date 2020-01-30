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

    %for each observer
for( t = 1:length(pp) )

        %load individuals data
    inputDir = ['../data/selectionData/' expName num2str(expRun) pp{t} num2str(expVersion) '/']
    load([inputDir 'selectionData']);
    load(['../data/stimulusData/' pp{t} num2str(expVersion) '/propertyFile.mat']);
            
    targetIorLatencies      = [];
    targetNoIorLatencies    = [];
     
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
            
            if( u == 1 && v == 1)
                %display([[trialInf.trial]' [trialInf.radPositions]' [trialInf.trial]' [trialInf.cueTime]']);
            end

            latencies       = latencies(succesfulTrialList);
            selectedEls     = selectedEls(succesfulTrialList);

            latencies(selectedEls == TARGET)
            if conditionData.condition == CONDITION_IOR
                targetIorLatencies     = [targetIorLatencies; latencies(selectedEls == TARGET)];
            elseif conditionData.condition == CONDITION_NO_IOR
                targetNoIorLatencies     = [targetNoIorLatencies; latencies(selectedEls == TARGET)];
            end
        end
    end

    targetIorLatencies
    median(targetIorLatencies)
    targetIorObsLat(t)      = median(targetIorLatencies);
    targetNoIorObsLat(t)    = median(targetNoIorLatencies);
end

figure;
targetNoIorObsLat
bar([1,2], [mean(targetNoIorObsLat) mean(targetIorObsLat)]);
hold on;
errorbar([1 2], [mean(targetNoIorObsLat) mean(targetIorObsLat)],[std(targetNoIorObsLat)./sqrt(length(pp)-1) std(targetIorObsLat)./sqrt(length(pp)-1)],'.','Color',[0.3,0.3,0.3], 'LineWidth',2);
xlabel('Condition');
ylabel('Median Latency to Target');
title('Target Cued Condition');
set(gca,'XTick',[1 2],'XTickLabel',{'No Target IOR', 'Target IOR'},'FontSize',18);
axis([0 3 0 300]);


[h p ci stats] = ttest(targetNoIorObsLat, targetIorObsLat)

figure;
bar([targetNoIorObsLat' targetIorObsLat']);
ylabel('Median Latency to Target');
xlabel('Observers');
set(gca, 'FontSize', 16)
legend('Distractor Cued', 'Target Cued','Location','NorthEast', 'FontSize', 18);
axis([0 14 140 300]);

[mean(targetNoIorObsLat) mean(targetIorObsLat)]
mean(targetNoIorObsLat) - mean(targetIorObsLat)
