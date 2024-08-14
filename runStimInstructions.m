function runStimInstructions(stg,sess,cfg)

mainWindow = sess.ptb.w ;
black = [ 0 0 0 ] ; 
x = sess.ptb.x ;
y = sess.ptb.y ;
instructionText1 = ['You will be shown continuous visual noise that looks like static on a TV.' ...
             '\n\nPatterns of diagonal lines called Gabor gratings will appear in the noise.\n\n' ...
             'Your task is to see whether they are \noriented to the "left" or "right".' ...
             '\n\nPress any key to continue.'];
instructionText2 = ['This is what the noise stimulus will look like.' ...
                    '\n\nPress any key to continue.'];
instructionText3 = ['This is an example of a Gabor grating.' ...
                    '\nThis grating is oriented to the "right".' ...
                    '\n\nPress the right arrow key "->" to continue.'];
instructionText4 = ['This is an example of a grating oriented to the "left".' ...
                    '\n\n\nPress the left arrow key "<-" to continue.'];
instructionText5 = 'Which way is this grating oriented? \n\n(Answer correctly 3 times to continue)';
instructionText6 = ['You will be shown gratings that appear for only a brief moment,' ...
                    '\nsome will be easily visible and some will be harder to see.' ...
                    '\n\nTry determining the direction of the next grating.'...
                    '\n\nPress any key to continue.'];
instructionText7 = ['For each trial in this experiment you will briefly ' ...
    'be shown a gabor grating embedded in noise. \n\nAfter each trial, report the orientation of the grating using the left or right ' ...
    'arrow keys.\n\nIf you have no idea, give it your best effort. You will need to pick one to move on.' ...
    '\n\nPress any key to continue.'];


%First instruction
Screen('TextSize', mainWindow, 40);                                                % Set text size
     DrawFormattedText(mainWindow, instructionText1, 'center', 'center', black, 80);    % draw text, set location, color, coordinates
     Screen('Flip', mainWindow);                                                        % pull back da curtain
     KbWait([],2);

% Prep Gabor and Noise
noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
gaborTex = CreateProceduralGabor(sess.ptb.w, stg.stimDim, stg.stimDim, [], ...
    [0.2 0.2 0.2 0.0], cfg.gabor.disableNorm, cfg.gabor.preContrastMult);
gaborProperties = [0, stg.stimFreq, stg.stimDim/7 , 0.8, 1.0, 0, 0, 0];
twoAfcAnswered = 0; lastKey = "";

% Show Noise instruction
f = 0; kbTmp = 0;
while ~kbTmp
    frameStart = GetSecs ;
    f = f+1;
        oldNoiseTex = noiseTex;
        noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
        DrawFormattedText(mainWindow, instructionText2, 'center', 3*y/4, black, 80);
        Screen('Close',oldNoiseTex) ;
    lastKey = checkLastKey(mainWindow) ;
    if f > 8
        kbTmp = ~(lastKey == 0) ;
    end
    waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
    Screen('Flip', sess.ptb.w) ;
end

% Show Right Gabor
Screen('DrawTexture', sess.ptb.w, gaborTex, [], [],...
                            180-cfg.gabor.angle, [], [], [], [], kPsychDontDoRotation, gaborProperties);
DrawFormattedText(mainWindow, instructionText3, 'center', 3*y/4, black, 80);
Screen('Flip', sess.ptb.w) ;
kbTmp = 0;
while ~kbTmp
    lastKey = checkLastKey(mainWindow) ;
    kbTmp = lastKey == 39 ;
end

% Show Left Gabor
Screen('DrawTexture', sess.ptb.w, gaborTex, [], [],...
                            cfg.gabor.angle, [], [], [], [], kPsychDontDoRotation, gaborProperties);
DrawFormattedText(mainWindow, instructionText4, 'center', 3*y/4, black, 80);
Screen('Flip', sess.ptb.w) ;
kbTmp = 0;
while ~kbTmp
    lastKey = checkLastKey(mainWindow) ;
    kbTmp = lastKey == 37 ;
end

% Show gabor in noise
nCorrect = 0 ;
while nCorrect < 3

    if round(rand()) %is 1
        orientGabor = 180-cfg.gabor.angle;
        correctKeyPress = 39;
    else %is 0
        orientGabor = cfg.gabor.angle;
        correctKeyPress = 37;
    end
    
    kbTmp = 0; f = 0;
    while ~kbTmp
        f = f + 1;
        frameStart = GetSecs ;    
        
        Screen('DrawTexture', sess.ptb.w, gaborTex, [], [],...
                            orientGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
        oldNoiseTex = noiseTex;
        noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
        Screen('Close',oldNoiseTex) ;
        DrawFormattedText(mainWindow, instructionText5, 'center', 3*y/4, black, 80);
        
       if f > 8
           lastKey = checkLastKey(mainWindow);
           kbTmp = lastKey == correctKeyPress ;
       end
       waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
       Screen('Flip', sess.ptb.w) ;     
    end

    if lastKey == correctKeyPress
        DrawFormattedText(mainWindow, 'Correct!\n\n Press any key to continue...', 'center', 'center', black, 80);         % showing more instruction text (6), doing same kbWait
        Screen('Flip', mainWindow);
        KbWait([],2);
        nCorrect = nCorrect+1 ;
    else
        DrawFormattedText(mainWindow, 'Wrong key... Try again.\n\n Press any key to continue...', 'center', 'center', black, 80);         % showing more instruction text (6), doing same kbWait
        Screen('Flip', mainWindow);
        KbWait([],2);
    end
end

% brief stim description
    DrawFormattedText(mainWindow, instructionText6, 'center', 'center', black, 80);         % showing more instruction text (6), doing same kbWait
    Screen('Flip', mainWindow);
    KbWait([],2);

% Show gabor in noise briefly
nCorrect = 0 ;
while nCorrect < 3

    if round(rand()) %is 1
        trls.orientationPerTrial(1) = 180-cfg.gabor.angle;
    else %is 0
        trls.orientationPerTrial(1) = cfg.gabor.angle;
    end

    %setup
    trls.frameJitterPerTrial(1) = 1 ;
    trls.jitterXPerTrial(1) = sess.ptb.rect(3)/2 ;
    trls.jitterYPerTrial(1) = sess.ptb.rect(4)/2;
    sess.ptb.missed = 0 ;
    
    acc = runTrial(1, -0.8, "Quest", trls, stg, sess, cfg,0) ; 

    if acc
        if nCorrect == 0
            DrawFormattedText(mainWindow, 'Correct!\n\n Press any key to move on...', 'center', 'center', black, 80);         % showing more instruction text (6), doing same kbWait
        else
            DrawFormattedText(mainWindow, sprintf('Correct! Try answering %d more.\n\n Press any key to continue...',(3-nCorrect)), 'center', 'center', black, 80);         % showing more instruction text (6), doing same kbWait
        end
        Screen('Flip', mainWindow);
        KbWait([],2);
        nCorrect = nCorrect+1 ;
    else
        DrawFormattedText(mainWindow, 'Wrong key... Try again.\n\n Press any key to continue...', 'center', 'center', black, 80);         % showing more instruction text (6), doing same kbWait
        Screen('Flip', mainWindow);
        KbWait([],2);
    end
end

% design description
    Screen('TextSize', mainWindow, 40);
    DrawFormattedText(mainWindow, instructionText7, 'center', 'center', black, 80);     %  more instructions (7)
    Screen('Flip', mainWindow);
    KbWait([],2);

end
