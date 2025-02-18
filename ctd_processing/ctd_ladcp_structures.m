%ctd_ladcp_structures.m
%
% make a big structure combining all available  data for each station during
% Mendo12
%
% jen (based on Hanne's processing)
% Nov 12

%%
station=1;

%%
rootdir=['/Users/jen/projects/mendo12/'];
rootdir=['/Volumes/scienceparty_share/ctd/processed/'];
ladcp_dir=[rootdir 'ladcp/data/processed/'];
ctd_dir=[rootdir 'ctd/processed/'];
sadcp_dir=[rootdir 
%ctd_dir=[rootdir 'science_share/ctd/processed/'];
outdir=[rootdir 'ctd/processed/'];

%% station names
Names{1}='S4';
Names{2}='S5';
Names{3}='S6a';
Names{4}='S7';
Names{5}='S8 ';
Names{6}='N1a';
Names{7}='N2a';
Names{8}='A1';
Names{9}='N2b';
Names{10}='N1b';
Names{11}='F1';
Names{12}='S6b';


%% load ctd data


if station==1
    files=2:26;; 
elseif station==2
    files=27:85; 
elseif station==3
    files=86:110; 
elseif station==4
    files=111:134; 
elseif station==5
    files=[135 137 140:153]; 
elseif station==6
    files=[154:173]; 
elseif station==7
    files=[174:199]; 
elseif station==8
    files=[200:214]; 
elseif station==9
    files=[215:235];
elseif station==10
    files=[236:256]; 
elseif station==11
    files=[257:290];
elseif station==12
    files=[292:311]; 
end

%%
doup=1; % add the up-casts too?
disp(['Loading ctd data'])
nn=NaN*ones(12000,length(files)); 
clear C
todo = {'t1','t2','c1','c2','s1','s2','z','p','t1_hi','t2_hi','s1_hi','s2_hi','z_hi','p_hi','datenum_down','t1_up','t2_up','c1_up','c2_up','datenum_up','p_up'};
for j=1:length(todo);
    C.(todo{j})=nn;
end

ind=1;
for ifile=files; 
    load([ctd_dir 'IWISE10_' sprintf('%03d',ifile) '.mat'])
    iz=1:length(datad.t1);
    C.s1_hi(iz,ind)=datad.s1;
    C.s2_hi(iz,ind)=datad.s2;
    C.t1_hi(iz,ind)=datad.t1;
    C.t2_hi(iz,ind)=datad.t2;
    C.z_hi(iz,ind)=datad.depth;
    C.p_hi(iz,ind)=datad.p;

    iz1=1:length(datad_1m.t1);
    C.s1(iz1,ind)=datad_1m.s1;
    C.s2(iz1,ind)=datad_1m.s2;
    C.t1(iz1,ind)=datad_1m.t1;
    C.t2(iz1,ind)=datad_1m.t2;
    C.c1(iz1,ind)=datad_1m.c1;
    C.c2(iz1,ind)=datad_1m.c2;
    C.z(iz1,ind)=datad_1m.depth;
    C.p(iz1,ind)=datad_1m.p;
    
    C.lon(ind)=nanmean(datad.lon);
    C.lat(ind)=nanmean(datad.lat);
    C.datenum_down(iz1,ind)=datad_1m.datenum;
    C.cast(ind)=ifile;
    
    if doup
        iz1=1:length(datau_1m.t1);
      C.t1_up(iz1,ind)=datau_1m.t1;  
      C.t2_up(iz1,ind)=datau_1m.t2;  
      C.c1_up(iz1,ind)=datau_1m.c1;  
      C.c2_up(iz1,ind)=datau_1m.c2;  
      C.datenum_up(iz1,ind)=datau_1m.datenum;
      C.p_up(iz1,ind)=datau_1m.p;
    end  % if doup

    ind=ind+1;
    
end


%% make the appropriate depth
C.z=nanmean([C.z],2); 
C.p=nanmean([C.p],2); 
todo = {'t1','t2','s1','s2','c1','c2','z','p','datenum_down'};
ig=find(~isnan(C.z)); iz=1:max(ig);
for j=1:length(todo);
    C.(todo{j})=C.(todo{j})(iz,:);
end
if doup
todo = {'t1_up','t2_up','c1_up','c2_up','datenum_up','p_up'};
for j=1:length(todo);
    C.(todo{j})=C.(todo{j})(iz,:);
end
end

C.z_hi=nanmean([C.z_hi],2); 
C.p_hi=nanmean([C.p_hi],2); 
todo = {'t1_hi','t2_hi','s1_hi','s2_hi','z_hi','p_hi'};
ig=find(~isnan(C.p_hi)); iz=1:max(ig);
for j=1:length(todo);
    C.(todo{j})=C.(todo{j})(iz,:);
end


% occasionally nans in pressure vector
C.p=sw_pres(C.z,nanmean(C.lat));
C.p_hi=sw_pres(C.z_hi,nanmean(C.lat));


%% s1 or s2 flag to choose a best guess "Good" t/s pair for each profile
%
%%
doplots=0;
if doplots
    figure(1); clf; fig_setup(0);
    subplot(131); imagesc(C.s1);caxis([34.4 35]); colorbar; fg
    subplot(132); imagesc(C.s2);caxis([34.4 35]); colorbar; fg
    subplot(133); imagesc(C.s2-C.s1); caxis([-1 1]*.03); colorbar; fg
    colormap(redblue)
end

%%

% some bad data. 1 for s1, 2 for s2
C.t=C.t1;
C.s=C.s1; 
C.c=C.c1;
C.t_hi=C.t1_hi;
C.s_hi=C.s1_hi;

C.s12flag=ones(size(C.lat));
if station==1;
    C.s12flag(17:24)=2;
end
if station==3;
    C.s12flag(1:length(C.lat))=2;
end
if station==4;
    C.s12flag(1:length(C.lat))=2;
end
if station==5;
    C.s12flag(1:length(C.lat))=2;
end

i2=find(C.s12flag==2);
C.s(:,i2)=C.s2(:,i2);
C.t(:,i2)=C.t2(:,i2);
C.c(:,i2)=C.c2(:,i2);
C.sgth = sw_pden(C.s,C.t,C.p,0)-1e3;

if doup
    C.t_up=C.t1_up; C.c_up=C.c1_up;
    C.t_up(:,i2)=C.t2_up(:,i2);
    C.c_up(:,i2)=C.c2_up(:,i2);
end  

%C.yday=C.datenum-datenum([2010 1 1 0 0 0]);

%% a few more useful quantities

% compute nsq from sorted gridded data, tis a bit more smoothed
a=1; b=ones(40,1)/40;
s0=C.s*NaN; t0=s0; 
for iy=1:length(C.lon); 
    ig=find(~isnan(C.sgth(:,iy)));
    [xxx,isg]=sort(C.sgth(ig,iy));
    s0(ig,iy)=nanfilt(b,a,C.s(ig(isg),iy));
    t0(ig,iy)=nanfilt(b,a,C.t(ig(isg),iy));
end
[n2,q,p_ave] = sw_bfrq(s0,t0,C.p,ones(size(C.t,1),1)*C.lat);
ig=find(~isnan(p_ave(:,2)));
n2_smooth=interp1(p_ave(ig,2),n2(ig,:),C.p);

C.n2_smoothed=nanmean(n2_smooth,2);
C.n2_comment='based on station average, smoothed over 40 m';

%% mode shapes
% create smoothed profiles for mode shapes
a=1; b=ones(40,1)/40;
p0=[0:5:max(C.p)]'; ig=find(~isnan(C.p)); [xx,ig0]=unique(C.p(ig)); ig=ig(ig0);
t0=interp1(C.p(ig),nanfilt(b,a,nanmean(C.t(ig,:),2)),p0(:));
s0=interp1(C.p(ig),nanfilt(b,a,nanmean(C.s(ig,:),2)),p0(:));

%
ig=find(~isnan(t0)&~isnan(s0)&~isnan(p0)); s0=s0(ig); t0=t0(ig); p0=p0(ig);
[c2, Psi, G, N2, Pmid] = VERT_FSFB(t0,s0,p0);

C.mode_speeds=sqrt(c2(1:10));
C.mode_shapes=interp1(p0(:),Psi(:,1:10),C.p); 
C.mode_comment='Based on smoothed N2 profile';


%% spectral plots to see overturn noise levels
dospectra=0;
dz=nanmean(diff(C.z));dzhi=nanmean(diff(C.z_hi));
m0=[.02:.02:12];
Ptot_t=NaN*ones(length(C.lat),length(m0)); Ptot_r=Ptot_t; Ptot_t0=Ptot_t;Ptot_r0=Ptot_t; Ptot_s0=Ptot_t; Ptot_s=Ptot_t;
if dospectra
    sgth_hi = sw_pden(C.s_hi,C.t_hi,C.p_hi,0)-1e3;
    for ii=1:length(C.lat)
        ig=find(~isnan(C.t(:,ii))&~isnan(C.sgth(:,ii))&~isnan(C.s(:,ii))); 
        if length(ig)>.5*length(C.z)
            [Pcw,Pccw,Ptot,m] = psd_jen(detrend(diff(C.t(ig,ii)))/dz,dz,'t',1,0,64);
            Ptot_t(ii,:)=interp1(m,Ptot,m0);
            [Pcw,Pccw,Ptot,m] = psd_jen(detrend(diff(C.sgth(ig,ii)))/dz,dz,'t',1,0,64);
            Ptot_r(ii,:)=interp1(m,Ptot,m0);
            [Pcw,Pccw,Ptot,m] = psd_jen(detrend(diff(C.s(ig,ii)))/dz,dz,'t',1,0,64);
            Ptot_s(ii,:)=interp1(m,Ptot,m0);
        end
        ig=find(~isnan(C.t_hi(:,ii))&~isnan(sgth_hi(:,ii))&~isnan(C.s_hi(:,ii))); 
        if length(ig)>.5*length(C.z_hi)
            [Pcw,Pccw,Ptot,m] = psd_jen(detrend(diff(C.t_hi(ig,ii)))/dzhi,dzhi,'t',1,0,64);
            Ptot_t0(ii,:)=interp1(m,Ptot,m0);
            [Pcw,Pccw,Ptot,m] = psd_jen(detrend(diff(sgth_hi(ig,ii)))/dzhi,dzhi,'t',1,0,64);
            Ptot_r0(ii,:)=interp1(m,Ptot,m0);
            [Pcw,Pccw,Ptot,m] = psd_jen(detrend(diff(C.s_hi(ig,ii)))/dzhi,dzhi,'t',1,0,64);
            Ptot_s0(ii,:)=interp1(m,Ptot,m0);
        end
    end
end

%%
if dospectra
figure(1);clf; set(gcf,'paperposition',[.5 .5 15 10]); wysiwyg
mmax=3; 
phit=5e-6; phir=3e-7; phis=5e-6;
phit=.5e-6; phir=.5e-7; phis=5e-6;
%phit=2e-6; phir=1.5e-7; phis=5e-6;



subplot(231)
loglog(m0,nanmean(Ptot_t0)./m0.^2./sinc(m0*dzhi/2/pi).^2,m0,nanmean(Ptot_t)./m0.^2./sinc(m0*dz/2/pi).^2,m0,phit*ones(size(m0))); fg;
hold on; plot(mmax*[1 1],[1e-6 1e0],'c--')
set(gca,'xlim',[.02 15])
text(.2,1e-0,['Temperature noise level  ' num2str(phit,2)])
text(.2,1e-1,['sigma =  ' num2str(sqrt(phit*mmax),2)])
ylabel('^({\circ}C m^{-1})^2')

subplot(232)
loglog(m0,nanmean(Ptot_s0)./m0.^2./sinc(m0*dzhi/2/pi).^2,m0,nanmean(Ptot_s)./m0.^2./sinc(m0*dz/2/pi).^2,m0,phis*ones(size(m0))); fg;
hold on; plot(mmax*[1 1],[1e-6 1e0],'c--')
set(gca,'xlim',[.02 15])
text(.2,1e-0,['salinity noise level  ' num2str(phis,2)])
text(.2,1e-1,['sigma =  ' num2str(sqrt(phis*mmax),2)])
ylabel('^({\circ}C m^{-1})^2')

subplot(233)
loglog(m0,nanmean(Ptot_r0)./m0.^2./sinc(m0*dzhi/2/pi).^2,m0,nanmean(Ptot_r)./m0.^2./sinc(m0*dz/2/pi).^2,m0,phir*ones(size(m0)),'b'); fg;
hold on; plot(mmax*[1 1],[1e-7 1e-2],'c--')
set(gca,'xlim',[.02 15])
text(.2,1e-2,['Rho noise level  ' num2str(phir,2)])
text(.2,1e-3,['sigma =  ' num2str(sqrt(phir*mmax),2)])
xlabel('\omega / s^{-1}')
%print(gcf,'-djpeg','/Users/jen/projects/iwap/notes/mixing/noise_spectra')

subplot(234)
loglog(m0,nanmean(Ptot_t0)./sinc(m0*dzhi/2/pi).^2,m0,nanmean(Ptot_t)./sinc(m0*dz/2/pi).^2,m0,phit*ones(size(m0)).*m0.^2); fg;
hold on; plot(mmax*[1 1],[1e-6 1e0],'c--')
set(gca,'xlim',[.02 15])
axis([.02 15 1e-5 1e-2])

subplot(235)
loglog(m0,nanmean(Ptot_s0)./sinc(m0*dzhi/2/pi).^2,m0,nanmean(Ptot_s)./sinc(m0*dz/2/pi).^2,m0,phis*ones(size(m0)).*m0.^2); fg;
hold on; plot(mmax*[1 1],[1e-6 1e0],'c--')
set(gca,'xlim',[.02 15])
axis([.02 15 1e-7 1e-3])

ylabel('^({\circ}C m^{-1})^2')
subplot(236)
loglog(m0,nanmean(Ptot_r0)./sinc(m0*dzhi/2/pi).^2,m0,nanmean(Ptot_r)./sinc(m0*dz/2/pi).^2,m0,phir*ones(size(m0)).*m0.^2,'b'); fg;
hold on; plot(mmax*[1 1],[1e-7 1e-2],'c--')
axis([.02 15 1e-6 1e-2])

xlabel('\omega / s^{-1}')


sigma_t=sqrt(phit*mmax);
sigma_rho=sqrt(phir*mmax);
%sigma_t0=sqrt(phit*10); %for hi resolution t

else

% from previous looks at spectra, so it's automated
 if station==1; sigma_t=3e-3;sigma_rho=6e-4; 
 elseif station==2; sigma_t=4e-3;sigma_rho=1e-3;
 elseif station==3; sigma_t=3e-3;sigma_rho=6e-4;
 elseif station>=4&station<=7; sigma_t=1e-3;sigma_rho=4e-4;
 elseif station==8; sigma_t=2.5e-3;sigma_rho=6e-4; 
 elseif station==9; sigma_t=1e-3;sigma_rho=4e-4;
 elseif station>9; sigma_t=2e-3; sigma_rho=4e-4;
 end

end
    
%% overturns
% calculate separately for each sensor pair
disp(['Calculating overturns'])

% setup sizes   
C.eps_t1=NaN*C.t; C.eps_t1_hi=NaN*C.t1_hi; C.eps_rho1=C.eps_t1; 
C.eps_t2=NaN*C.t; C.eps_t2_hi=NaN*C.t1_hi; C.eps_rho2=C.eps_t1;
Lot_rho1=NaN*C.t; Lt_rho1=NaN*C.t;
Lot_rho2=NaN*C.t; Lt_rho2=NaN*C.t;
Lot_t1=NaN*C.t; Lt_t1=NaN*C.t;
Lot_t2=NaN*C.t; Lt_t2=NaN*C.t;



for idrop=1:length(C.lat)
   if rem(idrop,20)==0; disp(idrop); end
 
    in=find(~isnan(C.t1(:,idrop))&~isnan(C.s1(:,idrop)));
     if length(in)<30; continue; end
     % t1,s1 for 1 m data
    [Epsout,Lmin,Lot,runlmax,Lttot]=compute_overturns2(C.p(in),C.t1(in,idrop),C.s1(in,idrop),C.lat(idrop),1,3,sigma_t,0); 
    C.eps_t1(in,idrop) = Epsout;
    [Epsout,Lmin,Lot,runlmax,Lttot]=compute_overturns2(C.p(in),C.t1(in,idrop),C.s1(in,idrop),C.lat(idrop),0,3,sigma_rho,0); 
    C.eps_rho1(in,idrop) = Epsout;
    Lot_rho1(in,idrop)=Lot; Lt_rho1(in,idrop)=Lttot;
    
    
     % t1,s1 for 25cm data
    in=find(~isnan(C.t1_hi(:,idrop))&~isnan(C.s1_hi(:,idrop)));
     if length(in)<30; continue; end
    [Epsout,Lmin,Lot,runlmax,Lttot]=compute_overturns2(C.p_hi(in),C.t1_hi(in,idrop),C.s1_hi(in,idrop),C.lat(idrop),1,2,sigma_t*2,0); 
    C.eps_t1_hi(in,idrop) = Epsout;
    Lot_t1(in,idrop)=Lot; Lt_t1(in,idrop)=Lttot;
    
    in=find(~isnan(C.t1(:,idrop))&~isnan(C.s1(:,idrop)));
     if length(in)<30; continue; end
     % t2,s2 for 1m data
    [Epsout,Lmin,Lot,runlmax,Lttot]=compute_overturns2(C.p(in),C.t2(in,idrop),C.s2(in,idrop),C.lat(idrop),1,3,sigma_t,0); 
    C.eps_t2(in,idrop) = Epsout;
    [Epsout,Lmin,Lot,runlmax,Lttot]=compute_overturns2(C.p(in),C.t2(in,idrop),C.s2(in,idrop),C.lat(idrop),0,3,sigma_rho,0); 
    C.eps_rho2(in,idrop) = Epsout;
    Lot_rho2(in,idrop)=Lot; Lt_rho2(in,idrop)=Lttot;
        
    
     % t2,s2 for 25 m data
    in=find(~isnan(C.t2_hi(:,idrop))&~isnan(C.s2_hi(:,idrop)));
     if length(in)<30; continue; end
    [Epsout,Lmin,Lot,runlmax,Lttot]=compute_overturns2(C.p_hi(in),C.t2_hi(in,idrop),C.s2_hi(in,idrop),C.lat(idrop),1,2,sigma_t*2,0); 
    C.eps_t2_hi(in,idrop) = Epsout;
    Lot_t2(in,idrop)=Lot; Lt_t2(in,idrop)=Lttot;
end

%% take the least value for each
%eps_t=min(C.eps_t1,C.eps_t2);
eps_t=interp1(C.z_hi,min(C.eps_t1_hi,C.eps_t2_hi),C.z);
eps_rho=min(C.eps_rho1,C.eps_rho2);
eps_min=min(eps_t,eps_rho);



C.epsilon_OT=eps_min;
C.epsilon_OT_t=eps_t;
C.epsilon_OT_rho=eps_rho;


%% save interim version
%save([outdir 'CTD_' Names{station} '.mat'],'C')

%% add LADCP data
clear L
ladcp_dir=[rootdir 'LADCP/data/processed/'];
z0=[0:8:max(C.z_hi)]';
L.u=NaN*ones(length(z0),length(files)); L.v=L.u; 
ind=1;
if station==6; files=[154:170]; L.note='No data for last three ctd casts, LADCP batteries died'; end  % ladcp batteries died
for ifile=files
    load([ladcp_dir 'IWISE10_' int2str(ifile) '.mat'])
 nz=length(dr.z);
L.u(:,ind)=interp1(dr.z,dr.u,z0); 
L.v(:,ind)=interp1(dr.z,dr.v,z0);;

ind=ind+1;
end
L.z=z0(:); L.p=sw_pres(L.z,nanmean(C.lat));
L.datenum=nanmean([C.datenum_down;C.datenum_up]);

%%
C.author='Jen';
C.creation=datestr(now);
%% make output file
clear All down up 

todo = {'z','p','t','c','s','sgth','n2_smoothed','n2_comment','mode_speeds','mode_shapes','epsilon_OT','epsilon_OT_t','epsilon_OT_rho','lat','lon','cast','author','creation'};
for j=1:length(todo);
    down.(todo{j})=C.(todo{j});
end
down.datenum=C.datenum_down;
down.datenum_avg=nanmean(C.datenum_down);

if doup
    up.t=C.t_up; up.c=C.c_up; up.p=C.p_up; up.datenum=C.datenum_up;
   up.datenum_avg=nanmean(C.datenum_up);
end


%
All.ctd_down=down;
All.ctd_up=up;
All.ladcp=L;

%% save
save([outdir 'CTD_' Names{station} '.mat'],'All')

