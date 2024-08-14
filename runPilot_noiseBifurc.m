function runPilot_noiseBifurc(stg,sess,cfg)
disp("Running Pilot....\n\n")

%Generate trial info
nTrials = cfg.design.nTrials ;
nBlocks = cfg.pilot.nBlocks ;

presp = generateResponseTable("Pilot", nTrials*nBlocks, stg, sess, cfg) ;

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
    [ptrls, stg] = generateTrials_noiseBifurc("Pilot", stg, sess, cfg);

    if b > 1
        getReady("interBlock",sess,cfg)
    end

    noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);

% Run single block    
    for t = 1:nTrials
    
        T = t + ((b-1)*nTrials);
    
        ContrastVal = stg.contrLowest + (ptrls.contrastPerTrial(t) * stg.contrStep) ;
        [tafc, rt, pas, missed] = runTrial(t, ContrastVal, "Pilot", ptrls, stg, sess, cfg, missed) ;
    
        presp.contrastLv(T) = ptrls.contrastPerTrial(t);
        presp.contrastVal(T) = ContrastVal ;
        presp.accuracy(T) = tafc ;
        presp.responseTime(T) = rt ;
        presp.pas(T) = pas ;
        presp.trials(T) = T ;
    
    end
end

if ismember(4, sess.filesToSave)
    pBehavTable = struct2table(presp); %,'VariableNames',{'ContrastSetting','Accuracy', '2afc_Response_Time', 'Pas_Response'}
    file = sprintf("%s%s_Pilot_Results_%s%s.csv",sess.saveDir,sess.subNum,sess.date,sess.startTime) ;
    writetable(pBehavTable,file)
end

end