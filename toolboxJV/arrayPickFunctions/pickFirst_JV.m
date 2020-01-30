function [element complement] = pickFirst_JV(elementList)
        
    element = elementList(1);
    complement = elementList(2:end);
    
    