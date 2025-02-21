% Code for processing CTD casts for St Lucia Escarpment on Sally Ride
% Feb/March 2025.
% 
% Change:
% 1. the data dir in the hex_time_XXXX you're using.
% 2. changed the number of variabes in: MakeCtdConfigFromXMLCON


close all
fclose('all');
cruise= 'ST_LUCIA';

datadir = '/Volumes/cruise/SR2503/ctd/data/';
outdir = '/Volumes/scienceparty_share/SR2503_scienceparty_share/CTD/';
outdir_cnv = '/Volumes/scienceparty_share/SR2503_scienceparty_share/LADCP/ctd_cnv/';

icast=stn;

ctdlist = dirs(fullfile(datadir,'*.hex'));
outname = ctdlist(icast).name;
ctdname = [datadir outname];
matname = [outdir outname(1:end-4) '.mat'];
xmlname = [datadir outname(1:end-11) 'cast' outname(end-6:end-3) 'XMLCON']
disp(['CTD file: ' ctdname])

%
% Load calibration coefficients
disp('configuring data')

cfg=MakeCtdConfigFromXMLCON(xmlname);
% THIS ONLY DOES CTD, need to figure out Oxygen and chlorophyll.. cfdload?


% 24 Hz data 
disp('loading hex file')
d = hex_read(ctdname); 

disp('parsing')
data1 = hex_parse_arcticMix(d);
% Create time vector for ArcticMix
data1.time = hex_time_arcticMix(datadir,icast,length(data1.t1));

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

% %% Save 24 Hz data (no binning)
% save24 = 0;
% if save24
%     disp('saving: 24 Hz data')
%     matname24 = [matname(1:end-4) '_raw.mat'];
%     disp(['saving: ' matname24])
%     save(matname24,'data2','data3','datad4','datad5','datad6','datad7')
% end


% specify the depth range over which t-c lag fitting is done. For deep
% stations, use data below 500 meters, otherwise use the entire depth
% range.
if max(data2.p)>800
    data2.tcfit=[1500 max(data2.p)-5];
else
    data2.tcfit=[0 max(data2.p)-5];
end

    
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

% Remove loops
disp('removing loops:')
wthresh = 0.1;
datad6 = ctd_rmloops(datad5, wthresh, 1);
datau6 = ctd_rmloops(datau5, wthresh, 0);

% Despike
datad7 = ctd_cleanup2_arcticMix(datad6);
datau7 = ctd_cleanup2_arcticMix(datau6);
    
% %% output raw data for someone if anyone wants it
% 
% saveraw = 1;
% if saveraw
%     matname0 = [outdir outname(1:end - 4) '_raw.mat'];
%     disp(['saving: ' matname0])
% %         save(matname0, 'data2','data3','datad4','datau4','datad5','datau5',...
% %             'datad6','datau6','datad7','datau7')
%     save(matname0, 'data2')
% end

% 0.25-m bin (good for temperature, salinity might be a little ratty looking, or maybe not)
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
    
 % 1m bin
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
    
  

% save as a text file for use by LADCP
% dataout=[CTD.sec(:) CTD.p(:) CTD.t1(:) CTD.s1(:)];
% save([rootdir filename '_clean.cnv'],'dataout','-ascii','-tabs')

% took this from load_hex_nemo found in the NORSE/shared programs/ctd/proc2
% something something...

% a little  too high resolution in time, stalls ladcp processing
% try to reduce a bit
data3b = swcalcs(data3, cfg); % calc S, theta, sigma, depth

sec=data3b.time-min(data3b.time);
p=data3b.p;
t=data3b.t1;
s=data3b.s1;
lat=data3b.lat;
lon=data3b.lon;


dataout=[sec p t s lat lon];
ig=find(~isnan(sec)); dataout=dataout(ig,:);
save([outdir_cnv outname(1:end-4) '_nofilt.cnv'],'dataout','-ascii','-tabs')

disp(['Done processing cast ' num2str(stn)])

%%

    
%      %% compute epsilon from Thorpe scales now, as a test
%     doeps = 1;
%     if doeps
%         sigma_t=2e-4;
%         sigma_rho=5e-4;
%         
%         disp('Calculating epsilon:')
%         [Epsout,Lmin,Lot,runlmax,Lttot]=compute_overturns2(datad6.p,datad6.t1,datad6.s1,nanmean(datad6.lat),0,3,sigma_rho,0);
%         %[epsilon]=ctd_overturns(datad6.p,datad6.t1,datad6.s1,33,5,5e-4);
%         datad6.epsilon1=Epsout;
%         [epsilon]=compute_overturns(datad6.p,datad6.t2,datad6.s2,33,5,5e-4);
%         datad6.epsilon2=epsilon;
%     end
%     
    
