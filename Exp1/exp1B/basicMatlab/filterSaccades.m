    %cleanup memory and figures
clear all;
close all;

    %zet JV toolboxes in het path
toolboxFolder = [cd '../../toolboxJV']
addpath(genpath(toolboxFolder));


constantsSacExp_JV;     %load the constants!

    %experiment variables
expVersion  = 7;
expName     = 'ISA';
expRun      = 102;
pp          = {'ep' 'gs' 'js' 'jw' 'km' 'mh' 'mj' 'sm' 'ul' 'ke'};

    %critereon variables
maxInitMov      = 1.5;
minLat          = 60;
maxLat          = 600;
maxElDist       = 2;

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
            latencies   = conditionData.latencies;
            amplitudes  = conditionData.amplitudes;
            initAmplMax = conditionData.maxInitAmpl;
            elDistance  = conditionData.distanceToEl;
            selectedEl  = conditionData.selectedEl;
            xInit       = conditionData.xBeginPoints;
            yInit       = conditionData.yBeginPoints;
            
                %make seperate boolean lists for the individual criterea
            startingPointCrit   = sqrt((xInit-expProps.startX).^2 + (yInit-expProps.startY).^2) < (pixPerDeg)*maxInitMov; 
            latencyCrit         = (latencies > minLat & latencies < maxLat);
            noInitMov           = initAmplMax < maxInitMov;
            elDistCrit          = elDistance < maxElDist*pixPerDeg;
            elSelectCrit        = selectedEl == TARGET | selectedEl == DISTRACTOR;
            
                %combined criterea and add to selectionData
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
    
        %save the selectionData to file
    save([inputDir 'selectionData'],'selectionData');
    
        %now calculate the mean for the observer over condition to be used
        %for the overall average below
    startingProp(t) = mean(startingPercInd);
    latencyProp(t)  = mean(latencyPercInd);
    initMovProp(t)  = mean(initMovPerInd);
    elDistProp(t)   = mean(elDistPercInd);
    elSelectProp(t) = mean(elSelectPercInd);
    totalProp(t)    = mean(trialsCorrectPercInd);
    
end

    %display the percentages to be used in the paper
disp(['Passed starting location: ' num2str(mean(startingProp)) ', ' num2str((1-mean(startingProp))*100)]);
disp(['Passed latency timings: ' num2str(mean(latencyProp)) ', ' num2str((1-mean(latencyProp))*100)]);
disp(['Passed element distance criterion: ' num2str(mean(elDistProp)) ', ' num2str((1-mean(elDistProp))*100)]);
disp(['Passed element selection criterion: ' num2str(mean(elSelectProp)) ', ' num2str((1-mean(elSelectProp))*100)]);
disp(['Passed no init mov criterion: ' num2str(mean(initMovProp)) ', ' num2str((1-mean(initMovProp))*100)]);
disp(['Passed combined criteria: ' num2str(mean(totalProp)) ', ' num2str((1-mean(totalProp))*100)]);
