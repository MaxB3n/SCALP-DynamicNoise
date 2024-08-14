clear PsychImaging;
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1 );
Screen('Preference', 'VisualDebugLevel', 4);
AssertOpenGL;

% get ID and dimensions of display screen
mainScreen = max(Screen('Screens'));
if mainScreen ~= 0
    mainScreen = 1; 
end

% assert screen colors,  open ptb screen, and set ptb window reference
white = WhiteIndex(mainScreen);
grey = white / 2;
bkg = [grey grey grey];
[w, rect] = PsychImaging('OpenWindow', mainScreen, grey, [], 32, 2,...
  [], [],  kPsychNeed32BPCFloat);

% assert transparency f unction
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);


gaborTex = CreateProceduralGabor(w, 400, 400, [], ...
    [0.5 0.5 0.5 1.5 ], 0, 55);
gaborProperties = [ 0, 0.0450, 400/7 , 0.8 , 1 , 0, 0, 0];
blk = zeros(400,400,4) ;
blk(:,:,4) = 0.01 ;

blkt = Screen('MakeTexture', w, blk) ;
Screen('DrawTexture', w, blkt) ;
Screen('DrawTexture', w, gaborTex, [], [],...
                            45, [], [], [], [], kPsychDontDoRotation, gaborProperties);
Screen('Flip',w) ;
KbWait([],2) ;

abortExperiment;