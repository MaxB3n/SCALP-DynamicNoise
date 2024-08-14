function pauseExperiment(w)

Screen('TextSize', w, 40);
DrawFormattedText(w, 'Experiment is paused.\n\nPress any key to resume', 'center', 'center', black, 80);
Screen('Flip', w);
KbWait;

for i=1:3
if i == 3
    secs = ' second';
else
    secs = ' seconds';
end
DrawFormattedText(w, 'Resuming in ',num2str(4-i), secs, 'center', 'center', black, 80);
Screen('Flip', w);
pause(0.8)
end

end