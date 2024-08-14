tmp = readtable("Saved_Data\02033_Quest_BehavResults_08-Aug-202414-28-18.txt")
tmp1 = tmp(1:50,:) ;
tmp2 = tmp(51:100,:) ;
tmp3 = tmp(101:150,:) ;
plot(tmp1.trials,-tmp1.contrastVal, "-og")
hold on
plot(tmp2.trials,-tmp2.contrastVal, "-or")
plot(tmp3.trials,-tmp3.contrastVal, "-ok")
hold off