
%  St Lucia LADCP processing
addpath '/Users/kerstin/Desktop/St_Lucia/2025/Processing_at_sea'

dir_name = '/Volumes/cruise/SR2503/';



%% Met
base = [dir_name 'metacq/data/'];
cruise = 'SR2503';
outpath = '/Volumes/scienceparty_share/SR2503_scienceparty_share/MetData/';
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