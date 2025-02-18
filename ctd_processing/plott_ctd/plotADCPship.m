%plotADCPship
plot_properties
readcolorsheme
adcp_u = addcol(U,U_SHIP);
adcp_v = addcol(V,V_SHIP);
timelim0=[timelim(1)-.3 timelim(2)];

xcolor=.75*[1 1 1];
figure(113)
clf
set(113,'Name','Ship ADCP data','NumberTitle','off')
set(113,'color',[0 0 0])
%set(113,'paperposition',[0.01 0.01 8 5.5])

k3=subplot(2,1,1);
pcolorcen(adcptime,DEPTH(:,1),adcp_u);
hold on
contour(CTD.time(:,3),depth,CTD.sig,30,'linecolor',[0 0 0])
colormap(colorsheme)
setfigprop(k3,depthlim,ulim,plotc,ac,'U velocity', 'm/s');
set(k3,'Xlim',timelim0)
datetick('keeplimits')
set(k3,'Ylim',depthlim,'color',colorx)


k4=subplot(2,1,2);
pcolorcen(adcptime,DEPTH(:,1),adcp_v);
hold on
colormap(colorsheme)
contour(CTD.time(:,3),depth,CTD.sig,30,'linecolor',[0 0 0])
setfigprop(k4,depthlim,ulim,plotc,ac,'V velocity', 'm/s');
set(k4,'Xlim',timelim0)
datetick('keeplimits')
set(k4,'Ylim',depthlim,'color',colorx)


%export_fig velocity.png






