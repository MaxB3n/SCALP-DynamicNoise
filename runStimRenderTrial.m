function [twoAfcAcc, responseTime, pasResponse, missed] = runTrial(contrastVal, trls, stg, sess, cfg)

%noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
gaborTex = CreateProceduralGabor(sess.ptb.w, stg.stimDim, stg.stimDim, [], ...
    [0.5 0.5 0.5 1.0], cfg.gabor.disableNorm, cfg.gabor.preContrastMult);
gaborProperties = [0, stg.stimFreq, stg.stimDim/7 , contrastVal, 1.0, 0, 0, 0];

Screen('DrawTexture', sess.ptb.w, gaborTex, [], CenterRectOnPoint(stg.stimRect, trls.jitterXPerTrial, trls.jitterYPerTrial),...
                orientGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
%noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);

Screen('Flip',sess.ptb.w) ;

%% Trial Over
end