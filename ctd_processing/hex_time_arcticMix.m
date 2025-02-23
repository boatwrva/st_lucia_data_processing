function time = hex_time_arcticMix(datadir,castnumber,totalscans)
% Using the cast's header file and number of scans create a time vector
% giving the time in seconds since 1970/1/1 0000 based on the number of
% scans averaged for each given data point with the CTD sampling at 24 Hz.

% 
%
% datadir='/Users/jen/projects/arctic/data/ctd/raw/';
ctdlist = dirs(fullfile(datadir,'*.hdr'));
hdrname = [datadir ctdlist(castnumber).name];
fid=fopen(hdrname);

% Read header for start time and averaging;
str=fgetl(fid);
while ~strncmp(str,'*END*',5)
    if strncmp(str,'* NMEA UTC',10)
        % Start time of cast in UTC
        start_time=datenum(str(21:end),'mmm dd yyyy  HH:MM:SS');  % [days]
    elseif strncmp(str,'* number of scans',17)
        % time between deck unit-avereaged data points
        dt=str2double(str(end-1:end))/24;   % [s]
    end
    str=fgetl(fid);
end

% Initialize time
base_time=datenum(1970,1,1);    % [days]
scan=transpose(0:totalscans-1);
start_time_sec1970=(start_time-base_time)*86400;      % [s]

time=start_time_sec1970+(scan*dt);      % [s] since 1970