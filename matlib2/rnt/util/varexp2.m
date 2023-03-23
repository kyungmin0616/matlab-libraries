
function [skill,tt]=varexp2(t1,s1,t2,s2,dt, maxlag)

% Clear NaN values
in=find(~isnan(s1)); s1=s1(in); t1=t1(in);
in=find(~isnan(s2)); s2=s2(in); t2=t2(in);



% align time series so that the begin and end at the same time
t_start= max(t1(1), t2(1));
t_end  =min(t1(end), t2(end));


% create a new time array and interpolate the timeseries so 
% that they have the exact times.
time=t_start:dt:t_end;
s1=interp1(t1,s1,time,'linear');
s2=interp1(t2,s2,time,'linear');
% detrend
s1=detrend(s1(:));
s2=detrend(s2(:));
% normalize
s1=s1/std(s1);
s2=s2/std(s2);


k=0;
skill(1)=1;
tt(1)=0;
for i=2:2:maxlag
  s1l= nn(ndnanfilter(s1,'blackman',i));
  s2l= nn(ndnanfilter(s2,'blackman',i));
  k=k+1;
  skill(k) = 1 - var(s2l-s1l)/var(s1l);
  tt(k)=i;
end  
skill(skill<0)=0;


