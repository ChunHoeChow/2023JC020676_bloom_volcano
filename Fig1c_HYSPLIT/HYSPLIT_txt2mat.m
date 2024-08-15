tic,close all, clc, clear,format long g

data=load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\tdump.163574_nohead.txt');
num=data(:,1);
lon=data(:,11); I=find(lon<0); lon(I)=lon(I)+360;

lat=data(:,10);
alt=data(:,12);
mon=data(:,4);
day=data(:,5);
hr=data(:,6);

save('HYSPLIT_data','num','lon','lat','hr','day','alt')

toc