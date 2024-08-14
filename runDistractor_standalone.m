function runDistractor_standalone(stg,sess,cfg)

getReady("interBlock",sess,cfg)
%nCoherent = nTrials * nFrames ;
%nCoherent = 42 * 12 ;

%temp1 = repmat(0:1,1,(dimStim^2)/2) ;
%storedCoherent = zeros(1,dimStim^2/2,nCoherent);
%for i = 1:nCoherent
%    storedCoherent(1,:,i) = find(temp1(randperm(dimStim^2))) ;
%end

dimStim = 100;%round(stg.stimDim / cfg.noise.pSpatialFrequency)+1 ;

logi = repmat([1,1,1,0,0,0,0,0,0,0],1,(dimStim^2)/10) ;

%[indr,indc] = find(
logi = logi(randperm(dimStim^2)) ;


[noiseTex, oldNoise] = readyNoiseFrameDistracter(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency, 0);
f = 0; keyNotPressed = 1;
while keyNotPressed
    f = f +1 ;
    frameStart = GetSecs ;
    
    oldNoiseTex = noiseTex;
    [noiseTex,oldNoise] = readyNoiseFrameDistracter(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency, 1, oldNoise, dimStim*2, logi);
    Screen('Close', oldNoiseTex) ; 

    if f > 8
        lastKey = checkLastKey(sess.ptb.w) ;
        keyNotPressed = lastKey == 0;
    end
    waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
    Screen('Flip',sess.ptb.w) ;

end

f = 0; keyNotPressed = 1;
while keyNotPressed
    f = f +1 ;
    frameStart = GetSecs ;
    
    oldNoiseTex = noiseTex;
    [noiseTex,oldNoise] = readyNoiseFrameDistracter(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency, 2, oldNoise, dimStim*2, logi);
    Screen('Close', oldNoiseTex) ; 

    if f > 8
        lastKey = checkLastKey(sess.ptb.w) ;
        keyNotPressed = lastKey == 0;
    end
    waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
    Screen('Flip',sess.ptb.w) ;

end

f = 0; keyNotPressed = 1;
while keyNotPressed
    f = f +1 ;
    frameStart = GetSecs ;
    
    oldNoiseTex = noiseTex;
    [noiseTex,oldNoise] = readyNoiseFrameDistracter(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency, 3, oldNoise, dimStim*2, logi);
    Screen('Close', oldNoiseTex) ; 


    if f > 8
        lastKey = checkLastKey(sess.ptb.w) ;
        keyNotPressed = lastKey == 0;
    end
    waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
    Screen('Flip',sess.ptb.w) ;

end

f = 0; keyNotPressed = 1;
while keyNotPressed
    f = f +1 ;
    frameStart = GetSecs ;
    
    oldNoiseTex = noiseTex;
    [noiseTex,oldNoise] = readyNoiseFrameDistracter(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency, 4, oldNoise, dimStim*2, logi);
    Screen('Close', oldNoiseTex) ; 

    if f > 8
        lastKey = checkLastKey(sess.ptb.w) ;
        keyNotPressed = lastKey == 0;
    end
    waitUntilRefresh(frameStart-GetSecs, cfg.noise.sRefresh) ;
    Screen('Flip',sess.ptb.w) ;

end
