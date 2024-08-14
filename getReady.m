function getReady(blockType, sess, cfg)

if blockType == "interBlock"
    Screen('TextSize', sess.ptb.w, 40);
    DrawFormattedText(sess.ptb.w, 'Press any key when you are ready to continue.', 'center', 'center', [0 0 0], 80);
    Screen('Flip', sess.ptb.w);
    KbWait([],2);
    return;
else

if blockType == "Pilot"
    blocks = cfg.pilot.nBlocks ;
    trials = cfg.design.nTrials ;
elseif blockType == "Quest"
    blocks = 3 ;
    trials = cfg.design.questTrials ;
else
    blocks = cfg.design.nBlocks ;
    trials = cfg.design.nTrials ;
end

readyText = ['There will be ', num2str(blocks), ' rounds of ', num2str(trials),... 
    ' trials in this section.\n\nPress any key to begin.'];

Screen('TextSize', sess.ptb.w, 40);
    DrawFormattedText(sess.ptb.w, readyText, 'center', 'center', [0 0 0], 80);
    Screen('Flip', sess.ptb.w);
    KbWait([],2);

end