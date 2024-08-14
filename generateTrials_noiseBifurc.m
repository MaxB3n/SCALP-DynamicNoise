function [trls,stg] = generateTrials_noiseBifurc(blockType, stg, sess, cfg) 
disp("Generating Trials based on input.... \n\n")

if blockType == "Report" || blockType == "No Report" || blockType == "Pilot"
    nTrials = cfg.design.nTrials;
    [trls.contrastPerTrial,stg.contrStep,stg.contrLowest] = genContrast_questTo50only(blockType, nTrials, stg, cfg) ;%genContrast_questTo10and50(blockType, nTrials, stg, cfg);
    if blockType == "No Report"
        trls.distractorPerTrial = cat(1,repmat(1,cfg.design.nDistractor,1),repmat(0,nTrials-cfg.design.nDistractor,1)) ;
        trls.distractorPerTrial = trls.distractorPerTrial(randperm(nTrials)) ;
        trls.contrastPerTrial(trls.distractorPerTrial) = -randi([1 4],cfg.design.nDistractor,1) ;
    end
elseif blockType == "Quest"
    nTrials = cfg.design.questTrials;
else
    warning("block type not recognized, should be one of 'Report', 'No Report', 'Quest', 'Pilot'.")
    abortExperiment
end

% Set Jitter Randomly
trls.frameJitterPerTrial = randi(stg.jitterFrames,nTrials);
trls.jitterXPerTrial = randi([round((sess.ptb.rect(3)-stg.stimJitterDim)/2) round((sess.ptb.rect(3)+stg.stimJitterDim)/2)], nTrials);
trls.jitterYPerTrial = randi([round((sess.ptb.rect(4)-stg.stimJitterDim)/2) round((sess.ptb.rect(4)+stg.stimJitterDim)/2)], nTrials);

% Set Stim Orientations %
trls.orientationPerTrial = repmat(0:1,1,nTrials/2);
trls.orientationPerTrial = trls.orientationPerTrial(randperm(nTrials));

% Set contrast and no report trials



end