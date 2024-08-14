function ExpMetadata = launch

% Runs launch routine and returns experiment metadata file and default settings.
% Initializes global APP variable IDing the active application as Matlab or Octave.
%
% 4-14-23   Written ------------------------------------- CD ------ coledembski@gmail.com
% 4-27-23   UI functionality added ---------------------- CD ------ coledembski@gmail.com
% 7-1-24    Adapted ------------------------------------- MB --- maxwellbennett@proton.me

clearvars;

global APP; % NOTE: IDs run environment as Octave or Matlab


if ~exist('OCTAVE_VERSION', 'builtin')

    APP = 'Matlab';

else

    APP = 'Octave';

end

% reseed random number generator if in Matlab
if strcmpi('Matlab',APP)
    
    rng('shuffle');
    
end

% attempt to load experiment metadata file and set working directory
try

    load('Temp_Data/ExpMetadata.mat','ExpMetadata');
    cd(ExpMetadata.mainFolder);

catch % launch GUI error handling

    missingMetadata = questdlg('Experiment metadata not found.',['Experiment ' ...
        'Metadata Error'],'Select folder with metadata file',['Proceed without ' ...
        'metadata file'],'Select folder with metadata file');

         switch missingMetadata
             
             case 'Select folder with metadata file'
             
                 cd(uigetdir(cd,'Select experiment folder'));

             case 'Proceed without metadata file'
                 proceed = questdlg(['Running the experiment without a metadata ' ...
                     'file may cause unexpected behavior and bugs. Proceed?'], ...
                     'Proceed without metadata','Continue','Cancel','Cancel');

                 switch proceed

                     case 'Cancel'
                         error(['Experiment aborted. Locate the experiment metadata ' ...
                                'file or run experiment configuration.'])

                     case 'Continue'
                         
                         % generate metadata file
                         ExpMetadata.programName = 'dynamic_noise_bifurcation';
                         ExpMetadata.version = '4.1';
                         ExpMetadata.mainFolder = cd;
                         ExpMetadata.author = 'Max Bennett';
                         if strcmpi(APP,'Matlab')
                             ExpMetadata.date = strcat(string(datetime("today")), '?');
                         elseif strcmpi(APP,'Octave')
                             ExpMetadata.date = strcat(date,"?");
                         end

                         ExpMetadata.WARNING = ['This metadata file was generated ' ...
                                                'automatically and may be inaccurate.' ...
                                                'This session may have contained bugs.'];

                 end

         end

end

addpath(genpath(ExpMetadata.mainFolder));

% clear any leftover PsychImaging settings in case program previously aborted after 
% initiating PsychImaging but before calling Screen('OpenWindow',[...])
clear PsychImaging;

% check OpenGL installation & Screen() functionality; normalize color range and remap key
% names to facilitate OS and hardware compatibility
PsychDefaultSetup(2);

% skip any Psychtoolbox sync tests during startup routine
Screen('Preference', 'SkipSyncTests', 1);

% get ID and dimensions of display screen
mainScreen = max(Screen('Screens'));
if mainScreen ~= 0
    mainScreen = 1; % Select the system primary screen for displaying the experiment
end

resolution = Screen(mainScreen,'resolution');
screenWidth = resolution.width;
screenHeight = resolution.height;


% open startup screen and display startup text
startupWindow = PsychImaging('OpenWindow', mainScreen,[0 0 0],[screenWidth/3 ...
                screenHeight/3 screenWidth*2/3 screenHeight*2/3]);
DrawFormattedText(startupWindow,'Starting up...','center','center',[1 1 1]);
Screen('Flip',startupWindow);

% open and close any mp4 file
%startupMovie = Screen('OpenMovie', startupWindow, fullfile(ExpMetadata.mainFolder, ...
%    'psychtoolbox_services','launch.mp4'));
%Screen('CloseMovie',startupMovie);

WaitSecs(0.75); % pause for a moment so the startup text can be read

Screen('Close',startupWindow);
