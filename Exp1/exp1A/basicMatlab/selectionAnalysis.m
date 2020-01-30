    %perform cleanup
clear all;
close all;

    %zet JV toolboxes in het path
toolboxFolder = [cd '../../toolboxJV']
addpath(genpath(toolboxFolder));

constantsSacExp_JV; %load constants

    %experiment params
expRun      = 101;
expName     = 'ISA';
pp          = {'ac' 'hr' 'jl' 'lb' 'mm' 'nw' 'pf' 'tb' 'tc' 'yo' };
expVersion  = 2;

    %bins for overall and individual
numbBinsInd = 6;
numbBins    = 10;   

observerFigure = figure;        %initiate observer figure

iorColor = [0.45 0.45 0.45];
noIorColor = [0.75 0.75 0.75];


    %for each observer
for( t = 1:length(pp) )

        %load individuals data
    inputDir = ['../data/selectionData/' expName num2str(expRun) pp{t} num2str(expVersion) '/']
    load([inputDir 'selectionData']);
    load(['../data/stimulusData/' pp{t} num2str(expVersion) '/propertyFile.mat']);
            
    %get the dimensions of the data and go through conditions and subcondition
    [dimX dimY] = size(selectionData);
    for( u =1:dimX )
        for( v =1:dimY )
            
                %get the data for this condition
            conditionData       = selectionData(u,v);
            trialInf            = conditionData.trialInf;      %get the corresponding trial inf files
            selectedEls         = conditionData.selectedEl; 
            latencies           = conditionData.latencies; 
            succesfulTrialList  = conditionData.succesFullTrials;

                %filter based on trial that fullfill criteria
            latencies   = latencies(succesfulTrialList);
            selectedEls = selectedEls(succesfulTrialList);
            
                %sort based on latencies
            sortedLatElList     = sortrows([latencies selectedEls]);
            sortedLatencies     = sortedLatElList(:,1);
            sortedSelectedEl    = sortedLatElList(:,2);
            
                %now calculate binned proportions
            binSize = floor(length(sortedLatencies)/numbBins);
            for( r = 1:numbBins )
                beginIndex  = 1+(r-1)*binSize;
                endIndex    = r*binSize;
                
                    %calculate bin properties
                latencyLists(r)     = median(sortedLatencies(beginIndex:endIndex));
                targetPropList(r)   = sum(sortedSelectedEl(beginIndex:endIndex) == TARGET)/binSize;
                distPropList(r)     = sum(sortedSelectedEl(beginIndex:endIndex) == DISTRACTOR)/binSize;
                
            end
            
                %now divide based on condition
            if( conditionData.condition == CONDITION_DOUBLE_IOR )
                latencyBinsIOR(t,:)     = latencyLists;
                tarPropIOR(t,:)         = targetPropList;
                distPropIOR(t,:)        = distPropList;
            elseif( conditionData.condition == CONDITION_NO_IOR )
                latencyBinsNoIOR(t,:)   = latencyLists;
                tarPropNoIOR(t,:)       = targetPropList;
                distPropNoIOR(t,:)      = distPropList;
            end
            
                           %now calculate binned proportions
            binSizeInd = floor(length(sortedLatencies)/numbBinsInd);
            for( r = 1:numbBinsInd )
                beginIndex  = 1+(r-1)*binSizeInd;
                endIndex    = r*binSizeInd;
                
                    %calculate bin properties
                latencyListsInd(r)     = median(sortedLatencies(beginIndex:endIndex));
                targetPropListInd(r)   = sum(sortedSelectedEl(beginIndex:endIndex) == TARGET)/binSizeInd;
                distPropListInd(r)     = sum(sortedSelectedEl(beginIndex:endIndex) == DISTRACTOR)/binSizeInd;
                
            end
                            %now divide based on condition
            if( conditionData.condition == CONDITION_DOUBLE_IOR )
                latencyBinsIORInd(t,:)     = latencyListsInd;
                tarPropIORInd(t,:)         = targetPropListInd;
                distPropIORInd(t,:)        = distPropListInd;
            elseif( conditionData.condition == CONDITION_NO_IOR )
                latencyBinsNoIORInd(t,:)   = latencyListsInd;
                tarPropNoIORInd(t,:)       = targetPropListInd;
                distPropNoIORInd(t,:)      = distPropListInd;
            end
            
        end
    end
        
    figure(observerFigure);
    subplot(5,2,t);
    plot(latencyBinsIORInd(t,:), tarPropIORInd(t,:),'r-o');
    hold on;
    plot(latencyBinsNoIORInd(t,:), tarPropNoIORInd(t,:),'r-.d');
    maxX = max(max(latencyBinsIORInd(t,:)), max(latencyBinsNoIORInd(t,:))) + 10;
    minX = min(min(latencyBinsIORInd(t,:)), min(latencyBinsNoIORInd(t,:))) - 10;
    minY = min(min(tarPropIORInd(t,:)), min(tarPropNoIORInd(t,:))) - 0.1;
    axis([minX maxX minY 1]);
end

    %calculate averages for overall figure
latBinIORAll    = mean(latencyBinsIOR);
latBinNoIORAll  = mean(latencyBinsNoIOR);

tarPropIORAll   = mean(tarPropIOR);
tarPropNoIORAll = mean(tarPropNoIOR);
tarSEIORAll   = std(tarPropIOR)./sqrt(length(pp)-1);
tarSENoIORAll = std(tarPropNoIOR)./sqrt(length(pp)-1);

distPropIORAll  = mean(distPropIOR);
distPropNoIORAll = mean(distPropNoIOR);
distSEIORAll  = std(distPropIOR)./sqrt(length(pp)-1);
distSENoIORAll = std(distPropNoIOR)./sqrt(length(pp)-1);

selectionFig = figure;
xMin = 130;
xMax = 300;
plot([xMin xMax],[0.5 0.5],'-.','Color',[0.9 0.9 0.9],'LineWidth',2);
hold on;
handleNoIOR = errorbar(latBinNoIORAll,tarPropNoIORAll,tarSENoIORAll,'-','Color',noIorColor,'LineWidth',3);
handleIOR = errorbar(latBinIORAll,tarPropIORAll,tarSEIORAll,'-.','Color',iorColor,'LineWidth',3);
set(gca,'FontSize',14);
box off;
xlabel('Median Latency (ms)','FontSize',18);
ylabel('Accuracy','FontSize',18);
legendH = legend([handleNoIOR handleIOR],{'Irrelevant Cue Cond.','Relevant Cue Cond.'},'Location','SouthEast');
set(legendH, 'FontSize',18);
axis([xMin xMax 0.35 1.03]);

print(selectionFig, '-depsc','-r300','../outputs/manuscriptFigures/figure5.eps');
