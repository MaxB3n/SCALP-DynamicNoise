function abortExperiment(intended, w)



try
    if intended
        DrawFormattedText(w, 'Abort Experiment? \n\n Y  /  N  ? ', 'center', 'center', [ 0 0 0 ] , 80);         % showing more instruction text (6), doing same kbWait
        Screen('Flip', w);
        pause(0.5)
        bzt = 0 ;
        while ~bzt
            lastKey = checkLastKey(w) ;
            if lastKey == 89 
                bzt = 1 ;
            elseif lastKey == 78
                return ;
            end
        end
    end
catch
end

fprintf('Aborting Experiment ... \n')

stack = dbstack('-completenames');
stackheight = numel(stack);
stackMessage = '';

if stackheight >= 2
    for i = stackheight
        stackMessage = strcat(stackMessage, sprintf('Called from %s line %d in file %s.\n', stack(i).name, stack(i).line, stack(i).file) );
    end
else
   stackMessage = 'No caller.';
end

Screen('closeall');
ListenChar(0);
ShowCursor;
diary off;
error('Experiment aborted. \n\n%s',stackMessage)
end