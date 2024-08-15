tic,close all, clc, clear,format long g

load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\chl_smaller_box_timemean_std_max_2003_2018',...
    'year','month','chl_box2_all','chl_box1_all') ;
time2=year+(month-1)/12;

L=length(time2);
for m=1:L
    q=reshape(chl_box2_all(:,:,m),1,[]);
    all_data(:,m)=q;
    Q2(m)=median(q,'omitnan');
    max_data(m)=max(q,[],'omitnan');
    min_data(m)=min(q,[],'omitnan');
    Q3(m) = quantile(q,0.75);
    Q1(m) = quantile(q,0.25);
    up=Q3(m)+1.5*(Q3(m)-Q1(m));
    dn=Q1(m)-1.5*(Q3(m)-Q1(m));
    if up<max_data(m)
        wup(m)=up;
    else
        wup(m)=max_data(m)
    end
    if dn>min_data(m)
        wdn(m)=dn;
    else
        wdn(m)=min_data(m);
    end    
end
plot(time2,Q2,'r')
hold on
plot(time2,Q3,'b')
plot(time2,Q1,'b')
plot(time2,wup,'k')
plot(time2,wdn,'k')

figure
boxplot(all_data,'symbol','')
save('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\whiskers_mondata_170_190_18_27_2003_2018',...
    'time2','Q2','Q3','Q1','wup','wdn','all_data')

toc