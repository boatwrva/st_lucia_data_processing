

% Loading in an processing the Sproul data for St Lucia

addpath(genpath('/Users/kerstin/Desktop/St_Lucia/'))
addpath(genpath('/Users/kerstin/Desktop/ASTraL/matlab_scripts'))

%%%% CTD 
dir = '/Users/kerstin/Desktop/St_Lucia/May_2024/ctd/data';

% 
% AT = Airtemp C
% BP - Barometric Pressure
% BS - BP corrected to sea level
% RH - Relative Humidity
% RT - Air Temp RH module
% DP - Dew Point
% PR - Precipitation
% LD - LWR dome temp
% LB - LWR Body temp
% LT - LWR Thermphile
% LW - Long wave radiation
% SW - Short wave radiation
% PA - Surface PAR
% WS - Rel Wind Speed
% WD - Rel Wind Direction
% TW - True wind Speed
% TI - True wind direction
% TT - thermosalinograph temperature
% TC - thermosalinograph conductivity - mS/cm with slope offset correction
% SA - salinity PSU
% SD - Sigma-T
% SV - Sound Velocity
% TG - thermosalinograph conductivity ms/cm no slope offset correction
% FL - Flourometer
% OT - Oxygen Temperature
% OX - Oxygen ml/l
% OS - Oxygen saturation value
% TR - Transmissometer
% BA - Beam Attenuation
% ST - Sea Surface Temperature
% BT - Bottom Depth
% BT_2 - ????
% LF - Depth Sounder 3.5KHz
% HF - Depth Sounder 12KHz
% LA - Latitude decimal degree
% LO - Longitude decimal degree
% GT - GPS time of day
% CR - Ship course GPS COG
% SP - Ship speed GPS SOG
% ZD - GPS dateTime - GMT Secs Since 00:00:00 01/01/1970
% GA - GPS Altitude - Meters above/below Mean Sealevel
% GS - GPS Status/Number Satellites
% GY - Ships Heading (Gyrocompass)
% ZO - Winch wire out
% ZS - Winch Speed
% ZT - Winch Tension
% ZI - ZI Winch ID Winch LAN numbers 1 thru 9
% IP - CTD Depth
% IV - CTD Velocity
% IA - CTD Altimeter




%% MET data

clear; close all;

addpath(genpath('/Users/kerstin/Desktop/St_Lucia'))

%run setup
%run('ASTRAL23_setup.m')
path_main = '/Users/kerstin/Desktop/St_Lucia/May_2024';


%set up data path
path_data = [path_main,'/','met','/','data'];
flist = dir([path_data,'/','*.MET']);

%loop through all available MET files
dataFull = [];
timeFull = [];

for ii = 1:length(flist)

   fileID = fopen([flist(ii).folder '/' flist(ii).name], 'r');
    
    % Check if the file exists
    if fileID == -1
        error('File not found or permission denied');
    end
    
    
    % Read and store metadata (assuming the first few lines are metadata)
    metadata = [];
    for i = 1:4 % Change this number based on how many metadata lines there are
        metadata{end+1} = fgetl(fileID);
    end
    
    % Initialize arrays to store the data
    data = [];
    
    % Read the file line by line
    while ~feof(fileID)
        line = fgetl(fileID);
        
        % Parse the line, assuming space-delimited data
        dataRow = str2double(strsplit(line, ' '));
        
        % Append the parsed data to the array
        data = [data; dataRow];


    end

         %time formatting
        fname = flist(ii).name;
        date = fname(1:end - 4);
        time = data(:,1);
        time_dt = cell(length(time),1);
        for jj = 1:length(time)
            t = num2str(time(jj));
            if length(t) < 6
                u = num2str([ones(1,6-length(t))*0]);
                u = u(~isspace(u));
                t = [u,t];
            end
            time_dt(jj) = {[date,t]}; 
        end
        time_dt = datetime(time_dt,"InputFormat",'yyMMddHHmmss');

    
    % Close the file
    fclose(fileID);

    dataFull = [dataFull; data];
    timeFull = [timeFull; time_dt];



end


%Mask bad data
dataFull(dataFull == -99) = NaN;
dataFull(:,1) = datenum(timeFull);

tableheaders = strsplit(metadata{4},' ');
% remove an annoying # 
tableheaders{1} = 'Time';
tableheaders{33} = 'BT_2';

met_fs = struct();

% Loop through the array and assign each element to a field in the structure
for ii = 1:size(dataFull,2)
    fieldName = tableheaders{ii}; % Create a field name like 'field1', 'field2', etc.
    met_fs.(fieldName) = dataFull(:,ii);          % Assign the array element to the field
end



%% ADCP data

function adcps=LoadNewADCP_SPROUL_2023(plotit)

%5/2023 MHA
%Load in the ADCP data from the cruise shared data server.

year=2024;

%basedir='/Users/kerstin/Library/CloudStorage/GoogleDrive-ncouto@ucsd.edu/Shared drives/TFOSeamounts2023_ship_data/04_ship_data/adcp';
basedir='/Users/kerstin/Desktop/St_Lucia/May_2024/currents';


%datadir=fullfile(basedir,'proc'); %for on board ship
datadir=fullfile(basedir,'proc');

%wh_adcps={'wh300';'os150bb';'os150nb';'os38bb';'os38nb'};
wh_adcps={'wh300';'os150bb';'os150nb';'os38bb';'os38nb'};

ymaxs=[150 500 500 1500 1500];

todo=[2 3]; %SPROUL ONLY HAS THESE TWO!


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


end


%% CTD casts

