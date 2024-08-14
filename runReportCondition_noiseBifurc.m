function runReportCondition_noiseBifurc(stg, sess, cfg)
disp("Running Report Trials....\n\n")

%Generate trial info
nTrials = cfg.design.nTrials ;
nBlocks = cfg.design.nBlocks ;

rresp = generateResponseTable("Report", nTrials*nBlocks, stg, sess, cfg) ;

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
    [ptrls, stg] = generateTrials_noiseBifurc("Report", stg, sess, cfg);

    if b > 1
        getReady("interBlock",sess,cfg)
    end

    noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);

% Run single block    
    for t = 1:nTrials
    
        T = t + ((b-1)*nTrials);
    
        ContrastVal = stg.contrLowest + (ptrls.contrastPerTrial(t) * stg.contrStep) ;
        [tafc, rt, pas, missed] = runTrial(t, ContrastVal, "Report", ptrls, stg, sess, cfg, missed) ;
    
        rresp.contrastLv(T) = ptrls.contrastPerTrial(t);
        rresp.contrastVal(T) = ContrastVal ;
        rresp.accuracy(T) = tafc ;
        rresp.responseTime(T) = rt ;
        rresp.pas(T) = pas ;
        rresp.trials(T) = T ;
    
    end
end

if ismember(3, sess.filesToSave)
    rBehavTable = struct2table(rresp); %,'VariableNames',{'ContrastSetting','Accuracy', '2afc_Response_Time', 'Pas_Response'}
    file = sprintf("%s%s_Report_Results_%s%s.csv",sess.saveDir,sess.subNum,sess.date,sess.startTime) ;
    writetable(pBehavTable,file)
end

end