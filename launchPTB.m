function launchSess = launchPTB(launchSess)

% clear any leftover PsychImaging settings in case program previously aborted after 
% initiating PsychImaging but before calling Screen('OpenWindow',[...])
clear PsychImaging;

% check OpenGL installation & Screen() functionality; normalize color range and remap key
% names to facilitate OS and hardware compatibility
PsychDefaultSetup(2);
% skip any Psychtoolbox sync tests during startup routine
if launchSess.skipPTBsync == "Yes"
    Screen('Preference', 'SkipSyncTests', 1 );
end
Screen('Preference', 'VisualDebugLevel', 4);

AssertOpenGL; % break and issue error message if the installed Psychtoolbox is not based on OpenGL or Screen() is not working properly

% get ID and dimensions of display screen
launchSess.ptb.mainScreen = max(Screen('Screens'));
if launchSess.ptb.mainScreen ~= 0
    launchSess.ptb.mainScreen = 1; % Select the system primary screen for displaying the experiment
end

% assert screen colors, open ptb screen, and set ptb window reference
launchSess.ptb.white = WhiteIndex(launchSess.ptb.mainScreen);
launchSess.ptb.grey = launchSess.ptb.white / 2;
launchSess.ptb.bkg = [launchSess.ptb.grey launchSess.ptb.grey launchSess.ptb.grey];
[launchSess.ptb.w, launchSess.ptb.rect] = PsychImaging('OpenWindow', launchSess.ptb.mainScreen, launchSess.ptb.grey, [], 32, 2,...
  [], [],  kPsychNeed32BPCFloat);

% assert transparency function
Screen('BlendFunction', launchSess.ptb.w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% detect monitor refresh
launchSess.ptb.ifi = Screen('GetFlipInterval', launchSess.ptb.w );
% detect screen pixel dimensions
[launchSess.ptb.x, launchSess.ptb.y] = Screen('WindowSize', launchSess.ptb.w);
launchSess.ptb.ppi = java.awt.Toolkit.getDefaultToolkit().getScreenResolution();
   
% display startup screen
DrawFormattedText(launchSess.ptb.w,'Starting up PTB...','center','center',[1 1 1]);
Screen('Flip',launchSess.ptb.w);
WaitSecs(0.75); % pause for a moment so the startup text can be read
%Screen('Close',launchSess.ptb.w);
  
% SILENCE KEYBOARD AND MOUSE
KbName('UnifyKeyNames');
% suppress output of keypresses in the command window
%ListenChar(2);
% hide cursor
%HideCursor;
