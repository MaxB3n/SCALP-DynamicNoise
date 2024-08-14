function [NoiseTex, Noise]= readyNoiseFrameDistractor(mainWindow, dimNoise, noiseTransp, frequency, direction, oldNoise, dimStim, logi)

    [X, Y] = Screen('WindowSize', mainWindow);
    windowRect = [ 0, 0, X, Y];
    rectNoise = [(windowRect(3)-dimNoise)/2 (windowRect(4)-dimNoise)/2 (windowRect(3) + dimNoise)/2 (windowRect(4) + dimNoise)/2 ];

    dimNoise = dimNoise /frequency;

    Noise = ones(dimNoise,dimNoise,3);       
    Sample = round(rand(dimNoise)*255);
    Noise(:,:,:) = cat(3,Sample,cat(3,Sample,Sample));

if ~direction == 0
    dimStim = round(dimStim / frequency) ;
    oldDim = [(dimNoise - dimStim)/2 : ((dimNoise + dimStim-2)/2)]' ;
    bkgNoise = Noise(oldDim,oldDim,1) ;
    movedNoise = oldNoise(oldDim,oldDim,1) ;
    movedNoise = shiftSquareMatrix(movedNoise, direction) ;
    logi = shiftSquareMatrix(reshape(logi, dimStim, dimStim), direction) ;
    inds = find(logi);
    bkgNoise(inds) = movedNoise(inds) ;
    bkgNoise = reshape(bkgNoise,dimStim,dimStim,1) ;
    bkgNoise(:,:,1:3) = cat(3,bkgNoise(:,:,1),bkgNoise(:,:,1),bkgNoise(:,:,1));

    Noise(oldDim,oldDim,1:3) = bkgNoise;
end

    Noise(:,:,4) = noiseTransp;
    NoiseTex = Screen('MakeTexture', mainWindow, Noise);
    Screen('DrawTexture', mainWindow, NoiseTex, [], rectNoise);
    
end