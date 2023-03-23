function sig2=lowpassa(sig,nw);
%function sig2=lowpassa(sig,nw);

sig=sig(:);
sig2=sig*nan;
a=triang(nw);
a=blackman(nw);

T=length(sig);
t=length(a)./2;
% need to cut off the edge

for i=1+t:T-t

ifw =i+1: i+t;
tmp1 = (sig(ifw) - meanNaN(sig(i-t:i+t),1)  ).*a(t+1:2*t);

ibw =i-t:i-1;
tmp2 = (sig(ibw) - meanNaN(sig(i-t:i+t),1)   ).*a(1:t);

tmp=[tmp1;tmp2;sig(i)];
tmp=meanNaN(tmp,1);
sig2(i)=tmp + meanNaN(sig(i-t:i+t),1);

end