%     %% Test 1
%     testing = 0;
%     if testing
%         
%         load ../../model/TS/ts_swir_03 % Te Se Ze
%         Pe = sw_pres(Ze, -33);
%         
%         data3.s1 = sw_salt(10*data3.c1/sw_c3515, data3.t1, data3.p);
%         data3.s2 = sw_salt(10*data3.c2/sw_c3515, data3.t2, data3.p);
%         
%         figure; orient tall; wysiwyg
%         ax(1) = subplot(411); plot(real(data3.c1), 'b'); grid; set(gca, 'YLim', [3 5]); title('c1')
%         ax(2) = subplot(412); plot(real(data3.c2), 'r'); grid; set(gca, 'YLim', [3 5]); title('c2')
%         ax(3) = subplot(413); plot(real(data3.t1), 'b'); grid; set(gca, 'YLim', [0 23]); title('t1')
%         ax(4) = subplot(414); plot(real(data3.t2), 'r'); grid; set(gca, 'YLim', [0 23]); title('t2')
%         linkaxes(ax, 'x');
%         
%         figure; orient landscape; wysiwyg
%         ax(1) = subplot(141); plot(datad.s1, datad.p, 'b', datad.s2, datad.p, 'r--'); grid; axis ij; set(gca, 'XLim', [34.2 36]); title('s dn');
%         hold on; plot(Se, Pe, 'g'); hold off
%         ax(2) = subplot(142); plot(datad.t1, datad.p, 'b', datad.t2, datad.p, 'r--'); grid; axis ij; set(gca, 'XLim', [0 23]); title('t dn');
%         hold on; plot(Te, Pe, 'g'); hold off
%         ax(3) = subplot(143); plot(datau.s1, datau.p, 'b', datau.s2, datau.p, 'r--'); grid; axis ij; set(gca, 'XLim', [34.2 36]); title('s up');
%         hold on; plot(Se, Pe, 'g'); hold off
%         ax(4) = subplot(144); plot(datau.t1, datau.p, 'b', datau.t2, datau.p, 'r--'); grid; axis ij; set(gca, 'XLim', [0 23]); title('t up');
%         hold on; plot(Te, Pe, 'g'); hold off
%         linkaxes(ax,'y');
%         
%         figure; orient landscape; wysiwyg; clear ax
%         ax(1) = subplot(131); plot(data3.s1,data3.p,'b', data3.s2,data3.p,'r--'); grid; axis ij; set(gca, 'XLim', [34.2 36]); title('data3.s1 s2')
%         hold on; plot(Se, Pe, 'g'); hold off
%         ax(2) = subplot(132); plot(datau6.s1,datau6.p,'b', datau6.s2,datau6.p,'r--'); grid; axis ij; set(gca, 'XLim', [34.2 36]); title('datau6.s1 s2')
%         hold on; plot(Se, Pe, 'g'); hold off
%         ax(3) = subplot(133); plot(datad6.s1,datad6.p,'b', datad6.s2,datad6.p,'r--'); grid; axis ij; set(gca, 'XLim', [34.2 36]); title('datad6.s1 s2')
%         hold on; plot(Se, Pe, 'g'); hold off
%         linkaxes(ax,'xy');
%         
%         figure; orient landscape; wysiwyg; clear ax
%         ax(1) = subplot(131); plot(data3.t1,data3.p,'b', data3.t2,data3.p,'r--'); grid; axis ij; set(gca, 'XLim', [0 23]); title('data3.t1 t2')
%         hold on; plot(Te, Pe, 'g'); hold off
%         ax(2) = subplot(132); plot(datau6.t1,datau6.p,'b', datau6.t2,datau6.p,'r--'); grid; axis ij; set(gca, 'XLim', [0 23]); title('datau6.t1 t2')
%         hold on; plot(Te, Pe, 'g'); hold off
%         ax(3) = subplot(133); plot(datad6.t1,datad6.p,'b', datad6.t2,datad6.p,'r--'); grid; axis ij; set(gca, 'XLim', [0 23]); title('datad6.t1 t2')
%         hold on; plot(Te, Pe, 'g'); hold off
%         linkaxes(ax,'xy');
%         
%     end
%     
%     
%     %% Test 2
%     testing2 = 0;
%     if testing2
%         
%         
%         zd = runmean(datad.depth, 5);
%         sd = runmean(datad.sigma1, 5);
%         zz = runmean(zd, 2);
%         [sigmas, isig] = sort(sd);
%         figure; plot(diff(isig), zz)
%         
%     end
%     
%     close all
% %     S=S+1;
% % end
