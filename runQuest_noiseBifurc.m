function [quest50] = runQuest_noiseBifurc(stg, sess, cfg)
 
thresholds = [0.75 0.7 0.7];

%Generate quest trial info
nThresh = length(thresholds);
questTrials = cfg.design.questTrials;

f_quest = fopen('f_quest_results.txt','a');
fprintf(f_quest,'subject stim trial Contrast_Value Quest_SD \n');
f_summary = zeros(nThresh,2);
f_summary(:,1) = (thresholds-0.50)*200 ; %accuracy -> percent seen

% Reset relevant settings 
missed = 0;

%Indicate beginning of quest
Screen('TextSize', sess.ptb.w, 40);
DrawFormattedText(sess.ptb.w, ['You are about to begin the quest procedure!', ...
    '\n\nPress any key to continue ...'], 'center', 'center', [0 0 0], 80);
Screen('Flip', sess.ptb.w);
KbWait([],2);

getReady( "Quest", sess, cfg) 

for d = 1:nThresh
    % Pre trial quest overhead
    pThreshold = thresholds(d);
    guessVal = 0.2; % this is for contrast
    SdVal = 0.12;    % " "
    tGuess = guessVal;
    tGuessSd = SdVal;
    beta = 3.5;
    delta = 0.01;
    gamma = 0.25;
    q = QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma);
    cSum = 0 ;

    qtrls = generateTrials_noiseBifurc("Quest", stg, sess, cfg) ;
    qresp = generateResponseTable("Quest", questTrials, stg, sess, cfg) ;

    if d > 1
        getReady( "interBlock", sess, cfg) 
    end
    noiseTex = readyNoise(sess.ptb.w, stg.noiseDim, cfg.noise.transp, cfg.noise.pSpatialFrequency);
    
    % trial loop
    for t = 1:questTrials
        ContrastValue = 10^(QuestMean(q)) ;
        ContrastVal = 1-ContrastValue ;
        if ContrastVal > -0.1
            ContrastVal = -0.1;
        end
        tGuessSd = QuestSd(q) ; 

        %if t > 1
        %    DrawFormattedText(sess.ptb.w, sprintf('Last one correct?:  %d\n\n contrast Dif: %0.2f',twoAfcAcc, oldContrast-ContrastVal), sess.ptb.x/2, sess.ptb.y/10, [ 0 0 0 ], 40);
        %    Screen('Flip', sess.ptb.w) ;
        %    KbWait([],2)
        %end
        %oldContrast = ContrastVal ;

        [twoAfcAcc, responseTime, pasResponse, missed] = runTrial(t, ContrastVal, "Quest", qtrls, stg, sess, cfg, missed) ;

        % Store 
        qresp.contrastVal(t) = ContrastVal;
        qresp.accuracy(t) = twoAfcAcc;
        qresp.responseTime(t) = responseTime ;
        qresp.trials(t) = t;
        qresp.thresh(t) = thresholds(d)';

        intensity = log10(ContrastValue) ;
        q = QuestUpdate(q,intensity, twoAfcAcc) ;
        fprintf(f_quest,'%s %d %d %d \n', sess.subNum, t, ContrastVal, tGuessSd) ;
        
        if t > 30
            cSum = cSum + ContrastVal ;
            c = cSum / (t - 30) ;
        end

    end

     
     if d > 1
         qBehavTable = cat(1, qBehavTable , struct2table(qresp));
     else 
         qBehavTable = struct2table(qresp);
     end

    % Post trial quest overhead
    %q_ContrastValue = 10^(QuestMean(q)) ;
    %q_ContrastVal = 1-q_ContrastValue ;
    f_summary(d,2) = c; %ContrastVal ; %q_ContrastValue ;
end

% Write results to log


if ismember(5, sess.filesToSave)
    file = sprintf("%s%s_Quest_BehavResults_%s%s",sess.saveDir,sess.subNum,sess.date,sess.startTime) ;
    writetable(qBehavTable,file)
    
    file = sprintf("%s%s_Quest_ContrResults_%s%s",sess.saveDir,sess.subNum,sess.date,sess.startTime) ;
    qSummaryTable = array2table(f_summary,'VariableNames',{'Percent_Seen','Contrast'});
    writetable(qSummaryTable,file)
end

quest50 = (f_summary(1,2) + f_summary(2,2) + f_summary(3,2))/3 ;

%quest10 = f_summary(2,2); quest50 = (f_summary(1,2) + f_summary(2,2))/2; %(f_summary(2,2) + f_summary(4,2))/2 ; quest50 = (f_summary(1,2) + f_summary(3,2))/2 ;

end