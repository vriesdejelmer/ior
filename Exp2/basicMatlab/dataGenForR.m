    %perform cleanup
clear all;
close all;

    %zet JV toolboxes in het path
toolboxFolder = [cd '../../toolboxJV']
addpath(genpath(toolboxFolder));

constantsSacExp_JV; %load constants

%    experiment params
expRun      = 101;
expName     = 'RDI';
pp          = {'me' 'mt' 'ke' 'st' 'se' 'za' 'rw' 'sj' 'yt' 'ep' 'ml' 'kr' 'cj'};
expVersion  = 9;

allData = [];

    %for each observer
for( t = 1:length(pp) )

        %load individuals data
    inputDir = ['../data/selectionData/' expName num2str(expRun) pp{t} num2str(expVersion) '/']
    load([inputDir 'selectionData']);
    load(['../data/stimulusData/' pp{t} num2str(expVersion) '/propertyFile.mat']);
    
    [dimX dimY] = size(selectionData);
    
        %for each condition and subcondition
    for( cond = 1:dimX )
        for( subCond = 1:dimY )

                %fixated elements
            fixEls          = vertcat(selectionData(cond,subCond).selectedEl);
            latencies       = selectionData(cond,subCond).latencies;
            obsId           = ones(size(fixEls))*t;
            trialId         = [selectionData(cond,subCond).trials]';
            condId          = ones(size(fixEls))*selectionData(cond,subCond).condition;
            subCondId       = ones(size(fixEls))*selectionData(cond,subCond).subCondition;
            
                %make matrix for observer and condition combination
            obsCondMatrix = [obsId trialId condId subCondId latencies fixEls];
            
                %make selection based on succesful trial criterea
            obsCondMatrix = obsCondMatrix(selectionData(cond,subCond).succesFullTrials,:);

                %append condition data to the overall matrix
            allData = [allData; obsCondMatrix];
        end
    end

end

dlmwrite('../data/dataForR.dat',allData,'delimiter','\t');