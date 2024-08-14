function lastKey = checkLastKey(w)

if KbCheck
    [~,~,kbCode] = KbCheck;
    if sum(kbCode) == 1

        [ ~, lastKey ] = max(kbCode);

        if lastKey == 27
                abortExperiment(1,w);
        end
    else
        lastKey = 0;
    end
else
    lastKey = 0;
end