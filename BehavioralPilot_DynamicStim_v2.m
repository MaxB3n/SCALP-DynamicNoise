% ListenChar(0);  ### run this command w/ right-click or press CTRL-C if keyboard stops
% responding to input after exiting mid-run ###

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written 07/03/2024 by Max Bennett (maxwellbennett@proton.me)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PARAMETERS %%

% EXPERIMENTAL DESIGN PARAMETERS %
nTrials = 56;               %> Number of trials per condition (per stim strength). Choose an even multiple of nSteps
nSteps = 7;                 %> Number of different stim strengths, should be odd number.
nStepsFromThreshold = 2;    %> Quest should obtain the stim strength for threshold
                            % perception and one higher accuracy value, ex 90% seen. This
                            % variable sets the number of steps or intervals the higher
                            % acc stim strength should be from threshold; minimum 1.
includeBlanks = 0;          %> Whether or not to show blanks.
showInstructions = 1;       %> Whether or not to show instructions.


% DISPLAY SETTINGS %
ppd = 30;                   %> Pixels per degree (set @ 30 for 1080p 24in monitor and
                            % 57in viewing distance or similar).
x = 1920;                   %> Pixels on X and Y axes (ex 1920 x 1080 for 1080p monitor).
y = 1080;                   %

% STIM SETTINGS %
%  Gabor
preContrastMultiplier = 0.50 ;
stimTime = 0.1;             %> Duration of stimulus in sec, ~ 100 ms.

dimGabor = 5*ppd;           %> Size of gabor texture in pixels (x & y); after applying
                            % gaussian envelope, diameter of stim is a little smaller.
angleGabor = 45;            %> Orientation in degrees (will be horizontally reflected).
cyclGabor = 15;             %
contrGabor = 0.85;          %
freqGabor = cyclGabor/dimGabor; %
sigma = dimGabor / 7;       %> Sigma of gaussian envelope ~ the radial fade.
aspectGabor = 1.0;          %
phaseGabor = 0;             %
backgroundOffset = [0 0 0 0];   % Alternatively try [0.2 0.2 0.2 0.0];
disableNorm = 1;            %
%  Jitter
bufferTime = 0.7;           %> Time in sec to buffer before and after stim, excl jitter.
jitterTime = 0.4;           %> Time in sec from earliest to latest stim onset.
jitterSpace = 2*ppd;        %> Distance in pixels between most extreme stim positions in
                            % each x, y dimension.
%  Noise
noiseType = 'static';       %> 'Static' or 'procedural'; 'procedural' uses
                            % CreateProceduralNoise() to generate an OpenGL texture,
                            % 'static' uses a simple array of pixel luminances produced
                            % by round(rand(dimNoise)*255).
transpNoise = 127;          %> Transparency of the noise as an 8 bit value.
dimNoise = 12 * ppd;        %> Size of the noise box in pixels.
freqNoise = 2;              %> The 'fuzziness' of the noise; higher is fuzzier.
refreshNoise = 2;           %> The number of frames to wait before refreshing noise.

% RESPONSE SETTINGS %
twoAfcKeys = ["RightArrow", "LeftArrow"] ;       %> This reqs KbName(); LeftArrow: 37, RightArrow: 39
                            % Alternatively, [37,39]
pasKeys = ["1!", "2@", "3#", "4$"];    %> Same as above; "1!": 49, "2@": 50, "3#": 51, "4$": 52
                            % Alternatively, [49,50,51,52];
saveFolder = "Saved_Data/";
% Add Helper functions to path
parentFolder = fileparts(which(matlab.desktop.editor.getActiveFilename));
addpath(strcat([parentFolder,'/Helpers']));

% INSTRUCTION TEXT %
instructionText1 = ['You will be shown continuous visual noise \nthat looks like static on a TV.' ...
             '\n\nPatterns of diagonal lines called \nGabor gratings will appear in the noise.\n\n' ...
             'Your task is to see whether they are \noriented to the "left" or "right".' ...
             '\n\nPress any key to continue.'];
