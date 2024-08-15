tic, clc, clear,format long g,close all,warning off
load('world_map2','coast4')
x1=190; x2=220; y1=15; y2=30;
% load('Z:\STCC\Chla\merged_data\GSM\chl_JJAS_data','chl_JJAS','chl_x','chl_y')

file=ls('*_bottle.nc');
return
p=0;
for m=[3 4 1 2]
% in='33KI20180625_bottle.nc';
% in='33KI20180723_bottle.nc';
% in='33KB20180909_bottle.nc';
in=file(m,:);
c = julian(1950,1,1,0,0,0);

    lon=ncread(in,'longitude');
    lat=ncread(in,'latitude');
    pres=ncread(in,'pressure');
    juld=ncread(in,'time'); 
    Si=ncread(in,'silicate'); 
    P=ncread(in,'phosphate'); 
    N=ncread(in,'nitrite_nitrate'); 
    O=ncread(in,'oxygen');
    
    
[gtime]=gregoria(juld+c);   
lon=360+lon;
I=find(lat>22.5);
lon=lon(I);
lat=lat(I);
pres=pres(:,I);
N=N(:,I);
O=O(:,I);
P=P(:,I);
Si=Si(:,I);
juld=juld(I);
gtime=gtime(I,:);

% for m=1:length(I)
%     Y=pres(:,m);
%     X=N(:,m);
%     plot(X,Y,'.k-');
%     hold on
% end
% set(gca,'ydir','reverse','ylim',[0 200])
% return
p=p+1;
if p<4
    pres=[pres(1,2);pres(:,3)];
    N=[N(1,2);N(:,3)];
    P=[P(1,2);P(:,3)];
    O=[O(1,2);O(:,3)];
    Si=[Si(1,2);Si(:,3)];
else
    pres=[NaN;pres(:,3)];
    N=[NaN;N(:,3)];
    P=[NaN;P(:,3)];
    O=[NaN;O(:,3)];
    Si=[NaN;Si(:,3)];    
end


pres_all(:,p)=pres;
N_all(:,p)=N;
P_all(:,p)=P;
O_all(:,p)=O;
Si_all(:,p)=Si;
end
% return
myfigure
cc=['r';'b';'k';'g';'m'];
subplot(3,3,1)
for m=1:2
    plot(N_all(:,m),pres_all(:,m),'o:','color',cc(m),'markerfacecolor',cc(m));
    hold on
end
title('N')
set(gca,'ydir','reverse','ylim',[0 200])
legend('Jun25','July23')
% return
subplot(3,3,2)
for m=1:2
    plot(P_all(:,m),pres_all(:,m),'o:','color',cc(m),'markerfacecolor',cc(m));
    hold on
end
title('P')
set(gca,'ydir','reverse','ylim',[0 200])
legend('Jun25','July23')

subplot(3,3,3)
for m=1:2
    plot(Si_all(:,m),pres_all(:,m),'o:','color',cc(m),'markerfacecolor',cc(m));
    hold on
end
title('Si')
set(gca,'ydir','reverse','ylim',[0 200])
legend('Jun25','July23')

% return
subplot(3,3,4)
for m=1:2
    plot(N_all(:,m)./P_all(:,m),pres_all(:,m),'o:','color',cc(m),'markerfacecolor',cc(m));
    hold on
end
title('N/P')
set(gca,'ydir','reverse','ylim',[0 200])
legend('Jun25','July23')

subplot(3,3,5)
for m=1:2
    plot(N_all(:,m)./Si_all(:,m),pres_all(:,m),'o:','color',cc(m),'markerfacecolor',cc(m));
    hold on
end
title('N/Si')
set(gca,'ydir','reverse','ylim',[0 200])
legend('Jun25','July23')

subplot(3,3,6)
for m=1:2
    plot(O_all(:,m),pres_all(:,m),'o','color',cc(m),'markerfacecolor',cc(m));
    hold on
end
title('O2')
set(gca,'ydir','reverse','ylim',[0 200])
% legend('Jun25','July23','Sep09','Oct11')

% data=load('h305a0203_0909.ctd');
% z=data(:,1);
% o2_ctd=data(:,4);
% chl_ctd=data(:,6);
% plot(o2_ctd,z,'.-','color','k');

