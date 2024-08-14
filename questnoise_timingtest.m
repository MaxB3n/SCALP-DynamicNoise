% ListenChar(0);  ### run this command or press CTRL-C if keyboard stops responding to input after exiting mid-run ###
 
%% PARAMETERS %%

% EXPERIMENTAL DESIGN PARAMETERS %
nTrials = 50;           % number of trials used per threshold
accThreshold = [0.75 0.95];      % start by thresholding to 50% and 90% seen (75% and 95% 2afc accuracy, respectively)
    nThresh = length(accThreshold); 
showInstructions = 1;           % whether or not to show instructions (0 no, 1 yes) 

% DISPLAY SETTINGS %
ppd = 46; % pixels per degree (assuming 1440p 27in monitor and ~57cm viewing distance)
x = 2560;
y = 1440;

% STIM SETTINGS %
%  Gabor 
preContrastMultiplier = 0.50 ;
stimTime = 0.1;           % in seconds, ~ 100 ms

dimGabor = 6*ppd;           % size of gabor texture in pixels (x & y); after applying gaussian envelope, diameter of stim is a little smaller
angleGabor = 45;            % orientation in degrees (will be horizontally reflected) 
cyclGabor = 15;             % *****
contrGabor = 0.85   ;
freqGabor = cyclGabor/dimGabor;
sigma = dimGabor / 7;       % sigma of gaussian envelope, aka the radial fade inside the drawbox
aspectGabor = 1.0;          % 
phaseGabor = 0;             %
backgroundOffset = [0 0 0 0]; %[0.2 0.2 0.2 0.0];
disableNorm = 1;
%  Jitter
bufferTime = 0.7;       % time in seconds to buffer before and after stim, not including jitter
jitterTime = 0.4;       % time in seconds from earliest to latest stim onset
jitterSpace = 2*ppd;        % distance in pixels between most extreme stim positions in each dimension (x, y) 
%  Noise
noiseType = 'static';       % 'static' or 'procedural'; 'procedural' uses CreateProceduralNoise() 
                            % to generate an OpenGL texture, 'static' uses a simple array of 
                            % pixel luminances produced by round(rand(dimNoise)*255)
transpNoise = 127;          % 
dimNoise = 12 * ppd;        %
freqNoise = 1;              % pixel size of noise
refreshNoise = 2;           % number of frames to wait before refreshing noise

% RESPONSE SETTINGS %
twoAfcKeys = ["RightArrow", "LeftArrow"];
pasKeys =    ["1!", "2@", "3#", "4$"];
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
                    '\n\nPress the correct arrow key, "<-" or "->" to continue.'];
instructionText6 = ['You will be shown gratings that appear for only a brief moment, ' ...
                    '\nsome will be easily visible and some will be harder to see.' ...
                    '\n\nTry determining the direction of the next grading.'...
                    '\n\nPress any key to continue.'];
instructionText7 = ['For each trial in this part of the experiment you will \nbriefly ' ...
    'be shown a gabor grating embedded in noise. \n\nAfter each ' ...
    'trial, report the orientation of the grating \nusing the left or right ' ...
    'arrow keys.\n\nThere will be ',num2str(nThresh), ' rounds of ', num2str(nTrials), ...
    ' trials.\n\nPress any key to continue.'];

% DIALOG BOX %
questions = {'SUBJECT NUMBER?'};
defaults = {'XXX'};
answers = inputdlg(questions, 'DialogueBox', 1, defaults);
subject = answers{1};
subNum = str2num(subject);

