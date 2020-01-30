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
    
    diagonalIOR         = []; diagonalNoIOR = []; diagonalLatencies = [];
    adjacentIOR         = []; adjacentNoIOR = []; adjacentLatencies = [];
     
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
           
                %calculate the angles between the elements on the screen
            positions       = [trialInf.radPositions];
            elementAngles   = abs(positions(2,:) - positions(1,:));
            elementAngles   = round(elementAngles/pi*2);
            
            
            elementAngles   = elementAngles(succesfulTrialList)';
            diagonalSelec   = elementAngles == 2;
            adjacentSelec   = elementAngles == 1 | elementAngles == 3;
            
            latencies       = latencies(succesfulTrialList);
            selectedEls     = selectedEls(succesfulTrialList);
            
            if conditionData.condition == CONDITION_IOR
                diagonalIOR     = [diagonalIOR; selectedEls(diagonalSelec)];
                adjacentIOR     = [adjacentIOR; selectedEls(adjacentSelec)];
            elseif conditionData.condition == CONDITION_NO_IOR
                diagonalNoIOR   = [diagonalNoIOR; selectedEls(diagonalSelec)];
                adjacentNoIOR   = [adjacentNoIOR; selectedEls(adjacentSelec)];
            end
            diagonalLatencies   = [diagonalLatencies; latencies(diagonalSelec)];
            adjacentLatencies   = [adjacentLatencies; latencies(adjacentSelec)];
        end
    end
    
    diagIorTarProp(t)   = sum(diagonalIOR == TARGET)/length(diagonalIOR);
    adjIorTarProp(t)    = sum(adjacentIOR == TARGET)/length(adjacentIOR);
    
    diagNoIorTarProp(t)   = sum(diagonalNoIOR == TARGET)/length(diagonalNoIOR);
    adjNoIorTarProp(t)    = sum(adjacentNoIOR == TARGET)/length(adjacentNoIOR);
    
    diagLatencies(t)   = median(diagonalLatencies);
    adjLatencies(t)    = median(adjacentLatencies);
end

figure;
subplot(1,3,2);
bar([1,2], [mean(diagIorTarProp) mean(adjIorTarProp)]);
hold on;
errorbar([1 2], [mean(diagIorTarProp) mean(adjIorTarProp)],[std(diagIorTarProp)./sqrt(length(pp)-1) std(adjIorTarProp)./sqrt(length(pp)-1)],'.','Color',[0.3,0.3,0.3], 'LineWidth',2);
xlabel('Relative Target-Distractor Position');
ylabel('Proportion to Target');
title('Target Cued Condition');
set(gca,'XTick',[1 2],'XTickLabel',{'Diagonal', 'Adjacent'},'FontSize',18);
axis([0 3 0 1]);

subplot(1,3,3);

bar([1,2], [mean(diagNoIorTarProp) mean(adjNoIorTarProp)]);
hold on;
errorbar([1 2], [mean(diagNoIorTarProp) mean(adjNoIorTarProp)],[std(diagNoIorTarProp)./sqrt(length(pp)-1) std(adjNoIorTarProp)./sqrt(length(pp)-1)],'.','Color',[0.3,0.3,0.3], 'LineWidth',2);
ylabel('Proportion to Target');
title('Distractor Cued Condition');
set(gca,'XTick',[1 2],'XTickLabel',{'Diagonal', 'Adjacent'},'FontSize',18);

axis([0 3 0 1]);

subplot(1,3,1);
bar([1,2], [mean(diagLatencies) mean(adjLatencies)]);
hold on;
errorbar([1 2], [mean(diagLatencies) mean(adjLatencies)],[std(diagLatencies)./sqrt(length(pp)-1) std(adjLatencies)./sqrt(length(pp)-1)],'.','Color',[0.3,0.3,0.3], 'LineWidth',2);
axis([0 3 0 300]);
ylabel('Average Median Latency');
title('All Trials Combined');
set(gca,'XTick',[1 2],'XTickLabel',{'Diagonal', 'Adjacent'},'FontSize',18);

disp('Latency comparison (left-most plot)')
[mean(diagLatencies) mean(adjLatencies) mean(diagLatencies)-mean(adjLatencies)]
[h p ci stat] = ttest(diagLatencies, adjLatencies)

disp('Accuracy comparison target-cued (middle plot)')
[mean(diagIorTarProp) mean(adjIorTarProp) mean(diagIorTarProp)-mean(adjIorTarProp)]
[h p ci stat] = ttest(diagIorTarProp, adjIorTarProp)

disp('Accuracy comparison distractor-cued (right-most plot)')
[mean(diagNoIorTarProp) mean(adjNoIorTarProp) mean(diagNoIorTarProp)-mean(adjNoIorTarProp)]
[h p ci stat] = ttest(diagNoIorTarProp, adjNoIorTarProp)

