function [data] = generateSummary_JV(data)

fieldsInStruct = fieldnames(data);

for( w = 1:length(data) )
    for( u = 1:length(fieldsInStruct) )
        variableName = fieldsInStruct{u};
        variableName = [upper(variableName(1)) variableName(2:end)];
        eval(['array = data(w).' fieldsInStruct{u} ';'] );
        array
        if( length(array) > 1 & ~isnan(mean(array)) )
            ['data(w).mean' variableName ' = mean(array) ;']
            eval(['data(w).mean' variableName ' = mean(array) ;']);
            eval(['data(w).median' variableName ' = median(array) ;']);
            eval(['data(w).std' variableName ' = std(array) ;']);
            eval(['data(w).se' variableName ' = std(array)/sqrt(length(array)-1) ;']);
        end
    end
end