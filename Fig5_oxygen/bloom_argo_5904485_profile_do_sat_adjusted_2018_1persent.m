tic, clc, clear,format long g,close all, warning off
x1=160; x2=220; y1=10; y2=30;
woa_pth='Z:\SCS initial data\web\WOA18\Dissolved Oxygen\';
woa_pth_temp='Z:\SCS initial data\web\WOA18\Temperature\';
woa_pth_salt='Z:\SCS initial data\web\WOA18\Salinity\';
pth='Z:\SCS initial data\web\ocean color\merged_chla\daily_4km\';
files=ls([pth,'*2018*.nc']);
date_chl=files(:,5:12); 
yr_chl=str2num(date_chl(:,1:4));
mn_chl=str2num(date_chl(:,5:6));
dd_chl=str2num(date_chl(:,7:8));
% return
% load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\DATA_BIO_ARGO\bio_argo_HLCC_water_data_adjusted',...
%     'T_id','T_lon','T_lat','T_pres','T_pres_qc','T_do','T_do_qc','gt',...
%     'T_sal','T_sal_qc','T_temp','T_temp_qc') 
load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\DATA_BIO_ARGO\bio_argo_5904485_data_adjusted_all',...
    'T_id','T_lon','T_lat','T_pres','T_pres_qc',...
    'T_do','T_do_qc','T_sal','T_sal_qc','T_temp','T_temp_qc','gt')
I=find(T_id==5904485 & gt(:,2)>=5 & gt(:,2)<=10 & gt(:,1)==2018); %return
% L=[6:2:300];
L=[6:2:500];
% do_all=ones(length(L),length(I))*NaN;
% do_all_eq=ones(length(L),length(I))*NaN;
% do_all=ones(length(L),length(I));
% do_all=ones(length(L),length(I));
% myfigure
p=0;
for m=1:length(I)
    pres=T_pres{I(m)};
    do=T_do{I(m)};
    temp=T_temp{I(m)};
    salt=T_sal{I(m)};
    do_qc=T_do_qc{I(m)};
    pres_qc=T_pres_qc{I(m)};
    temp_qc=T_temp_qc{I(m)};
    salt_qc=T_sal_qc{I(m)};    
    Iok=find(do_qc=='1' & pres_qc=='1' & temp_qc=='1' & salt_qc=='1');
%     if length(Iok)>0, return; end %% for double check 
    pres=pres(Iok);
    do=do(Iok);
    temp=temp(Iok);
    salt=salt(Iok);    
%     O2sat=sw_satO2(salt,temp); %return
    O2sat=o2satv2b(salt,temp); 
    pden = sw_pden(salt,temp,pres,0);
    
%     return
    time=gt(I(m),:);
    argo_lon=T_lon(I(m)); 
    argo_lat=T_lat(I(m));
    if argo_lon<0, argo_lon=argo_lon+360; end
    argo_lon_dep=ones(1,length(L))*argo_lon;
    argo_lat_dep=ones(1,length(L))*argo_lat;    
    dep = sw_dpth(pres,argo_lat); %return    
    
    
    Iok=find(isfinite(dep)==1 & isfinite(do)==1);
    Iok2=find(isfinite(dep)==1 & isfinite(do)==1 & isfinite(temp)==1 & isfinite(salt)==1); % no different
    if length(Iok2)~=length(Iok), display('check'); end %% would not come to here
    if length(Iok)>0
        p=p+1;
        dep_all(:,p)=L;
        do_all(:,p)=interp1(dep(Iok),do(Iok),L); %% micromole/kg
        do_all_eq(:,p)=interp1(dep(Iok),O2sat(Iok),L); %return
        temp_all(:,p)=interp1(dep(Iok),temp(Iok),L); 
        salt_all(:,p)=interp1(dep(Iok),salt(Iok),L); 
        pden_all(:,p)=interp1(dep(Iok),pden(Iok),L); 
        lon_all(p)=argo_lon;
        lat_all(p)=argo_lat;
