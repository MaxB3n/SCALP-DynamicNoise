function [contrastPerTrial,contrStep,contrLowest] = genContrast_questTo50only(blockType, nTrials, stg, cfg)

contrStep = -0.065;
if blockType == "Pilot"
    nSteps = cfg.pilot.nConds ;
    start = 1;
else
    nSteps = cfg.design.nConds + cfg.design.bBlanks;
    start = 1 - cfg.design.bBlanks;
end

if ~mod(nTrials,nSteps)
    contrastPerTrial = repmat(start:(nSteps),1,nTrials/nSteps);
else
    warning(['WARNING: UNEQUAL NUMBER OF TRIALS PER CONDITION \nnTrials is not divisible by nConds + bBlanks (or not divisible by nConds if running pilot).', ...
        '\nThis should not cause issues, but if this behavior is not desired, nTrials, nConds, and bBlanks can be changed in the config file.'])
    contrastPerTrial = repmat(start:(nSteps),1,round(nTrials/nSteps, TieBreaker = "fromzero"));
end

contrastPerTrial = contrastPerTrial(randperm(nTrials));

contrLowest = stg.quest50 - contrStep*((nSteps+1)/2);

end
