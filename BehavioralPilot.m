% ListenChar(0); ### run this command w/ right-click or press CTRL-C if keyboard stops
% responding to input after exiting mid-run ###

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written 07/03/2024 by Max Bennett (maxwellbennett@proton.me)
%       Coauthors Abigail Hartman and Leore Capurso
 

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
showInstructions = 0;       %> Whether or not to show instructions.
showPASInstructions = 1;    %> Whether or not to show PAS instructions. 


% DISPLAY SETTINGS %
ppd = 46;                   %> Pixels per degree (set @ 30 for 1080p 24in monitor and
                            % 57in viewing distance or similar).
x = 2560;                   %> Pixels on X and Y axes (ex 1920 x 1080 for 1080p monitor).
y = 1440;                   %
skipSync = 1;               % 0 runs screen tests, use during live data collection, 1 skips to save time during debugging

% STIM SETTINGS %
%  Gabor
preContrastMultiplier = 0.5 ;
stimTime = 0.1;             %> Duration of stimulus in sec, ~ 100 ms.

dimGabor = 6*ppd;           %> Size of gabor texture in pixels (x & y); after applying
                            % gaussian envelope, diameter of stim is a little smaller.
angleGabor = 45;            %> Orientation in degrees (will be horizontally reflected).
cyclGabor = 18;             %
contrGabor = 0.85;          %
freqGabor = cyclGabor/dimGabor; %
sigma = dimGabor / 7;       %> Sigma of gaussian envelope ~ the radial fade.
aspectGabor = 1.0;          %
phaseGabor = 0;             %
backgroundOffset = [0 0 0 0];   % Alternatively try [0.2 0.2 0.2 0.0];
disableNorm = 1;            %
%  Jitter
bufferTime = 0.4;           %> Time in sec to buffer before and after stim, excl jitter.
jitterTime = 0.3;           %> Time in sec from earliest to latest stim onset.
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
refreshNoise = 0.033;           %> The number of frames to wait before refreshing noise.

% ADJUSTING NOISE DISPLAY SETTINGS FOR MONITOR %

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
instructionText5 = 'Which way is this grating oriented?';
instructionText6 = ['You will be shown gratings that appear for only a brief moment, ' ...
                    '\nsome will be easily visible and some will be harder to see.' ...
                    '\n\nTry determining the direction of the next grading.'...
                    '\n\nPress any key to continue.'];
instructionText7 = ['For each trial in this experiment you will \nbriefly ' ...
    'be shown a gabor grating embedded in noise. \n\nAfter each trial, report the orientation of the grating \nusing the left or right ' ...
    'arrow keys.\n\nIf you have no idea, give it your best effort. You will need to pick one to move on.' ...
    '\n\nThere will be ', num2str(nSteps), ' rounds of ', num2str(nTrials), ' trials.\n\nPress any key to continue.'];
instructionText8 = ['Which way is this grating oriented?'...
                    '\n\nPress the correct arrow key, "<-" or "->" 3 times to continue.'];

% PAS INSTRUCTIONS %

PASText1 = ['Then, you will be asked to rate the clarity of your experience on a scale of 1-4.'...
    '\n\nThis is not a confidence rating, rather it is a scale used to represent your experience of perceiving the stimuli'...
    '\n\nPress any key to continue.'];
PASText2 = ['Number 1 will represent No Experience.'...
    '\n\nThis means you did not have even the faintest sensation that the stimulus (diagonal lines) was presented on the screen at all.'...
    '\n\nIf I was to choose this number I might say that I saw nothing except tv static and I do not feel like anything was presented on the screen.'...
    '\n\nPress any key to continue.'];
PASText3 = ['Number 2 represents Brief Glimpse.'...
    '\n\nThis means that you have no idea what the stimulus was (face, diagonal lines, shapes), just an experience of something being flashed on the screen.'...
    '\n\nIf I was to choose this number I might say that I saw a flash of something on the screen, but if you asked for more details I would not be able to provide them'...
    '\n\n(e.g. I guessed whether the grating was oriented left or right) \n\nPress any key to continue.'];
PASText4 =['Number 3 represents an Almost Clear Experience.'...
    '\n\nThis would mean that your experience of the stimulus may have been blurry and not very clear,' ... 
    'but you do have an idea of the direction of the diagonal lines, and you are not purely guessing.' ...
    '\n\nIf I was to choose this number I might say that what I saw was blurry but I am pretty sure I know what it was, and some of its details.'...
    '\n\nPress any key to continue.'];
PASText5 = ['Number 4 represents a Clear Experience.'...
    '\n\nThis would mean that your experience of seeing the stimulus was clear and you are certain of the direction of the diagonal lines.' ...
    '/n/nIf I was to choose this number I might say that what I saw was clear and that I am able to tell you exactly what I experienced.'...
    '\n\nPress any key to continue.'];
PASText6= ['After each trial, you will be asked to rate your perceptual experience using this scale by pressing the keys 1-4.'...
     '\n\nPress any key to continue.']; 


