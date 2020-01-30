function [s] = zeroPad(number,stringLength)

zeroString = '';

if( number > 10^stringLength )
    disp('Het nummer is groter dan de output lengte');
else
    for(u = stringLength-1:-1:1)
        if( number < 10^u )
            zeroString = [zeroString '0'];
        end
    end
end

s = [zeroString num2str(number)];