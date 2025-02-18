%% ADCP data
%Initialize ADCP data
adcp_old = dir('/Volumes/current_cruise/adcp/proc/os75bb/contour/');

load('/Volumes/current_cruise/adcp/proc/os75bb/contour/allbins_u.mat')
load('/Volumes/current_cruise/adcp/proc/os75bb/contour/allbins_v.mat')
load('/Volumes/current_cruise/adcp/proc/os75bb/contour/allbins_other.mat')
load('/Volumes/current_cruise/adcp/proc/os75bb/contour/allbins_depth.mat')

%for windows
% adcp_old = dir('V:/adcp/proc/os75bb/contour/');
% 
% load('V:/adcp/proc/os75bb/contour/allbins_u.mat')
% load('V:/adcp/proc/os75bb/contour/allbins_v.mat')
% load('V:/adcp/proc/os75bb/contour/allbins_other.mat')
% load('V:/adcp/proc/os75bb/contour/allbins_depth.mat')

adcptime=datenum(TIME(:,1),TIME(:,2),TIME(:,3),TIME(:,4),TIME(:,5),TIME(:,6));

%% CTD data
% Initialize CTD matrix

nbin = 7000;
depth = 0:0.25:nbin*0.25-0.25;

ctddir = '/Volumes/scienceparty_share/ctd/processed/';
ctddir2 = '/Volumes/scienceparty_share/ctd/processed100/';
dold = dir('/Volumes/scienceparty_share/ctd/processed/mendo_ridge*.mat');
dold2 = dir('/Volumes/scienceparty_share/ctd/processed100/mendo_ridge*.mat');
% ctddir = 'W:/ctd/processed/';
% ctddir2 = 'W:/ctd/processed100/';
% dold = dir('W:/ctd/processed/mendo_ridge*.mat');
% dold2 = dir('W:/ctd/processed100/mendo_ridge*.mat');
nrcast = length(dold)+length(dold2);

CTD.t = NaN(nbin,nrcast);
CTD.s = NaN(nbin,nrcast);
CTD.sig = NaN(nbin,nrcast);
CTD.p=NaN(nbin,nrcast);
CTD.time = zeros(nrcast,2);

i100=1;
const = length('mendo_ridge_.mat');
for i=1:nrcast
    if(i<99)
        %99 because cast 13 is missing (12 was two down and up)
        %l = length(dold(i).name)-const;
        %CTD.castnr(i) = str2double(dold(i).name(13:13+l-1));
        %disp([ctddir,dold(i).name])
        load([ctddir,dold(i).name])
            
    CTD.time(i,1) = datad.datenum(find(~isnan(datad.datenum),1,'first'));
    CTD.time(i,2) = datad.datenum(find(~isnan(datad.datenum),1,'last'));
    CTD.time(i,3) = mean(CTD.time(i,1:2));
    k = length(datad.depth);
    CTD.t(1:k,i) = datad.t2;
    CTD.s(1:k,i) = datad.s2;
    CTD.sig(1:k,i) = datad.sigma2;
    CTD.p(1:k,i) = datad.p;
     elseif(i>=99)        
        %l = length(dold2(i).name)-const;    
        %CTD.castnr(i) = str2double(dold(i).name(13:13+l-1));
        %disp([ctddir2,dold2(i100).name])
        load([ctddir2,dold2(i100).name])
            
    CTD.time(i,1) = datad.datenum(find(~isnan(datad.datenum),1,'first'));
    CTD.time(i,2) = datad.datenum(find(~isnan(datad.datenum),1,'last'));
    CTD.time(i,3) = mean(CTD.time(i,1:2));
    k = length(datad.depth);
    CTD.t(1:k,i) = datad.t2;
    CTD.s(1:k,i) = datad.s2;
    CTD.sig(1:k,i) = datad.sigma2;
    CTD.p(1:k,i) = datad.p;
     
        i100=i100+1;
        
    end

   
end


%% First plot
plot_properties
plotCTD
plotADCPship
plotepsout





