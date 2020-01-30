clear all;
close all;

constantsSacExp_JV;

expVersion = 2;
expName = 'ISA';
expRun = 101;
pp = {'ac' 'hr' 'jl' 'lb' 'mm' 'nw' 'pf' 'tb' 'tc' 'yo'};

    %critereon variables
maxInitMov      = 1.5;
maxStartDev     = 1.5;
maxLat          = 600; minLat   = 60;
maxElDist       = 3;

for( t = 1:length(pp) )
        
        %load individuals data
    inputDir = ['../data/selectionData/' expName num2str(expRun) pp{t} num2str(expVersion) '/']
    load([inputDir 'selectionData']);
    load(['../data/stimulusData/' pp{t} num2str(expVersion) '/propertyFile.mat']);

        %calculate some properties of the experiment
    pixPerDeg_JV;
    
        %initiate lists to add condition data for
    startingPercInd = []; latencyPercInd = []; probePercInd = []; trialsCorrectPercInd = []; initMov = []; elDistPercInd = []; elSelectPercInd = [];
    
        %get the dimensions of the data and go through conditions and subcondition
    [dimX dimY] = size(selectionData);
    for( u =1:dimX )
        for( v =1:dimY )
            
                %get the data for this condition
            conditionData   = selectionData(u,v);
            trialInf        = conditionData.trialInf;      %get the corresponding trial inf files
            
                %retreive necesarry trial parameters
            latencies   = conditionData.latencies;
            amplitudes  = conditionData.amplitudes;
            initAmplMax = conditionData.maxInitAmpl;
            selectedEls = conditionData.selectedEl;
            elDistance  = conditionData.distanceToEl;
            xInit       = conditionData.xBeginPoints;
            yInit       = conditionData.yBeginPoints;
            
                %make seperate boolean lists for the individual criterea
            startingPointCrit   = sqrt((xInit-expProps.startX).^2 + (yInit-expProps.startY).^2) < (pixPerDeg)*maxStartDev;     %1600/36 is een graad
            latencyCrit         = (latencies > minLat & latencies < maxLat);
            noInitMov           = initAmplMax < maxInitMov;
            elDistCrit          = elDistance < maxElDist*pixPerDeg;
            elSelectCrit        = selectedEls == TARGET | selectedEls == DISTRACTOR;
            

                %combinedCriterea and add to selectionData
            combiCritList       = startingPointCrit & latencyCrit & elDistCrit & noInitMov & elSelectCrit;
            selectionData(u,v).succesFullTrials = combiCritList;
            
                %now add the proportion to the lists so we can calculate an average for the observerbellow 
            trialsCorrectPercInd    = [trialsCorrectPercInd mean(combiCritList)];
            startingPercInd         = [startingPercInd mean(startingPointCrit)];
            latencyPercInd          = [latencyPercInd mean(latencyCrit)];
            elDistPercInd           = [elDistPercInd mean(elDistCrit)];
            elSelectPercInd         = [elSelectPercInd mean(elSelectCrit)];
            initMovPerInd           = [initMov mean(noInitMov)];
        end
    end
    
    save([inputDir 'selectionData'],'selectionData');
    
        %now calculate the mean for the observer over condition to be used
        %for the overall average below
    startingProp(t) = mean(startingPercInd);
    latencyProp(t)  = mean(latencyPercInd);
    initMovProp(t)  = mean(initMovPerInd);
    elDistProp(t)   = mean(elDistPercInd);
    elSelectProp(t) = mean(elSelectCrit);
    totalProp(t)    = mean(trialsCorrectPercInd);
    
    
end

disp(['Passed starting location: ' num2str(mean(startingProp)*100) ', ' num2str((1-mean(startingProp))*100)]);
disp(['Passed latency timings: ' num2str(mean(latencyProp)*100) ', ' num2str((1-mean(latencyProp))*100)]);
disp(['Passed element distance criterion: ' num2str(mean(elDistProp)*100) ', ' num2str((1-mean(elDistProp))*100)]);
disp(['Passed element selection criterion: ' num2str(mean(elSelectProp)*100) ', ' num2str((1-mean(elSelectProp))*100)]);
disp(['Passed no init mov criterion: ' num2str(mean(initMovProp)*100) ', ' num2str((1-mean(initMovProp))*100)]);
disp(['Passed combined criteria: ' num2str(mean(totalProp)*100) ', ' num2str((1-mean(totalProp))*100)]);