% DIALOGUE BOX %
questions = {'SUBJECT NUMBER?', 'QUEST 50% CONTRAST', 'QUEST 10% CONTRAST'};
defaults = {'XXX','0','0'};
answers = inputdlg(questions, 'DialogueBox', 1, defaults);
subject = answers{1};
Quest50 = str2num(answers{2});
Quest10 = str2num(answers{3});
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
    Screen('Preference', 'SkipSyncTests', skipSync);
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
 
    % design description
    Screen('TextSize', mainWindow, 40);
    DrawFormattedText(mainWindow, instructionText7, 'center', 'center', black, 80);     %  more instructions (7)
    Screen('Flip', mainWindow);
    KbWait([],2);
    


    % PAS instructions % 
   if showPASInstructions
     % intro
     Screen('TextSize', mainWindow, 40);
     DrawFormattedText(mainWindow, PASText1, 'center', 'center', black, 80);
     Screen('Flip', mainWindow);
     KbWait([],2); 
     %Scale Instructions
     Screen('TextSize', mainWindow, 40);
     DrawFormattedText(mainWindow, PASText2, 'center', 'center', black, 80);
     Screen('Flip', mainWindow);
     KbWait([],2); 

     Screen('TextSize', mainWindow, 40);
     DrawFormattedText(mainWindow, PASText3, 'center', 'center', black, 80);
     Screen('Flip', mainWindow);
     KbWait([],2); 

     Screen('TextSize', mainWindow, 40);
     DrawFormattedText(mainWindow, PASText4, 'center', 'center', black, 80);
     Screen('Flip', mainWindow);
     KbWait([],2); 

     Screen('TextSize', mainWindow, 40);
     DrawFormattedText(mainWindow, PASText5, 'center', 'center', black, 80);
     Screen('Flip', mainWindow);
     KbWait([],2); 

     %End Instructions
     Screen('TextSize', mainWindow, 40);
     DrawFormattedText(mainWindow, PASText6, 'center', 'center', black, 80);
     Screen('Flip', mainWindow);
     KbWait([],2); 
     if kbNameTmp == "ESCAPE"
        abortExperiment;
     end
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
         
        contrastPerTrial = repmat(0:(nSteps-1),1,nSteps*nTrials/nSteps);
        contrastPerTrial = contrastPerTrial(randperm(nSteps*nTrials));

        contrStep = (Quest50 - Quest10)/nStepsFromThreshold;
        contrLowest = Quest50 - contrStep*((nSteps-1)/2);

 %% Begin main block loop %%
    for d = 1:nSteps
 % Get Ready... Screen
 DrawFormattedText(mainWindow, 'Press any key when you are ready to begin.', 'center', 'center', black, 80);
 Screen('Flip', mainWindow);
 KbWait([],2);

    %% Begin trial-by-trial loop %%
         for t = 1:nTrials
             trial = (d-1)*nTrials + t;

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
            while f < (bufferFrames + FrameJitterPerTrial(trial))
                tic;
                f = f+1;

                    oldNoiseTex = noiseTex;
                    noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise, freqNoise);
                    Screen('Flip', mainWindow);
                    Screen('Close',oldNoiseTex);

                lastKey = checkLastKey();
                waitUntilRefresh(toc,refreshNoise);
            end

            % Show Stimulus
            while  f < (bufferFrames + FrameJitterPerTrial(trial) + stimFrames-1)
                tic;
                f = f+1;
    
                    Screen('DrawTexture', mainWindow, gaborTex, [], CenterRectOnPoint(stimRect, XJitterPerTrial(trial), YJitterPerTrial(trial)),...
                        orientGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
                    oldNoiseTex = noiseTex;
                    noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise,freqNoise);
                    Screen('Flip', mainWindow);
                    Screen('Close',oldNoiseTex);

                lastKey = checkLastKey();
                waitUntilRefresh(toc,refreshNoise);
            end

            % Post Trial buffer
            while f < (trialFrames)
                tic;
                f = f+1;

                    oldNoiseTex = noiseTex;
                    noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise,freqNoise);
                    Screen('Flip', mainWindow);
                    Screen('Close',oldNoiseTex);

                lastKey = checkLastKey();
                waitUntilRefresh(toc,refreshNoise);
            end


    % subject response prompt
    while  (~twoAfcAnswered || ~pasAnswered) 
        tic;
        f = f+1;

        % show response prompt
            oldNoiseTex = noiseTex;
            noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise,freqNoise);
            if ~twoAfcAnswered
                DrawFormattedText(mainWindow, ['Which way was the grating oriented?' ...
                        '\n\nPress "<-" or "->".'], 'center', (x)/2, black, 80);
            else
                DrawFormattedText(mainWindow, ['Rate your perceptual experience.' ...
                    '\n\nPress one of  "1"  "2"  "3"  "4"'], 'center', (x)/2, black, 80);
            end
            Screen('Flip', mainWindow);
            Screen('Close', oldNoiseTex);

        % record responses
            lastKey = checkLastKey();
            if ~twoAfcAnswered && ismember(lastKey,twoAfcKeys)
                twoAfcAnswered = 1;
                accRecordPerTrial(trial) = lastKey == correctKeyPress;
                respRecordPerTrial(trial) = toc;
            elseif twoAfcAnswered && ismember(lastKey, pasKeys)
                pasAnswered = 1;
                pasRecordPerTrial(trial) = lastKey;
            end

        waitUntilRefresh(toc,refreshNoise);
    end

         end
     end
 catch
    ple;
end
ListenChar;

% Write responses
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

