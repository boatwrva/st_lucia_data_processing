
%Load in the ADCP data from the cruise shared data server.

year=2025;

basedir='/Volumes/data_archive/MOTIVE/Cruises/skq202417s/04_ship_data/adcp/raw/SKQ202417S/';

datadir=fullfile(basedir,'proc'); %for on board ship


wh_adcps={'wh300';'os150bb';'os150nb';'os38bb';'os38nb'};

ymaxs=[150 500 500 1500 1500];
% todo=1:2;
todo=[1 5]; %nb only


for c=1:length(todo)%:length(wh_adcps)
    wh_adcp=wh_adcps{todo(c)};
    D = load_getmat(fullfile(datadir, wh_adcp, 'contour', 'allbins_'));

    if ~isempty(fields(D))
        adcp.u=D.u;%.*D.nanmask;
        adcp.v=D.v;%.*D.nanmask;
        adcp.amp=D.amp;%.*D.nanmask;

        adcp.lon=D.lon;
        adcp.lat=D.lat;
        adcp.yday=D.dday;
        adcp.dnum=yday2datenum(adcp.yday,year);
        adcp.z=D.depth(:,1); %make sure # of bins and bin size does not change to do this!
        adcp.depth=adcp.z;
        adcp.uship=D.uship;
        adcp.vship=D.vship;

        adcp.wh_adcp=wh_adcp;
        adcps{c}=adcp;
    end

end
