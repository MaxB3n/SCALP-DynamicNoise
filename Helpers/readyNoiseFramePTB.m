function NoiseTex = readyNoiseFramePTB(mainWindow, dimNoise, noiseTransp, frequency)

    [X, Y] = Screen('WindowSize', mainWindow);
    windowRect = [ 0, 0, X, Y];
    rectNoise = [(windowRect(3)-dimNoise)/2 (windowRect(4)-dimNoise)/2 (windowRect(3) + dimNoise)/2 (windowRect(4) + dimNoise)/2 ];


    Noise = ones(dimNoise/frequency,dimNoise/frequency,3);       
    Sample = round(rand(dimNoise/frequency)*255);
    Noise(:,:,:) = cat(3,Sample,cat(3,Sample,Sample));


    Noise(:,:,4) = noiseTransp;
    NoiseTex = Screen('MakeTexture', mainWindow, Noise);
    Screen('DrawTexture', mainWindow, NoiseTex, [], rectNoise);
    
end