%     else
%         do_all(:,m)=NaN; %% micromole/kg
%         do_all_eq(:,m)=NaN; 
%         temp_all(:,m)=NaN; 
%         pden_all(:,m)=NaN;    
%     end
    temp_clim = nc_varget([woa_pth_temp,'woa18_decav_t',num2str(time(2),'%2.2u'),'_01.nc']...
        ,'t_an'); temp_clim=permute(temp_clim,[2 3 1]);  
    salt_clim = nc_varget([woa_pth_salt,'woa18_decav_s',num2str(time(2),'%2.2u'),'_01.nc']...
        ,'s_an'); salt_clim=permute(salt_clim,[2 3 1]);
    O2sat_clim=o2satv2b(salt_clim,temp_clim);  %return
    
            
    do_clim = nc_varget([woa_pth,'woa18_all_o',num2str(time(2),'%2.2u'),'_01.nc'],'o_an'); 
    do_clim=permute(do_clim,[2 3 1]); %return
    
    do_clim_x= nc_varget([woa_pth,'woa18_all_o',num2str(time(2),'%2.2u'),'_01.nc'],'lon'); 
    ilon=find(do_clim_x<0); do_clim_x(ilon)=do_clim_x(ilon)+360;
        do_clim_x2(1:length(do_clim_x)-length(ilon))=do_clim_x(length(ilon)+1:end); 
        do_clim_x2(length(do_clim_x)-length(ilon)+1:length(do_clim_x))=do_clim_x(1:length(ilon));
        do_clim_x=do_clim_x2; clear do_clim_x2
    do_clim2(:,1:length(do_clim_x)-length(ilon),:)=do_clim(:,length(ilon)+1:end,:); 
    do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=do_clim(:,1:length(ilon),:); %return
    do_clim=do_clim2; clear do_clim2
    do_clim2(:,1:length(do_clim_x)-length(ilon),:)=O2sat_clim(:,length(ilon)+1:end,:); 
    do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=O2sat_clim(:,1:length(ilon),:); %return
    O2sat_clim=do_clim2; clear do_clim2    
    
    do_clim_y= nc_varget([woa_pth,'woa18_all_o',num2str(time(2),'%2.2u'),'_01.nc'],'lat'); 
    do_clim_z= nc_varget([woa_pth,'woa18_all_o',num2str(time(2),'%2.2u'),'_01.nc'],'depth'); %return
    [do_clim_x,do_clim_y,do_clim_z]=meshgrid(do_clim_x,do_clim_y,do_clim_z);
    
    pden_clim = sw_pden(salt_clim,temp_clim,do_clim_z,zeros(size(do_clim_z))); %return
    do_clim2(:,1:length(do_clim_x)-length(ilon),:)=pden_clim(:,length(ilon)+1:end,:); 
    do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=pden_clim(:,1:length(ilon),:); %return
    pden_clim=do_clim2; clear do_clim2  
    
    do_clim2(:,1:length(do_clim_x)-length(ilon),:)=temp_clim(:,length(ilon)+1:end,:); 
    do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=temp_clim(:,1:length(ilon),:); %return
    temp_clim=do_clim2; clear do_clim2     
    
    do_clim_argo = interp3(do_clim_x,do_clim_y,do_clim_z,do_clim,argo_lon_dep,argo_lat_dep,L); %return
    do_all_clim(:,p)=do_clim_argo;
    do_clim_argo = interp3(do_clim_x,do_clim_y,do_clim_z,O2sat_clim,argo_lon_dep,argo_lat_dep,L); %return
    doeq_all_clim(:,p)=do_clim_argo;   %return 
    
    pden_clim_argo = interp3(do_clim_x,do_clim_y,do_clim_z,pden_clim,argo_lon_dep,argo_lat_dep,L); %return
    pden_all_clim(:,p)=pden_clim_argo; 
    
    temp_clim_argo = interp3(do_clim_x,do_clim_y,do_clim_z,temp_clim,argo_lon_dep,argo_lat_dep,L); %return
    temp_all_clim(:,p)=temp_clim_argo;     
    
    if time(2)==6, 
        mon_day=30; 
    else
        mon_day=31;
    end
    time_float=time(2)+(time(3)-1)/mon_day;
    time_all(:,p)=ones(1,length(L))*time_float;
    gt_all(p,:)=gt(I(m),:);
    