instructionText2 = ['This is what the noise stimulus will look like.' ...
                    '\n\nPress any key to continue.'];
instructionText3 = ['This is an example of a Gabor grating.' ...
                    '\nThis grating is oriented to the "right".' ...
                    '\n\nPress the right arrow key "->" to continue.'];
instructionText4 = ['This is an example of a grating oriented to the "left".' ...
                    '\n\n\nPress the left arrow key "<-" to continue.'];
instructionText5 = ['Which way is this grating oriented?' ...
                    '\n\nPress the correct arrow key, "<-" or "->" 3 times to continue.'];
instructionText6 = ['You will be shown gratings that appear for only a brief moment, ' ...
                    '\nsome will be easily visible and some will be harder to see.' ...
                    '\n\nTry determining the direction of the next grading.'...
                    '\n\nPress any key to continue.'];
instructionText7 = ['For each trial in this part of the experiment you will \nbriefly ' ...
    'be shown a gabor grating embedded in noise. \n\nAfter each ' ...
    'trial, report the orientation of the grating \nusing the left or right ' ...
    'arrow keys.\n\nThere will be ', num2str(nSteps), ' rounds of ', num2str(nTrials), ...
    ' trials.\n\nPress any key to continue.'];

% DIALOG BOX %
questions = {'SUBJECT NUMBER?', 'QUEST 50% CONTRAST', 'QUEST 90% CONTRAST'};
defaults = {'XXX','0','0'};
answers = inputdlg(questions, 'DialogueBox', 1, defaults);
subject = answers{1};
Quest50 = str2num(answers{2});
Quest90 = str2num(answers{3});
subNum = str2num(subject);

