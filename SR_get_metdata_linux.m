function MET=SR_get_metdata_linux(base,cruise,outpath,rerunnit,times,DT);
% code to parse Sally Ride MET data into structure
% HLS
% base: path to the MET files
% cruise: name, used to store the data in outpath
% rerunnit
% times: days to work on, in datenum format, e.g. times = datenum(2017,2,17:30)
% DT: not presently used, meant to decimate the data as desired
%
%# 1    2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18   19   20  21
%#Time AT BP BC BS PR RH RT DP LB LT LW SW PA WS WD TW TI WS-2 WD-2 TW-2 TI-2 TT TC SA SD SV TG FI PS TT-2 TC-2 SA-2 SD-2 SV-2 TG-2 OC OT OX OS FL FI-2 PS-2 VP VR VH VX VY GY MB BT LF HF  LA  LO GT CR SP  ZD GA GS SH SM SR ZO ZS ZT ZI ZO-2 ZS-2 ZT-2 ZI-2 PZ PZ-2 IP IV IA MG MD MS MG-2 MD-2 MS-2 GC
%!open ../DATA/SCS2013/RR1304/MetAcq_Appendix_A.pdf
%%
if rerunnit
%%
%keyboard 
%%
%files = dir([base,'*.MET'])
%%
clear files
for tdx = 1:length(times)
    fname = sprintf('%s.MET', datestr(times(tdx),'YYmmdd'));
    if exist([base,fname])
    files(tdx).name = fname;
    end
end
%%
%170215.MET

%%
% delete last file since it is being updated
fdx=length(files);file =   files(fdx).name;disp(file)
if exist(sprintf('%s/MET_%s.mat',outpath,file(1:end-4)))
    eval(sprintf('!rm -f %s/MET_%s.mat',outpath,file(1:end-4)))
end

for fdx = 1:length(files)

file =   files(fdx).name;disp(file)
if ~exist(sprintf('%s/MET_%s.mat',outpath,file(1:end-4))) % only redo the last file in the list
d      = importdata([base,file]);
data   = d.data;
clear tmp
%------------------------------------------------------------------
for ii   = 1:length(d.data(:,1)); % loop through data file parsing time vector
%------------------------------------------------------------------
tmp(ii,:) = (sprintf('%06s',num2str(data(ii,1))));
end
%% parse time
 hour     = str2num(tmp(:,1:2));
 year     = str2num(file(1:2))+2000;
 month    = str2num(file(3:4));
 day      = str2num(file(5:6));
 minute   = str2num(tmp(:,3:4));
 second   = str2num(tmp(:,5:6));
     MET.time     = [datenum(year,month,day,hour,minute,second)];

for cdx = 2:length(d.colheaders)
    varname = char(d.colheaders(cdx));varname=strrep(varname,'-','_');
        MET.(varname)=data(:,cdx);
end
MET.header = d.colheaders;
%%
str = sprintf('save %s/MET_%s.mat MET',outpath,file(1:end-4))
eval(str)
end
end % loop over files, saving each day as a matlab structure
%%
% now read them all in and concatenate

MET=[];
for fdx = 1
 file =   files(fdx).name;disp(file)
 a=load(sprintf('%s/MET_%s.mat',outpath,file(1:end-4)));b = fieldnames(a.MET);
 for ndx = 1:length(b)-1 
     the_name = b(ndx);eval(sprintf('MET.%s = [];',char(the_name)))
 end
end


for fdx = 1:length(files)
file =   files(fdx).name;disp(file)
a=load(sprintf('%s/MET_%s.mat',outpath,file(1:end-4)));
b = fieldnames(a.MET);
for ndx = 1:length(b)-1 % last field is just the header 
    the_name = b(ndx);
eval(sprintf('MET.%s = [MET.%s;a.MET.%s];',char(the_name),char(the_name),char(the_name)))
end
end
MET.header=a.MET.header;
%%

%%
% now interpolate to regular 15 second grid
%%
% keyboard
% %%
% [yy0 mo0 dd0 hh0 mi0 ss0]=datevec(MET.time(1));
% [yy1 mo1 dd1 hh1 mi1 ss1]=datevec(MET.time(end));
% timei = datenum(yy0,mo0,dd0,hh0,mi0,0):DT:datenum(yy1,mo1,dd1,hh1,mi1,0);
% for ii=2:length(names)
%     disp(char(names(ii)))
%     MET.(char(names(ii)))=interp1(MET.time,MET.(char(names(ii))),timei);
% end
%%
%MET.time = timei;
%MET.timeyd = date2doy(MET.time);
%%

%%
% derive some stuff
if 0 ; REVELLE_MET_derive;end % derived
%%
disp(['save ',outpath,cruise,'_MET.mat MET'])
eval(['save ',outpath,cruise,'_MET.mat MET'])
else % rerunnut
eval(['load ',outpath,cruise,'_MET'])
end % rerunnit
clear ii names tdx data hour year month day minute second *dx d file* tmp* varname
%%
%keyboard
%%
disp(['last time in MET file is ',datestr(MET.time(end))])