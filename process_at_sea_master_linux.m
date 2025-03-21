
%  St Lucia LADCP processing
%addpath '/Users/kerstin/Desktop/St_Lucia/2025/Processing_at_sea'

addpath '/home/vboatwright/OneDrive/Documents/SIO/projects/st_lucia_data_processing'

dir_name = '/Volumes/cruise/SR2503/';

% for Mac, can use the direct path 

dir_in = 'smb://sr-sci-filesvr.ucsd.edu/cruise/SR2503/';
dir_out = 'smb://sr-sci-filesvr.ucsd.edu/scienceparty_share/SR2503/';

% for MATLAB on Linux, you need to tunnel into the remote server to read 
% and you need to make a direct CIFS mount to write (see instructions)

dir_in = '/run/user/1001/gvfs/smb-share:server=sr-sci-filesvr.ucsd.edu,share=cruise/SR2503/'; 
dir_in = '/home/vboatwright/mnt/cruise/SR2503/';
dir_out = '~/mnt/scienceparty_share/SR2503_scienceparty_share/'; % after you've mounted via CIFS 

% now, just accessing data from harddrive 
dir_in = '/media/vboatwright/KBZ/SR2503_cruise/';
dir_out = '/media/vboatwright/KBZ/SR2503_scienceparty_share/';


%% Met 

base = [dir_in 'metacq/data/'];
cruise = 'SR2503';
outpath = [dir_out, 'MetData'];
%SR_get_metdata(base,cruise,outpath,rerunnit,times,DT);
times = [datenum('2025,02,20'),datenum('2025,02,21'),datenum('2025,02,22'),datenum('2025,02,23'),datenum('2025,02,24'),datenum('2025,02,25'),datenum('2025,02,26'),datenum('2025,02,27'),datenum('2025,02,28')];

SR_get_metdata_linux(base, cruise, outpath, 1, times)



%% CTD stations

stn = 1;
% use load_hex_st_Lucia


%% ADCPDT

dir_name = dir_in ;
ADCP_pathname = [dir_name 'adcp_uhdas/SR2503/proc/'];

%ADCPs: 'os38nb' 'wh300' 'os150nb'
ADCP = 'wh300';
adcp_path = [ADCP_pathname ADCP '/contour'];


%% ADCP - data already processed
ADCP_pathname = [dir_in 'adcp_uhdas/SR2503/proc/'];

%ADCPs: 'os38nb' 'wh300' 'os150nb' 'wh300'


year=2025;

datadir=fullfile(ADCP_pathname); %for on board ship

wh_adcps={'wh300';'os150bb';'os150nb';'os38bb';'os38nb'};

ymaxs=[150 500 500 1500 1500];

todo=[1 3 5]; %nb only


for c=1:length(todo)%:length(wh_adcps)
    wh_adcp=wh_adcps{todo(c)};
    D = load_getmat(fullfile(datadir, wh_adcp, 'contour', 'allbins_'));

    if ~isempty(fields(D))
        adcp.u=D.u;%.*D.nanmask;
        adcp.v=D.v;%.*D.nanmask;
        adcp.amp=D.amp;%.*D.nanmask;

        adcp.lon=D.lon;
        adcp.lat=D.lat;
        adcp.yday=D.dday;
        adcp.dnum=yday2datenum(adcp.yday,year);
        adcp.z=D.depth(:,1); %make sure # of bins and bin size does not change to do this!
        adcp.depth=adcp.z;
        adcp.uship=D.uship;
        adcp.vship=D.vship;

        adcp.wh_adcp=wh_adcp;
        adcps{c}=adcp;
    end

end

% could save this on the science_share but would need to figure out how to
% concatenate etc


%% LADCP

% This master script processes LADCP data using CTD and shipboard ADCP
% It is currently only running one station at a time but could probably be adapted to loop
% 
% Your LADCP directory should be set up as follows:
% - One folder called 'raw' with _RDI_xxxx.000 files
% - one folder called "processed" for output
% - one folder called "checkpoints"
% - one folder called "SADCP" in which the shipboard ADCP stuff goes
% 
% You need scripts:
% 1. load_hex_St_Lucia
% 2. set_cast_params 
% note that both these need to be modified
% as well as all your regular ctd processing toolboxes and the LDEO IX toolbox
% If you haven't already, (re)process the CTD stuff to make .cnv files

output_base_dir = '/home/vboatwright/mnt/scienceparty_share/SR2503_scienceparty_share/LADCP/';
output_base_dir = '/media/vboatwright/KBZ/SR2503_scienceparty_share/LADCP/';

% pick a station
stn = 10; % for now this only runs one cast at a time.


% Then get shipboard ADCP data and run mkSADCP

SADCP_output_file = [output_base_dir 'SADCP/SADCP.mat'];
ADCP_contour_dir = [adcp_path '/contour/'];

%mkSADCP(ADCP_contour_dir, SADCP_output_file)


%% Then set your cast parameters 
% double check the script set_cast_parameters.mat
% note that set_cast_params has to be it's own sepaCTDrate script or it won't
% work

%% Then run the LADCP processing:
% make sure we grab the right set_cast_params & set cast from LDEO code 
% process_cast from LDEO 
cd '/home/vboatwright/OneDrive/Documents/SIO/projects/st_lucia_data_processing/LDEO_IX-master' 

process_cast(stn,1,0) % station number, start on step 1 and do all steps (0 - default)

