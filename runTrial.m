function [twoAfcAcc, responseTime, pasResponse, missed] = runTrial(t, contrastVal, blockType, trls, stg, sess, cfg, missed)

% This function is where most of the magic happens ~ all of the general and 
% trial design specific settings are used to render the continuous noise
% and trial stimuli, to send codes, and to ask for and store responses


%% Trial Setup
% Defaults
contrastLv = 0 ;
twoAfcAnswered = 0 ; pasAnswered = 0 ;
twoAfcAcc = 0 ; responseTime = 0 ; pasResponse = 0 ;
% distractor = 
codesActive = 0 ;

% block-specific settings
switch blockType
    case "Quest"
        buffer = stg.rBufferFrames ;
        pasAnswered = 1 ;
    case "Pilot"
        buffer = stg.rBufferFrames ;
        contrastLv = trls.contrastPerTrial(t) ;
    case "Report"
        buffer = stg.rBufferFrames ;
        contrastLv = trls.contrastPerTrial(t) ;
        codesActive = 1 ;
    case "No Report"
        buffer = stg.rBufferFrames ;
        twoAfcAnswered = 1 ; pasAnswered = 1 ;
        contrastLv = trls.contrastPerTrial(t) ;
        
        codesActive = 1 ;
end

% settings for orientation of gabor
if trls.orientationPerTrial(t) %is 1
    orientGabor = 180-cfg.gabor.angle;
    correctKeyPress = 39;
    stimTrigger = stg.trigger.stim.rightblank + contrastLv ;
else %is 0
    orientGabor = cfg.gabor.angle;
    correctKeyPress = 37;
    stimTrigger = stg.trigger.stim.leftblank + contrastLv ;
end

% init some convenient stim settings before presenting frame-by-frame
ifi = sess.ptb.ifi ;
noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
gaborTex = CreateProceduralGabor(sess.ptb.w, stg.stimDim, stg.stimDim, [], ...
    [0.5 0.5 0.5 1.0], cfg.gabor.disableNorm, cfg.gabor.preContrastMult);
gaborProperties = [0, stg.stimFreq, stg.stimDim/7 , contrastVal, 1.0, 0, 0, 0];
refreshBottom = (cfg.noise.sRefresh-0.0015);
refreshTop = (cfg.noise.sRefresh+0.0015);


% BEGIN DISPLAYING TRIAL
%% Noise-only buffer period
f = 0; kbTmp = 0; 
while f < ( buffer + trls.frameJitterPerTrial(t) )
    if f>1
            frameTime = (GetSecs-frameStart);
            missed = missed + ~(refreshTop >  frameTime && refreshBottom < frameTime) ;
    end
    frameStart = GetSecs ;
    f = f+1;

    oldNoiseTex = noiseTex;
    noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
    Screen('Close',oldNoiseTex) ;
    if sess.debugMode == "Yes"
        DrawFormattedText(sess.ptb.w, sprintf(['Block Type: %s\n\n', ...
                                               'Contrast Value: %0.3f\n\n', ...
                                               'Contrast Level: %d\n\n', ...
                                               'Missed Frames: %d\n\n'],blockType,contrastVal,contrastLv,missed), sess.ptb.x/1.35, sess.ptb.y/10, [ 0 0 0 ], 40);
    end

    checkLastKey(sess.ptb.w);
    waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
    Screen('Flip', sess.ptb.w) ;
end

