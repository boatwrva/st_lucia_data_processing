function load_hex_sproul(icast)


close all
fclose('all');
datadir='/Users/jen/projects/kerstin_sproul/raw_data/';
outdir='/Users/jen/projects/kerstin_sproul/processed_data/';

%datadir='/Users/kerstin/Desktop/SIO_year_4/MPL_intern/SP2412/ctd/data/';
%outdir='/Users/kerstin/Desktop/processed_data/';


icast=1;

%ctdlist = dir(fullfile(datadir,'SP2403_CTD*.hex'));
ctdlist = dir(fullfile(datadir,'SP2412_CTD1.hex'));

outname=ctdlist(icast).name;
ctdname = [datadir outname];
matname = [outdir outname(1:end-4) '.mat'];
xmlname= [datadir outname(1:end-3)  'XMLCON'];
disp(['CTD file: ' ctdname])

%%
% Load calibration coefficients
disp('configuring data')
cfg=MakeCtdConfigFromXMLCON(xmlname);
%cfgload_arcticMix

% 24 Hz data 
disp('loading hex file')
d = hex_read(ctdname);

disp('parsing')
data1 = hex_parse_arcticMix(d);
% Create time vector
data1.time = hex_time_sproul(icast,length(data1.t1));

% check for modcount errors
dmc = diff(data1.modcount);
mmc = mod(dmc, 256);
%figure; plot(mmc); title('mod diff modcount')
fmc = find(mmc - 1); 
if ~isempty(fmc); 
  disp(['Warning: ' num2str(length(dmc(mmc > 1))) ' bad modcounts']); 
  disp(['Warning: ' num2str(sum(mmc(fmc))) ' missing scans']); 
end

% check for time errors
dt = data1.time(end) - data1.time(1);
ds = dt*24;
np = length(data1.p);
mds = np - ds;
if abs(mds) >= 24;
    disp(['Warning: ' num2str(mds) ' difference in time scans']);
end

% % time is discretized
% nt=length(data1.time);
% time0=data1.time(1):1/24:data1.time(end);

% convert freq, volatage data
disp('converting:')
% *** fl, trans, ch4 
data2 = physicalunits(data1, cfg);

    %% Save 24 Hz data (no binning)
    save24 = 0;
    if save24
        disp('saving: 24 Hz data')
        matname24 = [matname(1:end-4) '_raw.mat'];
        disp(['saving: ' matname24])
        save(matname24,'data2','data3','datad4','datad5','datad6','datad7')
    end

    %% specify the depth range over which t-c lag fitting is done. For deep
    % stations, use data below 500 meters, otherwise use the entire depth
    % range.
    if max(data2.p)>1500
        data2.tcfit=[1500 max(data2.p)-5];
    else
        data2.tcfit=[0 max(data2.p)-5];
    end
    
    %%
    disp('cleaning:')
    % Remove pressure spikes, and spikes in temperature. Eliminate top 5 m
    % of data. Discard outliers beyond the range reasonable in the ocean.
    data3 = ctd_cleanup(data2);
    
    disp('correcting:')
    % ***include ch4
    [datad4, datau4] = ctd_correction_updn(data3); % T lag, tau; lowpass T, C, oxygen
    
    disp('calculating:')
    % *** despike oxygen
    datad5 = swcalcs(datad4, cfg); % calc S, theta, sigma, depth
    datau5 = swcalcs(datau4, cfg); % calc S, theta, sigma, depth

    %% Remove loops
    disp('removing loops:')
    wthresh = 0.1;
    datad6 = ctd_rmloops(datad5, wthresh, 1);
    datau6 = ctd_rmloops(datau5, wthresh, 0);
    
    %% Despike
    datad7 = ctd_cleanup2_arcticMix(datad6);
    datau7 = ctd_cleanup2_arcticMix(datau6);
    
    %% output raw data for someone if anyone wants it
    
    saveraw = 0;
    if saveraw
        matname0 = [outdir outname(1:end - 4) '_raw.mat'];
        disp(['saving: ' matname0])
%         save(matname0, 'data2','data3','datad4','datau4','datad5','datau5',...
%             'datad6','datau6','datad7','datau7')
        save(matname0, 'data2')
    end
    
    %% 0.25-m bin (good for temperature, salinity might be a little ratty looking, or maybe not)
    dobin = 1;
    if dobin
        disp('binning:')
        dz = 0.25; % m
        zmin = 0; % surface
        [zmax, imax] = max([max(datad7.depth) max(datau7.depth)]);
        zmax = ceil(zmax); % full depth
        datad = ctd_bincast(datad7, zmin, dz, zmax);
        datau = ctd_bincast(datau7, zmin, dz, zmax);
        datad.datenum=datad.time/24/3600+datenum([1970 1 1 0 0 0]);
        datau.datenum=datau.time/24/3600+datenum([1970 1 1 0 0 0]);
        
        disp(['saving: ' matname])
        save(matname, 'datad', 'datau')
    end
    
    
    %% 1m bin
    dobin = 1;
    if dobin
        disp('binning:')
        dz = 1; % m
        zmin = 0; % surface
        [zmax, imax] = max([max(datad7.depth) max(datau7.depth)]);
        zmax = ceil(zmax); % full depth
        datad_1m = ctd_bincast(datad7, zmin, dz, zmax);
        datau_1m = ctd_bincast(datau7, zmin, dz, zmax);
        datad_1m.datenum=datad_1m.time/24/3600+datenum([1970 1 1 0 0 0]);
        datau_1m.datenum=datau_1m.time/24/3600+datenum([1970 1 1 0 0 0]);
        
        disp(['saving: ' matname])
        save(matname, 'datad_1m', 'datau_1m','datad','datau')
    end
    
    
    
 %%   
 