

%% leore data 7/31 with percent value (0.70 0.55) (subject no 111) - red

T = readtable("Saved_Data\111_PilotBehavioralResults_31-Jul-202411-36-22.csv");

M = groupsummary(T,"contrast","mean");

plot(M.contrast,M.mean_accuracy,"-or")
ylabel('percent correct')
xlabel('contrast level')
hold on 

%% leore data tues 7/30 w percent value (0.75 0.55) (subject no 777) - green

C = readtable("Saved_Data\777_PilotBehavioralResults_29-Jul-202414-31-56.csv");

V = groupsummary(C,"contrast","mean");

plot(V.contrast,V.mean_accuracy,"-og")


%% graphing leore data 8/5 w percent value (0.70 0.70) subject no 987 - magenta

d = readtable("Saved_Data\987_Pilot_Results_05-Aug-202415-41-19.csv");

g = groupsummary(d,"contrastVal","mean");

plot(-g.contrastVal,g.mean_accuracy,"-om")
hold on
%% graphing leore data 8/5 w percent value (0.65 0.65) (subject no 12345) - dark blue

s = readtable("Saved_Data\12345_Pilot_Results_05-Aug-202416-01-48.csv");

m = groupsummary(s,"contrastVal","mean");

plot(-m.contrastVal,m.mean_accuracy,"-ob")

%% leore data 8/6 w percent value (0.70 0.62) (subject 33333) - black 

q = readtable("Saved_Data\33333_Pilot_Results_06-Aug-202410-42-10.csv");

ee = groupsummary(q,"contrastVal","mean");

plot(-ee.contrastVal,ee.mean_accuracy,"-ok")



%% angelica data 8/5 w percent value (0.68 0.68) (subject no 8765) - teal

f = readtable("Saved_Data\8765_Pilot_Results_05-Aug-202416-31-21.csv");

b = groupsummary(f,"contrastVal","mean");

plot(-b.contrastVal,b.mean_accuracy,"-oc")

%% angelica data 8/6 w percent (0.68 0.68) (subject no 88888) - orange 
hh = readtable("Saved_Data\88888_Pilot_Results_06-Aug-202411-10-26.csv");

k = groupsummary(hh,"contrastVal","mean");

plot(-k.contrastVal,k.mean_accuracy,"-og");


%% plotting contrast level = threshold 

xline(4,"--k")

set(gca,'color','gray')
print(f(1),num2str(SavePath),'-dmeta');
%%







%% abby 8/7 (0.75) (02021) 
hold on

abby = readtable("Saved_Data\02022_Pilot_Results_07-Aug-202414-25-54.csv");
abbySum = groupsummary(abby, "contrastVal", "mean") ;
plot(-abbySum.contrastVal, abbySum.mean_accuracy, "-om") % pink 



%% leore 8/7 (0.75) (02012)

leore = readtable("Saved_Data\02012_Pilot_Results_07-Aug-202413-39-01.csv");
leoreSum = groupsummary(leore, "contrastVal", "mean");
plot(-leoreSum.contrastVal, leoreSum.mean_accuracy, "-o", Color = '#7E2F8E') % purple


%% Max 8/7 (0.75) (02031)

Max= readtable("Saved_Data\02031_Pilot_Results_07-Aug-202414-05-21.csv");
maxSum = groupsummary(Max, "contrastVal","mean");
plot(-maxSum.contrastVal, maxSum.mean_accuracy, "-o", Color = '#77AC30') % green 


%% Colton 8/7 (02081)

colton = readtable("Saved_Data\02081_Pilot_Results_07-Aug-202414-50-10.csv") ;
coltonSum = groupsummary(colton, "contrastVal", "mean") ;
plot(-coltonSum.contrastVal,coltonSum.mean_accuracy, "-or") % red

%% Leore 8/8 (02014

leore2 = readtable("Saved_Data\02014_Pilot_Results_08-Aug-202413-03-08.csv");
leore2Sum = groupsummary(leore2, "contrastVal", "mean");
plot(-leore2Sum.contrastVal, leore2Sum.mean_accuracy, "-ok") % black 

%% Jules 8/8 (02061)

jules = readtable("Saved_Data\02061_Pilot_Results_08-Aug-202413-33-47.csv");
julesSum = groupsummary(jules, "contrastVal", "mean");
plot(-julesSum.contrastVal, julesSum.mean_accuracy, "-o", Color = '#4DBEEE') % light blue 

%% Max 8/8 (02033)
Max2= readtable("Saved_Data\02033_Pilot_Results_08-Aug-202414-37-57.csv");
max2Sum = groupsummary(Max2, "contrastVal","mean");
plot(-max2Sum.contrastVal, max2Sum.mean_accuracy, "-ob") % ocean blue 


%% Abby 8/9 (02024)
% abby2= readtable("Saved_Data\02024_Pilot_Results_09-Aug-202411-21-22.csv");
% abby2Sum = groupsummary(abby2, "contrastVal","mean");
% plot(-abby2Sum.contrastVal, abby2Sum.mean_accuracy, "-oc")

%% Leore 8/9 (02014)

leore3 = readtable("Saved_Data\02015_Pilot_Results_09-Aug-202412-05-00.csv");
leore3Sum = groupsummary(leore3, "contrastVal", "mean");
plot(-leore3Sum.contrastVal, leore3Sum.mean_accuracy, "-o", Color= '#EDB120'); % Gold

%% Max 8/9 (02035)
Max3= readtable("Saved_Data\02035_Pilot_Results_09-Aug-202412-32-46.csv");
max3Sum = groupsummary(Max3, "contrastVal","mean");
plot(-max3Sum.contrastVal, max3Sum.mean_accuracy, "-o", Color='#D95319') % orange


%% leore 8/12 (02015)




%% PAS Graphs 




%%
ylabel('percent correct (threshold = 75% correct)')
xlabel('contrast value')
xlim([0.05 0.425])
ylim([0.5 1])

yline(0.75, "--k")

legend('Abby', 'Leore', 'Max', 'Colton')


