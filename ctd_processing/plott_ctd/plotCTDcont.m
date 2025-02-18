%CTD-data viewer

%% Plot data
% One variable for time, salinity, pressure density
%Position: Left, Bottom, width, height
pos(1,:) = [0.110 0.7673 0.80 0.1577];
pos(2,:) = [0.110 0.5482 0.80 0.1577];
pos(3,:) = [0.110 0.3291 0.80 0.1557];
pos(4,:) = [0.110 0.1100 0.80 0.1557];

plotc = [0 0 0];
tempc = [1 0 0]; 
salc = [0 1 0];
denc = [0 0 1];
%oxc = [.5 .5 0]
ac = [1 1 1];


%% Caxis Limits
tlim = [3 20];
slim = [32.5 35];
dlim = [1024 1028];
ulim = [-1.2 1.2];
depthlim = [0 850];

%%
%load 
%figure('color',plotc)
figure(1)
set(1,'Name','Real Time Profile Data','NumberTitle','off','Position', [100 100 800 1000])
set(gcf,'color',[0 0 0])

h1= subplot('position',pos(1,:));
contourf(CTD.time(:,3), depth, CTD.t,64,'linecolor','none')
setfigprop(h1,depthlim,tlim,plotc,ac,'Temperature', 'C');
set(h1, 'Xticklabel',[]);
set(h1,'Xtick',CTD.time(:,3))


h2 = subplot('position',pos(2,:));
contourf(CTD.time(:,3), depth, CTD.s,64,'linecolor','none')
setfigprop(h2,depthlim,slim,plotc,ac,'Salinity', 'g/kg');
set(h2,'Xtick',CTD.time(:,3))
set(h2, 'Xticklabel',[]);
set(h2,'Ylim',depthlim)


h3 = subplot('position',pos(3,:));

contourf(CTD.time(:,3), depth, CTD.sig,64,'linecolor','none')
setfigprop(h3,depthlim,dlim,plotc,ac,'Density', 'kg/m^3');
set(h3,'Xtick',CTD.time(:,3))
datetick('keeplimits','keepticks')
%set(h3, 'Xticklabel',datestr(time));



h4=subplot('position',pos(4,:));
contourf(adcptime,DEPTH(:,1),addcol(V,V_SHIP),64,'linecolor','none')
setfigprop(h4,depthlim,ulim,plotc,ac,'V velocity', 'm/s');
set(h4,'Xlim',[CTD.time(1,1) CTD.time(end,2)])
datetick('keeplimits','keepticks')
set(h4,'Ylim',depthlim)

%%

%{
figure
imagesc(adcptime,[1:75],addcol(U,U_SHIP))
setfigprop(h4,depthlim,ulim,plotc,ac,'U velocity', 'm/s');
set(h4,'Xtick',adcptime(1:96:317));
set(h4,'Xticklabel',{datestr(adcptime(1:96:317))})
set(h4,'Ylim',[1 75])
figure
imagesc(adcptime,[1:75],addcol(V,V_SHIP))
setfigprop(h4,depthlim,ulim,plotc,ac,'V velocity', 'm/s');
set(h4,'Xtick',adcptime(1:96:317));
set(h4,'Xticklabel',{datestr(adcptime(1:96:317))})
set(h4,'Ylim',[1 75])

%}