%% PTB %%
presentationScreen = min(Screen('Screens')); % ry monitor, if one exists
screenRect = Screen('Rect', presentationScreen);   % get local rect of window or screen called presentationScreen
KbName('UnifyKeyNames');
% suppress output of keypresses in the command window
ListenChar(2);
try
    %% More PTB %%
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
     
     % intro
     Screen('TextSize', mainWindow, 40);
     DrawFormattedText(mainWindow, instructionText1, 'center', 'center', black, 80);
     Screen('Flip', mainWindow);
     KbWait([],2); 

     % noise example
     kbTmp = 0; i = 0;
     while ~kbTmp
         i = i+1;
         Noise = ones(dimNoise,dimNoise,3);       
         Sample = round(rand(dimNoise)*255);
         Noise(:,:,:) = cat(3,Sample,cat(3,Sample,Sample));
         Noise(:,:,4) = 127;
         NoiseTex = Screen('MakeTexture', mainWindow, Noise);
         Screen('DrawTexture', mainWindow, NoiseTex);
         DrawFormattedText(mainWindow, instructionText2, 'center', (x)/2, black, 80);
         Screen('Flip', mainWindow);
         pause(ifi);
         if i > 10
            kbTmp = KbCheck; % waits for subject to respond with keypress
         end
     end
 

    % gabor right
    GaborTex = CreateProceduralGabor(mainWindow, dimGabor, dimGabor, [],...
    backgroundOffset, disableNorm, preContrastMultiplier);
    gaborProperties = [phaseGabor, freqGabor, sigma, contrGabor, aspectGabor, 0, 0, 0]; % randomise the phase of the Gabors and make a properties matrix.
    rectGabor = [(windowRect(3)-dimGabor)/2 (windowRect(4)-dimGabor)/2 (windowRect(3) + dimGabor)/2 (windowRect(4) + dimGabor)/2 ];

    Screen('DrawTexture', mainWindow, GaborTex, [], [] ,...
    180-angleGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
    Screen('TextSize', mainWindow, 40);
    DrawFormattedText(mainWindow, instructionText3, 'center', x/2, black, 80);
    Screen('Flip', mainWindow);
    %pause(10*ifi);
    kbNameTmp = "";
    while kbNameTmp ~= "RightArrow"
        [~, kbCodeTmp] = KbWait([],2); % waits for subject to respond with keypress
        kbNameTmp = KbName(kbCodeTmp);
    end

    % gabor left
    Screen('DrawTexture', mainWindow, GaborTex, [], [] ,...
    angleGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
    DrawFormattedText(mainWindow, instructionText4, 'center', x/2, black, 80);
    Screen('Flip', mainWindow);
    pause(10*ifi);
    while kbNameTmp ~= "LeftArrow"
        [~, kbCodeTmp] = KbWait([],2); % waits for subject to respond with keypress
        kbNameTmp = KbName(kbCodeTmp);
    end

    % constant gabor in noise
    if rand>0.5
        orientGabor = 180-angleGabor;
        orientKey = "RightArrow";
    else
        orientGabor = angleGabor;
        orientKey = "LeftArrow";
    end

    kbNameTmp = "";  kbTmp = 0; i = 0;       
    while kbNameTmp ~= orientKey
         i = i+1;
         Noise = ones(dimNoise,dimNoise,3);       
         Sample = round(rand(dimNoise)*255);
         Noise(:,:,:) = cat(3,Sample,cat(3,Sample,Sample));
         Noise(:,:,4) = transpNoise;
         NoiseTex = Screen('MakeTexture', mainWindow, Noise);
         Screen('DrawTexture', mainWindow, GaborTex, [], [] ,...
            orientGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
         Screen('DrawTexture', mainWindow, NoiseTex);
         DrawFormattedText(mainWindow, instructionText5, 'center', (x)/2, black, 80);
         Screen('Flip', mainWindow);
         pause(ifi);
         kbTmp = KbCheck;
         if i > 10 && kbTmp
            [~,~,kbCodeTmp] = KbCheck; % waits for subject to respond with keypress
            kbNameTmp = KbName(kbCodeTmp);
         end
    end

    % brief stim description
    Screen('TextSize', mainWindow, 40);
    DrawFormattedText(mainWindow, instructionText6, 'center', 'center', black, 80);
    Screen('Flip', mainWindow);
    KbWait([],2);

    % brief gabor in noise
    if rand>0.5
        orientGabor = 180-angleGabor;
        orientKey = "RightArrow";
    else
        orientGabor = angleGabor;
        orientKey = "LeftArrow";
    end

    kbNameTmp = "";  kbTmp = 0; i = 0;       
    while kbNameTmp ~= orientKey
         i = i+1;
         Noise = ones(dimNoise,dimNoise,3);       
         Sample = round(rand(dimNoise)*255);
         Noise(:,:,:) = cat(3,Sample,cat(3,Sample,Sample));
         Noise(:,:,4) = transpNoise;
         NoiseTex = Screen('MakeTexture', mainWindow, Noise);
         if mod(idivide(int16(i),int16(4)) + 16, 20) == 0
         Screen('DrawTexture', mainWindow, GaborTex, [], [] ,...
            orientGabor, [], [], [], [], kPsychDontDoRotation, gaborProperties);
         end
         Screen('DrawTexture', mainWindow, NoiseTex);
         DrawFormattedText(mainWindow, instructionText5, 'center', (x)/2, black, 80);
         Screen('Flip', mainWindow);
         pause(ifi);
         kbTmp = KbCheck;
         if i > 10 && kbTmp
            [~,~,kbCodeTmp] = KbCheck;
            kbNameTmp = KbName(kbCodeTmp);
         end
     end

    % design description
    Screen('TextSize', mainWindow, 40);
    DrawFormattedText(mainWindow, instructionText7, 'center', 'center', black, 80);
    Screen('Flip', mainWindow);
    KbWait([],2);
    
 end


 %% Init 
 % Init Response Recording %
        orientRecordPerTrial = string(zeros(nTrials,1));
        accRecordPerTrial = string(zeros(nTrials,1));
        respRecordPerTrial = string(zeros(nTrials,1));

% Init QUEST %
    f_quest = fopen('f_quest_results.txt','a');
    fprintf(f_quest,'subject stim trial Contrast_Value Quest_SD \n');
    f_summary = zeros(nThresh,2);
    f_summary(:,1) = accThreshold;

 %% Begin main block loop %%
    for d = 1:nThresh
 % Get Ready... Screen
 Screen('TextSize', mainWindow, 40);
 DrawFormattedText(mainWindow, 'Press any key when you are ready to begin.', 'center', 'center', black, 80);
 Screen('Flip', mainWindow);
 KbWait([],2);

% QUEST setup - DO NOT CHANGE %
         pThreshold = accThreshold(d);
         guessVal = 0.2; % this is for contrast
         SdVal = 0.25;    % " "
         tGuess = guessVal;
         tGuessSd = SdVal;
         beta = 3.5;
         delta = 0.01;
         gamma = 0.25;
    
         q = QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma);

% Init Stim Timing and Location %         
        bufferFrames = round(bufferTime/ifi); jitterFrames = round(jitterTime/ifi); stimFrames = round(stimTime/ifi);
        trialFrames = (bufferFrames*2) + jitterFrames + stimFrames;

        stimRect = [(windowRect(3)-dimGabor)/2 (windowRect(4)-dimGabor)/2 (windowRect(3) + dimGabor)/2 (windowRect(4) + dimGabor)/2 ];
        
% Set Stim Jitter %
        for i = 1:nTrials
            FrameJitterPerTrial(i) = randi([1 jitterFrames]) ;
            XJitterPerTrial(i) = randi([(windowRect(3)-jitterSpace)/2 (windowRect(3)+jitterSpace)/2]) ;
            YJitterPerTrial(i) = randi([(windowRect(4)-jitterSpace)/2 (windowRect(4)+jitterSpace)/2]) ;
        end
        
% Set Stim Orientations %
        orientationPerTrial = cat(2,zeros(1,nTrials/2),ones(1,nTrials/2));
        orientationPerTrial = orientationPerTrial(randperm(nTrials));

% Set Stim Contrast Levels %
        orientationPerTrial = cat(2,zeros(1,nTrials/2),ones(1,nTrials/2));
        orientationPerTrial = orientationPerTrial(randperm(nTrials));

    %% Begin trial-by-trial loop %%   
         for trial = 1:nTrials
             % QUEST variables - DO NOT CHANGE %
             
             ContrastValue = 10^(QuestMean(q));
             ContrastVal = 1-ContrastValue;
             tGuessSd = QuestSd(q);
             
             % Set gabor orientation for trial
             if orientationPerTrial(trial) %is 1
                 orientGabor = 180-angleGabor;
                 correctKeyPress = "RightArrow";
             else %is 0
                 orientGabor = angleGabor;
                 correctKeyPress = "LeftArrow";
             end
               
             % Set jitter
             %frameJitter = randi([1 round(jitterTemporal/ifi)]) ;
             %stimFrames = (stimFrameOnset + frameJitter):(stimFrameOnset+frameJitter+stimFrameLength-1) ;
             rectGabor = [(windowRect(3)-dimGabor)/2 (windowRect(4)-dimGabor)/2 (windowRect(3) + dimGabor)/2 (windowRect(4) + dimGabor)/2 ];
             spaceJitterX = randi([(windowRect(3)-jitterSpace)/2 (windowRect(3)+jitterSpace)/2]) ;
             spaceJitterY = randi([(windowRect(4)-jitterSpace)/2 (windowRect(4)+jitterSpace)/2]) ;
             centerGabor = CenterRectOnPoint(rectGabor, spaceJitterX, spaceJitterY);
             
             %% Begin Trial %%

             gaborTex = CreateProceduralGabor(mainWindow, dimGabor, dimGabor, [],...
                     backgroundOffset, disableNorm, preContrastMultiplier);
             gaborProperties = [phaseGabor, freqGabor, sigma, ContrastVal, aspectGabor, 0, 0, 0];
             twoAfcAnswered = 0; lastKey = "";
             
             f = 0; kbTmp = 0;
            noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise, freqNoise);
            while f < (bufferFrames + FrameJitterPerTrial(trial)) && lastKey ~= "ESCAPE"
                f = f+1;
        
                if ~mod(f,refreshNoise)
                    oldNoiseTex = noiseTex;
                    noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise, freqNoise);
