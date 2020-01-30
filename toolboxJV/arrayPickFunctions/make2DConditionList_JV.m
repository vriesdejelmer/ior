function [conditionList] = make2DConditionList_JV(primaryConditions, subConditions, trialsPerSubCondition)

    mainConditionList = makeConditionList_JV(primaryConditions,trialsPerSubCondition*length(subConditions));
    subConditionList = [];
    for( u = 1:length(primaryConditions) )
        subConditionList = [subConditionList makeConditionList_JV(subConditions,trialsPerSubCondition)];
    end
    
    conditionList = [mainConditionList; subConditionList];
    
    
