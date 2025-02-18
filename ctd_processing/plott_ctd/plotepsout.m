%Calculate the dissipation using amy's compute_overturns
plot_properties
colorx = 0.75*[1 1 1];
gridsi = size(CTD.t);
CTD.dissipationrate = NaN(size(CTD.t));
for i=1:gridsi(2)
    okbins = find(~isnan(CTD.t(:,i)));
    p = CTD.p(okbins,i);
    t = CTD.t(okbins,i);
    s = CTD.s(okbins,i);
    [Epsout,Lmin,Lot,run1max,Lttot] = compute_overturns_amy(p, t, s);
    CTD.dissipationrate(okbins,i) = Epsout;
end

figure(97); clf
set(97,'color',[0 0 0],'name','Dissipation rate','NumberTitle','off')
d1 = gca;
colormap(flipud(hot))
pcolorcen(CTD.time(:,3), depth, log10(CTD.dissipationrate));
hold on 
contour(CTD.time(:,3),depth,CTD.sig,30,'linecolor',[0 0 0]);
title('Dissipation rate','color',[1 1 1],'fontsize',14)
setfigprop(d1,depthlim,dislim,plotc,.75*ac,'Depth', 'm^2 s^-3');
set(d1,'Ylim',depthlim)
set(d1,'Xlim',timelim)
datetick('keeplimits','keepticks')


dosepplot=0
if dosepplot
subplot(212)
figure(98); clf; set(gcf,'defaultaxesfontweight','bold')
colormap(flipud(hot))
d2 = gca;
pcolorcen(CTD.time(:,3), depth, log10(CTD.dissipationrate));
hold on 
contour(CTD.time(:,3),depth,CTD.sig,20,'linecolor',[0 0 0]);
title('Dissipation rate','color',[1 1 1],'fontsize',14)
setfigprop(d1,depthlim,dislim,plotc,.75*ac,'Depth', 'm^2 s^-3');
set(d2,'Xlim',[timelim(1) timelim(1)+.8])
set(d2,'Ylim',[0 700])
datetick('keeplimits','keepticks')
end
