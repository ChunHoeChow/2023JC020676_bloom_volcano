tic, clc, clear,format long g,close all, warning off
% myfigure

YY=[2018 2017 2018]; %return
L=[6:2:300];

woa_pth_temp='Z:\SCS initial data\web\WOA18\Temperature\';
woa_pth_salt='Z:\SCS initial data\web\WOA18\Salinity\';

% pg=[1 4; 2 5; 3 6];
lab=['abcd'];
f_width=30; f_height=20; mar_w=[1.5 2]; mar_h=[1 1.5]; gap=[1.5 3.5];
[ax]=mysubplot_nomap(2,2,gap,f_height,f_width,mar_h,mar_w); 
% [ax, f_height, q, q, q]=mysubplot(4,1,gap,f_width,[x1 x2],[y1 y2],mar_h,mar_w);
set(figure,'units','centimeter','position',[0.1 1 f_width f_height],'visible','on',...
    'PaperPositionMode', 'manual', 'PaperUnits', 'centimeter', 'PaperPosition', [0 0 f_width f_height]); 
% axes('units','centimeters','position',ax(1,:));
sz=12;
% pg=0;
pg=[1 3 4];
for PP=[1 3]
    yr=YY(PP);
    if PP<3, 
        load(['argo_5904093_chl_',num2str(yr),'_MJJA'],'argo_chl','gt_all','argo_sla','argo_ow')
        load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\DATA_BIO_ARGO\bio_argo_5904093_data_adjusted_all',...
            'T_id','T_lon','T_lat','T_pres','T_pres_qc',...
            'T_do','T_do_qc','T_sal','T_sal_qc','T_temp','T_temp_qc','gt')
    else
        load(['argo_5904485_chl_',num2str(yr),'_MJJA'],'argo_chl','gt_all','argo_sla','argo_ow')
        load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\DATA_BIO_ARGO\bio_argo_5904485_data_adjusted_all',...
            'T_id','T_lon','T_lat','T_pres','T_pres_qc',...
            'T_do','T_do_qc','T_sal','T_sal_qc','T_temp','T_temp_qc','gt')
    end
    mn=gt_all(:,2);
    dd=gt_all(:,3);
    time=mn+(dd-1)/31;
    hr=gt_all(:,4);
    I=find(mn==6);
    time(I)=mn(I)+(dd(I)-1)/30; 

% subplot(2,3,pg(PP,1))
% axes('units','centimeters','position',ax(pg,:));
% pg=pg+1;
axes('units','centimeters','position',ax(pg(PP),:));
I=find(gt(:,2)>=5 & gt(:,2)<=8 & gt(:,1)==yr); 
p=0; 
clear pden_all_clim dep_all do_all do_all_eq pden_all time_all hr_all
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
    O2sat=o2satv2b(salt,temp); 
    pden = sw_pden(salt,temp,pres,0);
    
    time2=time(m);
    hr2=hr(m);
    mon2=gt(I(m),2);
    argo_lon=T_lon(I(m)); 
    argo_lat=T_lat(I(m));
    if argo_lon<0, argo_lon=argo_lon+360; end
    argo_lon_dep=ones(1,length(L))*argo_lon;
    argo_lat_dep=ones(1,length(L))*argo_lat;    
    dep = sw_dpth(pres,argo_lat); 
    
    Iok=find(isfinite(dep)==1 & isfinite(do)==1); return
%     Iok=find(isfinite(dep)==1 & isfinite(do)==1 & isfinite(temp)==1 & isfinite(salt)==1); % no different 
    if length(Iok)>0
        p=p+1;
        dep_all(:,p)=L;
        do_all(:,p)=interp1(dep(Iok),do(Iok),L); %% micromole/kg
        do_all_eq(:,p)=interp1(dep(Iok),O2sat(Iok),L); 
        pden_all(:,p)=interp1(dep(Iok),pden(Iok),L); 
        time_all(:,p)=ones(1,length(L))*time2;
        hr_all(p)=hr2;
        
        temp_clim = nc_varget([woa_pth_temp,'woa18_decav_t',num2str(mon2,'%2.2u'),'_01.nc']...
            ,'t_an'); temp_clim=permute(temp_clim,[2 3 1]);  
        salt_clim = nc_varget([woa_pth_salt,'woa18_decav_s',num2str(mon2,'%2.2u'),'_01.nc']...
            ,'s_an'); salt_clim=permute(salt_clim,[2 3 1]);    
        clim_z= nc_varget([woa_pth_salt,'woa18_decav_s',num2str(mon2,'%2.2u'),'_01.nc'],'depth'); %return
        clim_x= nc_varget([woa_pth_salt,'woa18_decav_s',num2str(mon2,'%2.2u'),'_01.nc'],'lon');
            ilon=find(clim_x<0); clim_x(ilon)=clim_x(ilon)+360;
            do_clim_x2(1:length(clim_x)-length(ilon))=clim_x(length(ilon)+1:end); 
            do_clim_x2(length(clim_x)-length(ilon)+1:length(clim_x))=clim_x(1:length(ilon));
            clim_x=do_clim_x2; clear do_clim_x2
        clim_y= nc_varget([woa_pth_salt,'woa18_decav_s',num2str(mon2,'%2.2u'),'_01.nc'],'lat');
        [clim_x,clim_y,clim_z]=meshgrid(clim_x,clim_y,clim_z);
