function sig2=lowpassa(sig,nw);
%function sig2=lowpassa(sig,nw);

sig=sig(:);
sig2=sig*nan;

delta=nw/2;

T=length(sig);
% need to cut off the edge

for i=1+delta:T-delta
t=delta;
tmp1 = meanNaN(sig(i-t:i+t),1);
sig2(i)=tmp1;

end

