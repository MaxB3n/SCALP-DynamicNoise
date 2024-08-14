%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Main Noise Bifurcation Experiment Program %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written 2024-07-28 by Max Bennett (maxwellbennett@proton.yme)
% Coauthors Abigail Hartman and Leore Capurso
% Based in large part on code written by Cole Dembski and Aaron Schurger
 
% This code maintains the following data structures (in order of init):
%     <meta> "Metadata" contains experiment code metadata.
%     <cfg> "Configuration" contains most experimental design and stimulus 
%           settings that are softcoded to be system agnostic.
%     <sess> "Session" contains all run-specific information including
%            psychtoolbox variables and system information.
%     <stg> "Settings" contains all final stimulus settings generated from 
%           configuration and system information.
%     <trls> "Trials" contains trial settings. 
%     <resp> "Responses" contains all participant response data, trial-wise
%     response data is in response.<trls>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

meta.programName = 'Dynamic_Noise_Bifurcation';
meta.version = '4.2';
meta.lastEdited = "2024-07-225";
meta.authors = ["Max Bennett"];

% add functions in parent and /Helpers folders to path
parentDir = fileparts(which(matlab.desktop.editor.getActiveFilename));
addpath(strcat([parentDir,'/Helpers'])); addpath(parentDir);


%% Init Session Info %%

% Init basic session variables
dt = strsplit(string(datetime), {' ',':'});
sess.date = dt(1);
sess.startTime = strjoin(dt(2:4), '-');
sess.fileLocationy = parentDir;
sess.device = getenv('COMPUTERNAME');
% check if running in matlab or octave environment, save to sess.app
if ~exist('OCTAVE_VERSION', 'builtin'),   sess.app = 'Matlab'; else,    sess.app = 'Octave'; end

% Start writing command window log
sess.logFile = sprintf('log_noiseBifurc_%s_%s.txt',sess.date, sess.startTime);
diary log_file
fprintf('Dear diary ...\n\n')
fprintf('%s',sess.logFile)
fprintf(['Running %s experiment program, version %s, last edited on %s by %s. \n', ...
    'Program is being run with %s on the %s machine on the day %s\n\n'], ...
    meta.programName, meta.version, meta.lastEdited, meta.authors{1},sess.app, sess.device,sess.date)

% Ask user for advanced run options
sess.devMode = questdlg("Run experiment in development mode?   This will display dialogue boxes for advanced settings."); 
if sess.devMode == "Cancel", abortExperiment, end

if sess.devMode == "Yes"
    sess.skipPTBsync = questdlg('Skip PTB screen tests?');   if sess.skipPTBsync == "Cancel", abortExperiment, end
    sess.debugMode = questdlg(['Run in debug mode? This shows trial information in', ... 
        'upper right corner and response information in upper left corner during the experiment.']);   if sess.debugMode == "Cancel", abortExperiment, end
    sess.pilot = questdlg('Run as pilot?');   if sess.pilot == "Cancel", abortExperiment, end

    sess.saveDir = "Saved_Data/"; %uigetdir(strcat(parentDir, '/','Saved_Data/'),'Select save folder.');    if sess.saveDir == "Cancel", abortExperiment, end
    saveFiles = {'console log', 'workspace env', 'participant data', 'behavioral data', 'quest summary and behavioral data'};   
    sess.filesToSave = [1 2 3 4 5];%listdlg('ListString',saveFiles);                                 if sess.filesToSave == "Cancel", abortExperiment, end
else
    sess.saveDir = "Saved_Data/";
    sess.skipPTBsync = "No";
    sess.pilot = "No"; 
    sess.debugMode = "No";
    sess.filesToSave = [1 2 3 4 5];
end

%% Init Config %%

% cfg data structure should have the following substructures
%   configVersion
%   design
%   gabor
%   trial
%   noise
%   kbd

try
    cfg = readyaml("stimConfig.yaml");
catch
    cfgFile = uigetfile({'*.yaml','*.yml'},'"stimConfig.yaml" not found ... \nSelect .yaml config file.');
    [cfgPath,~,cfgExt] = fileparts(cfgFile);
    % add config file parent folder to path if different from experiment parent folder 
    addpath(cfgPath);
    if cfgExt == ".yaml" || cfgExt == ".yml" 
        cfg = readyaml(cfgFile);
    else
        warning('Experiment aborting. Locate or generate the experiment .yaml file.')
        abortExperiment;
    end
end

cfg.kbd.twoAfcKeys = [37 39] ; %[ 'LeftArrow' 'RightArrow']
cfg.kbd.pasKeys = [49 50 51 52]; %[ '1!' '2@' '3#' '4$' ]

%% Ask for Subject Info %%

subjQuestions = {'SUBJECT NUMBER?', 'SUBJECT NAME?', 'SUBJECT AGE?', 'SUBJECT GENDER? (m/f/n)'};
subjDefaults = {'000   ','name','0','n'}; 
subjAnswers = inputdlg(subjQuestions, 'DialogueBox', 1, subjDefaults);

sess.subNum = subjAnswers{1};
sess.subAge = subjAnswers{3};
sess.subName = subjAnswers{1};
sess.subGender = subjAnswers{4};

%% Launch PTB %%
sess = launchPTB(sess);

sprintf('');
ptbWindow = sess.ptb.w;

stg = generateSettings_noiseBifurc(sess,cfg);

% Begin log file and save environment (to be updated in stages)
saveEnvFilePath = strcat(sess.saveDir, num2str(sess.subNum),"_NoiseBifurcSessionData_",num2str(sess.startTime), ".mat" );
save( saveEnvFilePath , 'stg','sess','cfg');

% Open io port for trigger codes
openIoPort('DFC8') ;
sendTrigger(255) ;

% Import trigger codes
stg.trigger = readyaml("triggerCodes.yaml");

%% Init Saved Data %%

%% Run Quest %%

% Run Instructions
runStimInstructions(stg,sess,cfg)

% Run Quest
% [stg.quest50] = runQuest_noiseBifurc(stg, sess, cfg); %comment out and hardcode below to save time as desired
%   stg.quest10 = -0.7 ; stg.quest50 = -0.69 ;
  stg.quest50 = -0.27;
% fprintf("quest10: %d \nquest50: %d\n\n", stg.quest10, stg.quest50)

%% Run Main Experiment Block %%

% Run PAS instructions
runPasInstructions(sess);

% Save Contrast Images
%renderAndSaveContrasts(stg,sess,cfg)

% Run Pilot
%runPilot_noiseBifurc(stg,sess,cfg)

% runDistracter_standalone(stg,sess,cfg)

% Run Report

% Run No Report

%% Finalize Saved Data %%

fprintf("Experiment %s is finished running! \n\nClosing log.... \n\n",meta.programName)
ShowCursor; 
ListenChar(0);
diary off
abortExperiment;



 