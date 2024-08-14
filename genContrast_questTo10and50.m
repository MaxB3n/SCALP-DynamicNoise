function [contrastPerTrial,contrStep,contrLowest] = genContrast_questTo10and50(blockType, nTrials, stg, cfg)

if blockType == "Pilot"
    nSteps = cfg.pilot.nConds ;
    start = 1;
    contrStep = (stg.quest50 - stg.quest10)/cfg.pilot.nStepsFromThreshold;
else
    nSteps = cfg.design.nConds + cfg.design.bBlanks;
    start = 1 - cfg.design.bBlanks;
    contrStep = (stg.quest50 - stg.quest10)/1;
end

if ~mod(nTrials,nSteps)
    contrastPerTrial = repmat(start:(nSteps),1,nTrials/nSteps);
else
    warning(['WARNING: UNEQUAL NUMBER OF TRIALS PER CONDITION \nnTrials is not divisible by nConds + bBlanks (or not divisible by nConds if running pilot).', ...
        '\nThis should not cause issues, but if this behavior is not desired, nTrials, nConds, and bBlanks can be changed in the config file.'])
    contrastPerTrial = repmat(start:(nSteps),1,round(nTrials/nSteps, TieBreaker = "fromzero"));
end

contrastPerTrial = contrastPerTrial(randperm(nTrials));

contrLowest = stg.quest50 - contrStep*((nSteps-1)/2);

end
