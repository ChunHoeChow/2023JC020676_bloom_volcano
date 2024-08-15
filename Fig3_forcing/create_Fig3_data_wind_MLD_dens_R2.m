tic,close all, clc, clear,format long g
x1=149; x2=211; y1=5; y2=35;

load('Z:\STCC\Chla\merged_data\high_chl_bloom_JJ_nocloud','cx','cy','chl_all')
% load('D:\on_going_proposal\running\science\on_going_paper\dragon_chla\ECMWF_winds\wind_2018_JUNE_JULY',...
%     'xi','yi','wcurl2','curlm')
load('D:\on_going_proposal\running\science\on_going_paper\dragon_chla\ECMWF_winds\wind_2018_JUNE_JULY_R2',...
    'xi','yi','wcurl2','curlm')

wx=xi; wy=yi; 
curlclim67=mean(curlm(:,:,6:7),3,'omitnan');

mon=7; monstr='July'; %return
yr=2018;

pth=['Z:\SCS initial data\web\copernicus\chl_interpolated_4km_month\',num2str(yr),'\'];
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
pth=['Z:\SCS initial data\web\copernicus\MLD\dataset-armor-3d-rep-monthly\',num2str(yr),'\'];
files=ls([pth,'*.nc']);
in=[pth,files(mon,:)];

x=ncread(in,'longitude');
y=ncread(in,'latitude');
mld=ncread(in,'mlotst');
T=ncread(in,'to');
S=ncread(in,'so');
D=ncread(in,'depth'); 

Ix=find(x>=x1 & x<=x2);
Iy=find(y>=y1 & y<=y2);

mld=mld(Ix,Iy)';  
T=T(Ix,Iy,:); S=S(Ix,Iy,:); 
T=permute(T,[2 1 3]); S=permute(S,[2 1 3]);

I=find(mld>30000); mld(I)=NaN; mld=mld*0.1+2500;
I=find(T>30000); T(I)=NaN; T=T*0.001+20;
I=find(S>30000); S(I)=NaN; S=S*0.001+20;
[xi,yi]=meshgrid(x(Ix),y(Iy));

P = repmat(D,[1 120 248]);
P = permute(P,[2 3 1]);
PR=zeros(size(P));
pden = sw_pden(S,T,P,PR)-1000;
save('Fig3_data_R2','cx','cy','chl','xi','yi','S','T','pden','mld','D',...
    'wx','wy','curlclim67','wcurl2')

toc