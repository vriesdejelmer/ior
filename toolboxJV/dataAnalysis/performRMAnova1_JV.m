function [] = performRMAnova1_JV(dataSet,var1,cat1,multComp,corrType)

    %if there is no input for corrType we set it to lsd, in essence no correction
if ~exist('corrType'), corrType = 'lsd'; end

    %create data table
varNums     = 1:length(cat1);
varNames    = arrayfun(@(x) horzcat('Y',num2str(x)) ,varNums,'UniformOutput',false);
dataSplit   = arrayfun(@(x) ['dataSet' '(:,' num2str(x) '), '] ,varNums,'UniformOutput',false);
dateTable   = eval(['table(' strjoin(dataSplit) '''VariableNames'',varNames);']);

    %create withinFactors table
within = table(cat1','VariableNames',{var1});

    %generate the repeated measures model
repMeasModel = fitrm(dateTable,[varNames{1} '-' varNames{end} '~1'],'WithinDesign',within)

    %output repeated measures anova
[ranovatbl A C D]  = ranova(repMeasModel,'WithinModel',var1)

    %output mauchly's sphericity test
T = mauchly(repMeasModel,C)

    %output epsilon
tbl = epsilon(repMeasModel,C)

    %multiple comparisons
if multComp, 
    multcompare(repMeasModel,var1,'ComparisonType',corrType)
end