%         return
        pden_clim = sw_pden(salt_clim,temp_clim,clim_z,zeros(size(clim_z))); %return
        do_clim2(:,1:length(clim_x)-length(ilon),:)=pden_clim(:,length(ilon)+1:end,:); 
        do_clim2(:,length(clim_x)-length(ilon)+1:length(clim_x),:)=pden_clim(:,1:length(ilon),:); %return
        pden_clim=do_clim2; clear do_clim2 
        
        pden_clim_argo = interp3(clim_x,clim_y,clim_z,pden_clim,argo_lon_dep,argo_lat_dep,L); %return
        pden_all_clim(:,p)=pden_clim_argo;   
    end
    
end
contourf(time_all,dep_all,100*(do_all./do_all_eq),[60:1:120],'linecolor','none')
caxis([85 112])
colormap jet
hold on
contour(time_all,dep_all,100*(do_all./do_all_eq),[100 100],...
    'linecolor','k','linewidth',2,'linestyle','--')
[C,h]=contour(time_all,dep_all,pden_all-1000,[1:0.25:32],'linecolor','k');
clabel(C,h,[20:25])
contour(time_all,dep_all,pden_all_clim-1000,[24 24],'linecolor','m','linewidth',2);

plot(time_all,dep_all,'.','color',[1 1 1]*.5)
if PP==1 | PP==3,
    pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
    plot(time_all(:,pf),dep_all(:,pf),'.r')
end
for m=1:length(hr_all)
    text(time_all(1,m),5,num2str(hr_all(m)))
end
% return
plot([5 9],[25 25],'--k')
set(gca,'ylim',[0 150],'ydir','reverse')
set(gca,'xlim',[5 9],'fontsize',sz)
ylabel('Depth (m)')
xlabel('Calendar month')
text(8.5,20,['(',lab(pg(PP)),')'],'fontsize',sz,'BackgroundColor','w')
% return
ax1=axes('position',[(ax(pg(PP),1)+ax(pg(PP),3)+0.3)/f_width ax(pg(PP),2)/f_height 0.02 [1*ax(pg(PP),4)]/f_height]);
xc_bar=[1 2 3];
yc_bar=[60:1:120];
[xc_bar,yc_bar]=meshgrid(xc_bar,yc_bar);
pcolor(xc_bar,yc_bar,yc_bar)
shading flat, %freezeColors
colormap(ax1,'jet');
caxis([85 112])
set(gca,'layer','top','xtick',[],'ytick',[60:10:120],'yaxislocation','right','ylim',[85 112])
text(1.5,113,'%')  
% return
end
return
axes('units','centimeters','position',ax(2,:));
load('5904093_2018_oxden','pden','delO2','satO2','do_all','time_all',...
    'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim')
% pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
pf=find(time_all(1,:)>=6.0 & time_all(1,:)<8);
plot(satO2(:,pf),dep_all(:,pf),'r')
satO2_5904093=satO2(:,pf);
dep_5904093=dep_all(:,pf); %return
hold on
load('5904485_2018_oxden','pden','delO2','satO2','do_all','time_all',...
    'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim')
% pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
pf=find(time_all(1,:)>=6 & time_all(1,:)<8);
plot(satO2(:,pf),dep_all(:,pf),'b')
satO2_5904485=satO2(:,pf);
dep_5904485=dep_all(:,pf);

load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\test_nutrient\HOT_o2_test',...
    'O2sat_06','O2sat_07','o2_ctd_06','o2_ctd_07','dep_07','dep_06','pden_anol_july','pden_anol_june',...
    'temp_anol_july','temp_anol_june',...
    'O2sat_07_point180','O2sat_06_point180',...
    'do_point_clim_July','do_point_clim_June','do_point_z')
load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\test_nutrient\HOT_O2sat_climdata','O2sat_ave','pres_ave')


plot(100*o2_ctd_06./O2sat_06,dep_06,'--','color',[1 1 1]*.5,'linewidth',2)
plot(100*o2_ctd_07./O2sat_07,dep_07,'-','color',[1 1 1]*.5,'linewidth',2)

plot(100*do_point_clim_June./O2sat_06_point180,do_point_z,':k','linewidth',2)
plot(100*do_point_clim_July./O2sat_07_point180,do_point_z,'ok','linewidth',2)
I=find(pres_ave>10);
plot(O2sat_ave(I),pres_ave(I),'or');

