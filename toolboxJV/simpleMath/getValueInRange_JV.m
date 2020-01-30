function [value] = getValueInRange_JV(range)
    value = min(range) + rand(1)*(max(range) - min(range));
end