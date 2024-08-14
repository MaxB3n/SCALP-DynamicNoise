function settings = generateSettings_noiseBifurc(sess, cfg)
disp("Generating stimulus settings from user inputs, config file, and detected hardware.... \n\n")

% assumes a view distance of ~57 cm= where 1 cm = 1 degree visual angle
ppd = round((sess.ptb.ppi*1.125) / 2.54);
settings.ppd = ppd;
ifi = sess.ptb.ifi;
rect = sess.ptb.rect;


settings.stimDim = cfg.gabor.dDimension * ppd;
settings.stimRect = [(rect(3)-settings.stimDim)/2 (rect(4)-settings.stimDim)/2 (rect(3) + settings.stimDim)/2 (rect(4) + settings.stimDim)/2 ];
settings.stimJitterDim = cfg.gabor.dJitterXY * ppd;
settings.noiseDim = cfg.noise.dDimension * ppd;
settings.stimCycles = cfg.gabor.dDimension * cfg.gabor.nCyclePerDegree;
settings.stimFreq = settings.stimCycles / settings.stimDim ;
settings.noiseFrames = cfg.noise.sRefresh/ifi;


settings.stimFrames = round(cfg.gabor.sDuration / ifi);
settings.jitterFrames = round(cfg.design.sJitter / ifi);
settings.rBufferFrames = round(cfg.design.sBufferReport / ifi);
settings.nrBufferFrames = round(cfg.design.sBufferNoReport / ifi);
settings.noiseRefreshFrames = round(cfg.noise.sRefresh / ifi);


end