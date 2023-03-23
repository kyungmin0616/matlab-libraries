function [c99, c95, c12, signi, cpdf_xaxis, cpdf_values]=red_signi_trend(t1,s1,NUM,varargin);
% [c99, c95, c12, signi, cpdf_xaxis, cpdf_values]=red_signi(t1,s1,NUM);
%
%   Compute the significance of trend on timeseries s1. The significance is 
%   estimate based on the PDF of the trend coefficients 
%
%      - E. Di Lorenzo (edl@gatech.edu)
%

if nargin > 3
 DO_PLOT=0;
 DO_PLOT=varargin{1};
else
 DO_PLOT=1;
end

color1='b';
color2='r';
if nargin > 7
  color1=varargin{2};
  color2=varargin{3};
end

% Clear NaN values
in=find(~isnan(s1)); s1=s1(in); t1=t1(in);


% normalize
s1=s1/std(s1);

% compute autocorrelation coefficient AR-1 of both timeseries
alfa1=  s1(1:end-1)'*s1(2:end) / (s1'*s1);


disp(['Computing PDF of correlation using samples # ',num2str(NUM)]);
N=length(s1);
for num = 1:NUM
  n1=randn(N,1);
  s1h(1)=n1(1);
  for it=2:N
    s1h(it)= alfa1*s1h(it-1) + n1(it);
  end
  tmp=s1h-detrend(s1h); tmp=abs(tmp(end)-tmp(1));
  % store the correlation coefficients in variable c 
  c(num)=tmp; 
end

% now put together the cumulative distribution of correlations
c=sort(abs(c));

% compute where c12 falls in the cumulative curve.
tmp=s1-detrend(s1); tmp=(tmp(end)-tmp(1));
c12=abs(tmp);
cfac=sign(tmp);

in=find(c <= c12);
signi=length(in)/NUM*100;



% Compute the PDF
edges=0:0.05:max(c);
Nc = histc(c,edges);
Nc=Nc/sum(Nc)*100;
cpdf_values=Nc;
cpdf_xaxis=edges;

% ----------------------------------------------------
% Plotting 
% ----------------------------------------------------
if DO_PLOT>0
ln=1;
clf;
% Plot timeseries
if DO_PLOT==1
subplot(2,1,1)
ln=1;
end
time=t1
plot(time,s1,'color',[0.5 0.5 0.5],'linewidth',ln); hold on; 
datetick;
grid on; hold on
plot(time,s1-detrend(s1),'color','k','linewidth',2); hold on; 
set(gca, 'xlim', [time(1)  time(end) ]);

if DO_PLOT==1
% Plot histogram
subplot(2,1,2);
bar(cpdf_xaxis,cpdf_values,'histc');
hold on

plot( [c12 c12], [0 max(cpdf_values)/3*2], 'color','g','linewidth',2);
p=num2str(c12); iend=min([ length(p) 4]); p=p(1:iend);
if cfac<0, p=num2str(c12*cfac); iend=min([ length(p) 5]); p=p(1:iend);end

%set(gca, 'xlim', [0 1]);
ylabel 'percentage of samples'
xlabel 'Correlation'
end
end


if c12>=0
pcorr=num2str(c12);    iend=min([ length(pcorr) 4]);    pcorr=pcorr(1:iend);
else
pcorr=num2str(c12);    iend=min([ length(pcorr) 4])+1;    pcorr=pcorr(1:iend);
end
psigni=num2str(signi); iend=min([ length(psigni) 4]);   psigni=psigni(1:iend);

disp(['Trend  Significance        = ',psigni,'%']);
text( c12,  max(cpdf_values)/3*2,[psigni,'%']);

