function runPasInstructions(sess)


mainWindow = sess.ptb.w ;
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
    '\n\nIf I was to choose this number I might say that what I saw was clear and that I am able to tell you exactly what I experienced.'...
    '\n\nPress any key to continue.'];
PASText6= ['After each trial, you will be asked to rate your perceptual experience using this scale by pressing the keys 1-4.'...
     '\n\nPress any key to continue.']; 

% intro
Screen('TextSize', mainWindow, 40);
DrawFormattedText(mainWindow, PASText1, 'center', 'center', [ 0 0 0 ], 80);
Screen('Flip', mainWindow);
KbWait([],2);

checkLastKey(mainWindow) ;

%Scale Instructions
Screen('TextSize', mainWindow, 40);
DrawFormattedText(mainWindow, PASText2, 'center', 'center', [ 0 0 0], 80);
Screen('Flip', mainWindow);
KbWait([],2); 

checkLastKey(mainWindow) ;

Screen('TextSize', mainWindow, 40);
DrawFormattedText(mainWindow, PASText3, 'center', 'center', [ 0 0 0 ], 80);
Screen('Flip', mainWindow);
KbWait([],2); 

checkLastKey(mainWindow) ;

Screen('TextSize', mainWindow, 40);
DrawFormattedText(mainWindow, PASText4, 'center', 'center', [ 0 0 0 ], 80);
Screen('Flip', mainWindow);
KbWait([],2); 

checkLastKey(mainWindow) ;

Screen('TextSize', mainWindow, 40);
DrawFormattedText(mainWindow, PASText5, 'center', 'center', [ 0 0 0 ], 80);
Screen('Flip', mainWindow);
KbWait([],2); 

checkLastKey(mainWindow) ;

%End Instructions
Screen('TextSize', mainWindow, 40);
DrawFormattedText(mainWindow, PASText6, 'center', 'center', [ 0 0 0 ], 80);
Screen('Flip', mainWindow);
KbWait([],2); 

end