data=load('h304a0203_0723.ctd');
z=data(:,1);
o2_ctd=data(:,4);
chl_ctd=data(:,6);
plot(o2_ctd,z,'.-','color','b');
o2_ctd_07=o2_ctd;

data=load('h303a0203_0625.ctd');
z=data(:,1);
o2_ctd=data(:,4);
chl_ctd=data(:,6);
plot(o2_ctd,z,'.-','color','r');
o2_ctd_06=o2_ctd;

% data=load('h306a0203_1011.ctd');
% z=data(:,1);
% o2_ctd=data(:,4);
% chl_ctd=data(:,6);
% plot(o2_ctd,z,'.-','color','g');



subplot(3,3,9)
data=load('h303a0203_0625.ctd');
z=data(:,1); chl_ctd=data(:,6);
plot(chl_ctd,z,'.-','color','r'); hold on

data=load('h304a0203_0723.ctd');
z=data(:,1); chl_ctd=data(:,6);
plot(chl_ctd,z,'.-','color','b');

% data=load('h305a0203_0909.ctd');
% z=data(:,1); chl_ctd=data(:,6);
% plot(chl_ctd,z,'.-','color','k'); hold on

% data=load('h306a0203_1011.ctd');
% z=data(:,1); chl_ctd=data(:,6);
% plot(chl_ctd,z,'.-','color','g');

title('Chl')
set(gca,'ydir','reverse','ylim',[0 200],'xlim',[0 1.2])

legend('Jun25','July23','location','southwest')

ALOHA_x=360-158;
ALOHA_y=22.75;
woa_pth_temp='V:\SCS initial data\web\WOA18\Temperature\';
woa_pth_salt='V:\SCS initial data\web\WOA18\Salinity\';
woa_pth_do='V:\SCS initial data\web\WOA18\Dissolved Oxygen\';
temp_clim = nc_varget([woa_pth_temp,'woa18_decav_t',num2str(6,'%2.2u'),'_01.nc']...
    ,'t_an'); temp_clim=permute(temp_clim,[2 3 1]);  
salt_clim = nc_varget([woa_pth_salt,'woa18_decav_s',num2str(6,'%2.2u'),'_01.nc']...
    ,'s_an'); salt_clim=permute(salt_clim,[2 3 1]);
do_clim = nc_varget([woa_pth_do,'woa18_all_o',num2str(6,'%2.2u'),'_01.nc']...
    ,'o_an'); do_clim=permute(do_clim,[2 3 1]);

do_clim_z= nc_varget([woa_pth_do,'woa18_all_o',num2str(6,'%2.2u'),'_01.nc'],'depth');    
do_clim_y= nc_varget([woa_pth_do,'woa18_all_o',num2str(6,'%2.2u'),'_01.nc'],'lat'); 
do_clim_x= nc_varget([woa_pth_do,'woa18_all_o',num2str(6,'%2.2u'),'_01.nc'],'lon'); 
ilon=find(do_clim_x<0); do_clim_x(ilon)=do_clim_x(ilon)+360;
    do_clim_x2(1:length(do_clim_x)-length(ilon))=do_clim_x(length(ilon)+1:end); 
    do_clim_x2(length(do_clim_x)-length(ilon)+1:length(do_clim_x))=do_clim_x(1:length(ilon));
    do_clim_x=do_clim_x2; clear do_clim_x2
[do_clim_x,do_clim_y,do_clim_z]=meshgrid(do_clim_x,do_clim_y,do_clim_z);
pden_clim = sw_pden(salt_clim,temp_clim,do_clim_z,zeros(size(do_clim_z))); %return
do_clim2(:,1:length(do_clim_x)-length(ilon),:)=pden_clim(:,length(ilon)+1:end,:); 
do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=pden_clim(:,1:length(ilon),:); %return
pden_clim=do_clim2; clear do_clim2 
do_clim2(:,1:length(do_clim_x)-length(ilon),:)=temp_clim(:,length(ilon)+1:end,:); 
do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=temp_clim(:,1:length(ilon),:); %return
temp_clim=do_clim2; clear do_clim2  
do_clim2(:,1:length(do_clim_x)-length(ilon),:)=do_clim(:,length(ilon)+1:end,:); 
do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=do_clim(:,1:length(ilon),:); %return
do_clim=do_clim2; clear do_clim2 
do_clim2(:,1:length(do_clim_x)-length(ilon),:)=salt_clim(:,length(ilon)+1:end,:); 
do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=salt_clim(:,1:length(ilon),:); %return
salt_clim=do_clim2; clear do_clim2 

