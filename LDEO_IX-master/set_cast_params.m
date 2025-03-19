
more off;

dir_in = '/home/vboatwright/mnt/cruise/SR2503/';
path = '/home/vboatwright/mnt/scienceparty_share/SR2503_scienceparty_share/';
f.ladcpdo = sprintf('%sLADCP/raw/_RDI_%03d.000', path, stn);
f.ladcpdo = sprintf('%sLADCP/raw/_RDI_%03d.000', path, stn);

p.ladcp_station = stn;

f.res = sprintf('%sLADCP/processed/%03d', path, stn);
f.checkpoints = sprintf('%sLADCP/checkpoints/', path); 
f.ctd = sprintf('%sLADCP/ctd_cnv/SR2503_cast_%02d_nofilt.cnv', path, stn);
p.cruise_id = 'SR2503';
p.whoami = 'Bergentz & Boatwright';
p.name = sprintf('%s cast #%d',p.cruise_id,p.ladcp_station);


f.ctd_header_lines = 0;
f.ctd_fields_per_line = 6;
f.ctd_pressure_field = 2;
f.ctd_temperature_field = 3;
f.ctd_salinity_field = 4; %16 % we changed these based on the output from our .cnv CTD files
f.ctd_time_field = 1; %14
f.ctd_time_base = 0;
f.nav = f.ctd;
f.nav_header_lines = 0;
f.nav_fields_per_line = 6;
f.nav_time_field = 1; %14
f.nav_lat_field = 5; %12
f.nav_lon_field = 6; %13
f.nav_time_base = 0;

f.sadcp = '../SADCP/SADCP.mat';


%--------------------------------------------------------- 
%  If your LADCP clock wasn't set to UTC:
%---------------------------------------------------------
%     p.timoff = 6/24; % here eg it was set to local time of GMT(+6)

% If you didn't have ADCP data:
%p.drot = 110;
%p.poss = [CTD.datad.lon(44) CTD.datad.lat(44)];
%p.pose = [CTD.datad.lon(17128) CTD.datad.lat(17128)];


p.saveplot = [1:6 9:11 13:14];
p.saveplot_png  = [];

p.edit_mask_dn_bins = [1];
p.edit_mask_up_bins = [1];
p.checkpoints = [1];
