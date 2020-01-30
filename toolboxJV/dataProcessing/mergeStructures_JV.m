function [ mergedStruct ] = mergeStructures_JV(struct1,struct2,keyFields)

interSectList   = intersect(fieldnames(struct1),fieldnames(struct2));
complList       = setxor(fieldnames(struct1),fieldnames(struct2));

for( u = 1:length(interSectList) )
    values1 = getfield(struct1,interSectList{u});
    values2 = getfield(struct2,interSectList{u});
    
        %if it pertains a keyField, values should match
    if( sum(ismember(keyFields,interSectList{u})) > 0 )
        if( ~(values1 == values2) )
            mergedStruct = struct([]);
            disp('Key fields don-t match');
            return;
        end
    else
        [rows1 columns1] = size(values1);
        [rows2 columns2] = size(values2);
        if( rows1 == rows2 & columns1 == columns2 )
            if( rows1 < columns1 )
                values = [values1 values2];
            else
                values = [values1; values2];
            end
        else
            if( rows1 == rows2 )
                values = [values1 values2];
            elseif( columns1 == columns2 )
                values = [values1; values2];
            end
        
        end
        struct1 = setfield(struct1,interSectList{u},values);
    end
end

for( u = 1:length(complList) )
    if( isfield(struct2,complList{u}) )
        values  = getfield(struct2,complList{u});
        struct1 = setfield(struct1,complList{u},values);
    end
    
end

mergedStruct = struct1;