tic, clc, clear,format long g,close all,warning off
in='HOT_1988_2021_TSO2.nc';

jd=ncread(in,'days');
temp=ncread(in,'temp');
sal=ncread(in,'sal');
press=ncread(in,'press');
oxy=ncread(in,'oxy');

c = julian(1988,10,0,0,0,0);
[gtime]=gregoria(jd+c); 

I=find(gtime(:,2)>=6 & gtime(:,2)<=7 & gtime(:,1)==2018);
% I=find(gtime(:,2)>=6 & gtime(:,2)<=7);
gtime=gtime(I,:);
temp=temp(I);
sal=sal(I);
press=press(I);
oxy=oxy(I);
return
pres_grid=[]; temp_grid=[]; salt_grid=[]; 
oxy_grid=[]; O2sat_grid=[];

I=find(sal<0); sal(I)=NaN;
I=find(oxy<0); oxy(I)=NaN;
for yr=1989:2021
    I=find(gtime(:,1)==yr);
%  if length(I)==0, display(yr), end  ## missing 1993 summer data from origin
    temp_ann{yr-1988}=temp(I);
    salt_ann{yr-1988}=sal(I);
    pres_ann{yr-1988}=press(I);
    oxy_ann{yr-1988}=oxy(I);
    
    P=press(I);
    O=oxy(I);
    T=temp(I);
    S=sal(I);
    O2sat=o2satv2b(S,T);
    O2sat_ann{yr-1988}=O2sat;
    if length(I)==101, 
        pres_grid=[pres_grid P];
        oxy_grid=[oxy_grid O];
        O2sat_grid=[O2sat_grid O2sat];
        temp_grid=[temp_grid T];
        salt_grid=[salt_grid S];
    end
    if length(I)==202, 
        pres_grid=[pres_grid P(1:101)];
        pres_grid=[pres_grid P(102:end)];
        oxy_grid=[oxy_grid O(1:101)];
        oxy_grid=[oxy_grid O(102:end)]; 
        O2sat_grid=[O2sat_grid O2sat(1:101)];
        O2sat_grid=[O2sat_grid O2sat(102:end)];  
        temp_grid=[temp_grid T(1:101)];
        temp_grid=[temp_grid T(102:end)];  
        salt_grid=[salt_grid S(1:101)];
        salt_grid=[salt_grid S(102:end)];          
    end    
    if length(I)~=0 & length(I)~=101 & length(I)~=202
        display(['check the data:',num2str(length(I))])
    end
end
% I=find(oxy_grid<0); oxy_grid(I)=NaN;
O2sat_ave=mean(100*oxy_grid./O2sat_grid,2,'omitnan');
pres_ave=mean(pres_grid,2);
O2sat_ave2=100*mean(oxy_grid,2,'omitnan')./mean(O2sat_grid,2,'omitnan');


save('HOT_O2sat_climdata','O2sat_ave','pres_ave','oxy_grid','O2sat_grid','pres_grid')

figure
plot(O2sat_ave,pres_ave); 
% hold on
% plot(O2sat_ave2,pres_ave); 
set(gca,'ydir','reverse','ylim',[0 200])

return
figure
[xi,yi]=meshgrid([1:55],pres_ave);
pcolor(xi,yi,O2sat_grid); shading flat
set(gca,'ydir','reverse')

figure
pcolor(xi,yi,oxy_grid); shading flat
set(gca,'ydir','reverse')

figure
pcolor(xi,yi,salt_grid); shading flat
set(gca,'ydir','reverse')

figure
plot(oxy_grid,pres_grid);
set(gca,'ydir','reverse')
toc