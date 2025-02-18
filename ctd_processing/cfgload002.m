%%
%ctd calibration data for IWISE11, starting 10 June

%%

% ctd
cfg.ctdsn = '381';

% c1
cfg.c1sn = 3430; %aw
cfg.c1cal.ghij = [-1.00745152e+001 1.54099043e+000 -1.89692698e-003 2.32100199e-004]; 
cfg.c1cal.ctpcor = [3.2500e-6 -9.5700e-8];
cfg.c1date = '17-FEB_2011';

% t1
cfg.t1sn = 4588; %aw
cfg.t1cal.ghij = [4.35606486e-003 6.39038621e-004 2.15660660e-005 1.91690018e-006];
cfg.t1cal.f0 = 1000;
cfg.t1date = '11-FEB-2011';
    
% c2 
cfg.c2sn = 1880; %AW
cfg.c2cal.ghij = [-4.13343952e+000 5.04919612e-001 -7.10504771e-004 6.00439665e-005]; 
cfg.c2cal.ctpcor = [3.2500e-6 -9.5700e-8];
cfg.c2date = '16-FEB-2011';

% t2
cfg.t2sn = 4486; %AW
cfg.t2cal.ghij = [4.42190259e-003 6.49910099e-004 2.33578639e-005 2.03676795e-006];
cfg.t2cal.f0 = 1000;
cfg.t2date = '11-FEB-2011';

% p 
cfg.psn = 0401;	%AW
cfg.pcal.c = [-4.588163e+004 1.989810e-001 1.408190e-002];
cfg.pcal.d = [3.950300e-002 0.000000e+0];
cfg.pcal.t = [2.998526e+001 -2.557400e-004 4.268350e-006 1.671990e-009 0.0000e+000];
cfg.pcal.AD590 = [1.11700e-2 -8.66832E+0];
cfg.pcal.linear = [1.0 0.0];
cfg.pdate = '12-APR-2011';

% oxygen ***from PsaReport.txt not cal sheet (amy didn't update this one)
cfg.oxsn = 0255;
cfg.oxcal.soc = 4.8090e-001;
cfg.oxcal.boc = 0.0;
cfg.oxcal.tcor = 0.0009;
cfg.oxcal.pcor = 1.35e-004;
cfg.oxcal.voffset = -0.5165;
cfg.oxdate = '';
