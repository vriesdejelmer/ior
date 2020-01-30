    %perform cleanup
clear all;
close all;

    %zet JV toolboxes in het path
toolboxFolder = [cd '../../toolboxJV']
addpath(genpath(toolboxFolder));


constantsSacExp_JV; %load constants

expName     = 'ISA';
iorColor    = [0.45 0.45 0.45];
noIorColor  = [0.75 0.75 0.75];

expRun      = 102;
expVersion  = 7;
pp          = {'ep' 'gs' 'js' 'jw' 'km' 'mh' 'mj' 'sm' 'ul' 'ke'};
name        = '102-7';

numbBins = 8;

shortCtoaFig    = figure; longCtoaFig     = figure; longestCtoaFig     = figure;

    %for each observer
for( t = 1:length(pp) )

        %load individual's data
    inputDir = ['../data/selectionData/' expName num2str(expRun) pp{t} num2str(expVersion) '/']
    load([inputDir 'selectionData']);
    load(['../data/stimulusData/' pp{t} num2str(expVersion) '/propertyFile.mat']);
            
        %get the dimensions of the data and go through conditions and subcondition
    [dimX dimY] = size(selectionData);
    for( v =1:dimY )
        for( u = 1:dimX )

                %get the data for this condition
            conditionData       = selectionData(u,v);
            trialInf            = conditionData.trialInf;      %get the corresponding trial inf files
            selectedEls         = [conditionData.selectedEl]'; 
            latencies           = conditionData.latencies; 
            succesfulTrialList  = conditionData.succesFullTrials;

            if( v == 1 && u == 1 )
                display([trialInf.radials]');
            end
            
                %filter based on trial that fullfill criteria
            latencies   = latencies(succesfulTrialList);
            selectedEls = selectedEls(succesfulTrialList);

                 %now divide based on condition        
            [latencyBins, targetProp, distractorProp] = makeBins(latencies,selectedEls',TARGET,DISTRACTOR,numbBins);

            if conditionData.condition == CONDITION_IOR && conditionData.subCondition == expProps.subConditions(1),
                    latencyBinsIORshort(t,:) = latencyBins; tarPropIORshort(t,:) = targetProp; distPropIORshort(t,:) = distractorProp;
                    latencyIORshort(t) = median(latencies); targetSelectionIORshort(t) = sum(selectedEls==TARGET);
            elseif conditionData.condition == CONDITION_IOR && conditionData.subCondition == expProps.subConditions(2),
                    latencyBinsIORlong(t,:) = latencyBins; tarPropIORlong(t,:) = targetProp; distPropIORlong(t,:) = distractorProp;
                    latencyIORlong(t) = median(latencies); targetSelectionIORlong(t) = sum(selectedEls==TARGET);
            elseif conditionData.condition == CONDITION_IOR && conditionData.subCondition == expProps.subConditions(3),
                    latencyBinsIORlongest(t,:) = latencyBins; tarPropIORlongest(t,:) = targetProp; distPropIORlongest(t,:) = distractorProp;
                    latencyIORlongest(t) = median(latencies); targetSelectionIORlongest(t) = sum(selectedEls==TARGET);
            elseif conditionData.condition == CONDITION_NO_IOR && conditionData.subCondition == expProps.subConditions(1),
                    latencyBinsNoIORshort(t,:) = latencyBins; tarPropNoIORshort(t,:) = targetProp; distPropNoIORshort(t,:) = distractorProp;
                    latencyNoIORshort(t) = median(latencies); targetSelectionNoIORshort(t) = sum(selectedEls==TARGET);
            elseif conditionData.condition == CONDITION_NO_IOR && conditionData.subCondition == expProps.subConditions(2),
                    latencyBinsNoIORlong(t,:) = latencyBins; tarPropNoIORlong(t,:) = targetProp; distPropNoIORlong(t,:) = distractorProp;
                    latencyNoIORlong(t) = median(latencies); targetSelectionNoIORlong(t) = sum(selectedEls==TARGET);
            elseif conditionData.condition == CONDITION_NO_IOR && conditionData.subCondition == expProps.subConditions(3),
                    latencyBinsNoIORlongest(t,:) = latencyBins; tarPropNoIORlongest(t,:) = targetProp; distPropNoIORlongest(t,:) = distractorProp;
                    latencyNoIORlongest(t) = median(latencies); targetSelectionNoIORlongest(t) = sum(selectedEls==TARGET);
            end

            if conditionData.subCondition == expProps.subConditions(1), figure(shortCtoaFig);
            elseif conditionData.subCondition == expProps.subConditions(2), figure(longCtoaFig); 
            elseif conditionData.subCondition == expProps.subConditions(3), figure(longestCtoaFig); end

                    %plot the observer in her/his individual subplot
            subplot(5,2,t);
            if conditionData.condition == CONDITION_IOR, lineStyle = '-.';
            elseif  conditionData.condition == CONDITION_NO_IOR, lineStyle = '-'; end

            plot(latencyBins, targetProp,['b' lineStyle 'o'],'LineWidth',2);
            hold on;
            plot(latencyBins, distractorProp,['r' lineStyle 'o'],'LineWidth',2);

            if u == 2,
                if conditionData.subCondition == expProps.subConditions(1), axis([min(latencyBinsNoIORshort(t,:))-10 max(latencyBinsIORshort(t,:))+10 0 1]);
                elseif conditionData.subCondition == expProps.subConditions(2), axis([min(latencyBinsNoIORlong(t,:))-10 max(latencyBinsIORlong(t,:))+10 0 1]);
                elseif conditionData.subCondition == expProps.subConditions(3), axis([min(latencyBinsNoIORlongest(t,:))-10 max(latencyBinsIORlongest(t,:))+10 0 1]);
                end
            end
            xlabel('Latency (ms)','FontSize',18);
            ylabel('Proportion to','FontSize',18);
   
        end
    end
end


selectionFig = figure('rend','painters','pos',[10 10 1000 400]);
    %plot the observer in her/his individual subplot

subplot(1,2,1);
xMin = 180; xMax = 370; 
plot([xMin xMax],[0.5 0.5],':','Color',[0.9 0.9 0.9],'LineWidth',2);
hold on;
errorbar(mean(latencyBinsNoIORshort), mean(tarPropNoIORshort),std(tarPropNoIORshort)/sqrt(length(pp)-1),'-s','Color',noIorColor,'LineWidth',3);
errorbar(mean(latencyBinsIORshort), mean(tarPropIORshort),std(tarPropIORshort)/sqrt(length(pp)-1),'-.d','Color',iorColor,'LineWidth',3);
% TO ADD DISTRACTOR SELECTION
% errorbar(mean(latencyBinsIORshort), mean(distPropIORshort),std(distPropIORshort)/sqrt(length(pp)-1),'b-.d','LineWidth',2);
% errorbar(mean(latencyBinsNoIORshort), mean(distPropNoIORshort),std(distPropNoIORshort)/sqrt(length(pp)-1),'b-s','LineWidth',2);
axis([xMin xMax 0.4 1]);
text(xMin-20,1.02,'A','FontSize',18,'FontWeight','bold');
set(gca,'FontSize',12);
ylabel('Accuracy','FontSize',18);
title('Short CTOA','FontSize',16);

subplot(1,2,2);
xMin = 160; xMax = 330; 
plot([xMin xMax],[0.5 0.5],':','Color',[0.9 0.9 0.9],'LineWidth',2);
hold on;
noIorHandle = errorbar(mean(latencyBinsNoIORlong), mean(tarPropNoIORlong),std(tarPropNoIORlong)/sqrt(length(pp)-1),'-s','Color',noIorColor,'LineWidth',3);
iorHandle = errorbar(mean(latencyBinsIORlong), mean(tarPropIORlong),std(tarPropIORlong)/sqrt(length(pp)-1),'-.d','Color',iorColor,'LineWidth',3);
set(gca,'FontSize',12);
axis([xMin xMax 0.4 1]);
text(xMin-20,1.02,'B','FontSize',18,'FontWeight','bold');
text(-1.1,87,'Latency (ms)','FontSize',18);       %title in an ugly way
title('Long CTOA','FontSize',16);
xlabel('Latency (ms)','FontSize',18);
legend([noIorHandle iorHandle],{'Irrelevant Cue Cond.','Relevant Cue Cond.'},'FontSize',18,'Location','SouthEast');

print(selectionFig, '-depsc','-r300','../outputs/manuscriptFigures/figure8.eps');


disp(['T-test, latency short: ' num2str(mean(latencyIORshort)-mean(latencyNoIORshort))]);
[h p ci stat]   = ttest(latencyIORshort,latencyNoIORshort)
cohenDshort     = abs(mean(latencyIORshort) - mean(latencyNoIORshort))/((std(latencyIORshort) + std(latencyNoIORshort))/2)
disp(['Cohen D ']);
disp(['T-test, latency long: ' num2str(mean(latencyIORlong)-mean(latencyNoIORlong))]);
[h p ci stat] = ttest(latencyIORlong,latencyNoIORlong)
cohenDLong     = abs(mean(latencyIORlong) - mean(latencyNoIORlong))/((std(latencyIORlong) + std(latencyNoIORlong))/2)

figure;
subplot(1,2,1);
bar([latencyNoIORshort' latencyIORshort']);
axis([0 11 100 350]);
ylabel('Median Latency (ms)','FontSize',18);
xlabel('Subject Number','FontSize',18);
subplot(1,2,2);
bar([latencyNoIORlong' latencyIORlong']);
xlabel('Subject Number','FontSize',18);
axis([0 11 100 350]);
legendH = legend('Irr. Cue Cond.','Rel. Cue Cond.');
set(legendH,'FontSize',18);

latFig = figure;
subplot(1,2,1);
bar(1,mean(latencyNoIORshort),'FaceColor',noIorColor);
hold on;
bar(2,mean(latencyIORshort),'FaceColor',iorColor);
errorbar([mean(latencyNoIORshort) mean(latencyIORshort)],[std(latencyNoIORlong)./sqrt(length(pp)-1) std(latencyIORlong)./sqrt(length(pp)-1)],'k.');
box off;
axis([0 3 100 300]);
set(gca,'XTick',[1 2],'XTickLabel',{'Irr. Cue','Rel. Cue'},'YTick',100:50:300,'FontSize',12);
ylabel('Average Median Latency (ms)','FontSize',18);
text(-0.65,310,'A','FontSize',18,'FontWeight','bold');
title('Short CTOA');
subplot(1,2,2);
bar(1,mean(latencyNoIORlong),'FaceColor',noIorColor);
hold on;
bar(2,mean(latencyIORlong),'FaceColor',iorColor);
errorbar([mean(latencyNoIORlong) mean(latencyIORlong)],[std(latencyNoIORlong)./sqrt(length(pp)-1) std(latencyIORlong)./sqrt(length(pp)-1)],'k.');
axis([0 3 100 300]);
box off;
title('Long CTOA');
set(gca,'XTick',[1 2],'XTickLabel',{'Irr. Cue','Rel. Cue'},'YTick',100:50:300,'FontSize',12);
text(-0.65,310,'B','FontSize',18,'FontWeight','bold');
text(-1.1,87,'Condition','FontSize',18);       %xlabel in an ugly way

rect = [.5, .78, 0.3, 0.11];
legendH = legend('Irrelevant Cue Cond.','Relevant Cue Cond.','Location','NorthEast');
set(legendH,'FontSize',14,'Position',rect);

print(latFig, '-depsc','-r300','../outputs/manuscriptFigures/figure7.eps');

% sigmoidFunc = @(x) 1./(1+exp(-x));
% lme = fitlme(tbl,sigmoidFunc)
