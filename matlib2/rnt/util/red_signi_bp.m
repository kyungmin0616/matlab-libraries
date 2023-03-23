function [c99, c95, c12, signi, cpdf_xaxis, cpdf_values]=red_signi_bp(t1,s1,t2,s2,dt,NUM,timescale1, timescale2,varargin);
% [c99, c95, c12, signi, cpdf_xaxis, cpdf_values]=red_signi(t1,s1,t2,s2,dt,NUM);
%
%   Compute the significance of correlation between timeseries s1 and s2 that 
%   posses a non zero autocorrelation coefficient. The significance is 
%   estimate based on the PDF of the cross-correlation coefficients between
%   s1 and s2. The PDF is build by computing the correlation of NUM random pairs
%   of timeseries that posses the same AR-1 of s1 and s2 repsectively. This means 
%   that the autocorelation of s1 and s2 can be different.
%
% t1, s1   are the times and timesereries number 1
% t2, s2   are the times and timesereries number 2
% dt       the average time interval between datapoint in the timeseries
%          in the same units used in t1 and t2
% NUM      number of sample in the PDF of the cross-correlation coefficients.
%
% Outputs:
% c99      correlation for 99% significance level
% c95      correlation for 95% significance level
% c12      correlation between s1 and s2
% signi    significance level in % for c12 correlation coeff.
%
% You can plot the PDF by:
% bar(cpdf_xaxis,cpdf_values,'histc');
%
% Example is provided:
% load red_signi_test.mat
% [c99, c95, c12, signi, cpdf_xaxis, cpdf_values]=red_signi(t1,s1,t2,s2,dt,NUM);
%
%      - E. Di Lorenzo (edl@gatech.edu)
%

if nargin == 9
 DO_PLOT=0;
else
 DO_PLOT=1;
end
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

% compute autocorrelation coefficient AR-1 of both timeseries
alfa1=  s1(1:end-1)'*s1(2:end) / (s1'*s1);
alfa2=  s2(1:end-1)'*s2(2:end) / (s2'*s2);

% lowpass
s1=bandpass(s1,1/timescale1, 1/timescale2);
s2=bandpass(s2,1/timescale1, 1/timescale2);

% compute correlation
tmp=corrcoef(s1,s2); 
c12=(tmp(2,1));
 
 % keep track if the correlation was negative or positive
cfac=1; if c12 < 0, cfac=-1; c12=abs(c12); end

% Create pair of timeseries with same ar1 of the orginal timeseries.
% Use these newly generated timeseries to compute the PDF of the cross-correlation
% coefficients. The ensemble is of legnth NUM

disp(['Computing PDF of correlation using samples # ',num2str(NUM)]);
N=length(s1);
for num = 1:NUM
  n1=randn(N,1);
  n2=randn(N,1);
  s1h=zeros(N,1);
  s2h=zeros(N,1);
  s1h(1)=n1(1);
  s2h(1)=n2(1);
  for it=2:N
    s1h(it)= alfa1*s1h(it-1) + n1(it);
    s2h(it)= alfa2*s2h(it-1) + n2(it);
  end
  s1h=bandpass(detrend(s1h),1/timescale1,1/timescale2);
  s2h=bandpass(detrend(s2h),1/timescale1,1/timescale2);
  tmp=corrcoef(s1h,s2h);
  % store the correlation coefficients in variable c 
  c(num)=tmp(2,1);
end

% now put together the cumulative distribution of correlations
c=sort(abs(c));
% compute the 95% and 99% level 
s=[1:NUM]/NUM*100;
c=interp1(s,c,[1:100]);
c95=c(95); c99=c(99);
% compute where c12 falls in the cumulative curve.
if c12 >= max(c(:))
  signi=100;
else
  signi=interp1(c,[1:100], c12, 'linear')';
end

% Compute the PDF
edges=0:0.05:1;
Nc = histc(c,edges);
Nc=Nc/sum(Nc)*100;
cpdf_values=Nc;
cpdf_xaxis=edges;

% ----------------------------------------------------
% Plotting 
% ----------------------------------------------------
if DO_PLOT==1
clf;
% Plot timeseries
subplot(2,1,1)
plot(time,s1,'b'); hold on; plot(time,cfac*s2,'r'); datetick;
s11=s1; s22=s2;stime=time;
set(gca, 'xlim', [time(1)  time(end) ]);

% Plot histogram
subplot(2,1,2);
bar(cpdf_xaxis,cpdf_values,'histc');
hold on
plot( [c95 c95], [0 max(cpdf_values)/2], 'color','k','linewidth',2);
text( c95,  max(cpdf_values)/2,'95%');

plot( [c99 c99], [0 max(cpdf_values)/2], 'color','k','linewidth',2);
text( c99,  max(cpdf_values)/2,'99%');

plot( [c12 c12], [0 max(cpdf_values)/3*2], 'color','g','linewidth',2);
p=num2str(c12); iend=min([ length(p) 4]); p=p(1:iend);
if cfac<0, p=num2str(c12*cfac); iend=min([ length(p) 5]); p=p(1:iend);end
text( c12,  max(cpdf_values)/3*2,p);
set(gca, 'xlim', [0 1]);
ylabel 'percentage of samples'
xlabel 'Correlation'
end

c12=c12*cfac;
p95=num2str(c95); p95=p95(1:4);
p99=num2str(c99); p99=p99(1:4);
if c12>=0
pcorr=num2str(c12);    iend=min([ length(pcorr) 4]);    pcorr=pcorr(1:iend);
else
pcorr=num2str(c12);    iend=min([ length(pcorr) 4])+1;    pcorr=pcorr(1:iend);
end
psigni=num2str(signi); iend=min([ length(psigni) 4]);   psigni=psigni(1:iend);

disp(['95% sig. level = ',p95]);
disp(['99% sig. level = ',p99]);
disp(['Correlation    = ',pcorr,' (',psigni,'%)']);

