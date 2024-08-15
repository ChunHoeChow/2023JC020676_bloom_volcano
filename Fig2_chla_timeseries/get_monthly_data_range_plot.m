tic,close all, clc, clear,format long g
% x1=160; x2=200; y1=16; y2=28;
% x1s=170; x2s=190; y1s=18; y2s=27;
% x1=121; x2=250; y1=12; y2=40; %% whole north Pacific
load('chl_box12_mondata_2003_2022','year','month',...
    'chl_box1_spacemean','chl_box1_spacestd',...
    'chl_box2_spacemean','chl_box2_spacestd','chl_box2_all','chl_box1_all')

I=find(year>=2003 & year<=2018);
year=year(I); month=month(I);
chl_box2_spacemean=chl_box2_spacemean(I);
chl_box2_spacestd=chl_box2_spacestd(I);
chl_box1_all=chl_box1_all(:,:,I);
chl_box2_all=chl_box2_all(:,:,I);
time=year+(month-1)/12;
subplot(2,1,1)
plot(time,chl_box2_spacemean)
I=find(month==7);
hold on
plot(time(I),chl_box2_spacemean(I),'.r')

subplot(2,1,2)
plot(time,chl_box2_spacemean)
hold on
plot(time,chl_box2_spacemean+chl_box2_spacestd,':')

for m=1:12
    I=find(month==m);
    chl_timemean(m)=mean(chl_box2_spacemean(I));
    chl_timestd(m)=std(chl_box2_spacemean(I),0);
    chl_timemax(m)=max(chl_box2_spacemean(I));

end
figure
plot([1:12],chl_timemean);
hold on
plot([1:12],chl_timemean+chl_timestd,'--')
plot([1:12],chl_timemax,':o');

save('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\chl_smaller_box_timemean_std_max_2003_2018',...
    'chl_timemean','chl_timestd','chl_box2_all','chl_box1_all',...
    'chl_timemax','year','month','chl_box2_spacemean','chl_box2_spacestd')
toc