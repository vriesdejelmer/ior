function [titleStr] = getTitle(condition)

constantsSacExp_JV;

if( condition == CONDITION_SIZE_LARGE )
    titleStr = 'Large';
elseif( condition == CONDITION_SIZE_SMALL )
    titleStr = 'Small';
elseif( condition == CONDITION_LARGE_SMALL )
    titleStr = 'Large-Small';
elseif( condition == CONDITION_LARGE_LARGE )
    titleStr = 'Large-Large';
elseif( condition == CONDITION_SMALL_SMALL )
    titleStr = 'Small-Small';
elseif( condition == CONDITION_SMALL_LARGE )
    titleStr = 'Small-Large';
elseif( condition == CONDITION_DISTANCE_FAR )
    titleStr = 'Far';
elseif( condition == CONDITION_DISTANCE_NEAR )
    titleStr = 'Far';
end