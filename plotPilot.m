function plotPilot(filename)

%hold off

T = readtable(filename);

M = groupsummary(T,"contrastVal","mean");

plot(-M.contrastVal,M.mean_accuracy,"-or")

end

