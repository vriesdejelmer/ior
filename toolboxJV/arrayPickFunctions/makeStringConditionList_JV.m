function [conditionList] = makeStringConditionList_JV(conditions, trialsPerCondition)
  
    for( u = 1:length(conditions) )
        conditionList((1+(u-1)*trialsPerCondition):(u*trialsPerCondition)) = {conditions{u}};
    end
