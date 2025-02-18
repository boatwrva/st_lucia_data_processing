%CTD-data viewer

%% Plot data
% One variable for time, salinity, pressure density
%Position: Left, Bottom, width, height
%pos(1,:) = [0.110 0.7673 0.80 0.1577];
%pos(2,:) = [0.110 0.5482 0.80 0.1577];
%pos(3,:) = [0.110 0.3291 0.80 0.1557];
%pos(4,:) = [0.110 0.1100 0.80 0.1557];
plot_properties

%%
%load 
%figure('color',plotc)
figure(108)
set(108,'Name','CTD Profile Data','NumberTitle','off')
set(gcf,'color',[0 0 0])
colorx=.75*[1 1 1];
%h1= subplot('position',pos(1,:));
h1 = subplot(2,1,1);
imagesc(CTD.time(:,3), depth, CTD.t)
setfigprop(h1,depthlim,tlim,plotc,ac,'Temperature', 'C');
set(h1, 'Xticklabel',[],'color',colorx);
set(h1,'Xtick',CTD.time(:,3))
set(h1,'Xlim',timelim)


%h2 = subplot('position',pos(2,:));
h2 = subplot(2,1,2);
imagesc(CTD.time(:,3), depth, CTD.s)
setfigprop(h2,depthlim,slim,plotc,ac,'Salinity', 'g/kg');
set(h2,'Xtick',CTD.time(1:5:end,3))
set(h2, 'Xticklabel',[],'color',colorx);
set(h2,'Xlim',timelim)

datetick('keeplimits','keepticks')




