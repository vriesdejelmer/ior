
if ~exist('prefix'), prefix = ''; end

dirName = cd;

    %Load the results file with all the fixations.
fileName = [prefix '../../data/fixationData/' expName '/' expName zerroPad_JV(expRun,3) ppi num2str(expVersion) '.mat'];
cd
load(fileName);

    %If it is available load the trialInfFile
trialInfFileName = [prefix '../../data/fixationData/' expName '/' expName zerroPad_JV(expRun,3) ppi num2str(expVersion) 'TrialInf.mat']
try
    
    load(trialInfFileName);
catch exception
    exception
end

    %Laad de eigenschappen van het experiment
stimDir = [prefix '../../data/stimInf/' expName '/' expName zerroPad_JV(expRun,3) '/' ppi num2str(expVersion) '/'];
mesDir = [prefix '../../data/emData/' expName '/' zerroPad_JV(expRun,3) '/' ppi num2str(expVersion) '/'];
propertyFile = [stimDir 'propertyFile.mat'];
load(propertyFile,'expProps');
messageFile = [mesDir 'experimentMessages.mat'];
load(messageFile);