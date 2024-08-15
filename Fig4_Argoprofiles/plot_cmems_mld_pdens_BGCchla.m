tic, clc, clear,format long g,close all,warning off
load('world_map2','coast4')
mon=6; monstr='June'; 
x1=120; x2=220; y1=5; y2=30;

for yr=1998:2020
close all

pth=['V:\SCS initial data\web\copernicus\chl_interpolated_4km_month\cmems_obs-oc_glo_bgc-plankton_my_l4-multi-4km_P1M\',num2str(yr),'\'];
files=ls([pth,'*.nc']);
in=[pth,files(mon,:)];
lon=ncread(in,'lon');
        ilon=find(lon<0); lon(ilon)=lon(ilon)+360;
        lon2(1:length(lon)-length(ilon))=lon(length(ilon)+1:end); 
        lon2(length(lon)-length(ilon)+1:length(lon))=lon(1:length(ilon));
        lon=lon2; clear lon2
lat=ncread(in,'lat');
chl=ncread(in,'CHL'); chl=chl';
        Ix=find(lon>=x1 & lon<=x2);
        Iy=find(lat>=y1 & lat<=y2);
        [cx,cy]=meshgrid(lon(Ix),lat(Iy));     
        chl2(:,1:length(lon)-length(ilon))=chl(:,length(ilon)+1:end); 
        chl2(:,length(lon)-length(ilon)+1:length(lon))=chl(:,1:length(ilon)); %return
        chl=chl2; clear chl2  
        chl=chl(Iy,Ix);
pth=['Z:\CloudStation\data\CMEMS2\cmems_obs-oc_glo_bgc-transp_my_l4-multi-4km_P1M\',num2str(yr),'\'];
files=ls([pth,'*.nc']);
in=[pth,files(mon,:)];
zsd=ncread(in,'ZSD'); zsd=zsd';
        chl2(:,1:length(lon)-length(ilon))=zsd(:,length(ilon)+1:end); 
        chl2(:,length(lon)-length(ilon)+1:length(lon))=zsd(:,1:length(ilon)); %return
        zsd=chl2; clear chl2  
        zsd=zsd(Iy,Ix);
        Inan=find(zsd==-999);
        zsd(Inan)=NaN;
        zsd_NS=mean(zsd,2,'omitnan');
        
% return
% load('Z:\STCC\Chla\merged_data\high_chl_bloom_JJ_nocloud','cx','cy','chl_all')

pth=['V:\SCS initial data\web\copernicus\MLD\dataset-armor-3d-rep-monthly\',num2str(yr),'\'];
files=ls([pth,'*.nc']);
in=[pth,files(mon,:)];
% pth=['V:\SCS initial data\web\copernicus\MLD\dataset-armor-3d-rep-monthly\2018\'];
% in=[pth,'dataset-armor-3d-rep-monthly_20180715T1200Z_P20201106T2231Z.nc'];
x=ncread(in,'longitude'); 
y=ncread(in,'latitude');
mld=ncread(in,'mlotst'); return
T=ncread(in,'to');
S=ncread(in,'so');
D=ncread(in,'depth'); %return

Ix=find(x>=x1 & x<=x2);
Iy=find(y>=y1 & y<=y2);

mld=mld(Ix,Iy)';  %return
T=T(Ix,Iy,:); S=S(Ix,Iy,:); 
T=permute(T,[2 1 3]); S=permute(S,[2 1 3]);

I=find(mld>30000); mld(I)=NaN; mld=mld*0.1+2500;
I=find(T>30000); T(I)=NaN; T=T*0.001+20;
I=find(S>30000); S(I)=NaN; S=S*0.001+20;
[xi,yi]=meshgrid(x(Ix),y(Iy));
[a,b]=size(yi);
for m=1:a
    LAT=zeros(size(D))+yi(m,1);
    z(m,:)=sw_pres(D,LAT);
    dep(m,:)=D;
end
P=repmat(z,[1 1 b]);P=permute(P,[1 3 2]);
Pr=zeros(size(P));
dep_all=repmat(dep,[1 1 b]);dep_all=permute(dep_all,[1 3 2]);
% return
pden = sw_pden(S,T,P,Pr);
[q,q,m] = size(pden);
iup   = 1:m-1;
ilo   = 2:m;
pden_up = pden(:,:,iup);
pden_lo = pden(:,:,ilo);
dep_up = dep_all(:,:,iup);
dep_lo = dep_all(:,:,ilo);
mid_pden = (pden_up + pden_lo )/2;
mid_dep = (dep_up+dep_lo)/2;
dif_pden = pden_up - pden_lo;
dif_z    = dep_up - dep_lo;
n2       = 9.8 * dif_pden ./ (dif_z .* mid_pden);

for dd=1:50
    [dpdx,dpdy]=my_gradient(xi,yi,pden(:,:,dd));
    dpdy_all(:,:,dd)=dpdy;
    dpgrad_all(:,:,dd)=sqrt(dpdy.^2+dpdx.^2);
end
pden_all(:,:,:,yr-1997)=pden;
mld_NS=mean(mld,2,'omitnan');
myfigure_off
subplot(4,2,1)
% pcolor(xi,yi,mld); shading flat
contourf(xi,yi,mld,[10:5:80],'linecolor','none')
caxis([10 80])
colormap jet
colorbar
axis equal
hold on
contour(xi,yi,mld,[50 50],'linecolor','k')  
contour(cx,cy,chl,[0.08 0.08],'linecolor','k','linewidth',2)
h=fillseg(coast4);
set(h,'edgecolor','none')     
set(gca,'xlim',[x1 x2],'ylim',[y1 y2],'fontsize',12,'fontweight','bold','TickDir','out','linewidth',2,'xtick',[x1:10:x2])    
title(['MLD in ',monstr,' ',num2str(yr)])

subplot(4,2,3)
contourf(xi,yi,mean(T(:,:,1:4),3,'omitnan'),[20:0.5:40],'linecolor','none')
caxis([20 30])
colormap jet
colorbar
axis equal
hold on
[C,h]=contour(xi,yi,mean(T(:,:,1:4),3,'omitnan'),[25 27 28],'linecolor','k')  ;
clabel(C,h)
contour(cx,cy,chl,[0.08 0.08],'linecolor','k','linewidth',2)
h=fillseg(coast4);
set(h,'edgecolor','none')     
set(gca,'xlim',[x1 x2],'ylim',[y1 y2],'fontsize',12,'fontweight','bold','TickDir','out','linewidth',2,'xtick',[x1:10:x2])    
title(['0~15m temperature in ',monstr,' ',num2str(yr)])

subplot(4,2,5)
contourf(xi,yi,mean(S(:,:,1:4),3,'omitnan'),[33:0.1:36],'linecolor','none')
caxis([33 36])
colormap jet
colorbar
axis equal
hold on
% contour(xi,yi,T(:,:,1),[25 27 28],'linecolor','k')  
contour(cx,cy,chl,[0.08 0.08],'linecolor','k','linewidth',2)
h=fillseg(coast4);
set(h,'edgecolor','none')     
set(gca,'xlim',[x1 x2],'ylim',[y1 y2],'fontsize',12,'fontweight','bold','TickDir','out','linewidth',2,'xtick',[x1:10:x2])    
title(['0~15m salinity in ',monstr,' ',num2str(yr)])

subplot(4,2,7)
dpdy_mean=mean(dpdy_all(:,:,1:4),3,'omitnan');
pden_mean=mean(pden(:,:,1:4),3,'omitnan');
Ixm=find(xi(1,:)>=160 & xi(1,:)<=200);
Iym=find(yi(:,1)>=16 & yi(:,1)<=28);
dpdy_mean_box(yr-1997)=mean(reshape(dpdy_mean(Iym,Ixm),1,[]),'omitnan');
pden_mean_box(yr-1997)=mean(reshape(pden_mean(Iym,Ixm),1,[]),'omitnan');
contourf(xi,yi,pden_mean-1000,[10:0.25:30],'linecolor','k')
caxis([20 24])
% contourf(xi,yi,dpdy_mean,[-5:1:5]*10^-6,'linecolor','none')
% caxis([-3 3]*10^-6)
colormap jet
colorbar
axis equal
hold on
% contour(xi,yi,T(:,:,1),[25 27 28],'linecolor','k')  
contour(cx,cy,chl,[0.08 0.08],'linecolor','m','linewidth',2)
h=fillseg(coast4);
set(h,'edgecolor','none')     
set(gca,'xlim',[x1 x2],'ylim',[y1 y2],'fontsize',12,'fontweight','bold','TickDir','out','linewidth',2,'xtick',[x1:10:x2])    
title(['0~15m potential density in ',monstr,' ',num2str(yr)])
% return
% subplot(4,2,5)
% contourf(xi,yi,S(:,:,20),[33:0.1:36],'linecolor','none')
% caxis([34.5 35.5])
% colormap jet
% colorbar
% axis equal
% hold on
% % contour(xi,yi,T(:,:,1),[25 27 28],'linecolor','k')  
% contour(cx,cy,chl,[0.08 0.08],'linecolor','k','linewidth',2)
% h=fillseg(coast4);
% set(h,'edgecolor','none')     
% set(gca,'xlim',[x1 x2],'ylim',[y1 y2],'fontsize',12,'fontweight','bold','TickDir','out','linewidth',2,'xtick',[x1:10:x2])    
% title(['Salinity at 150m in ',monstr,' ',num2str(yr)])

% subplot(4,2,6)
% % pden_mean=mean(pden(:,:,1:18),3,'omitnan');
% % [qqq,dpdy_mean]=my_gradient(xi,yi,pden_mean);
% % % contourf(xi,yi,dpdy_mean,[-5:0.5:5]*10^-6,'linecolor','none')
% % caxis([-5 5]*10^-6)
% % contourf(xi,yi,pden_mean-1000,[10:0.2:30],'linecolor','none')
% contourf(xi,yi,pden(:,:,20)-1000,[10:0.2:30],'linecolor','none')
% caxis([22 26])
% colormap jet
% colorbar
% axis equal
% hold on
% % contour(xi,yi,T(:,:,1),[25 27 28],'linecolor','k')  
% contour(cx,cy,chl,[0.08 0.08],'linecolor','k','linewidth',2)
% h=fillseg(coast4);
% set(h,'edgecolor','none')     
% set(gca,'xlim',[x1 x2],'ylim',[y1 y2],'fontsize',12,'fontweight','bold','TickDir','out','linewidth',2,'xtick',[x1:10:x2])    
% title(['Potential density at 150m in ',monstr,' ',num2str(yr)])

subplot(4,2,[2 4])
[xi2,yi2]=meshgrid(yi(:,1),D);
Ix=find(xi(1,:)>=170 & xi(1,:)<=190);
Z2=squeeze(mean(T(:,Ix,:),2,'omitnan'))';
% Z3=squeeze(mean(pden(:,Ix,:),2,'omitnan'))';
N2=squeeze(mean(n2(:,Ix,:),2,'omitnan'))';
T_sec=Z2;
N2_sec=N2;
[q,Imin]=min(abs(xi(1,:)-180));
Z=squeeze(T(:,Imin,:))';
% pcolor(xi2,yi2,Z); shading flat
% contourf(xi2,yi2,Z2,[2:1:40],'linecolor','none')
contourf(xi2(1:end-1,:),yi2(1:end-1,:),N2,[-2:0.1:3]*10^-3,'linecolor','none')
caxis([-0.5 1.0]*10^-3)
colorbar
hold on

% clabel(C,h)
[C,h]=contour(xi2,yi2,Z2,[0:1:40],'linecolor','k');
% clabel(C,h,[5:5:40])
[C,h]=contour(xi2,yi2,Z2,[10 15 20 25],'linecolor','k','linewidth',2);
clabel(C,h)
set(gca,'ydir','reverse','ylim',[0 300])
% title(['Temperature Section along 180^oE in ',monstr,' ',num2str(yr)])
title(['Temperature & N2 section within 170-190^oE in ',monstr,' ',num2str(yr)])
plot(cy(:,1),zsd_NS,'--r','linewidth',2)
plot(yi(:,1),mld_NS,':r','linewidth',2)
text(cy(1,1),zsd_NS(1),'ZS','Color','r','HorizontalAlignment','left')
text(yi(end,1),mld_NS(end),'ML','Color','r','HorizontalAlignment','left')
ylabel('Depth (m)')
% return

subplot(4,2,[6 8])
[xi2,yi2]=meshgrid(yi(:,1),D);
Ix=find(xi(1,:)>=170 & xi(1,:)<=190);
Z2=squeeze(mean(pden(:,Ix,:),2,'omitnan'))'-1000;
N2=squeeze(mean(n2(:,Ix,:),2,'omitnan'))';
Z3=squeeze(mean(dpdy_all(:,Ix,:),2,'omitnan'))';
% [q,Imin]=min(abs(xi(1,:)-180));
% Z=squeeze(T(:,Imin,:))';
% pcolor(xi2,yi2,Z3); shading flat
% contourf(xi2,yi2,Z2,[2:1:40],'linecolor','none')
contourf(xi2,yi2,Z3,[0:0.1:1]*10^-5,'linecolor','none')
pgrad_sec=Z3;
rho_sec=Z2;
% save('2018_section_T_dens_N2_160_200','xi2','yi2','pgrad_sec','T_sec','N2_sec','rho_sec')
caxis([-0.5 0.5]*10^-5)
colorbar
hold on

% clabel(C,h)
[C,h]=contour(xi2,yi2,Z2,[20:0.25:30],'linecolor','k');
% clabel(C,h)
[C,h]=contour(xi2,yi2,Z2,[23.5 24.5 25.5],'linecolor','k','linewidth',2);
clabel(C,h)
set(gca,'ydir','reverse','ylim',[0 300])
% title(['Temperature Section along 180^oE in ',monstr,' ',num2str(yr)])
title(['\sigma_\theta & \partial\sigma_\theta/\partialy section within 170-190^oE in ',monstr,' ',num2str(yr)])
plot(cy(:,1),zsd_NS,'--r','linewidth',2)
plot(yi(:,1),mld_NS,':r','linewidth',2)
ylabel('Depth (m)')

saveas(gcf,['BGCchla_MLD_surface_front_all_cases_',monstr,' ',num2str(yr)],'png')
% return
end
return
figure
plot([1998:2020],dpdy_mean_box)
xlabel('Year')
ylabel('\partial\sigma_\theta/\partialy')

figure
bar([1998:2020],dpdy_mean_box)
xlabel('Year')
ylabel('\partial\sigma_\theta/\partialy')
set(gca,'xlim',[1997 2021],'xtick',[1998:2:2020])
% save(['pdens_1998_2020_',monstr],'xi','yi','pden_all')
toc