%                     Screen('FillRect',WindowOrTexture,[0 0 0],location) %% rectangle
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
%                     Screen('FillRect',WindowOrTexture,[0 0 0],location)             %%%%%% creates lil square guy in the corner for timing tests 
                    oldNoiseTex = noiseTex;
                    noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise,freqNoise);  
                    Screen('Flip', mainWindow);
                    %%%trigger code for gabor presentation here!
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
             
             
             %% subject response prompt
           tic
           while  ~twoAfcAnswered && (lastKey ~= "ESCAPE")
                f = f+1;
        
                if ~mod(f,refreshNoise)
                    oldNoiseTex = noiseTex;
                    noiseTex = readyNoiseFramePTB(mainWindow, dimNoise, transpNoise,freqNoise);
                    
                        DrawFormattedText(mainWindow, ['Which way was the grating oriented?' ...
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
%FIX                        accRecordPerTrial(trial) = lastKey == correctKeyPress;
%FIX                        respRecordPerTrial(trial) = toc;
                    end
                end
           end

            if lastKey == "ESCAPE"
                abortExperiment;
            end
    
                % UPDATE QUEST %
                intensity = log10(ContrastValue);
                response = lastKey == correctKeyPress;
                q = QuestUpdate(q,intensity, response);
                fprintf(f_quest,'%s %d %d %d %d \n', subject, trial, ContrastVal, tGuessSd);
 
         end
         %% calculate final QUEST values %%

         q_ContrastValue = 10^(QuestMean(q));
         q_ContrastVal = 1-q_ContrastValue;
         f_summary(d,2) = (1-q_ContrastVal)/2;
         
     end
 catch
    ple;
end

try
file = strjoin([parentFolder, '/', saveFolder, 'subject',subject,'_Quest_Results_', ...
    strjoin(strsplit(string(datetime), {' ',':'}), '_'),'.csv'],'');
summaryTable = array2table(f_summary,'VariableNames',{'Percent_Seen','Contrast'});
writetable(summaryTable,file)
catch
file = strjoin([parentFolder, '/', 'subject',subject,'_Quest_Results_', ...
    strjoin(strsplit(string(datetime), {' ',':'}), '_'),'.csv'],'');
summaryTable = array2table(f_summary,'VariableNames',{'Percent_Seen','Contrast'});
writetable(summaryTable,file)
end


Screen('TextSize', mainWindow, 60);
DrawFormattedText(mainWindow, 'Stop. You have finished this section. Please get the experimenter.', 'center', 'center', black, 80);
Screen('Flip', mainWindow);
KbWait;

ListenChar;
Screen('CloseAll');
ShowCursor;

