function [conditionList] = makeConditionList_JV(conditions, trialsPerCondition)
    
    conditionList = [];
    for( u = 1:length(conditions) )
        conditionList = [conditionList conditions(u) * ones(1,trialsPerCondition)];
    end