%     Ichl=find(yr_chl==time(1) & mn_chl==time(2) & dd_chl==time(3)); 
% %     in=[pth,files(Ichl,:)]; 
%     chl = nc_varget(in,'CHL1_mean'); 
%         lon = nc_varget(in,'lon'); ilon=find(lon<0); lon(ilon)=lon(ilon)+360;
%         lon2(1:length(lon)-length(ilon))=lon(length(ilon)+1:end); 
%         lon2(length(lon)-length(ilon)+1:length(lon))=lon(1:length(ilon));
%         lon=lon2; clear lon2
%         lat = nc_varget(in,'lat'); %return
%         Ix=find(lon>=x1 & lon<=x2);
%         Iy=find(lat>=y1 & lat<=y2);
%         [chl_x,chl_y]=meshgrid(lon(Ix),lat(Iy));
%     chl2(:,1:length(lon)-length(ilon))=chl(:,length(ilon)+1:end); 
%     chl2(:,length(lon)-length(ilon)+1:length(lon))=chl(:,1:length(ilon)); %return
%     chl=chl2; clear chl2
%     
%     ix=find(lon>=140 & lon<=155);
%     iy=find(lat>=15 & lat<=25); 
%     chl=chl(Iy,Ix);
%     argo_chl=interp2(chl_x,chl_y,chl,argo_lon,argo_lat,'nearest');
%     Ichk=isnan(argo_chl);
%     if Ichk==1
%         Iok=find(isfinite(chl)==1);
%         argo_chl=griddata(chl_x(Iok),chl_y(Iok),chl(Iok),argo_lon,argo_lat);
%         argo_chl_qc=0;
%     else
%         argo_chl_qc=1;
%     end
%     argo_chl_all(p)=argo_chl;
%     argo_chl_qc_all(p)=argo_chl_qc;
    end
%     return
end
% return
myfigure
% subplot(7,1,1)
% plot(time_all(1,:),argo_chl_all,'.-k')
% I=find(argo_chl_qc_all==0);
% hold on
% plot(time_all(1,I),argo_chl_all(I),'ok')
% % set(gca,'xlim',[time_all(1,1) time_all(1,end)])
% set(gca,'xlim',[5 11])
% ylabel('CHL conc. (mg/m^3)')
% title('Argo 5904485')
% text(6.2,0.15,'(a) Satellite Chl')

subplot(7,1,[2 3])
% pcolor(time_all,dep_all,do_all); shading flat
% contourf(time_all,dep_all,do_all,[100:2.5:300],'linecolor','none')
contourf(time_all,dep_all,pden_all-1000,[1:0.25:32],'linecolor','none')
% caxis([150 250])
caxis([20 25])
colormap jet
% colorbar 
hold on
[C,h]=contour(time_all,dep_all,do_all,[100:5:300],'linecolor','k');
clabel(C,h)
% [C,h]=contour(time_all,dep_all,pden_all-1000,[1:0.5:32],'linecolor','k');
% clabel(C,h)
plot(time_all,dep_all,'.k')
set(gca,'ylim',[0 200],'ydir','reverse')
set(gca,'xlim',[5 11])
ylabel('Depth (m)')
text(6.2,150,'(b) Argo DO adjusted (micro mol/kg)','backgroundcolor','w')