satO2_ALOHA_06=100*o2_ctd_06./O2sat_06;
dep_ALOHA_06=dep_06;
satO2_ALOHA_07=100*o2_ctd_07./O2sat_07;
dep_ALOHA_07=dep_07;
satO2_clim180_July=100*do_point_clim_July./O2sat_07_point180;
satO2_clim180_June=100*do_point_clim_June./O2sat_06_point180;
% save('satO2_data_ALOHA_5904093_5904485_b_allJJ','satO2_5904093','dep_5904093',...
%     'satO2_5904485','dep_5904485','satO2_ALOHA_06','dep_ALOHA_06',...
%     'satO2_ALOHA_07','dep_ALOHA_07','do_point_z',...
%     'satO2_clim180_June','satO2_clim180_July')
% save('Fig5_data_allJJ','satO2_5904093','dep_5904093',...
%     'satO2_5904485','dep_5904485','satO2_ALOHA_06','dep_ALOHA_06',...
%     'satO2_ALOHA_07','dep_ALOHA_07','do_point_z',...
%     'satO2_clim180_June','satO2_clim180_July')

set(gca,'ylim',[0 150],'ydir','reverse','fontsize',sz)
ylabel('Depth (m)')
xlabel('Saturated O_2 (%)')
text(107,20,'(b)','fontsize',sz)
Dlim=350;

return
myfigure
subplot(2,2,1)
load('5904093_2018_oxden','pden','delO2','satO2','do_all','time_all',...
    'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim',...
    'pden_anol','temp_anol','pden_all','temp_all')
pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
plot(pden_all(:,pf)-1000,dep_all(:,pf),'r')
% satO2_5904093=satO2(:,pf);
% dep_5904093=dep_all(:,pf);
hold on
plot(pden_all(:,pf(5))-1000,dep_all(:,pf(5)),'or')
load('5904485_2018_oxden','pden','delO2','satO2','do_all','time_all',...
    'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim',...
    'pden_anol','temp_anol','pden_all','temp_all')
pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
plot(pden_all(:,pf)-1000,dep_all(:,pf),'b')
set(gca,'ylim',[0 Dlim],'ydir','reverse','fontsize',sz)
ylabel('Depth (m)')
xlabel('Potential Density (kg/m^3)')
% plot(pden_anol_june,dep_ALOHA_06,'--r','linewidth',2)
% plot(pden_anol_july,dep_ALOHA_07,'--b','linewidth',2)
% plot([0 0],[0 Dlim],'k')
% return
subplot(2,2,2)
load('5904093_2018_oxden','pden','delO2','satO2','do_all','time_all',...
    'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim',...
    'pden_anol','temp_anol','pden_all','temp_all')
pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
plot(temp_all(:,pf),dep_all(:,pf),'r')
% satO2_5904093=satO2(:,pf);
% dep_5904093=dep_all(:,pf);
hold on
plot(temp_all(:,pf(5)),dep_all(:,pf(5)),'or')
load('5904485_2018_oxden','pden','delO2','satO2','do_all','time_all',...
    'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim',...
    'pden_anol','temp_anol','pden_all','temp_all')
pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
plot(temp_all(:,pf),dep_all(:,pf),'b')
set(gca,'ylim',[0 Dlim],'ydir','reverse','fontsize',sz)
ylabel('Depth (m)')
xlabel('Temperature (^oC)')
% plot(temp_anol_june,dep_ALOHA_06,'--r','linewidth',2)
% plot(temp_anol_july,dep_ALOHA_07,'--b','linewidth',2)
% plot([0 0],[0 Dlim],'k')

% satO2_5904485=satO2(:,pf);
% dep_5904485=dep_all(:,pf);
% saveas(gcf,'argo_sla_ow_o2_B','png')
subplot(2,2,3)
load('5904093_2018_oxden','pden','delO2','satO2','do_all','time_all',...
    'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim',...
    'pden_anol','temp_anol','pden_all','temp_all')
pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
plot(salt_all(:,pf),dep_all(:,pf),'r')
% satO2_5904093=satO2(:,pf);
% dep_5904093=dep_all(:,pf);
hold on
plot(salt_all(:,pf(5)),dep_all(:,pf(5)),'or')
load('5904485_2018_oxden','pden','delO2','satO2','do_all','time_all',...
    'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim',...
    'pden_anol','temp_anol','pden_all','temp_all')
pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
plot(salt_all(:,pf),dep_all(:,pf),'b')
set(gca,'ylim',[0 Dlim],'ydir','reverse','fontsize',sz)
ylabel('Depth (m)')
xlabel('Salinity (ppt)')

subplot(2,2,4)
load('5904093_2018_oxden','pden','delO2','satO2','do_all','time_all',...
    'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim',...
    'pden_anol','temp_anol','pden_all','temp_all')
pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
plot(satO2(:,pf),dep_all(:,pf),'r')
% satO2_5904093=satO2(:,pf);
% dep_5904093=dep_all(:,pf);
hold on
plot(satO2(:,pf(5)),dep_all(:,pf(5)),'or')
load('5904485_2018_oxden','pden','delO2','satO2','do_all','time_all',...
    'dep_all','salt_all','temp_all','lon_all','lat_all','satO2_clim','do_all_clim',...
    'pden_anol','temp_anol')
pf=find(time_all(1,:)>=6.5 & time_all(1,:)<7.6);
plot(satO2(:,pf),dep_all(:,pf),'b')
set(gca,'ylim',[0 Dlim],'ydir','reverse','fontsize',sz)
ylabel('Depth (m)')
xlabel('So_2')

% saveas(gcf,'bio_argo_temp_pdens_anol_So2','png')
toc