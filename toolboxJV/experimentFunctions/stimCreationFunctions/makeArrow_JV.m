function [arrow] = makeArrow_JV(size, thickness)

patch = ones(size)*0.5;

patch((size/2-thickness/2):(size/2+thickness/2),size/10:9*size/10) = 1;

for( u = 1:thickness*2 )
    patch((size/2+thickness/2):(size/2+thickness/2)+u,size/10+u:2*size/10+u) = 1;
end

for( u = 1:thickness*2 )
    patch((size/2-thickness/2)-u:(size/2-thickness/2),size/10+u:2*size/10+u) = 1;
end


arrow = patch;