% figure
% pcolor(do_clim_x(:,:,1),do_clim_y(:,:,1),do_clim(:,:,1)); shading flat
%   return  
subplot(3,3,7)
data=load('h303a0203_0625.ctd');
z=data(:,1); temp_ctd=data(:,2); salt_ctd=data(:,3);
plot(temp_ctd,z,'.-','color','r'); hold on
temp_ctd_06=temp_ctd;
salt_ctd_06=salt_ctd;
pden_ctd = sw_pden(salt_ctd,temp_ctd,z,zeros(size(z)));

L=z';
argo_lon_dep=ones(1,length(L))*ALOHA_x;
argo_lat_dep=ones(1,length(L))*ALOHA_y;

pden_all_clim = interp3(do_clim_x,do_clim_y,do_clim_z,pden_clim,argo_lon_dep,argo_lat_dep,L); %return
pden_all_clim = pden_all_clim';
temp_all_clim = interp3(do_clim_x,do_clim_y,do_clim_z,temp_clim,argo_lon_dep,argo_lat_dep,L); %return
temp_all_clim = temp_all_clim';
[xmin,Ixmin]=min(abs(do_clim_x(1,:,1)-180))
[ymin,Iymin]=min(abs(do_clim_y(:,1,1)-22.0))
do_clim_x(1,Ixmin,1), do_clim_y(Iymin,1,1), 
do_point_clim = do_clim(Iymin,Ixmin,:); %return
do_point_clim_June = squeeze(do_point_clim); 
temp_point_clim = temp_clim(Iymin,Ixmin,:); %return
temp_point_clim_June = squeeze(temp_point_clim); 
salt_point_clim = salt_clim(Iymin,Ixmin,:); %return
salt_point_clim_June = squeeze(salt_point_clim); 
do_point_z=squeeze(do_clim_z(1,1,:));
% figure
% plot(do_point_clim,do_point_z,'--','color','r');
% return

plot(temp_all_clim,z,'--','color','r');
temp_anol_june=temp_ctd-temp_all_clim;
pden_anol_june=pden_ctd-pden_all_clim;

data=load('h304a0203_0723.ctd');
z=data(:,1); temp_ctd=data(:,2); salt_ctd=data(:,3);
plot(temp_ctd,z,'.-','color','b');
temp_ctd_07=temp_ctd;
salt_ctd_07=salt_ctd;
pden_ctd = sw_pden(salt_ctd,temp_ctd,z,zeros(size(z)));

L=z';
argo_lon_dep=ones(1,length(L))*ALOHA_x;
argo_lat_dep=ones(1,length(L))*ALOHA_y;

temp_clim = nc_varget([woa_pth_temp,'woa18_decav_t',num2str(7,'%2.2u'),'_01.nc']...
    ,'t_an'); temp_clim=permute(temp_clim,[2 3 1]);  
salt_clim = nc_varget([woa_pth_salt,'woa18_decav_s',num2str(7,'%2.2u'),'_01.nc']...
    ,'s_an'); salt_clim=permute(salt_clim,[2 3 1]);
do_clim = nc_varget([woa_pth_do,'woa18_all_o',num2str(7,'%2.2u'),'_01.nc']...
    ,'o_an'); do_clim=permute(do_clim,[2 3 1]);
