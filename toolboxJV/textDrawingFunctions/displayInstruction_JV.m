function [] = displayInstruction(w, instructions)

instructionLines = regexp(instructions,'#','split');

rect=Screen('Rect', w);

centerX = rect(3)/2;
centerY = rect(4)/2;


Screen('TextSize', w,24);

for( u = 1:length(instructionLines) )
    Screen('DrawText', w, instructionLines{u},centerX/2,centerY/2 + u *40,255);
end
Screen('Flip', w);

[keyIsDown, secs, keyCode] = KbCheck();

while( ~keyIsDown )
   [keyIsDown, secs, keyCode] = KbCheck();
end
while( keyIsDown )
   [keyIsDown, secs, keyCode] = KbCheck();
end
