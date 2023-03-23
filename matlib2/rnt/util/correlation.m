function [c12, r1, r2]=correlation(t1,s1,t2,s2,dt);
%
%      - E. Di Lorenzo (edl@gatech.edu)
%


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


r2=sum(s1.*s2)/sum(s2.*s2)* std(s2);
r1=sum(s2.*s1)/sum(s1.*s1)* std(s1);

% normalize
s1=s1/std(s1);
s2=s2/std(s2);

% compute correlation
tmp=corrcoef(s1,s2); 
c12=(tmp(2,1));



 
