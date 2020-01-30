clear all;
close all;

constantsSacExp_JV;

plotOn = true;

expVersion = 2;
expName = 'ISA';
expRun = 101;
pp = {'ac' 'hr' 'jl' 'lb' 'mm' 'nw' 'pf' 'tb' 'tc' 'yo'};
filterData  = true;     %only inserted for comparison on reviewer request

iorColor = [0.45 0.45 0.45];
noIorColor = [0.75 0.75 0.75];

latenciesIOR = []; latenciesNoIOR = [];

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
            conditionData   = selectionData(u,v);
            trialInf        = conditionData.trialInf;      %get the corresponding trial inf files
            latencies       = conditionData.latencies; 
            opposite        = conditionData.opposite;
            
                %filter trials
            if filterData
                selectionList   = conditionData.succesFullTrials;
                latencies       = latencies(selectionList);
                opposite        = opposite(selectionList);
            end
            
                %get latencies for adjacent and opposite
            oppositeLatencies   = latencies(opposite == 1);
            adjacentLatencies   = latencies(opposite == 0);
            
                %checken dat opposite classificatie werkt
            if( sum(opposite == -1) > 0 )
                disp(['Warning: ' num2str(sum(opposite == -1))]);
                disp(['Warning: ' num2str(sum(opposite ~= -1))]);
                pause;
            end
                %get latencies for both conditions seperately
            if( conditionData.condition == CONDITION_DOUBLE_IOR )
                IORLatencies(t) = median(latencies);
                IORLatenciesOpp(t) = median(oppositeLatencies);
                IORLatenciesAdj(t) = median(adjacentLatencies);
                latenciesIOR = [latenciesIOR; latencies];
            else
                noIORLatencies(t) = median(latencies);
                noIORLatenciesOpp(t) = median(oppositeLatencies);
                noIORLatenciesAdj(t) = median(adjacentLatencies);
                latenciesNoIOR = [latenciesNoIOR; latencies];
            end
            
        end
    end
    
end

   %plot the final histogram of collapsed data
latFig = figure;
subplot(1,2,1);
bar(1,mean(noIORLatencies),'FaceColor',noIorColor);
hold on;
bar(2,mean(IORLatencies),'FaceColor',iorColor);
errorbar([mean(noIORLatencies) mean(IORLatencies)], [std(noIORLatencies)./sqrt(length(pp)-1) std(IORLatencies)./sqrt(length(pp)-1)],'k.' );
axis([0 3 100 265]);
title('Overall Latencies');
text(-0.55,268,'A','FontSize',18,'FontWeight','bold');
set(gca, 'XTick',[1 2],'XTickLabel',{'Irr. Cue','Rel. Cue'},'yTick',[100 150 200 250],'FontSize',14);
ylabel('Averaged Median Latencies (ms)','FontSize',18);
box off;
subplot(1,2,2);
bar(1,mean(noIORLatenciesOpp),'FaceColor',noIorColor);
hold on;
bar(2,mean(IORLatenciesOpp),'FaceColor',iorColor);
errorbar([mean(noIORLatenciesOpp) mean(IORLatenciesOpp)], [std(noIORLatenciesOpp)./sqrt(length(pp)-1) std(IORLatenciesOpp)./sqrt(length(pp)-1)],'k.' );
axis([0 3 100 265]);

set(gca, 'XTick',[1 2],'XTickLabel',{'Irr. Cue','Rel. Cue'},'yTick',[100 150 200 250],'FontSize',14);

title('Opposite Trials');
text(-0.55,268,'B','FontSize',18,'FontWeight','bold');
text(-1.1,87,'Condition','FontSize',18);       %title in an ugly way
box off;
rect = [.37, .75, 0.3, 0.11];
legendH = legend('Irrelevant Cue Cond.','Relevant Cue Cond.');
set(legendH,'FontSize',14,'Position',rect);

print(latFig, '-depsc','-r300','figure4.eps');

    %plot the final histogram of collapsed data
obsLatFig = figure;