%% PTB %%
presentationScreen = min(Screen('Screens')); % ry monitor, if one exists
screenRect = Screen('Rect', presentationScreen);   % get local rect of window or screen called presentationScreen
KbName('UnifyKeyNames');
% suppress output of keypresses in the command window
ListenChar(2);
try
    % More PTB
    AssertOpenGL; % break and issue error message if the installed Psychtoolbox is not based on OpenGL or Screen() is not working properly
    Screen('Preference', 'SkipSyncTests', 1);
    %Screen('Preference','SuppressAllWarnings', 1);
    Screen('Preference', 'VisualDebugLevel', 4);
    screenNumber = max(Screen('Screens'));
    white = WhiteIndex(screenNumber);
    grey = white / 2;
    black = [0 0 0];
    red = [200 50 50];

    backgroundColor = [grey grey grey];

    [mainWindow, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2,...
  [], [],  kPsychNeed32BPCFloat);
    Screen('BlendFunction', mainWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    ifi = Screen('GetFlipInterval', mainWindow );
    framesGabor = round(stimTime / ifi);
    % hide cursor
    HideCursor;

    % format start window
    Screen('TextSize', mainWindow, 20);
    DrawFormattedText(mainWindow, 'loading images....', 'center', 10, black, 80);
    Screen('Flip', mainWindow);
    % check resolution
    [screenX, screenY] = Screen('WindowSize', mainWindow);

 if showInstructions
    %% Main instructions %%

     % Intro
     Screen('TextSize', mainWindow, 40);                                                % Set text size
     DrawFormattedText(mainWindow, instructionText1, 'center', 'center', black, 80);    % draw text, set location, color, coordinates
     Screen('Flip', mainWindow);                                                        % pull back da curtain
     KbWait([],2);  % pauses until keyboard input, these arguments wait until any pressed
                    % keys are released and another key is pressed.
                    % need this so it doesn't jump through consecutive KbWaits

     % noise example
     kbTmp = 0; i = 0;                            % refreshes every frame, set frame counter to 0 and kbTemp to 0
     noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise, freqNoise);
     while ~kbTmp
         i = i+1;
         if ~mod(i,refreshNoise)                                             % checks if the frame is a multiple of the noise refresh rate
            oldNoiseTex = noiseTex;                                          % makes new noise texture, draws instruction text, keeps noise texture going without clogging memory
            noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise, freqNoise);
            DrawFormattedText(mainWindow, instructionText2, 'center', x/2, black, 80);
            Screen('Flip', mainWindow);
            Screen('Close', oldNoiseTex);
        end
         pause(ifi);
         if i > 10
            kbTmp = KbCheck;    % checks if there is a key pressed down, to make sure consecutive key presses dont mess it up
         end
     end

    % gabor right
    GaborTex = CreateProceduralGabor(mainWindow, dimGabor, dimGabor, [],...              % makes gabor
    backgroundOffset, disableNorm, preContrastMultiplier);
    gaborProperties = [phaseGabor, freqGabor, sigma, contrGabor, aspectGabor, 0, 0, 0]; % randomise the phase of the Gabors and make a properties matrix.
    rectGabor = [(windowRect(3)-dimGabor)/2 (windowRect(4)-dimGabor)/2 (windowRect(3) + dimGabor)/2 (windowRect(4) + dimGabor)/2 ];

    Screen('DrawTexture', mainWindow, GaborTex, [], [] ,...
    180-angleGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
    DrawFormattedText(mainWindow, instructionText3, 'center', x/2, black, 80);
    Screen('Flip', mainWindow);
    kbNameTmp = "";
    while kbNameTmp ~= "RightArrow" || (kbNameTmp == "ESCAPE")
        [~, kbCodeTmp] = KbWait([],2);
        kbNameTmp = KbName(kbCodeTmp);
    end
    if kbNameTmp == "ESCAPE"
        abortExperiment;
    end

    % gabor left
    Screen('DrawTexture', mainWindow, GaborTex, [], [] ,...
    angleGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
    DrawFormattedText(mainWindow, instructionText4, 'center', x/2, black, 80);
    Screen('Flip', mainWindow);
    pause(10*ifi);
    while kbNameTmp ~= "LeftArrow" || (kbNameTmp == "ESCAPE")
        [~, kbCodeTmp] = KbWait([],2);
        kbNameTmp = KbName(kbCodeTmp);
    end
    if kbNameTmp == "ESCAPE"
        abortExperiment;
    end


    % constant gabor in noise
    if rand>0.5
        orientGabor = 180-angleGabor;       % randomizing the orientation of the gabor (coin flip left or right, rand 0-1, .5 in between)
        orientKey = "RightArrow";
    else
        orientGabor = angleGabor;
        orientKey = "LeftArrow";
    end

    kbNameTmp = "";  kbTmp = 0; i = 0;      % drawing gabor + noise, refreshing noise, showing gabor continuously)
    while kbNameTmp ~= orientKey || (kbNameTmp == "ESCAPE")            % keeping track of key presses and if they pressed the right key
         i = i+1;
         if ~mod(i,refreshNoise)
            oldNoiseTex = noiseTex;
            noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise, freqNoise);
            Screen('DrawTexture', mainWindow, GaborTex, [], [] ,...
            orientGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
            Screen('DrawTexture', mainWindow, noiseTex);
            DrawFormattedText(mainWindow, instructionText5, 'center', (x)/2, black, 80);
            Screen('Flip', mainWindow);
            Screen('Close', oldNoiseTex);
         end

         pause(ifi);
         kbTmp = KbCheck;           % checks for l/r button presses, waits 10 frames
         if i > 10 && kbTmp
            [~,~,kbCodeTmp] = KbCheck;
            kbNameTmp = KbName(kbCodeTmp);
         end
    end
    if kbNameTmp == "ESCAPE"
        abortExperiment;
    end

    % brief stim description
    DrawFormattedText(mainWindow, instructionText6, 'center', 'center', black, 80);         % showing more instruction text (6), doing same kbWait
    Screen('Flip', mainWindow);
    KbWait([],2);

    % brief gabor in noise

correctResponses = 0;

while correctResponses < 3
    if rand>0.5
        orientGabor = 180-angleGabor;           %  showing gabor, randomized right/left oriented, person needs to press correct arrow
        orientKey = "RightArrow";
    else
        orientGabor = angleGabor;
        orientKey = "LeftArrow";
    end

    kbNameTmp = "";  kbTmp = 0; i = 0;
    while kbNameTmp ~= orientKey || (kbNameTmp == "ESCAPE")
         i = i+1;

         if mod( idivide(int16(i),int16(4)) + 16, 20) == 0
           Screen('DrawTexture', mainWindow, GaborTex, [], [] ,...
              orientGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
           DrawFormattedText(mainWindow, instructionText5, 'center', (x)/2, black, 80);
         end

         if ~mod(i,refreshNoise)
            oldNoiseTex = noiseTex;
            noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise, freqNoise);
            Screen('Flip', mainWindow);
            Screen('Close', oldNoiseTex);
            DrawFormattedText(mainWindow, instructionText5, 'center', (x)/2, black, 80);
         end

         pause(ifi);
         kbTmp = KbCheck;
         if i > 10 && kbTmp
            [~,~,kbCodeTmp] = KbCheck;
            kbNameTmp = KbName(kbCodeTmp);
         end
    end
    if kbNameTmp == "ESCAPE"
        abortExperiment;
    end
    correctResponses = correctResponses + 1                 %  participants have to wait til they answer 3 correct trials to move on, their correct responses add up each time
end

    % design description
    Screen('TextSize', mainWindow, 40);
    DrawFormattedText(mainWindow, instructionText7, 'center', 'center', black, 80);     %  more instructions (7)
    Screen('Flip', mainWindow);
    KbWait([],2);

 end

 %% Init
 % Init Response Recording %
        orientRecordPerTrial = string(zeros(nSteps*nTrials,1));
        accRecordPerTrial = string(zeros(nSteps*nTrials,1));
        respRecordPerTrial = string(zeros(nSteps*nTrials,1));
        pasRecordPerTrial = string(zeros(nSteps*nTrials,1));

% Init Stim Timing and Location %
        bufferFrames = round(bufferTime/ifi); jitterFrames = round(jitterTime/ifi); stimFrames = round(stimTime/ifi);
        trialFrames = (bufferFrames*2) + jitterFrames + stimFrames;
        stimRect = [(windowRect(3)-dimGabor)/2 (windowRect(4)-dimGabor)/2 (windowRect(3) + dimGabor)/2 (windowRect(4) + dimGabor)/2 ];

% Set Stim Jitter %
        for i = 1:(nTrials*nSteps)
            FrameJitterPerTrial(i) = randi([1 jitterFrames]) ;
            XJitterPerTrial(i) = randi([(windowRect(3)-jitterSpace)/2 (windowRect(3)+jitterSpace)/2]) ;
            YJitterPerTrial(i) = randi([(windowRect(4)-jitterSpace)/2 (windowRect(4)+jitterSpace)/2]) ;
        end

% Set Stim Orientations %
        orientationPerTrial = repmat(0:1,1,nSteps*nTrials/2);
        orientationPerTrial = orientationPerTrial(randperm(nSteps*nTrials));

% Set Stim Contrast Levels %
        contrastPerTrial = repmat(0:6,1,nSteps*nTrials/7);
        contrastPerTrial = contrastPerTrial(randperm(nSteps*nTrials));

        contrStep = (Quest90 - Quest50)/nStepsFromThreshold;
        contrLowest = Quest50 - contrStep*((nSteps-1)/2);
 %% Begin main block loop %%
    for d = 1:nSteps
 % Get Ready... Screen
 Screen('TextSize', mainWindow, 40);
 DrawFormattedText(mainWindow, 'Press any key when you are ready to begin.', 'center', 'center', black, 80);
 Screen('Flip', mainWindow);
 KbWait([],2);

    %% Begin trial-by-trial loop %%
         for t = 1:nTrials
             trial = d*nTrials + t;

             % Set jitter
             %frameJitter = randi([1 round(jitterTemporal/ifi)]) ;
             %stimFrames = (stimFrameOnset + frameJitter):(stimFrameOnset+frameJitter+stimFrameLength-1) ;
             rectGabor = [(windowRect(3)-dimGabor)/2 (windowRect(4)-dimGabor)/2 (windowRect(3) + dimGabor)/2 (windowRect(4) + dimGabor)/2 ];
             spaceJitterX = randi([(windowRect(3)-jitterSpace)/2 (windowRect(3)+jitterSpace)/2]) ;
             spaceJitterY = randi([(windowRect(4)-jitterSpace)/2 (windowRect(4)+jitterSpace)/2]) ;
             centerGabor = CenterRectOnPoint(rectGabor, spaceJitterX, spaceJitterY);

             % Set orientation
             if orientationPerTrial(trial) %is 1
                 orientGabor = 180-angleGabor; correctKeyPress = "RightArrow";
                 orientRecordPerTrial(trial) = "R";
             else %is 0
                 orientGabor = angleGabor; correctKeyPress = "LeftArrow";
                 orientRecordPerTrial(trial) = "L";
             end

             % Set contrast
             contrast = contrLowest + (contrastPerTrial(trial)*contrStep);

             % Make gabor texture for this trial
             gaborTex = CreateProceduralGabor(mainWindow, dimGabor, dimGabor, [],...
                     backgroundOffset, disableNorm, preContrastMultiplier);
             gaborProperties = [phaseGabor, freqGabor, sigma, contrast, aspectGabor, 0, 0, 0];
             twoAfcAnswered = 0; pasAnswered = 0; lastKey = "";

            % Present noise during buffer time
            f = 0; kbTmp = 0;
            noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise, freqNoise);
            while f < (bufferFrames + FrameJitterPerTrial(trial)) && lastKey ~= "ESCAPE"
                f = f+1;

                if ~mod(f,refreshNoise)
                    oldNoiseTex = noiseTex;
                    noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise, freqNoise);
                    Screen('Flip', mainWindow);
                    Screen('Close',oldNoiseTex);
                end

                kbTmp = KbCheck;
                if kbTmp
                    [~,~,kbCodeTmp] = KbCheck; % waits for subject to respond with keypress
                    if sum(kbCodeTmp) == 1
                        lastKey = KbName(kbCodeTmp);
                    end
                end
            end

            % Show Stimulus
            while  f < (bufferFrames + FrameJitterPerTrial(trial) + stimFrames-1) && lastKey ~= "ESCAPE"
                f = f+1;

                if ~mod(f,refreshNoise)
                    Screen('DrawTexture', mainWindow, gaborTex, [], CenterRectOnPoint(stimRect, XJitterPerTrial(trial), YJitterPerTrial(trial)),...
                        orientGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
                    oldNoiseTex = noiseTex;
                    noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise,freqNoise);
                    Screen('Flip', mainWindow);
                    Screen('Close',oldNoiseTex);
                end

                kbTmp = KbCheck;
                if kbTmp
                    [~,~,kbCodeTmp] = KbCheck; % waits for subject to respond with keypress
                    if sum(kbCodeTmp) == 1
                        lastKey = KbName(kbCodeTmp);
                    end
                end
            end

            % Post Trial buffer
            while f < (trialFrames) && lastKey ~= "ESCAPE"
                f = f+1;

                if ~mod(f,refreshNoise)
                    oldNoiseTex = noiseTex;
                    noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise,freqNoise);
                    Screen('Flip', mainWindow);
                    Screen('Close',oldNoiseTex);
                end

                kbTmp = KbCheck;
                if kbTmp
                    [~,~,kbCodeTmp] = KbCheck; % waits for subject to respond with keypress
                    if sum(kbCodeTmp) == 1
                        lastKey = KbName(kbCodeTmp);
                    end
                end
            end


    % subject response prompt
    while  (~twoAfcAnswered || ~pasAnswered) && (lastKey ~= "ESCAPE")
        f = f+1;

        % show response prompt
        if ~mod(f,refreshNoise)
            oldNoiseTex = noiseTex;
            noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise,freqNoise);
            if ~twoAfcAnswered
                DrawFormattedText(mainWindow, ['Which way was the grading oriented?' ...
                        '\n\nPress "<-" or "->".'], 'center', (x)/2, black, 80);
            else
                DrawFormattedText(mainWindow, ['Rate your perceptual experience.' ...
                    '\n\nPress one of  "1"  "2"  "3"  "4"'], 'center', (x)/2, black, 80);
            end
            Screen('Flip', mainWindow);
            Screen('Close', oldNoiseTex);
        end

        % record responses
        tic;
        kbTmp = KbCheck;
        if kbTmp
            [~,~,kbCodeTmp] = KbCheck;
            lastKey = KbName(kbCodeTmp);
            if ~twoAfcAnswered && ismember(lastKey,twoAfcKeys)
                twoAfcAnswered = 1;
                accRecordPerTrial(trial) = lastKey == correctKeyPress;
                respRecordPerTrial(trial) = toc;
            elseif ismember(lastKey, pasKeys)
                pasAnswered = 1;
                pasRecordPerTrial(trial) = lastKey;
            end
        end
    end

           while  ~twoAfcAnswered && (lastKey ~= "ESCAPE")
                f = f+1;

                if ~mod(f,refreshNoise)
                    oldNoiseTex = noiseTex;
                    noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise,freqNoise);

                        DrawFormattedText(mainWindow, ['Which way was the grading oriented?' ...
                                '\n\nPress "<-" or "->".'], 'center', (x)/2, black, 80);

                    Screen('Flip', mainWindow);
                    Screen('Close', oldNoiseTex);
                end

                kbTmp = KbCheck;
                if kbTmp
                    [~,~,kbCodeTmp] = KbCheck;
                    lastKey = KbName(kbCodeTmp);
                    if ismember(lastKey,twoAfcKeys)
                        twoAfcAnswered = 1;
                        accRecordPerTrial(trial) = lastKey == correctKeyPress;
                        respRecordPerTrial(trial) = toc;
                    end
                end
           end

            if lastKey == "ESCAPE"
                abortExperiment;
            end

         end


     end
 catch
    ple;
end
ListenChar;

% Write repsponses
summaryTable = array2table(cat(2, string(contrastPerTrial).', orientRecordPerTrial,accRecordPerTrial, ...
    pasRecordPerTrial,respRecordPerTrial),'VariableNames',{'Contrast','Orientation','Accuracy','Pas_Response','2afc_Response_Time'});
try
file = strjoin([parentFolder, '/', saveFolder, 'subject',subject,'_Behavioral_Results_', ...
    strjoin(strsplit(string(datetime), {' ',':'}), '_'),'.csv'],'');
writetable(summaryTable,file)
catch
file = strjoin([parentFolder, '/', 'subject',subject,'_Behavioral_Results_', ...
    strjoin(strsplit(string(datetime), {' ',':'}), '_'),'.csv'],'');
writetable(summaryTable,file)
end

%shut it down
Screen('TextSize', mainWindow, 60);
DrawFormattedText(mainWindow, 'Stop. You have finished this section. Please get the experimenter.', 'center', 'center', black, 80);
Screen('Flip', mainWindow);
KbWait;

Screen('CloseAll');
ShowCursor;


