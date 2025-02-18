more off;
mkSADCP('/Data/ADCP/LADDER-1','../data/SADCP/SADCP.mat');

%-------------------------------------------------------------------
% on stn 4, switched heads but not serial numbers in DEFAULTS.expect
% on stn 9, uplooker bombed; after stn 17, no uplooker available
%-------------------------------------------------------------------

if stn == 4
f.ladcpup = sprintf('../data/raw/%03d/%03ddn000.000',stn,stn);
f.ladcpdo = sprintf('../data/raw/%03d/%03dup000.000',stn,stn);
elseif stn == 9 | stn >= 18
f.ladcpdo = sprintf('../data/raw/%03d/%03ddn000.000',stn,stn);
f.ladcpup = ' ';
else
f.ladcpdo = sprintf('../data/raw/%03d/%03ddn000.000',stn,stn);
f.ladcpup = sprintf('../data/raw/%03d/%03dup000.000',stn,stn);
end360
f.res = sprintf('../data/processed/%03d',stn);
f.checkpoints = sprintf('../data/checkpoints/%03d',stn);
f.ctd = sprintf('../data/CTD/at1512_911_%03d_1s.cnv',stn);
f.ctd_header_lines = 115;
f.ctd_fields_per_line = 20;
f.ctd_pressure_field = 2;
f.ctd_temperature_field = 3;
f.ctd_salinity_field = 16;
f.ctd_time_field = 14;
f.ctd_time_base = 0;
f.nav = f.ctd;
f.nav_header_lines = 115;
f.nav_fields_per_line = 20;
f.nav_time_field = 14;
f.nav_lat_field = 12;
f.nav_lon_field = 13;
f.nav_time_base = 0;
f.sadcp = '../data/SADCP/SADCP.mat';

%---------------------------------------------------------
% before stn 10, LADCP clock was set to local time (GMT+6)
%---------------------------------------------------------

if stn <= 9
p.timoff = 6/24;
end

p.cruise_id = 'LADDER-1';
p.whoami = 'A.M. Thurnherr';
p.name = sprintf('%s cast #%d',p.cruise_id,p.ladcp_station);
p.saveplot = [1:6 9:11 13:14];
p.saveplot_png = [];
p.ladcp_station = stn;
p.edit_mask_dn_bins = [1];
p.edit_mask_up_bins = [1];
p.checkpoints = [1];
