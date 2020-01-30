function [responseKey] = displayInstruction_JV(w, instructions,expProps)

[keyIsDown, secs, keyCode] = KbCheck();

while( keyIsDown )
   [keyIsDown, secs, keyCode] = KbCheck();
end

rect=Screen('Rect', w);

centerX = rect(3)/2;
centerY = rect(4)/2;

Screen('TextSize', w,24);

DrawFormattedText(w, instructions, 'center', 'center',expProps.foregroundColor,80, [],[], 1.5);
 
Screen('Flip', w);

[keyIsDown, secs, keyCode] = KbCheck();

while( true )
   [keyIsDown, secs, keyCode] = KbCheck();
    if( keyIsDown && length(find(keyCode)) == 1 && ~isempty(find(find(keyCode) == expProps.responseKeys)) )
        responseKey = find(keyCode);
        break;
    end
end
while( keyIsDown )
   keyIsDown = KbCheck();
end

Screen('FillRect', w, expProps.backgroundColor);
 
Screen('Flip', w);