pden_clim = sw_pden(salt_clim,temp_clim,do_clim_z,zeros(size(do_clim_z))); %return
do_clim2(:,1:length(do_clim_x)-length(ilon),:)=pden_clim(:,length(ilon)+1:end,:); 
do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=pden_clim(:,1:length(ilon),:); %return
pden_clim=do_clim2; clear do_clim2 
do_clim2(:,1:length(do_clim_x)-length(ilon),:)=temp_clim(:,length(ilon)+1:end,:); 
do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=temp_clim(:,1:length(ilon),:); %return
temp_clim=do_clim2; clear do_clim2  
do_clim2(:,1:length(do_clim_x)-length(ilon),:)=do_clim(:,length(ilon)+1:end,:); 
do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=do_clim(:,1:length(ilon),:); %return
do_clim=do_clim2; clear do_clim2  
do_clim2(:,1:length(do_clim_x)-length(ilon),:)=salt_clim(:,length(ilon)+1:end,:); 
do_clim2(:,length(do_clim_x)-length(ilon)+1:length(do_clim_x),:)=salt_clim(:,1:length(ilon),:); %return
salt_clim=do_clim2; clear do_clim2 
do_point_clim = do_clim(Iymin,Ixmin,:); %return
do_point_clim_July = squeeze(do_point_clim); 
temp_point_clim = temp_clim(Iymin,Ixmin,:); %return
temp_point_clim_July = squeeze(temp_point_clim); 
salt_point_clim = salt_clim(Iymin,Ixmin,:); %return
salt_point_clim_July = squeeze(salt_point_clim); 
% do_point_z=squeeze(do_clim_z(1,1,:));
%%%% get one point for the DO clim.

pden_all_clim = interp3(do_clim_x,do_clim_y,do_clim_z,pden_clim,argo_lon_dep,argo_lat_dep,L); %return
pden_all_clim = pden_all_clim';
temp_all_clim = interp3(do_clim_x,do_clim_y,do_clim_z,temp_clim,argo_lon_dep,argo_lat_dep,L); %return
temp_all_clim = temp_all_clim';
plot(temp_all_clim,z,'--','color','b');
temp_anol_july=temp_ctd-temp_all_clim;
pden_anol_july=pden_ctd-pden_all_clim;
% data=load('h305a0203_0909.ctd');
% z=data(:,1); temp_ctd=data(:,2);
% plot(temp_ctd,z,'.-','color','k'); hold on
% 
% data=load('h306a0203_1011.ctd');
% z=data(:,1); temp_ctd=data(:,2);
% plot(temp_ctd,z,'.-','color','g');

title('Temperature')
set(gca,'ydir','reverse','ylim',[0 200])

subplot(3,3,8)
data=load('h303a0203_0625.ctd');
z=data(:,1); temp_ctd=data(:,3);
plot(temp_ctd,z,'.-','color','r'); hold on
salt_ctd_06=temp_ctd;
dep_06=z;

data=load('h304a0203_0723.ctd');
z=data(:,1); temp_ctd=data(:,3);
plot(temp_ctd,z,'.-','color','b');
salt_ctd_07=temp_ctd;
dep_07=z;

O2sat_07=o2satv2b(salt_ctd_07,temp_ctd_07); 
O2sat_06=o2satv2b(salt_ctd_06,temp_ctd_06); 

O2sat_07_point180=o2satv2b(salt_point_clim_July,temp_point_clim_July); 
O2sat_06_point180=o2satv2b(salt_point_clim_June,temp_point_clim_June); 

save('HOT_o2_test','O2sat_06','O2sat_07','o2_ctd_06','o2_ctd_07','dep_07','dep_06'...
    ,'N_all','pres_all','P_all','Si_all','temp_ctd_07','temp_ctd_06',...
    'salt_ctd_06','salt_ctd_07','pden_anol_july','pden_anol_june',...
    'temp_anol_july','temp_anol_june','O2sat_07_point180','O2sat_06_point180',...
    'do_point_clim_July','do_point_clim_June','do_point_z')



% data=load('h305a0203_0909.ctd');
% z=data(:,1); temp_ctd=data(:,3);
% plot(temp_ctd,z,'.-','color','k'); hold on
% 
% data=load('h306a0203_1011.ctd');
% z=data(:,1); temp_ctd=data(:,3);
% plot(temp_ctd,z,'.-','color','g');

title('Salinity')
set(gca,'ydir','reverse','ylim',[0 200])
% legend('Jun25','July23','Sep09','Oct11')

toc