close all; clear all
datadir = ['../../current_cruise/XBT/'];
fname = 'test.EDF';

NSWdrop_numbers = [4 9:3:27 32:3:59];
X1drop_numbers = [5 10:3:28 30:3:39 45:3:59];
NSEdrop_numbers = [7 11:3:29 31:3:59];

X.depth = NaN(3000,length(NSWdrop_numbers));
X.temp = NaN(3000,length(NSWdrop_numbers));
X.sound = NaN(3000,length(NSWdrop_numbers));
en = 1643;

for c = 1:3
  clear drop_numbers
  if c == 1, drop_numbers = NSWdrop_numbers, end
  if c == 2, drop_numbers = X1drop_numbers, end
  if c == 3, drop_numbers = NSEdrop_numbers, end
  for a = 1:length(drop_numbers)
    this_cast = drop_numbers(a);
    tmpfile = num2str(100000+this_cast);
    X.filename{a} = ['TF_' tmpfile(2:end) '.EDF'];
    fid = fopen([datadir X.filename{a}]);
    for b = 1:25
      tmp{b} = fgetl(fid);
    end
    tmp = char(tmp);
    tmpdat = dlmread([datadir X.filename{a}],'',33,0);
    X.depth(1:length(tmpdat(:,1)),a) = tmpdat(:,1); 
    X.temp(1:length(tmpdat(:,2)),a) = tmpdat(:,2); 
    X.sound(1:length(tmpdat(:,3)),a) = tmpdat(:,3);
    X.wypt{a} = tmp(12,:);
    jn = tmp(6,:);
    X.lat(a) =  eval(jn(18:20)) + eval(jn(21:27))/60;
    jn = tmp(7,:);
    X.lon(a) = eval(jn(18:21)) + eval(jn(22:27))/60;
    jn1 = tmp(3,:);
    jn2 = tmp(4,:);
    X.datenum(a) = datenum(eval(jn1(24:27)),eval(jn1(18:19)),eval(jn1(21:22)),eval(jn2(18:19)),eval(jn2(21:22)),eval(jn2(24:25)));
    clear tmp
  end
  if c == 1, NSW = X, end
  if c == 2, X1 = X, end
  if c == 3, NSE = X, end
  clear X
end
contourf(NSW.datenum,NSW.depth(:,7),NSW.temp,30); axis ij; shading flat
datetick('x','HH:MM')
xlim([min(NSW.datenum) max(NSW.datenum)])

figure
contourf(X1.datenum,X1.depth(:,7),X1.temp,30); axis ij; shading flat
datetick('x','HH:MM')
xlim([min(X1.datenum) max(X1.datenum)])

figure
contourf(NSE.datenum,NSE.depth(:,7),NSE.temp,30); axis ij; shading flat
datetick('x','HH:MM')
xlim([min(NSE.datenum) max(NSE.datenum)])

save('../xbt/processed/current.mat','NSW','X1','NSE')