%% Stimulus Display Period 
stimStart = GetSecs ;
while f < (buffer + trls.frameJitterPerTrial(t) + stg.stimFrames)
    frameTime = (GetSecs-frameStart);
    missed = missed + ~(refreshTop >  frameTime && refreshBottom < frameTime) ;
    frameStart = GetSecs ;
    f = f+1;

    
        Screen('DrawTexture', sess.ptb.w, gaborTex, [], CenterRectOnPoint(stg.stimRect, trls.jitterXPerTrial(t), trls.jitterYPerTrial(t)),...
                            orientGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
        oldNoiseTex = noiseTex;
        noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
        Screen('Close',oldNoiseTex) ;
        if sess.debugMode == "Yes"
            DrawFormattedText(sess.ptb.w, sprintf(['Block Type: %s\n\n', ...
                                               'Contrast Value: %0.2f\n\n', ...
                                               'Contrast Level: %d\n\n', ...
                                               'Missed Frames: %d\n\n'],blockType,contrastVal,contrastLv,missed), sess.ptb.x/1.35, sess.ptb.y/10, [ 0 0 0 ], 40);
        end
    
    
    checkLastKey(sess.ptb.w);
    waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
    Screen('Flip',sess.ptb.w) ;
end

%% Post-stimulus Noise-only Buffer (listens for response)
while f < (2* buffer + trls.frameJitterPerTrial(t) + stg.stimFrames) && ~twoAfcAnswered
    frameTime = (GetSecs-frameStart);
    missed = missed + ~(refreshTop >  frameTime && refreshBottom < frameTime) ;
    frameStart = GetSecs ;
    f = f+1 ;

    
        oldNoiseTex = noiseTex;
        noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
        Screen('Close', oldNoiseTex) ; 
        if sess.debugMode == "Yes"
            DrawFormattedText(sess.ptb.w, sprintf(['Block Type: %s\n\n', ...
                                               'Contrast Value: %0.2f\n\n', ...
                                               'Contrast Level: %d\n\n', ...
                                               'Missed Frames: %d\n\n'],blockType,contrastVal,contrastLv,missed), sess.ptb.x/1.35, sess.ptb.y/10, [ 0 0 0 ], 40);
        end

    lastKey = checkLastKey(sess.ptb.w) ;
    if ~twoAfcAnswered && ismember(lastKey,cfg.kbd.twoAfcKeys)
        twoAfcAnswered = 1 ;
        twoAfcAcc = lastKey == correctKeyPress;
        responseTime = stimStart - GetSecs ;
        sendTrigger(triggerFromKeyPress(lastKey,twoAfcAcc))
    end
    waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
    Screen('Flip',sess.ptb.w) ;
    
end

%% Two Way Forced Choice Question Text
while ~twoAfcAnswered
frameStart = GetSecs ;
    f = f+1 ;

    
        oldNoiseTex = noiseTex;
        noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
        DrawFormattedText(sess.ptb.w, '"<-" or "->".', 'center', sess.ptb.y/1.3, [0 0 0], 80);
        Screen('Close', oldNoiseTex) ;
        if sess.debugMode == "Yes"
            DrawFormattedText(sess.ptb.w, sprintf(['Block Type: %s\n\n', ...
                                               'Contrast Value: %0.2f\n\n', ...
                                               'Contrast Level: %d\n\n', ...
                                               'Missed Frames: %d\n\n'],blockType,contrastVal,contrastLv,missed), sess.ptb.x/1.35, sess.ptb.y/10, [ 0 0 0 ], 40);
        end
    

    lastKey = checkLastKey(sess.ptb.w) ;
    if ismember(lastKey,cfg.kbd.twoAfcKeys)
        twoAfcAnswered = 1 ;
        twoAfcAcc = lastKey == correctKeyPress;   
        responseTime = stimStart - GetSecs ;
        sendTrigger(triggerFromKeyPress(lastKey,twoAfcAcc))
    end
    waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
    Screen('Flip',sess.ptb.w) ;
    if f > 1 && codesActive
        sendTrigger(stg.trigger.text.tafc)
    end

end

%% PAS Question Text
while ~pasAnswered
frameStart = GetSecs ;
    f = f+1 ;

    
        oldNoiseTex = noiseTex;
        noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
        DrawFormattedText(sess.ptb.w, ['Rate your perceptual experience.' ...
                    '\n\nPress one of  "1"  "2"  "3"  "4"'], 'center', sess.ptb.y/1.3, [0 0 0], 80);
        Screen('Close', oldNoiseTex) ;
        if sess.debugMode == "Yes"
            DrawFormattedText(sess.ptb.w, sprintf(['Block Type: %s\n\n', ...
                                               'Contrast Value: %0.2f\n\n', ...
                                               'Contrast Level: %d\n\n', ...
                                               'Missed Frames: %d\n\n'],blockType,contrastVal,contrastLv,missed), sess.ptb.x/1.35, sess.ptb.y/10, [ 0 0 0 ], 40);
        end
    

    lastKey = checkLastKey(sess.ptb.w) ;
    if ismember(lastKey,cfg.kbd.pasKeys) 
        pasAnswered = 1 ;
        pasResponse = lastKey - 48; % turns keycode for top row number keys into just the integer value
        sendTrigger(triggerFromKeyPress(lastKey,0))
    end
    waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
    Screen('Flip',sess.ptb.w) ;
    if f > 1 && codesActive
        sendTrigger(stg.trigger.text.pas)
    end

end

%% Trial Over
end