% do_all_eq=do_all_eq*43.57; %%1 ml/l of O2 is approximately 43.570 ?mol/kg
subplot(7,1,[4 5])
% pcolor(time_all,dep_all,salt_all); shading flat
contourf(time_all,dep_all,salt_all,[34:0.1:35.5],'linecolor','none')
% contourf(time_all,pres_all,pden_all-1000,[1:0.25:32],'linecolor','none')
caxis([34.5 35.5])
colormap jet
% colorbar 
hold on
[C,h]=contour(time_all,dep_all,salt_all,[34:0.1:35.5],'linecolor','k');
clabel(C,h,[34:0.5:35.5])
% [C,h]=contour(time_all,dep_all,pden_all-1000,[1:0.5:32],'linecolor','k');
% clabel(C,h)
plot(time_all,dep_all,'.k')
set(gca,'ylim',[0 200],'ydir','reverse')
set(gca,'xlim',[5 11])
ylabel('Depth (m)')
xlabel('Time (month)')
text(6.2,150,'(c) Salinity (ppt)','backgroundcolor','w')

ax1=subplot(7,1,[6 7]);
% pcolor(time_all,dep_all,do_all); shading flat
% contourf(time_all,dep_all,100*do_all./do_all_eq,[0:2.5:120],'linecolor','none')
contourf(time_all,dep_all,100*(do_all./do_all_eq-1),[-50:2.5:30],'linecolor','none')
% contourf(time_all,pres_all,pden_all-1000,[1:0.25:32],'linecolor','none')
caxis([-30 20])
colormap jet
% colorbar 
hold on
% [C,h]=contour(time_all,dep_all,100*do_all./do_all_eq,[0:4:100],'linecolor','k');
% clabel(C,h)
% [C,h]=contour(time_all,dep_all,100*do_all./do_all_eq,[100 100],'linecolor','g');
[C,h]=contour(time_all,dep_all,100*(do_all./do_all_eq-1),[0 0],'linecolor','k'...
    ,'linewidth',3,'linestyle','--');
[C,h]=contour(time_all,dep_all,pden_all-1000,[1:0.25:32],'linecolor','k');
clabel(C,h,[1:0.5:32])
[C,h]=contour(time_all,dep_all,pden_all_clim-1000,[24.5 24.5],'linecolor','m','linewidth',2);
plot(time_all,dep_all,'.k')
set(gca,'ylim',[0 200],'ydir','reverse')
set(gca,'xlim',[5 11])
ylabel('Depth (m)')
xlabel('Time (month)')
text(6.2,150,'(d) delta SO_2 (%)','backgroundcolor','w')
ax2=get(gca,'position');
 axes('position',[(ax2(1,1)+ax2(1,3)+0.01) ax2(1,2) 0.02 ax2(1,4)]);
            xc_bar=[1 2 3];
            yc_bar=[-30:2.5:20];
            [xc_bar,yc_bar]=meshgrid(xc_bar,yc_bar);
            pcolor(xc_bar,yc_bar,yc_bar)
%             
            shading flat, 
            caxis([-30 20])
            set(gca,'layer','top','xtick',[],'ytick',[-30:10:20]...
                ,'yaxislocation','right','ylim',[-30 20],'fontsize',12,...
                'yticklabel',[-30:10:20])
%             text(1,0.31,'m','fontsize',12) 

figure
plot(pden_all-1000,100*(do_all./do_all_eq-1),'.k')
pden=pden_all-1000;
pden_anol=pden_all-pden_all_clim;
temp_anol=temp_all-temp_all_clim;
delO2=100*(do_all./do_all_eq-1);
satO2=100*(do_all./do_all_eq);
satO2_clim=100*(do_all_clim./doeq_all_clim);
% save('5904485_2018_oxden','pden','delO2','satO2','do_all','time_all',...
%     'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim',...
%     'pden_anol','temp_anol','pden_all','temp_all')
toc