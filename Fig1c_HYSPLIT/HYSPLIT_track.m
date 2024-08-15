tic,close all, clc, clear,format long g

load('Z:\STCC\Chla\merged_data\HYSPLIT_data','lon','lat','hr','day','num')
% load('Z:\STCC\Chla\merged_data\high_chl_bloom_JJ_nocloud','cx','cy','chl_all')

% chl_july=chl_all(:,:,2);
for m=[1:3]
    I=find(num==m);
    HYSPLIT_track_lon(m,:)=lon(I);
    HYSPLIT_track_lat(m,:)=lat(I);
    HYSPLIT_track_hr(m,:)=hr(I);
    HYSPLIT_track_day(m,:)=day(I);
end

save('Fig1c_data_HYSPLIT',...
    'HYSPLIT_track_lat','HYSPLIT_track_lon',...
    'HYSPLIT_track_hr','HYSPLIT_track_day')

