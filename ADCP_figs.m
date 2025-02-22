% Plotting script for ADCP data

%ADCPs: 'os38nb' 'wh300' 'os150nb'


cd /Users/kerstin/Desktop/St_Lucia/
% run process_at_sea_master first

% one with all ADCPs
set(0, 'DefaultFigureColor', 'w');
fig1 = figure(1);
clf
set_figure_LUCIA(fig1)

nr = 3;
nc = 2;

gap = [0.05 0.05];

time_1 = datenum('2025-02-20 23:00');
time_2 = datenum('2025-02-21 06:00');

A300 = adcps{1}; [t1, z1] = meshgrid(A300.dnum, A300.z);
A150 = adcps{2}; [t2, z2] = meshgrid(A150.dnum, A150.z);
A38 = adcps{3}; [t3, z3] = meshgrid(A38.dnum, A38.z);

s1 = subtightplot(nr, nc, 1, gap); % 300
p1 = pcolor(t1, z1, A300.u); p1.LineStyle='none';
cmocean('balance',25);caxis([-0.4,0.4]);
set(gca,'YDir','reverse','YLim',[z1(1,1), z1(end,1)],'XLim',[time_1 time_2]);
%datetick('x',6,'keeplimits')
%xtickformat('yy/mm/dd')
%ax = gca;
%ax.XTick = linspace(ax.XLim(1), ax.XLim(2), 5); % Set 15 ticks
%datetick('x', 'mmm-dd HH:MM', 'keeplimits', 'keepticks'); % Keep custom tick locations
box on
title('U - wh300'); ylabel('[m]')

s2 = subtightplot(nr, nc, 2, gap); % 300
p1 = pcolor(t1, z1, A300.v); p1.LineStyle='none';
cmocean('balance',25);caxis([-0.4,0.4]);
set(gca,'YDir','reverse','YLim',[z1(1,1), z1(end,1)],'XLim',[time_1 time_2]);
%ax = gca;
%ax.XTick = linspace(ax.XLim(1), ax.XLim(2), 5); % Set 15 ticks
%datetick('x', 'mmm-dd HH:MM', 'keeplimits', 'keepticks'); % Keep custom tick locations
box on
title('V - wh300')
c1 = colorbar;
c1.Label.String =  '[m/s]';


s3 = subtightplot(nr, nc, 3, gap); % 150
p1 = pcolor(t2, z2, A150.u); p1.LineStyle='none';
cmocean('balance',25);caxis([-0.4,0.4]);
set(gca,'YDir','reverse','YLim',[z2(1,1), z2(end,1)],'XLim',[time_1 time_2]);
%ax = gca;
%ax.XTick = linspace(ax.XLim(1), ax.XLim(2), 5); % Set 15 ticks
%datetick('x', 'mmm-dd HH:MM', 'keeplimits', 'keepticks'); % Keep custom tick locations
box on
title('U - os150'); ylabel('[m]')

s4 = subtightplot(nr, nc, 4, gap); % 150
p1 = pcolor(t2, z2, A150.v); p1.LineStyle='none';
cmocean('balance',25);caxis([-0.4,0.4]);
set(gca,'YDir','reverse','YLim',[z2(1,1), z2(end,1)],'XLim',[time_1 time_2]);
%ax = gca;
%ax.XTick = linspace(ax.XLim(1), ax.XLim(2), 5); % Set 15 ticks
%datetick('x', 'mmm-dd HH:MM', 'keeplimits', 'keepticks'); % Keep custom tick locations
box on
title('V - os150')
c1 = colorbar;
c1.Label.String =  '[m/s]';

s5 = subtightplot(nr, nc, 5, gap); % 38
p1 = pcolor(t3, z3, A38.u); p1.LineStyle='none';
cmocean('balance',25);caxis([-0.4,0.4]);
set(gca,'YDir','reverse','YLim',[z3(1,1), z3(end,1)],'XLim',[time_1 time_2]);
ax = gca;
ax.XTick = linspace(ax.XLim(1), ax.XLim(2), 5); % Set 15 ticks
datetick('x', 'mmm-dd HH:MM', 'keeplimits', 'keepticks'); % Keep custom tick locations
box on
title('U - os38'); ylabel('[m]')

