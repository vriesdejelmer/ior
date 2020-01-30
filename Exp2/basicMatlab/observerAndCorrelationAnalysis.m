    %perform cleanup
clear all;
close all;

    %zet JV toolboxes in het path
toolboxFolder = [cd '../../toolboxJV']
addpath(genpath(toolboxFolder));

constantsSacExp_JV; %load constants

    %experiment params
expRun      = 101;
expName     = 'RDI';
pp          = {'me' 'mt' 'ke' 'st' 'se' 'za' 'rw' 'sj' 'yt' 'ep' 'ml' 'cj' 'kr'};
expVersion  = 9;

numbBins    = 5;
indFigure   = figure;

iorColor    = [0.45 0.45 0.45];
noIorColor  = [0.7 0.7 0.7];

    %for each observer
for( t = 1:length(pp) )
    
        %load individuals data
    inputDir = ['../data/selectionData/' expName num2str(expRun) pp{t} num2str(expVersion) '/']
    load([inputDir 'selectionData']);
    load(['../data/stimulusData/' pp{t} num2str(expVersion) '/propertyFile.mat']);
            
    iorLatencies        = []; noIorLatencies      = [];
    iorSelection        = []; noIorSelection      = [];
     
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
            
            if conditionData.condition == CONDITION_IOR
                iorLatencies    = [iorLatencies; latencies];
                iorSelection    = [iorSelection; selectedEls];
            elseif conditionData.condition == CONDITION_NO_IOR
                noIorLatencies = [noIorLatencies; latencies];
                noIorSelection = [noIorSelection; selectedEls];
            end
                     
        end
        
    end
    figure(indFigure);
    subplot(5,3,t);
    [latencyListIOR, targetPropListIOR, distPropListIOR] = makeBins(iorLatencies, iorSelection,TARGET,DISTRACTOR,numbBins);
    plot(latencyListIOR,targetPropListIOR,'-.d','color',iorColor,'LineWidth',2);
    
    obsLatBinsIOR(:,:,t)    = latencyListIOR;
    targetPropIOR(:,:,t)    = targetPropListIOR;
    distPropIOR(:,:,t)      = distPropListIOR;
    
    [latencyListNoIOR, targetPropListNoIOR, distPropListNoIOR] = makeBins(noIorLatencies, noIorSelection,TARGET,DISTRACTOR,numbBins);
    hold on;
    plot(latencyListNoIOR,targetPropListNoIOR,'-d','color',noIorColor,'LineWidth',2);

    ylim([0 1]); 
    set(gca,'FontSize',11);
    latRange = [latencyListIOR latencyListNoIOR];
    xlim([min(latRange)-15 max(latRange)+15]);
    
    if( t==length(pp) )
        yH = ylabel('Accuracy','FontSize',18);
        set(yH, 'Units', 'Normalized', 'Position', [-0.23, 3.5, 0]);
        legHand = legend('Target-Cued','Distractor-Cued');
        rect    = [0.45 0.13 0.13 0.08];
        text(505,0.7,'Latency (ms)','FontSize',18);
        set(legHand,'FontSize',14,'Position',rect);
        print(indFigure, '-depsc','-r300','../outputs/manuscriptFigures/figure12.eps');
    end
    
    captureLatencies    = latencies(selectedEls == DISTRACTOR);
    
    obsLatBinsNoIOR(:,:,t)     = latencyListNoIOR;
    targetPropNoIOR(:,:,t)     = targetPropListNoIOR;
    distPropNoIOR(:,:,t)       = distPropListNoIOR;
    
    medianShortLatencyIOR(t)    = latencyListIOR(1);
    propShortInCorrectIOR(t)    = distPropListIOR(1);

    medianShortLatencyNoIOR(t)  = latencyListNoIOR(1);
    propShortInCorrectNoIOR(t)   = distPropListNoIOR(1);

    shortCombLatency(t)     = (medianShortLatencyIOR(t) + medianShortLatencyNoIOR(t))/2;
    
    medianLatencyIOR(t) = median(iorLatencies);
    propInCorrectIOR(t) = sum(iorSelection == DISTRACTOR)/length(iorSelection);

    medianLatencyNoIOR(t) = median(noIorLatencies);
    propInCorrectNoIOR(t)   = sum(noIorSelection == DISTRACTOR)/length(noIorSelection);

    combLatency(t) = (medianLatencyIOR(t) + medianLatencyNoIOR(t))/2;
    
