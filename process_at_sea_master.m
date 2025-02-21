
%  St Lucia LADCP processing
%addpath '/Users/kerstin/Desktop/St_Lucia/2025/Processing_at_sea'

dir_name = '/Volumes/cruise/SR2503/';

% for Mac, can use the direct path 

dir_in = 'smb://sr-sci-filesvr.ucsd.edu/cruise/SR2503/';
dir_out = 'smb://sr-sci-filesvr.ucsd.edu/scienceparty_share/SR2503/';

% for MATLAB on Linux, you need to tunnel into the remote server 

dir_in = '/run/user/1001/gvfs/smb-share:server=sr-sci-filesvr.ucsd.edu,share=cruise/SR2503/'; 
dir_out = '/run/user/1001/gvfs/smb-share:server=sr-sci-filesvr.ucsd.edu,share=scienceparty_share/SR2503/'; 


%% Met
base = [dir_in 'metacq/data/'];
cruise = 'SR2503';
outpath = [dir_out, 'MetData/'];
%SR_get_metdata(base,cruise,outpath,rerunnit,times,DT);
times = [datenum('2025,02,20')];

SR_get_metdata(base, cruise, outpath, 1, times)


%% ADCP
ADCP_pathname = [dir_name 'adcp_uhdas/SR2503/proc/'];

%ADCPs: 'os38nb' 'wh300' 'os150nb'
ADCP = 'wh300';

ADCP_pathname = [ADCP_pathname ADCP '/contour'];

%% LADCP
% first set up the set_cast_params.m file 

% then run process_cast.m
% process_cast(4,1,16)