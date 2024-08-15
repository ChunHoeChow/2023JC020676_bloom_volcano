tic, clc, clear,format long g,close all,warning off

% x1=120; x2=210; y1=10; y2=35;
x1=120; x2=220; y1=5; y2=35;
p=0;
% return
% in='Z:\SCS initial data\web\wind\monthly\ECMWF\copernicus\uv_10m_1998_2018_glob.nc';
in='Z:\SCS initial data\web\wind\monthly\ECMWF\copernicus\uv_10m_2001_2019_glob.nc';
% in='Z:\SCS initial data\web\wind\monthly\ECMWF\copernicus\uv_10m_2001_2023_glob.nc';
xi = nc_varget(in,'longitude');
yi = nc_varget(in,'latitude'); %return
u_all = nc_varget(in,'u10');
v_all = nc_varget(in,'v10');
time_wind=nc_varget(in,'time');
cw = julian(1900,1,1,0,0,0);
[gt]=gregoria(time_wind/24+cw);
year=gt(:,1);
month=gt(:,2); %return

u_all=permute(u_all,[2 3 1]);
v_all=permute(v_all,[2 3 1]);

    Ix=find(xi>=x1 & xi<=x2);
    Iy=find(yi>=y1 & yi<=y2);

    xi=xi(Ix);yi=yi(Iy);
    u_all=u_all(Iy,Ix,:);
    v_all=v_all(Iy,Ix,:);
    
[xi,yi]=meshgrid(xi,yi);


for m=1:length(year)
    u=u_all(:,:,m);
    v=v_all(:,:,m);
    [Ux,Uy]=my_gradient(xi,yi,u);
    [Vx,Vy]=my_gradient(xi,yi,v); 

    wcurl(:,:,m)=Vx-Uy;
    wdiv(:,:,m)=Ux+Vy;
end

% save('er5_corpenicus_wind_curl_1998_2018_div','xi','yi','u_all','v_all','wcurl','wdiv','year','month')
save('er5_corpenicus_wind_curl_2001_2019_div_R2','xi','yi','u_all','v_all','wcurl','wdiv','year','month')
% save('er5_corpenicus_wind_curl_2001_2023_div','xi','yi','u_all','v_all','wcurl','wdiv','year','month')

toc