end

figure;
xMin = 150; xMax = 320;
plot([xMin xMax],[0.5 0.5],':','Color',[0.9 0.9 0.9],'LineWidth',2);
hold on;
iorPropH     = errorbar(mean(obsLatBinsIOR,3),mean(targetPropIOR,3),std(targetPropIOR,[],3)./sqrt(length(pp)-1),'-d','Color',noIorColor,'LineWidth',3);
noIorPropH   = errorbar(mean(obsLatBinsNoIOR,3),mean(targetPropNoIOR,3),std(targetPropNoIOR,[],3)./sqrt(length(pp)-1),'-d','Color',iorColor,'LineWidth',3);

legendH = legend([iorPropH noIorPropH],{'Target-Cued','Distractor-Cued'},'Location','SouthEast');
set(legendH,'FontSize',18');
xlabel('Saccade Latency (ms)','FontSize',18);
ylabel('Proportion To Target','FontSize',18);
axis([xMin xMax 0.0 1]);

corrFigureH = figure('rend','painters','pos',[10 10 800 400]);

factor = propInCorrectIOR;
subplot(1,2,1);
xMin = 190; xMax = 280;
func = @(beta,x)(beta(1)+beta(2) * x);
beta = nlinfit(medianLatencyIOR',factor',func,[1 -1]);

values = func(beta,[xMin xMax]);
plot([xMin xMax],values,'--','color',[0.5 0.5 0.5],'LineWidth',3);
hold on;
plot(medianLatencyIOR,factor,'ko','MarkerFaceColor',[1 1 1]);
axis([xMin-15 xMax+15 0 0.95]);
xlabel('Median Latency (ms)','FontSize',18);
yH = ylabel('Proportion Incorrect','FontSize',18);
set(yH, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);
box off;
a = get(gca,'XTick');
set(gca,'XTick',a,'Fontsize',14);
labelHandle = get(gca,'XTickLabel');
set(gca,'XTick',[150 200 250],'XTickLabel',labelHandle,'Fontsize',16);
text(xMin-40,0.87,'A','FontSize',18,'FontWeight','bold');

[RHO,PVAL] = corr(medianLatencyIOR',factor')

factor = propShortInCorrectIOR;
xMin = 100; xMax = 220;
func = @(beta,x)(beta(1)+beta(2) * x);
beta = nlinfit(medianShortLatencyIOR',factor',func,[1 -1]);
subplot(1,2,2);
values = func(beta,[xMin xMax]);
plot([xMin xMax],values,'--','color',[0.5 0.5 0.5],'LineWidth',3);
hold on;
plot(medianShortLatencyIOR,factor,'ko','MarkerFaceColor',[1 1 1]);
axis([xMin-25 xMax+15 0 0.95]);
xlabel('Latency fastest bin (ms)','FontSize',18);
box off;
tickHandle = get(gca,'XTick');
set(gca,'XTick',tickHandle,'Fontsize',14);
labelHandle = get(gca,'XTickLabel');
set(gca,'XTick',[100 150 200],'XTickLabel',labelHandle,'Fontsize',16);
text(xMin-60,0.87,'B','FontSize',18,'FontWeight','bold');

print(corrFigureH, '-depsc','-r300','../outputs/manuscriptFigures/figure13.eps');

[RHO,PVAL] = corr(medianShortLatencyIOR',factor')