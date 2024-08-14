function renderAndSaveContrasts(stg,sess,cfg)

if ~exist(sprintf("Saved_Data\\%s_stimImages",sess.subNum), 'dir')
       mkdir(sprintf("Saved_Data\\%s_stimImages",sess.subNum))
end

[~,stg.contrStep,stg.contrLowest] = genContrast_questTo50only("Pilot", 7, stg, cfg);

for i = 1:cfg.design.nConds

    contrast = stg.contrLowest + (i *stg.contrStep ) ;

    gaborTex = CreateProceduralGabor(sess.ptb.w, stg.stimDim, stg.stimDim, [], ...
    [0.5 0.5 0.5 1.0], cfg.gabor.disableNorm, cfg.gabor.preContrastMult);
    gaborProperties = [0, stg.stimFreq, stg.stimDim/7 , contrast, 1.0, 0, 0, 0];

    Screen('DrawTexture', sess.ptb.w, gaborTex, [], [],...
                cfg.gabor.angle, [], [], [], [], kPsychDontDoRotation, gaborProperties);
    readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
    Screen('Flip',sess.ptb.w) ;

    if exist(sprintf("Saved_Data\\%s_stimImages\\exampleStimulus_%d.png",sess.subNum,i), 'file')
        delete(sprintf("Saved_Data\\%s_stimImages\\exampleStimulus_%d.png",sess.subNum,i))        
    end
    savePTBScreen(sess.ptb.w,sprintf("Saved_Data\\%s_stimImages\\exampleStimulus_%d.png",sess.subNum,i))
end

Screen('Flip',sess.ptb.w) ;

