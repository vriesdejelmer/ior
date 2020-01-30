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

filterData  = true;     %created for comparison on reviewer request
allData = [];

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

            if filterData
                    %filter based on trial that fullfill criteria
                succesfulTrialList  = conditionData.succesFullTrials;
                latencies           = latencies(succesfulTrialList);
                selectedEls         = selectedEls(succesfulTrialList);
            end

            obsList     = t*ones(length(selectedEls),1);
            condList    = conditionData.condition*ones(length(selectedEls),1);
            allData     = [allData; obsList condList latencies selectedEls];
        end
    end
    
end  

if filterData
    dlmwrite('../data/dataForR.dat',allData,'delimiter','\t');
else
    dlmwrite('../data/unfilteredDataForR.dat',allData,'delimiter','\t');
end

