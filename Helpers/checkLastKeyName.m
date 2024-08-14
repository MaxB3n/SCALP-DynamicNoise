function lastKey = checkLastKeyName()

if KbCheck
    [~,~,kbCode] = KbCheck;
    tmp = KbName(kbCode);
    if iscell(tmp)
        lastKey = string(tmp{1});
    elseif isstring(tmp)
        lastKey = string(tmp);
    else
        lastKey = "";
    end
else
    lastKey = "";
end

try
    if lastKey == "ESCAPE"
        abortExperiment;
    end
catch
    warning("something strange this way comes in checkLastKey function.")
end

end