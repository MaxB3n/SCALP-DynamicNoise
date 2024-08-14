function [windowId,ScreenInfo] = openScreen(debugging)
% Open a Psychtoolbox window for stimulus display, returning the correspondning window ID
% and a ScreenInfo structure containing information about the presentation screen number,
% the refresh rate (inter-frame interval), and the size and center coordinates of the new 
% window. The function takes a single boolean flag argument 'debugging' indicating whether 
% to run in debug mode, skipping PTB sync tests and uses a 1/4 sized window if set to 
% true. 
% 4-03-23   Written --------------------------- Cole Dembski ------ coledembski@gmail.com

% check debug flag and set appropriate Psychtoolbox sync test mode
if debugging 
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'VisualDebugLevel', 4);
else
    Screen('Preference', 'VisualDebugLevel', 0);
    Screen('Preference', 'SkipSyncTests',0);
end

% set defaults
try
    % attempt to load default configuration from file 'DefaultCfg.mat'
    load('DefaultCfg.mat');
    Default = configuration;
catch
    % if file cannot be loaded, set default black background and 30 pt text
    Default.backgroundColor = [0 0 0];
    Default.textSize = 30;
end

% determine presentation screen number (assumed to be highest screen ID) and resolution
primaryScreen = max(Screen('Screens'));

if primaryScreen ~= 0
    primaryScreen = 2;
    %PsychImaging('PrepareConfiguration');
    %PsychImaging('AddTask', 'General', 'DontUsePipelineIfPossible');
    %PsychImaging('AddTask','General','MirrorDisplayTo2ndOutputHead',2);
    %PsychImaging('AddTask','General','MirrorDisplayToSingleSplitWindow');
end

res = Screen(primaryScreen,'resolution');

if debugging 
    % open 1/4 sized window with visible cursor
    [windowId,wRect] = PsychImaging('OpenWindow',primaryScreen,Default.backgroundColor, ...
                            [10 10 res.width/2+10 res.height/2 + 10]);
else
    % open full-sized window and hide cursor
    [windowId,wRect] = PsychImaging('OpenWindow',primaryScreen,Default.backgroundColor);
    HideCursor;
end


% give the Psychtoolbox window maximum priority
Priority(MaxPriority(windowId));

% set default text size
Screen('TextSize', windowId, Default.textSize); 

% get center coordinates of main window
[cx,cy] = RectCenter(wRect);

% create a structure with information about the screen
ScreenInfo.Id = primaryScreen; % store primary screen pointer
ScreenInfo.rect = wRect; % store rectangle of main window
ScreenInfo.ifi = Screen('GetFlipInterval',windowId); % store screen refresh rate
ScreenInfo.cx = cx; % save center x coordinate
ScreenInfo.cy = cy; % save center y coordinate

% display status text in the center of the window and complete first screen flip
DrawFormattedText(windowId,'Initializing...','center','center',[0 0 0]);
Screen('Flip',windowId);

end
