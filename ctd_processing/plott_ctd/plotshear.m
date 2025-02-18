%plotADCPship
%readcolorsheme
%adcplim=[-1 1];
adcpdepth=[0 850];
adcp_u = addcol(U,U_SHIP);
adcp_v = addcol(V,V_SHIP);
shearlim = [-4.5 -3.2];

dudz = diff(adcp_u)./diff(DEPTH);
dvdz = diff(adcp_v)./diff(DEPTH);
shear2 = dudz.*dudz + dvdz.*dvdz;

toplot=conv2(shear2,ones(2,5)/10,'same');

xcolor=.75*[1 1 1];
figure(95)
clf
set(95,'Name','Shear','NumberTitle','off')
set(95,'color',[0 0 0])
s3=gca;
imagesc(adcptime,DEPTH(:,1),log10(toplot))
hold on
contour(CTD.time(:,3),depth,CTD.sig,30,'linecolor',.5*[1 1 1])
%colormap(flipud(hot))
cmap=jet;
cmap(1,:)=0;
colormap(cmap)

setfigprop(s3,depthlim,shearlim,plotc,ac,'Shear', '1/s^2');
set(s3,'Xlim',[CTD.time(1,1) CTD.time(end,2)])
datetick('keeplimits')
set(s3,'Ylim',adcpdepth,'color',colorx)



