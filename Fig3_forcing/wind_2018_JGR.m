tic, clc, clear,format long g,close all,warning off
% load('er5_corpenicus_wind_curl_2001_2019_div','xi','yi','u_all','v_all','wcurl','wdiv','year','month')
load('er5_corpenicus_wind_curl_2001_2019_div_R2','xi','yi','u_all','v_all','wcurl','wdiv','year','month')

% return
for m=1:12
    I=find(month==m);
    umean(:,:,m)=mean(u_all(:,:,I),3,'omitnan');
    vmean(:,:,m)=mean(v_all(:,:,I),3,'omitnan');
    curlm(:,:,m)=mean(wcurl(:,:,I),3,'omitnan');
    divm(:,:,m)=mean(wdiv(:,:,I),3,'omitnan');
    for n=1:length(I)
        u_anol(:,:,I(n))=u_all(:,:,I(n))-umean(:,:,m);
        v_anol(:,:,I(n))=v_all(:,:,I(n))-vmean(:,:,m);
        curl_anol(:,:,I(n))=wcurl(:,:,I(n))-curlm(:,:,m);
        div_anol(:,:,I(n))=wdiv(:,:,I(n))-divm(:,:,m);
    end
end
I=find(year==2018 & month>=6 & month<=7);
curl_anol2=mean(curl_anol(:,:,I),3,'omitnan');
wcurl2=mean(wcurl(:,:,I),3,'omitnan');
% div_anol2=mean(div_anol(:,:,I),3,'omitnan');
% wdiv2=mean(wdiv(:,:,I),3,'omitnan');
ss=10;
quiver(xi(1:ss:end,1:ss:end),yi(1:ss:end,1:ss:end),umean(1:ss:end,1:ss:end,6),vmean(1:ss:end,1:ss:end,6))
% save('wind_2018_JUNE_JULY','xi','yi','wcurl2','curl_anol2','curlm')
% save('wind_2018_JUNE_JULY_R2','xi','yi','wcurl2','curl_anol2','curlm')
toc
