function data = hex_parse_arcticMix(h)

h = char(h{ 1}(:)); % hex scans

% code used to process Arctic Mix CTD

data.t1 = hexword2freq(h(:, 1:6));
data.c1 = hexword2freq(h(:, 7:12));
data.p = hexword2freq(h(:, 13:18));
data.t2 = hexword2freq(h(:, 19:24));
data.c2 = hexword2freq(h(:, 25:30));

%data.test1 = hexword2volt(h(:, 31:36)); % ch0, ch1
%data.test2= hexword2volt(h(:, 37:42)); % ch2, ch3
%data.test3 = hexword2volt(h(:, 49:54)); % ch6, ch7

[data.lon, data.lat] = hexword2lonlat(h(:, 55:68)); % lonneg, latneg
data.pst = hexword2pststat(h(:, 69:72));
data.modcount = hex2dec(h(:, 73:74));

%data.test4=hex2dec(h(:,75:82))


% Time is not saved in each scan, need to solve for time from
% the header NMEA time and sampling frequency
% % seconds since 1970/1/1 0000
% data.time =  hex2dec(h(:, [81:82 79:80 77:78 75:76]));
