
function [sig2, trend] = dtrend(sig1)
%function [sig2, trend] = dtrend(signal)

signal=sig1;
t=1:length(signal);
t2=t;

in = find (~isnan(signal));
t=t(in); signal=signal(in);

G=t';
G(:,2) =1;
m=(G'*G) \ (G'*signal);

sig2=G*m;
sig2=signal-sig2;


G=t2';
size(t2)
G(:,2) =1;
trend=G*m;
sig2=sig1-trend;

%figure(2)
%plot(t,signal);hold on
%plot(t2,sig2,'r');

