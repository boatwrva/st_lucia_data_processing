%%
%ctd calibration data for ttide leg 1, starting 14 january

%%

% ctd
cfg.ctdsn = '381';

% c1
cfg.c1sn = 2148;
cfg.c1cal.ghij = [-1.02302363e+001 1.52224652e+000 -2.79694315e-003 3.00294799e-004]; 
cfg.c1cal.ctpcor = [3.2500e-006 -9.5700e-008];
cfg.c1date = '20-Oct-17';

% t1
cfg.t1sn = 4230;
cfg.t1cal.ghij = [4.37243607e-003 6.48288745e-004 2.27023046e-005 1.80599980e-006];
cfg.t1cal.f0 = 1000;
cfg.t1date = '19-Oct-17';
    
% c2
cfg.c2sn = 2186;
cfg.c2cal.ghij = [-1.02643384e+001 1.36666445e+000 -2.31869612e-003 2.12954027e-004]; 
cfg.c2cal.ctpcor = [3.2500e-006 -9.5700e-008];
cfg.c2date = '27-Oct-17';

% t2
cfg.t2sn = 4303;
cfg.t2cal.ghij = [4.38502809e-003 6.47528128e-004 2.19218763e-005 1.64079432e-006];
cfg.t2cal.f0 = 1000;
cfg.t2date = '19-Oct-17';

% p
cfg.psn = 0383;	
cfg.pcal.c = [-4.928049e+004 -5.591409e-001 1.510530e-002];
cfg.pcal.d = [3.944700e-002 0.000000e+0];
cfg.pcal.t = [3.017493e+001 -4.671701e-004 3.967900e-006 3.098920e-009 0.000000e+0];
cfg.pcal.AD590 = [1.135000e-002 -8.132450e+000];
cfg.pcal.linear = [1.0000 0];
cfg.pdate = '15-May-15';

% oxygen ***from PsaReport.txt not cal sheet
cfg.oxsn = 0875;
cfg.oxcal.soc = 4.8090e-001;
cfg.oxcal.boc = 0.0;
cfg.oxcal.tcor = 0.0009;
cfg.oxcal.pcor = 1.35e-004;
cfg.oxcal.voffset = -0.5165;
cfg.oxdate = '';
