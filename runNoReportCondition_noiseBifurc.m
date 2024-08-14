function runNoReportCondition_noiseBifurc(stg, sess, cfg)
disp("Running No Report Trials....\n\n")

%Generate trial info
nTrials = cfg.design.nTrials ;
nBlocks = cfg.design.nBlocks ;

nresp = generateResponseTable("No Report", nTrials*nBlocks, stg, sess, cfg) ;

% Reset relevant settings 
missed = 0 ;

%Indicate beginning of pilot
Screen('TextSize', sess.ptb.w, 40);
DrawFormattedText(sess.ptb.w, ['You are about to begin the behavioral pilot!', ...
    sprintf('\n\nYour threshold contrast modifier has been set to %0.3f',stg.quest50), ...
    '\n\nPress any key to continue ...'], 'center', 'center', [0 0 0], 80);
Screen('Flip', sess.ptb.w);
KbWait([],2);

getReady("Pilot",sess,cfg)

% Begin blocks
for b = 1:nBlocks
    [ntrls, stg] = generateTrials_noiseBifurc("No Report", stg, sess, cfg);

    if b > 1
        getReady("interBlock",sess,cfg)
    end

    noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);

% Run single block    
    for t = 1:nTrials
    
        T = t + ((b-1)*nTrials);
    
        if ntrls.distractorPerTrial(t) 

        else
            ContrastVal = stg.contrLowest + (ntrls.contrastPerTrial(t) * stg.contrStep) ;
            [tafc, rt, pas, missed] = runTrial(t, ContrastVal, "No Report", ntrls, stg, sess, cfg, missed) ;
        end
    
        nresp.contrastLv(T) = ptrls.contrastPerTrial(t);
        nresp.contrastVal(T) = ContrastVal ;
        nresp.accuracy(T) = tafc ;
        nresp.responseTime(T) = rt ;
        nresp.pas(T) = pas ;
        nresp.trials(T) = T ;
    
    end
end

if ismember(3, sess.filesToSave)
    nBehavTable = struct2table(nresp); %,'VariableNames',{'ContrastSetting','Accuracy', '2afc_Response_Time', 'Pas_Response'}
    file = sprintf("%s%s_NoReport_Results_%s%s.csv",sess.saveDir,sess.subNum,sess.date,sess.startTime) ;
    writetable(pBehavTable,file)
end

end