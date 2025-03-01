close all; clear all
station_list={'temp','S4','S5','S6','S7'};
ctd_casts={1,[2:26],[27:85],[86:110],[111:111]};
depths = [1000 2100 600 2000];

this_stat=4;
station_list(this_stat)
clear C
C.station.id=station_list{this_stat};
C.cast_numbers=ctd_casts{this_stat};
C.base_path='../../ctd/processed/';
%C.base_path='/Users/pepperjack/research/cruises/IWISE/luzon_strait/ctd_proc/data/processed/';
C.date=[];
C.z=[1:1:depths(this_stat)]';
warning off

for a=1:length(C.cast_numbers)
    this_cast=C.cast_numbers(a);
    tmpfile=num2str(1000+this_cast);
    C.filename{a}=['IWISE10_' tmpfile(2:4) '.mat'];
    load([C.base_path C.filename{a}]);

    to_interp=fieldnames(datad);

    for b=1:length(to_interp);
      % remove NaNs and linearly interpolate between
%       nanu = find(isnan(datau.(to_interp{b})) == 1);
%       nand = find(isnan(datad.(to_interp{b})) == 1);

%       if length(nanu) > 1
% 	diffu = diff(nanu)';
% 	cont = [nanu(find(diffu == 1)); max(nanu(find(diffu == 1))) + 1];
% 	ncont = nanu(find(diffu ~= 1) + 1);
% 	% create indices for nanmeans
% 	if min(cont) == 1, cont = [cont; max(cont)+1];, end;
% 	if max(cont) == length(datau.(to_interp{b})), cont = [min(cont)-1 cont];, end;
% 	datau.(to_interp{b})(cont) = nanmean(datau.(to_interp{b})(cont));
% 	datau.(to_interp{b})(ncont) = nanmean(datau.(to_interp{b})(max(ncont-1,1):min(ncont+1,length(datau.(to_interp{b})))));
%       else
% 	ncont = nanu;
% 	datau.(to_interp{b})(nanu) = nanmean(datau.(to_interp{b})(nanu-1:min(ncont+1,length(datau.(to_interp{b})))));
% 	clear cont ncont
%       end


%       if length(nand) > 1
% 	diffd = diff(nand)';
% 	cont = [nand(find(diffd == 1)); max(nand(find(diffd == 1))) + 1];
% 	ncont = nand(find(diffd ~= 1) + 1);
% 	% check if contiguous region is at start or end
% 	if min(cont) == 1, cont = [cont; max(cont)+1];, end;
% 	if max(cont) == length(datad.(to_interp{b})), cont = [min(cont)-1 cont];, end;
% 	datad.(to_interp{b})(cont) = nanmean(datad.(to_interp{b})(cont));
% 	datad.(to_interp{b})(ncont) = nanmean(datad.(to_interp{b})(max(ncont-1,1):min(ncont+1,length(datad.(to_interp{b})))));
%       else
% 	ncont = nand;
% 	datad.(to_interp{b})(nand) = nanmean(datad.(to_interp{b})(nand-1:min(ncont+1,length(datad.(to_interp{b})))));
% 	clear cont ncont
%       end

      data.(to_interp{b}) = [datad.(to_interp{b}) datau.(to_interp{b})];
    end

    big_x=[];

    for b=1:length(to_interp);
        big_x=[big_x data.(to_interp{b})];
    end
    tmp=interp1(datad.depth,big_x,C.z);
    for b=1:length(to_interp);
        C.(to_interp{b})(:,2*a-1:2*a)=tmp(:,2*b-1:2*b);
    end
    C.date(2*a-1:2*a)=nanmean(C.datenum(:,2*a-1:2*a));
end
C.isdown = zeros(length(C.cast_numbers),length(C.z));
C.isdown(1:2:end,:) = 1;
    filename = ([station_list{this_stat} '_all.mat'])
%    filename = 'all.mat';
    save(['../../ctd/processed/' filename], 'C')
