%% Function that specifies figure properties
function setfigprop(h,yli,cli,plotc,axc,ylab,clab)
shading flat, axis ij
set(h,'Xcolor', axc, 'Ycolor',axc)
set(h,'Ylim',yli)
set(get(h,'ylabel'),'string',ylab,'fontsize',14)
set(h,'color',plotc);

caxis(cli)
hc = colorbar;
set(get(hc,'ylabel'),'string',clab,'fontsize',14,'color',axc);
%cbfreeze(hc)
%freezeColors