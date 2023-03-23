
function [tlag, crossf, desc]=CrossCorrelation(t1,s1,t2,s2,dt,lagt, nlag, varargin)

s1=detrend(s1);
s2=detrend(s2);
if nargin == 8
   it=varargin{1};
   s1=lowpassa(s1,it);
   s2=lowpassa(s2,it);
end

k=0;
lags=-nlag*lagt:lagt:nlag*lagt;
crossf=zeros(length(lags),1);
tlag=crossf;
for lag=lags
k=k+1; tlag(k)=lag;
c12=correlation(t2-lag,s2,t1,s1,dt);
crossf(k)=c12;
end
desc='negative sig2 leads sig1';
