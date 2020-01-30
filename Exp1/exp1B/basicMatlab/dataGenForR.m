    %perform cleanup
clear all;
close all;

constantsSacExp_JV; %load constants

expName     = 'ISA';
iorColor    = [0.45 0.45 0.45];
noIorColor  = [0.75 0.75 0.75];

expRun      = 102;
expVersion  = 7;
pp          = {'ep' 'gs' 'js' 'jw' 'km' 'mh' 'mj' 'sm' 'ul' 'ke'};
name        = '102-7';

allData     = [];

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
        
            conditionData       = selectionData(u,v);
            selectedEls         = conditionData.selectedEl; 
            latencies           = conditionData.latencies; 
            succesfulTrialList  = conditionData.succesFullTrials;

                %filter based on trial that fullfill criteria
            latencies   = latencies(succesfulTrialList);
            selectedEls = selectedEls(succesfulTrialList);

            obsList     = t*ones(length(selectedEls),1);
            condList    = conditionData.condition*ones(length(selectedEls),1);
            subCondList = conditionData.subCondition*ones(length(selectedEls),1);
            allData = [allData; obsList condList subCondList latencies selectedEls];
            
        end
    end
    
end  


dlmwrite('../data/dataForR.dat',allData,'delimiter','\t');