subplot(1,4,1);
bar(1,mean(noIORLatencies),'FaceColor',noIorColor);
hold on;
bar(2,mean(IORLatencies),'FaceColor',iorColor);
errorbar([mean(noIORLatencies) mean(IORLatencies)], [std(noIORLatencies)./sqrt(length(pp)-1) std(IORLatencies)./sqrt(length(pp)-1)],'k.' );
axis([0 3 0 270]);
xlabel('Condition','FontSize',18);
ylabel('Averaged Median Latencies (ms)','FontSize',18);
set(gca, 'Xtick',[]);
box off;
subplot(1,4,2);
bar(1,mean(noIORLatenciesOpp),'FaceColor',noIorColor);
hold on;
bar(2,mean(IORLatenciesOpp),'FaceColor',iorColor);
errorbar([mean(noIORLatenciesOpp) mean(IORLatenciesOpp)], [std(noIORLatenciesOpp)./sqrt(length(pp)-1) std(IORLatenciesOpp)./sqrt(length(pp)-1)],'k.' );
axis([0 3 0 270]);
xlabel('Condition','FontSize',18);
ylabel('Averaged Median Latencies (ms)','FontSize',18);
set(gca, 'Xtick',[]);
box off;
subplot(1,4,3);
bar(1,mean(noIORLatenciesAdj),'FaceColor',noIorColor);
hold on;
bar(2,mean(IORLatenciesAdj),'FaceColor',iorColor);
errorbar([mean(noIORLatenciesAdj) mean(IORLatenciesAdj)], [std(noIORLatenciesAdj)./sqrt(length(pp)-1) std(IORLatenciesAdj)./sqrt(length(pp)-1)],'k.' );
axis([0 3 0 270]);
xlabel('Condition','FontSize',18);
ylabel('Averaged Median Latencies (ms)','FontSize',18);
set(gca, 'Xtick',[]);
box off;
subplot(1,4,4);
latenciesObservers = sortrows([noIORLatencies' IORLatencies' (1:10)']);
hold on;
bar((1:length(pp))+0.15',latenciesObservers(:,2),0.4,'FaceColor',iorColor);
bar((1:length(pp))-0.15',latenciesObservers(:,1),0.4,'FaceColor',noIorColor);
axis([0 11 0 270]);
legend('IOR condition','No IOR condition');
ylabel('Median Latency (ms)','FontSize',18);
xlabel({'Observer','(ordered by latency)'},'FontSize',18);
box off;

    %get the ordered observer list here
pp(latenciesObservers(:,3))

    %hier komt de collapsed latency figure
collapsedLatFig = figure;
[nNoIOR,X] = hist(latenciesNoIOR, 100:15:450);
[nIOR,X] = hist(latenciesIOR, 100:15:450);
    
bar([X; X]',[nIOR; nNoIOR]');

bar(X+2.5,nIOR,0.5,'FaceColor',iorColor);
hold on;
bar(X-2.5,nNoIOR,0.5,'FaceColor',noIorColor);
axis([75 450 0 450]);
xlabel('Latencies (ms)','FontSize',18);
ylabel('Saccade Count','FontSize',18);
legend('IOR condition','No IOR condition');

   % perform t-tests
fprintf('\nOPPOSITE STATS (below)');
[h p ci stats] = ttest(noIORLatenciesOpp,IORLatenciesOpp)
disp(['Latency difference ' num2str(mean(noIORLatenciesOpp) - mean(IORLatenciesOpp))])
cohenDopp  = abs(mean(noIORLatenciesOpp) - mean(IORLatenciesOpp))/((std(noIORLatenciesOpp)+std(IORLatenciesOpp))/2);
disp(['With an effect size of ' num2str(cohenDopp)]);

   % perform t-tests
fprintf('\nADJACENT STATS (below)');
[h p ci stats] = ttest(noIORLatenciesAdj,IORLatenciesAdj)
disp(['Latency difference ' num2str(mean(noIORLatenciesAdj) - mean(IORLatenciesAdj))])
cohenDadj  = abs(mean(noIORLatenciesAdj) - mean(IORLatenciesAdj))/((std(noIORLatenciesAdj)+std(IORLatenciesAdj))/2);
disp(['With an effect size of ' num2str(cohenDadj)]);


   % perform t-tests
fprintf('\nALL TRIAL STATS (below)');
[h p ci stats] = ttest(noIORLatencies,IORLatencies)
disp(['Latency difference ' num2str(mean(noIORLatencies) - mean(IORLatencies))])
cohenD  = abs(mean(noIORLatencies) - mean(IORLatencies))/((std(noIORLatencies)+std(IORLatencies))/2);
disp(['With an effect size of ' num2str(cohenD)]);

if( plotOn )
    print(collapsedLatFig, '-depsc','-r300','../outputs/manuscriptFigures/figure6.eps');
    print(obsLatFig, '-depsc','-r300','../outputs/manuscriptFigures/figure2.eps');
end

