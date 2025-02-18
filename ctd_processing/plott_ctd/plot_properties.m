%% Plot properties
%colors
plotc = [0 0 0];
ac = [1 1 1];



%Axes Limits
tlim = [4 15];
slim = [31 35];
dlim = [1024 1028];
ulim = [-.5 .5];
depthlim=[0 1300];
dislim = [-9 -5];


station1 = [1 43];
station2 = [44 109];
station3 = [110 nrcast];
section2_x = [44 nrcast];
canyon9 = [222 nrcast];
canyon7 = [258 nrcast];
canyon6 = [306 nrcast];

timelim = [CTD.time(canyon7(1),1) CTD.time(canyon7(2),end)];
