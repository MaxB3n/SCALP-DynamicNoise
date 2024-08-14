function resp = generateResponseTable(blockType, nTrials, stg, sess, cfg) 
disp("Generating Response Tables based on input.... \n\n")

resp.subNum = ones(nTrials,1) * str2num(sess.subNum) ;
resp.contrastVal = ones(nTrials,1) * 0.99 ;
resp.accuracy = ones(nTrials,1) ;
resp.responseTime = ones(nTrials,1) *0.99 ;
resp.pas = ones(nTrials,1) ;
resp.trials = zeros(nTrials,1) ;

switch blockType
    case "Quest"
        resp.thresh = zeros(nTrials,1);
    case "Pilot"
        resp.contrastLv = zeros(nTrials,1);
    otherwise
end

end