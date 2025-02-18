% Check if there is any new CTD cast files
%%
disp('--------------------------------------------')
disp('CTD casts: Looking for new file')
ctddir = '/Volumes/scienceparty_share/ctd/processed/';

cruise = 'mendo_ridge_';
datafile = dir('/Volumes/current_cruise/ctd/data/mendo_ridge_*.hex');
ctdfile = dir('/Volumes/scienceparty_share/ctd/processed/*.mat');

if(length(datafile)>length(ctdfile))
  const = length('mendo_ridge_.hex');

for i=1:length(datafile)
  l = length(datafile(i).name)-const;    
  
        icast(i) = str2double(datafile(i).name(13:14));
end

newcast = find(icast>str2double(ctdfile(end).name(13:14)));
for i=1:length(newcast)
    load_hex_mendo(newcast(i));
end
initialize
else
    disp(['No new file found. Latest file: ', ctddir(end).name])
    disp('--------------------------------------------')
end
%{
dnew = dir('/Volumes/scienceparty_share/ctd/processed/*.mat');

for j=1:length(newcast) 
    i = icast(newcast(j));
    CTD.castnr(i) = str2double(dnew(i).name(9));
   load([ctddir,dnew(newcast(j)).name])
    k = length(datad.depth);
    CTD.t(1:k,i) = datad.t1;
    CTD.s(1:k,i) = datad.s1;
    CTD.sig(1:k,i) = datad.sigma1;
    CTD.time(i,1) = datad.datenum(find(~isnan(datad.datenum),1,'first'));
    CTD.time(i,2) = datad.datenum(find(~isnan(datad.datenum),1,'last'));
    CTD.time(i,3) = mean(CTD.time(i,1:2));
	CTD.p(1:k,i)=datad.p;
end
            
            plotCTD
            disp(['Latest processed CTD file: ', dnew(end).name])
            disp('--------------------------------------------')
            dold = dnew;
            clear dnew
        
     else
        disp('No file update')
         disp(['Latest cast: ',dnew(end).name])

        disp('--------------------------------------------')
    end
    
%---------------------------    
%ADCP updates
%---------------------------
    

    
disp('--------------------------------------------')
disp('Ship bourne ADCP: Looking for new file')


adcp_new = dir('/Volumes/current_cruise/adcp/proc/os75bb/contour/');
load('/Volumes/current_cruise/adcp/proc/os75bb/contour/allbins_other.mat')
adcptime_new=datenum(TIME(:,1),TIME(:,2),TIME(:,3),TIME(:,4),TIME(:,5),TIME(:,6));

if(adcptime_new(end)>adcptime(end))
  load('/Volumes/current_cruise/adcp/proc/os75bb/contour/allbins_u.mat')
  load('/Volumes/current_cruise/adcp/proc/os75bb/contour/allbins_v.mat')
  
  disp(['File updated: ', datestr(adcptime_new(end))])
  disp('--------------------------------------------')
  adcptime = adcptime_new;
  clear adcptime_new;
  plotADCPship
%elseif(now - adcptime_new(end)> 1/24)
 %   disp('Error: ADCP Datafile has not been updated in over 1 hr')
 %   disp('--------------------------------------------')
    
else
    disp(['No update'])
    disp(['Newest file updated: ',datestr(adcptime_new(end)),' UTC'])
    disp('--------------------------------------------')
end
disp('   ')


%}