s6 = subtightplot(nr, nc, 6, gap); % 38
p1 = pcolor(t3, z3, A38.v); p1.LineStyle='none';
cmocean('balance',25);caxis([-0.4,0.4]);
set(gca,'YDir','reverse','YLim',[z3(1,1), z3(end,1)],'XLim',[time_1 time_2]);
ax = gca;
ax.XTick = linspace(ax.XLim(1), ax.XLim(2), 5); % Set 15 ticks
datetick('x', 'mmm-dd HH:MM', 'keeplimits', 'keepticks'); % Keep custom tick locations
box on
title('V - os38')
c1 = colorbar;
c1.Label.String =  '[m/s]';


s1.XTickLabel = [];
s2.XTickLabel = [];
s3.XTickLabel = [];
s4.XTickLabel = [];


fig2 = figure(2);
clf
set_figure_LUCIA(fig2)

[~,ii1] = (min(abs(A300.dnum - time_1)));
[~,ii2] = (min(abs(A300.dnum - time_2)));

long_west = -123; long_east = -117;
lat_south = 32; lat_north = 36; 

latlim0 = [lat_south lat_north];
lonlim0 = [long_west long_east];

subplot(1,2,1)
m_proj('lambert','lat',[lat_south, lat_north],'lon',[long_west long_east], 'clo' , mean(lonlim0), 'par' , latlim0, 'rec' , 'off');%,'aspect',.7);
m_scatter(A300.lon-360, A300.lat,10,'k')
hold on
m_scatter(A300.lon(ii1:ii2)-360, A300.lat(ii1:ii2),30,'r','filled')
cmapland=flipud(bone(30));

%m_coast('patch',[.4 .4 .4],'edgecolor','none');
m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');

m_grid('box','fancy','tickdir','in','yaxislocation','left',...
            'xaxislocation','bottom','xlabeldir','end','ticklen',.02,'Interpreter','latex');

m_ruler([.1 .25], .1 , 3,'fontsize',14,'Color','k','fontcolor','k')


filename = 'gebco_2024_n49.0_s30.0_w-130.0_e-110.0.nc';
%B = ncread(filename);

B.lat = ncread(filename,'lat');
B.lon = ncread(filename,'lon');
B.z = ncread(filename,'elevation');
[LONG, LAT] = meshgrid(B.lon, B.lat);
ELEV = B.z';
c_lims =[-3000 1];


long_west = min(A300.lon(ii1:ii2))-360-0.25; long_east = max(A300.lon(ii1:ii2))-360+0.25;
lat_south = min(A300.lat(ii1:ii2))-0.25; lat_north = max(A300.lat(ii1:ii2))+0.25; 

latlim0 = [lat_south lat_north];
lonlim0 = [long_west long_east];

subplot(1,2,2)
m_proj('lambert','lat',[lat_south, lat_north],'lon',[long_west long_east], 'clo' , mean(lonlim0), 'par' , latlim0, 'rec' , 'off');%,'aspect',.7);
[ELEV,LONG,LAT]=m_etopo2([long_west long_east lat_south lat_north ]);
%m_elev('contour',[-4000:250:0 500:500:3000],'edgecolor','none');
m_scatter(A300.lon-360, A300.lat,10,'k')
hold on
m_scatter(A300.lon(ii1:ii2)-360, A300.lat(ii1:ii2),30,'r','filled')
m_contour(LONG, LAT, ELEV,[-4500:500:-4001 -4000:250:0 ],'ShowText','on','Labelspacing',250)
cmapland=flipud(bone(30));
colormap(gca,[m_colmap('blues',60);cmapland(11:end,:)]);  
ccc=m_colmap('blues',60);
colormap(ccc(5:45,:))
colormap(gca,[bone(60);cmapland(11:end,:)]);
caxis(gca,[c_lims]);  
%c1 = colorbar;
%c1.Label.String = '[m]';
%m_coast('patch',[.4 .4 .4],'edgecolor','none');
m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');


m_grid('box','fancy','tickdir','in','yaxislocation','left',...
            'xaxislocation','bottom','xlabeldir','end','ticklen',.02,'Interpreter','latex');

m_ruler([.1 .25], .1 , 3,'fontsize',14,'Color','k','fontcolor','k')


