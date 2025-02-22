%% St Lucia data processing for lon/lat 

dir_in = '/run/user/1001/gvfs/smb-share:server=sr-sci-filesvr.ucsd.edu,share=cruise/'; 
% base = [dir_in 'metacq/data/'];
cruise = 'SR2503';
base = [dir_in cruise '/'];

%% MET



%% CTD




%% ADCP

adcp = 'adcp_uhdas/SR2503/proc/';
freq = 'wh300/';
filename = 'contour/contour_xy.mat';

pathname = [base adcp freq filename]; 
S = load(pathname);